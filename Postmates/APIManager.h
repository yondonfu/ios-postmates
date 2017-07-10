//
//  APIManager.h
//  PostmatesiOS
//

#import <Foundation/Foundation.h>

#import "Delivery.h"

/**
 Multi-delivery response
 */
typedef void (^DeliveriesResponseBlock)(NSArray<Delivery *> * _Nullable deliveries, NSError * _Nullable error);

/**
 Delivery response
 */
typedef void (^DeliveryResponseBlock)(Delivery * _Nullable delivery, NSError * _Nullable error);

/**
 Delivery quote response
 */
typedef void (^DeliveryQuoteResponseBlock)(DeliveryQuote * _Nullable quote, NSError * _Nullable error);

/**
 Generic dictionary/error response block
 */
typedef void (^ResponseBlock)(NSDictionary * _Nullable response, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

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
 Init Customer ID
 
 @param customerId Customer ID
 @param apiKey     API key
 @return APIManager instance
 */
- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

/**
 Get all deliveries
 
 @param filterOngoing   Only return deliveries that are currently being delivered
 @param block           Block containing `Delivery` objects or an `NSError`
 */
- (void)getDeliveriesWithCallback:(DeliveriesResponseBlock)block filterOngoing:(BOOL)filterOngoing;

/**
 Get delivery
 
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
 Create delivery request
 
 @param quoteId              The ID of a previously generated delivery quote. Optional, but recommended. Example: "del_KSsT9zJdfV3P9k"
 @param manifest             A detailed description of what the courier will be delivering. Example: "A box of gray kittens"
 @param optionalRef          Optional reference that identifies the manifest. Example: "Order #690"
 @param pickupName           Name of the place where the courier will make the pickup. Example: "Kitten Warehouse"
 @param pickupAddress        The pickup address for the delivery. Example: "20 McAllister St, San Francisco, CA"
 @param pickupPhone          The phone number of the pickup location. Example: "415-555-4242"
 @param optionalBusinessName Optional business name of the pickup location. Example: "Feline Enterprises, Inc."
 @param pickupNotes          Additional instructions for the courier at the pickup location. Example: "Ring the doorbell twice"
 @param dropName             Name of the place where the courier will make the dropoff. Example: "Alice"
 @param dropAdd              The dropoff address for the delivery. Example: "678 Green St, San Francisco, CA"
 @param dropPhone            The phone number of the dropoff location. Example: "415-555-8484"
 @param optionalBusName      Optional business name of the dropoff location. Example: "Alice's Cat Cafe"
 @param notes                Additional instructions for the courier at the dropoff location. Example: "Tell the security guard that you're here to see Alice."
 @param callback             Callback
 */
- (void)postDeliveryWithQuoteId:(NSString *)quoteId
                       manifest:(NSString *)manifest
             manifest_reference:(NSString *)optionalRef
                     pickupName:(NSString *)pickupName
                  pickupAddress:(NSString *)pickupAddress
                    pickupPhone:(NSString *)pickupPhone
             pickupBusinessName:(NSString *)optionalBusinessName
                    pickupNotes:(NSString *)pickupNotes
                    dropoffName:(NSString *)dropName
                    dropAddress:(NSString *)dropAdd
                      dropPhone:(NSString *)dropPhone
               dropBusinessName:(NSString *)optionalBusName
                       andNotes:(NSString *)notes
                   withCallback:(ResponseBlock)callback;

/**
 Create delivery request (dictionary)
 
 @param parameters Delivery quote
 @param callback   Callback
 */
- (void)postDeliveryWithParams:(NSDictionary *)parameters withCallback:(ResponseBlock)callback;

/**
 Add tip
 
 @param deliveryId Delivery ID
 @param tip        Tip amount (e.g. 3.50)
 @param block      If error is 410, the order can no longer be tipped (7 days)
 */
- (void)addTipForDelivery:(NSString *)deliveryId tip:(NSNumber *)tip withCallback:(DeliveryResponseBlock)block;

/**
 Cancel delivery
 
 @param deliveryId Delivery ID
 @param callback   Callback
 */
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;

/**
 Return delivery by identifier (deprecated Nov 2016)
 https://postmates.com/developer/docs/endpoints#return_delivery
 
 @param deliveryId Delivery ID
 @param callback   Callback
 */
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback __deprecated;

@end

NS_ASSUME_NONNULL_END
