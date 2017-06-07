//
//  APIManager.h
//  PostmatesiOS
//
//  Created by Cal Hacks Squad on 10/9/15.
//  Copyright © 2015 calhackssquad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Delivery.h"

typedef void (^ResponseBlock)(NSDictionary *response, NSError *error); // will be generic fail block. make internal

typedef void (^DeliveriesResponseBlock)(NSArray<Delivery *> *deliveries, NSError *error);
typedef void (^DeliveryResponseBlock)(Delivery *delivery, NSError *error);
typedef void (^DeliveryQuoteResponseBlock)(DeliveryQuote *quote, NSError *error);

@interface APIManager : NSObject

/**
 Customer ID token used for requests
 */
@property (nonatomic, readonly) NSString *customerId;

/**
 API key used for requests
 */
@property (nonatomic, readonly) NSString *apiKey;

/**
 Get deliveries
 
 @param Callback containing `Delivery` objects or an `NSError`
 */
- (void)getDeliveriesWithCallback:(DeliveriesResponseBlock)block;

/**
 Get delivery by ID
 
 @param deliveryId Delivery ID
 @param block      Callback containing matching delivery
 */
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(DeliveryResponseBlock)block;

/**
 Get delivery Quote
 
 @param pickupStr Pickup address
 @param dropStr   Dropoff address
 @param callback  Callback containing a `DeliveryQuote` object or an `NSError`
 */
- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr
                           andDropAddress:(NSString *)dropStr
                             withCallback:(DeliveryQuoteResponseBlock)callback;

- (void)postDeliveryWithQuoteId:(NSString *)quoteId
                       manifest:(NSString *)manifest
             manifest_reference:(NSString *)optionalRef
                     pickupName:(NSString *)pickupName
                  pickupAddress:(NSString *)pickupAddress
                    pickupPhone:(NSString *)pickupPhone
             pickupBusinessName:(NSString *)optionalbusName
                    pickupNotes:(NSString *)pickupNotes
                    dropoffName:(NSString *)dropName
                    dropAddress:(NSString *)dropAdd
                      dropPhone:(NSString *)dropPhone
               dropBusinessName:(NSString *)optionalBusName
                       andNotes:(NSString *)notes
                   withCallback:(ResponseBlock)callback;

- (void)postDeliveryWithParams:(NSDictionary *)dict withCallback:(ResponseBlock)callback;
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;

- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

@end
