//
//  Delivery.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryQuote.h"
#import "Location.h"

typedef NS_ENUM(NSUInteger, DeliveryStatus) {
    DeliveryStatusPending = 1,
    DeliveryStatusPickup,
    DeliveryStatusPickupComplete,
    DeliveryStatusDropoff,
    DeliveryStatusCanceled,
    DeliveryStatusDelivered,
    DeliveryStatusReturned
};

@interface Delivery : NSObject

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
@property (strong, nonatomic) Location *pickUp;
@property (strong, nonatomic) Location *dropOff;
@property (strong, nonatomic) NSDictionary *courier;

- (instancetype)initWithParams:(NSDictionary *)params;

- (void)createDeliveryWithParams:(NSDictionary *)params withCallback:(void (^)(Delivery *delivery, NSError *error))callback;
- (void)cancelDeliveryWithCallback:(void (^)(Delivery *delivery, NSError *err))callback;
- (void)returnDeliveryWithCallback:(void (^)(Delivery *delivery, NSError *err))callback;
- (void)updateDeliveryStatusWithCallback:(void (^)(Delivery *delivery, NSError *err))callback;

@end
