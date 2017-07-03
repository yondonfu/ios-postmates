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
 Get all deliveries
 
 @param block Block containing `Delivery` objects or an `NSError`
 */
- (void)getDeliveriesWithCallback:(DeliveriesResponseBlock)block;

/**
 Get delivery by ID
 
 @param deliveryId Delivery ID
 @param block      Callback containing matching delivery
 */
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(DeliveryResponseBlock)block;

/**
 Get delivery quote
 
 @param pickupStr Pickup address
 @param dropStr   Dropoff address
 @param callback  Callback containing a `DeliveryQuote` object or an `NSError`
 */
- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr
                           andDropAddress:(NSString *)dropStr
                             withCallback:(DeliveryQuoteResponseBlock)callback;

/**
 Post delivery request
 
 @param quoteId <#quoteId description#>
 @param manifest <#manifest description#>
 @param optionalRef <#optionalRef description#>
 @param pickupName <#pickupName description#>
 @param pickupAddress <#pickupAddress description#>
 @param pickupPhone <#pickupPhone description#>
 @param optionalbusName <#optionalbusName description#>
 @param pickupNotes <#pickupNotes description#>
 @param dropName <#dropName description#>
 @param dropAdd <#dropAdd description#>
 @param dropPhone <#dropPhone description#>
 @param optionalBusName <#optionalBusName description#>
 @param notes <#notes description#>
 @param callback <#callback description#>
 */
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

/**
 Post delivery request (dictionary)
 
 @param dict <#dict description#>
 @param callback <#callback description#>
 */
- (void)postDeliveryWithParams:(NSDictionary *)dict withCallback:(ResponseBlock)callback;

/**
 <#Description#>
 
 @param deliveryId <#deliveryId description#>
 @param callback <#callback description#>
 */
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;

/**
 Return delivery by identifier (deprecated)
 https://postmates.com/developer/docs/endpoints#return_delivery
 
 @param deliveryId Delivery ID
 @param callback <#callback description#>
 */
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback __deprecated;

/**
 <#Description#>
 
 @param customerId <#customerId description#>
 @param apiKey <#apiKey description#>
 @return <#return value description#>
 */
- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

@end
