//
//  Delivery.m
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "Delivery.h"
#import "Postmates.h"
#import "Location.h"

@implementation Delivery

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    
    if (self) {
        if ([params objectForKey:@"quote"]) {
            self.quote = [params objectForKey:@"quote"];
        }
    }
    
    return self;
}

- (void)createDeliveryWithParams:(NSDictionary *)params withCallback:(void (^)(Delivery *delivery, NSError *err))callback {
    [[Postmates currentManager] postDeliveryWithParams:params withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
            
            callback(nil, err);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
            
            callback(self, nil);
        }
    }];
    
}

- (void)updateDeliveryStatusWithCallback:(void (^)(Delivery *delivery, NSError *err))callback {
    if (!self.status) {
        return;
    }
    
    [[Postmates currentManager] getDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
            
            callback(nil, err);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
            callback(self, nil);
        }
    }];
}

- (void)cancelDeliveryWithCallback:(void (^)(Delivery *delivery, NSError *err))callback {
    if (self.status != DeliveryStatusPending && self.status != DeliveryStatusPickup) {
        return;
    }
    
    [[Postmates currentManager] cancelDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
            
            callback(nil, err);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
            callback(self, nil);
        }
    }];
}

- (void)returnDeliveryWithCallback:(void (^)(Delivery *delivery, NSError *error))callback {
    if (self.status != DeliveryStatusPickupComplete && self.status != DeliveryStatusDropoff) {
        return;
    }
    
    [[Postmates currentManager] returnDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
            
            callback(nil, err);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
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
    self.fee = [[dict objectForKey:@"fee"] integerValue];
    self.currency = [dict objectForKey:@"currency"];
    self.manifest = [dict objectForKey:@"manifest"];
    self.dropOffId = [dict objectForKey:@"dropoff_identifier"];
    
    NSDictionary *pickUpDict = [dict objectForKey:@"pickup"];
    self.pickUp = [[Location alloc] initWithParams:pickUpDict];
    
    NSDictionary *dropOffDict = [dict objectForKey:@"dropoff"];
    self.dropOff = [[Location alloc] initWithParams:dropOffDict];
    
    self.courier = [dict objectForKey:@"courier"];
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
        return [NSString stringWithFormat:@"{kind: %@, id: %@, created: %@, updated: %@, status: %lu, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: %@, fee: %ld, currency: %@, manifest: %@, dropoff_identifier: %@, pickup: %@, dropoff, %@, courier: %@}", self.kind, self.deliveryId, self.created, self.updated, self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, self.quote.quoteId, (long)self.fee, self.currency, self.manifest, self.dropOffId, self.pickUp, self.dropOff, self.courier];
    } else {
        return [NSString stringWithFormat:@"{kind: %@, id: %@, created: %@, updated: %@, status: %lu, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: (null), fee: %ld, currency: %@, manifest: %@, dropoff_identifier: %@, pickup: %@, dropoff: %@, courier: %@}", self.kind, self.deliveryId, self.created, self.updated, self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, (long)self.fee, self.currency, self.manifest, self.dropOffId, self.pickUp, self.dropOff, self.courier];
    }
    
}

@end
