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

//@property (strong, nonatomic) NSString *kind;
//@property (strong, nonatomic) NSString *deliveryId;

//@property (strong, nonatomic) NSDate *created;
//@property (strong, nonatomic) NSDate *updated;

//@property (assign, nonatomic) DeliveryStatus status;
//@property (assign, nonatomic) BOOL complete;

//@property (strong, nonatomic) NSDate *pickUpEta;
//@property (strong, nonatomic) NSDate *dropOffEta;
//@property (strong, nonatomic) NSDate *dropOffDeadline;

//@property (strong, nonatomic) DeliveryQuote *quote; // Optional

//@property (assign, nonatomic) NSInteger fee;
//@property (strong, nonatomic) NSString *currency;

//@property (strong, nonatomic) NSDictionary *manifest;
//@property (strong, nonatomic) NSString *dropOffId;

//@property (strong, nonatomic) Location *pickUp;
//@property (strong, nonatomic) Location *dropOff;

//@property (strong, nonatomic) NSDictionary *courier;

//"{
//kind: delivery,
//id: del_LEMqfc3r1XCcjV,
//created: 2017-04-18T11:21:18Z,
//updated: 2017-04-18T11:23:35Z,
//status: 6,
//complete: true,
//pickup_eta: <null>,
//dropoff_eta: <null>,
//dropoff_deadline: 2017-04-18T12:56:18Z,
//quote_id: (null),
//fee: 1225,
//currency: usd,
//manifest: {\n
//    description = \"A good book\";\n},
//dropoff_identifier: ,

//pickup: {
//    name: Postmates office,
//    phone_number: 646-413-1271,
//    address: 2363 Van Ness Avenue,
//    notes: ,
//    location: (37.797411, -122.424145)
//},
//dropoff: {

//name: Mager's Old House,
//    phone_number: 646-413-1271,
//    address: 690 5th Street,
//    notes: ,
//    location: (37.775329, -122.397653)
//},
//courier: <null>
//}",

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
    
    [[Postmates currentManager] getDeliveryForId:self.deliveryId withCallback:^(Delivery *delivery, NSError *error) {
        //        if (error) {
        //            NSLog(@"%@", [err localizedDescription]);
        //            NSLog(@"%@", res);
        //
        //            callback(nil, err);
        //        } else {
        //            NSLog(@"%@", res);
        //
        //            [self updateDeliveryInfoWithDict:res];
        //            callback(self, nil);
        //        }
    }];
}

- (void)cancelDeliveryWithCallback:(DeliveryCallbackBlock)callback {
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

- (void)returnDeliveryWithCallback:(DeliveryCallbackBlock)callback {
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
