//
//  APIManager.m
//  PostmatesiOS
//

#import "APIManager.h"
#import "AFNetworking.h"

NSString * const kPostmatesTestToken = @"Basic ZWZmY2RhOTItZWNjMy00ZGI2LWI5NTQtZjhkOTE0ZTA5NGQ5Og==";

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
        _customerId = customerId;
        _apiKey = apiKey;
    }
    
    return self;
}

# pragma mark - GET Endpoints

// GET /v1/customers/:customer_id/deliveries
- (void)getDeliveriesWithCallback:(DeliveriesResponseBlock)callback filterOngoing:(BOOL)filterOngoing {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", kPostmatesCustomersURL, self.customerId];
    targetAddress = (filterOngoing) ? [targetAddress stringByAppendingString:@"?filter=ongoing"] : targetAddress;
    
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
                
                callback(deliveries, error);
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
            
            callback(quote, error);
        } else {
            callback(nil, error);
        }
    }];
}

// GET /v1/customers/:customer_id/deliveries/:delivery_id
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(DeliveryResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self getWithURL:targetAddress parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            Delivery *delivery = [[Delivery alloc] initWithDictionary:response];
            callback(delivery, error);
        } else {
            callback(nil, error);
        }
    }];
}

# pragma mark - POST Endpoints

// POST /v1/customers/:customer_id/deliveries
- (void)postDeliveryWithQuoteId:(NSString *)quoteId
                       manifest:(NSString *)manifest
             manifest_reference:(NSString *)optionalRef
                     pickupName:(NSString *)pickupName
                  pickupAddress:(NSString *) pickupAddress
                    pickupPhone:(NSString *)pickupPhone
             pickupBusinessName:(NSString *)optionalBusinessName
                    pickupNotes:(NSString *)pickupNotes
                    dropoffName:(NSString *)dropName
                    dropAddress:(NSString *)dropAdd
                      dropPhone:(NSString *)dropPhone
               dropBusinessName:(NSString *)optionalBusName
                       andNotes:(NSString *)notes
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

- (void)postDeliveryWithParams:(NSDictionary *)parameters withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", kPostmatesCustomersURL, self.customerId];
    
    [self postWithURL:targetAddress paramaters:parameters block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customers/:customer_id/deliveries/:delivery_id
- (void)addTipForDelivery:(NSString *)deliveryId tip:(NSNumber *)tip withCallback:(DeliveryResponseBlock)block {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/return", kPostmatesCustomersURL, self.customerId, deliveryId];
    NSDictionary *parameters = (tip) ? @{ @"tip_by_customer" : @(tip.doubleValue / 0.01) } : nil;
    
    [self postWithURL:targetAddress paramaters:parameters block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            Delivery *delivery = [[Delivery alloc] initWithDictionary:response];
            block(delivery, nil);
        } else {
            block(nil, error);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/return
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback __deprecated {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/return", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress paramaters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/cancel
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/cancel", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress paramaters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}

# pragma mark - HTTP Helpers

- (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters block:(ResponseBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}

- (void)postWithURL:(NSString *)url paramaters:(NSDictionary *)parameters block:(ResponseBlock)block {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        block(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    }];
}

@end
