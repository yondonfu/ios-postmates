//
//  APIManager.m
//  PostmatesiOS
//
//  Created by Cal Hacks Squad on 10/9/15.
//  Copyright © 2015 calhackssquad. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

static NSString *kPostmatesTestToken = @"Basic ZWZmY2RhOTItZWNjMy00ZGI2LWI5NTQtZjhkOTE0ZTA5NGQ5Og==";

typedef void (^ResponseBlock)(NSDictionary *response, NSError *error);

@interface APIManager ()

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *apiKey;

@end

static const NSString *kPostmatesCustomersURL = @"https://api.postmates.com/v1/customers/";

@implementation APIManager

# pragma mark - Init

- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey {
    self = [super init];
    
    if (self) {
        self.customerId = customerId;
        self.apiKey = apiKey;
    }
    
    return self;
}

# pragma mark - Endpoints

// GET /v1/customers/:customer_id/deliveries
- (void)getDeliveriesWithCallback:(DeliveriesResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", kPostmatesCustomersURL, self.customerId];
    __block NSMutableArray<Delivery *> *deliveries = [NSMutableArray array];
    
    [self getWithURL:targetAddress parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            if ([response objectForKey:@"data"]) {
                for (NSDictionary *deliveryDict in response[@"data"]) {
                    Delivery *delivery = [[Delivery alloc] initWithDictionary:deliveryDict];
                    
                    if (![deliveries containsObject:delivery]) {
                        [deliveries addObject:delivery];
                    }
                }
                
                callback(deliveries, nil);
            }
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customers/:customer_id/delivery_quotes
- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr andDropAddress:(NSString *)dropStr withCallback:(DeliveryQuoteResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/delivery_quotes", kPostmatesCustomersURL, self.customerId];
    NSDictionary *parameters = @{ @"dropoff_address" : dropStr, @"pickup_address" : pickupStr };
    
    [self postWithURL:targetAddress paramaters:parameters block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            DeliveryQuote *quote = nil;
            
            if ([response objectForKey:@"id"]) {
                quote = [[DeliveryQuote alloc] initWithDictionary:response];
            }
            
            callback(quote, nil);
        } else {
            callback(nil, nil);
        }
    }];
}

// GET /v1/customers/:customer_id/deliveries/:delivery_id
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(DeliveryResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self getWithURL:targetAddress parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            Delivery *delivery = [[Delivery alloc] initWithDictionary:response];
            callback(delivery, nil);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customers/:customer_id/deliveries
- (void)postDeliveryWithQuoteId:(NSString *)quoteId
                       manifest:(NSString *)manifest
             manifest_reference:(NSString *)optionalRef
                     pickupName:(NSString *)pickupName
                  pickupAddress:(NSString *) pickupAddress
                    pickupPhone:(NSString *)pickupPhone
             pickupBusinessName: (NSString *)optionalbusName
                    pickupNotes: (NSString *)pickupNotes
                    dropoffName: (NSString *)dropName
                    dropAddress: (NSString *)dropAdd
                      dropPhone: (NSString *)dropPhone
               dropBusinessName: (NSString *)optionalBusName
                       andNotes: (NSString *)notes
                   withCallback:(ResponseBlock)callback {
    
    NSDictionary *mand = @{ @"quote_id" : quoteId,
                            @"manifest" : manifest,
                            @"manifest_reference" : optionalRef,
                            @"pickup_name" : pickupName ,
                            @"pickup_address" : pickupAddress,
                            @"pickup_phone_number" : pickupPhone,
                            @"pickup_business_name" : pickupName,
                            @"pickup_notes" : pickupNotes,
                            @"dropoff_name" : dropName,
                            @"dropoff_address" : dropAdd,
                            @"dropoff_phone_number" : dropPhone,
                            @"dropoff_business_name" : dropName,
                            @"dropoff_notes" : notes };
    
    [self postDeliveryWithParams:mand withCallback:callback];
}

- (void)postDeliveryWithParams:(NSDictionary *)dict withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", kPostmatesCustomersURL, self.customerId];
    
    [self postWithURL:targetAddress paramaters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, nil);
        } else {
            callback(nil, nil);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/return
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/return", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress paramaters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, nil);
        } else {
            callback(nil, nil);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/cancel
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/cancel", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress paramaters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, nil);
        } else {
            callback(nil, nil);
        }
    }];
}

# pragma mark - Helpers

- (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters block:(ResponseBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    // Don't set username when using dev token
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // NSError *dictError;
        // NSDictionary *json = [NSJSONSerialization JSONObjectWithData:task. options:kNilOptions error:&dictError];
        block(nil, error);
    }];
    
    //    [[self sessionManager] GET:targetAddress parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        callback(responseObject, nil);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSError *dictError;
    //        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
    //
    //        callback(json, error);
    //    }];
}

- (void)postWithURL:(NSString *)url paramaters:(NSDictionary *)parameters block:(ResponseBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    // Don't set username when using dev token
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}

@end
