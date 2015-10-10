//
//  Delivery.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryQuote.h"

typedef enum {
    Pending = 1,
    Pickup,
    PickupComplete,
    Dropoff,
    Canceled,
    Delivered,
    Returned
} DeliveryStatus;

@interface Delivery : NSObject

@property (strong, nonatomic) NSString *pickUpAddress;
@property (strong, nonatomic) NSString *dropOffAddress;

@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *deliveryId;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *updated;
@property (assign, nonatomic) DeliveryStatus status;
@property (assign, nonatomic) BOOL complete;
@property (strong, nonatomic) NSDate *pickUpEta;
@property (strong, nonatomic) NSDate *dropOffEta;
@property (strong, nonatomic) NSDate *dropOffDeadline;
@property (strong, nonatomic) DeliveryQuote *quote; // Optional
@property (assign, nonatomic) NSInteger fee;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSDictionary *manifest;
@property (strong, nonatomic) NSString *dropOffId;
@property (strong, nonatomic) NSDictionary *courier;

- (instancetype)initWithParams:(NSDictionary *)params;

+ (instancetype)createDeliveryWithParams:(NSDictionary *)params;


@end
