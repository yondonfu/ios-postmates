//
//  APIManager.h
//  PostmatesiOS
//
//  Created by Cal Hacks Squad on 10/9/15.
//  Copyright © 2015 calhackssquad. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(NSDictionary *response, NSError *error);

@interface APIManager : NSObject

@property (nonatomic, readonly) NSString *customerId;
@property (nonatomic, readonly) NSString *apiKey;

- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr
                           andDropAddress:(NSString *)dropStr
                             withCallback:(ResponseBlock)callback;

- (void)getDeliveriesWithCallback:(ResponseBlock)callback;

- (void)postDeliveryWithQuoteId:(NSString *)quoteId
                       manifest:(NSString *)manifest
             manifest_reference:(NSString *)optionalRef
                     pickupName:(NSString *)pickupName
                  pickupAddress:(NSString *) pickupAddress
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
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback;

- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

@end
