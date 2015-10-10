//
//  APIManager.h
//  TestiOSPostmates
//
//  Created by Cal Hacks Squad on 10/9/15.
//  Copyright © 2015 calhackssquad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

@property (nonatomic, copy, readonly) NSString *customerId;
@property (nonatomic, copy, readonly) NSString *apiKey;

- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr andDropAddress: (NSString *)dropStr withCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)getDeliveriesWithCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)postDeliveryWithQuoteId:(NSString *)quoteId manifest:(NSString *)manifest manifest_reference:(NSString *)optionalRef pickupName:(NSString *)pickupName pickupAddress:(NSString *) pickupAddress pickupPhone:(NSString *)pickupPhone pickupBusinessName: (NSString *)optionalbusName pickupNotes: (NSString *)pickupNotes dropoffName: (NSString *)dropName dropAddress: (NSString *)dropAdd dropPhone: (NSString *)dropPhone dropBusinessName: (NSString *)optionalBusName andNotes: (NSString *)notes withCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)postDeliveryWithParams:(NSDictionary *)dict withCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback;
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback;

+ (NSString *)baseAPIUrl;

- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

@end