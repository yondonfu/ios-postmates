//
//  Delivery.m
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "Delivery.h"
#import "Postmates.h"

@implementation Delivery

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (!self) return nil;
    
    _pickUpAddress = [params objectForKey:@"pickup_address"];
    _dropOffAddress = [params objectForKey:@"dropoff_address"];
    
    if ([params objectForKey:@"quote"]) {
        _quote = [params objectForKey:@"quote"];
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

- (void)updateDeliveryStatus {
    if (!self.status) {
        return;
    }
    
    [[Postmates currentManager] getDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
        }
    }];
}

- (void)cancelDelivery {
    if (self.status != Pending && self.status != Pickup) {
        return;
    }
    
    [[Postmates currentManager] cancelDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
        }
    }];
}

- (void)returnDelivery {
    if (self.status != PickupComplete && self.status != Dropoff) {
        return;
    }
    
    [[Postmates currentManager] returnDeliveryForId:self.deliveryId withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryInfoWithDict:res];
        }
    }];
}

- (void)updateDeliveryInfoWithDict:(NSDictionary *)dict {
    self.kind = [dict objectForKey:@"kind"];
    self.deliveryId = [dict objectForKey:@"id"];
    self.created = [dict objectForKey:@"created"];
    self.updated = [dict objectForKey:@"updated"];
    self.status = [self parseStatus:[dict objectForKey:@"status"]];
    self.complete = [dict objectForKey:@"complete"];
    self.pickUpEta = [dict objectForKey:@"pickup_eta"];
    self.dropOffEta = [dict objectForKey:@"dropoff_eta"];
    self.dropOffDeadline = [dict objectForKey:@"dropoff_deadline"];
    self.fee = [[dict objectForKey:@"fee"] integerValue];
    self.currency = [dict objectForKey:@"currency"];
    self.manifest = [dict objectForKey:@"manifest"];
    self.dropOffId = [dict objectForKey:@"dropoff_identifier"];
    self.courier = [dict objectForKey:@"courier"];
}

- (DeliveryStatus)parseStatus:(NSString *)status {
    if ([status isEqualToString:@"pending"]) {
        return Pending;
    } else if ([status isEqualToString:@"pickup"]) {
        return Pickup;
    } else if ([status isEqualToString:@"pickup_complete"]) {
        return PickupComplete;
    } else if ([status isEqualToString:@"dropoff"]) {
        return Dropoff;
    } else if ([status isEqualToString:@"canceled"]) {
        return Canceled;
    } else if ([status isEqualToString:@"delivered"]) {
        return Delivered;
    } else {
        return Returned;
    }
}

- (NSString *)description {
    if (self.quote) {
        return [NSString stringWithFormat:@"pickup_address: %@, dropoff_address: %@, kind: %@, id: %@, created: %@, updated: %@, status: %u, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: %@, fee: %ld, currency: %@, manifest: %@, dropoff_identifier: %@, courier: %@", self.pickUpAddress, self.dropOffAddress, self.kind, self.deliveryId, self.created, self.updated, self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, self.quote.quoteId, self.fee, self.currency, self.manifest, self.dropOffId, self.courier];
    } else {
        return [NSString stringWithFormat:@"pickup_address: %@, dropoff_address: %@, kind: %@, id: %@, created: %@, updated: %@, status: %u, complete: %s, pickup_eta: %@, dropoff_eta: %@, dropoff_deadline: %@, quote_id: (null), fee: %ld, currency: %@, manifest: %@, dropoff_identifier: %@, courier: %@", self.pickUpAddress, self.dropOffAddress, self.kind, self.deliveryId, self.created, self.updated, self.status, self.complete ? "true" : "false", self.pickUpEta, self.dropOffEta, self.dropOffDeadline, (long)self.fee, self.currency, self.manifest, self.dropOffId, self.courier];
    }
    
}

@end
