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

+ (instancetype)createDeliveryWithParams:(NSDictionary *)params {
    Delivery *delivery = [[self alloc] initWithParams:params];
    
    [[Postmates currentManager] postDeliveryWithParams:params withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
        } else {
            NSLog(@"%@", res);
        }
    }];
    
    return delivery;
}

@end
