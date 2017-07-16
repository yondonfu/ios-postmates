//
//  Delivery.m
//  PostmatesiOS
//

#import "Delivery.h"

#import "Postmates.h"
#import "Location.h"

@implementation Delivery

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (dictionary) {
            [self updateDeliveryInfoWithDict:dictionary];
        }
    }
    
    return self;
}

- (void)updateDeliveryStatusWithCallback:(void (^)(Delivery *delivery, NSError *err))callback {
    if (!self.status) {
        return;
    }
    
    [[Postmates currentManager] getDeliveryForId:self.deliveryId withCallback:^(Delivery *delivery, NSError *error) {
        if (error) {
            callback(nil, error);
        } else {
            callback(delivery, nil);
        }
    }];
}

- (void)cancelDeliveryWithCallback:(DeliveryCallbackBlock)callback {
    if (self.status != DeliveryStatusPending && self.status != DeliveryStatusPickup) {
        return;
    }
    
    [[Postmates currentManager] cancelDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *error) {
        if (error) {
            callback(nil, error);
        } else {
            [self updateDeliveryInfoWithDict:res];
            callback(self, nil);
        }
    }];
}

- (void)returnDeliveryWithCallback:(DeliveryCallbackBlock)callback __deprecated {
    if (self.status != DeliveryStatusPickupComplete && self.status != DeliveryStatusDropoff) {
        return;
    }
    
    [[Postmates currentManager] returnDeliveryForId:self.deliveryId withCallback:^(NSDictionary *response, NSError *error) {
        if (error) {
            callback(nil, error);
        } else {
            [self updateDeliveryInfoWithDict:response];
            callback(self, nil);
        }
    }];
}

- (void)updateDeliveryInfoWithDict:(NSDictionary *)dict {
    self.kind = [dict objectForKey:@"kind"];
    self.deliveryId = [dict objectForKey:@"id"];
    self.created = [dict objectForKey:@"created"];
    self.updated = [dict objectForKey:@"updated"];
    self.status = [self parseStatus:[dict objectForKey:@"status"]];
    self.complete = [[dict objectForKey:@"complete"] boolValue];
    self.pickUpEta = [dict objectForKey:@"pickup_eta"];
    self.dropOffEta = [dict objectForKey:@"dropoff_eta"];
    self.dropOffDeadline = [dict objectForKey:@"dropoff_deadline"];
    self.currency = [dict objectForKey:@"currency"];
    self.manifest = [dict objectForKey:@"manifest"];
    self.dropOffId = [dict objectForKey:@"dropoff_identifier"];
    self.courier = [dict objectForKey:@"courier"];
    
    int fee = [[dict objectForKey:@"fee"] intValue];
    self.fee = [NSNumber numberWithFloat:(fee * 0.01)];
    
    NSDictionary *pickUpDict = [dict objectForKey:@"pickup"];
    self.pickUp = [[Location alloc] initWithDictionary:pickUpDict];
    
    NSDictionary *dropOffDict = [dict objectForKey:@"dropoff"];
    self.dropOff = [[Location alloc] initWithDictionary:dropOffDict];
    
    if ([dict objectForKey:@"quote"]) {
        self.quote = [[DeliveryQuote alloc] initWithDictionary:dict[@"quote"]];
    }
}

- (DeliveryStatus)parseStatus:(NSString *)status {
    if ([status isEqualToString:@"pending"]) {
        return DeliveryStatusPending;
        
    } else if ([status isEqualToString:@"pickup"]) {
        return DeliveryStatusPickup;
        
    } else if ([status isEqualToString:@"pickup_complete"]) {
        return DeliveryStatusPickupComplete;
        
    } else if ([status isEqualToString:@"dropoff"]) {
        return DeliveryStatusDropoff;
        
    } else if ([status isEqualToString:@"canceled"]) {
        return DeliveryStatusCanceled;
        
    } else if ([status isEqualToString:@"delivered"]) {
        return DeliveryStatusDelivered;
        
    } else {
        return DeliveryStatusReturned;
    }
}

- (NSString *)description {
    if (self.quote) {
        return [NSString stringWithFormat:@"{ kind: %@, id: %@, created: %@, updated: %@, status: %lu, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: %@, fee: %@, currency: %@, manifest: %@, dropoff_identifier: %@, pickup: %@, dropoff, %@, courier: %@ }", self.kind, self.deliveryId, self.created, self.updated, (unsigned long)self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, self.quote.quoteId, self.fee, self.currency, self.manifest, self.dropOffId, self.pickUp, self.dropOff, self.courier];
    } else {
        return [NSString stringWithFormat:@"{ kind: %@, id: %@, created: %@, updated: %@, status: %lu, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: (null), fee: %@, currency: %@, manifest: %@, dropoff_identifier: %@, pickup: %@, dropoff: %@, courier: %@ }", self.kind, self.deliveryId, self.created, self.updated, self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, self.fee, self.currency, self.manifest, self.dropOffId, self.pickUp, self.dropOff, self.courier];
    }
    
}

@end
