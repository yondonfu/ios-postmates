//
//  Delivery.h
//  PostmatesiOS
//

#import <Foundation/Foundation.h>

#import "DeliveryQuote.h"
#import "Location.h"

@class Delivery;

typedef NS_ENUM(NSUInteger, DeliveryStatus) {
    DeliveryStatusPending = 1,
    DeliveryStatusPickup,
    DeliveryStatusPickupComplete,
    DeliveryStatusDropoff,
    DeliveryStatusCanceled,
    DeliveryStatusDelivered,
    DeliveryStatusReturned
};

typedef void (^DeliveryCallbackBlock)(Delivery * _Nullable delivery, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

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

@property (strong, nonatomic) DeliveryQuote *quote;
@property (strong, nonatomic) NSNumber *fee;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSDictionary *manifest;

@property (strong, nonatomic) NSString *dropOffId;
@property (strong, nonatomic) Location *pickUp;
@property (strong, nonatomic) Location *dropOff;

@property (strong, nonatomic) NSDictionary *courier;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)cancelDeliveryWithCallback:(DeliveryCallbackBlock)callback;
- (void)returnDeliveryWithCallback:(DeliveryCallbackBlock)callback __deprecated;
- (void)updateDeliveryStatusWithCallback:(DeliveryCallbackBlock)callback;

@end

NS_ASSUME_NONNULL_END
