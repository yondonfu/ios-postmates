//
//  APIManager.m
//  PostmatesiOS
//

#import "APIManager.h"

#import "AFNetworking.h"

#ifdef DEBUG
NSString * const kPostmatesTestToken = @"Basic ZWZmY2RhOTItZWNjMy00ZGI2LWI5NTQtZjhkOTE0ZTA5NGQ5Og==";
#endif

NSString * const kPostmatesCustomersURL = @"https://api.postmates.com/v1/customers/";

@interface APIManager ()

@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *apiKey;

@end

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
    
    [self postWithURL:targetAddress parameters:parameters block:^(NSDictionary *response, NSError *error) {
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
- (void)postDeliveryWithManifest:(NSString *)manifest
               manifestReference:(NSString *)manifestReference
                      pickupName:(NSString *)pickupName
                   pickupAddress:(NSString *)pickupAddress
                     pickupPhone:(NSString *)pickupPhone
              pickupBusinessName:(NSString *)pickupBusinessName
                     pickupNotes:(NSString *)pickupNotes
                     dropoffName:(NSString *)dropName
                  dropoffAddress:(NSString *)dropoffAddress
                       dropPhone:(NSString *)dropPhone
                dropBusinessName:(NSString *)dropBusinessName
                        andNotes:(NSString *)notes
                    withCallback:(ResponseBlock)callback {
    
    NSDictionary *mand = @{ @"manifest"              : manifest,
                            @"manifest_reference"    : manifestReference,
                            @"pickup_name"           : pickupBusinessName,
                            @"pickup_address"        : pickupAddress,
                            @"pickup_phone_number"   : pickupPhone,
                            @"pickup_business_name"  : pickupBusinessName,
                            @"pickup_notes"          : pickupNotes,
                            @"dropoff_name"          : dropBusinessName,
                            @"dropoff_address"       : dropoffAddress,
                            @"dropoff_phone_number"  : dropPhone,
                            @"dropoff_business_name" : dropBusinessName,
                            @"dropoff_notes"         : notes };
    
    [self postDeliveryWithParams:mand withCallback:callback];
}

- (void)postDeliveryWithParams:(NSDictionary *)parameters withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", kPostmatesCustomersURL, self.customerId];
    
    [self postWithURL:targetAddress parameters:parameters block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customers/:customer_id/deliveries/:delivery_id
- (void)addTipForDelivery:(NSString *)deliveryId tip:(NSNumber *)tip withCallback:(DeliveryResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@", kPostmatesCustomersURL, self.customerId, deliveryId];
    NSDictionary *parameters = (tip) ? @{ @"tip_by_customer" : @(tip.doubleValue / 0.01) } : nil;
    
    [self postWithURL:targetAddress parameters:parameters block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            Delivery *delivery = [[Delivery alloc] initWithDictionary:response];
            callback(delivery, nil);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/cancel
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/cancel", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}

// /v1/delivery_zones
- (void)getDeliveryZonesWithCallback:(DeliveryZonesResponseBlock)callback {
    [self getWithURL:@"https://api.postmates.com/v1/delivery_zones" parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            NSMutableArray *zones = [NSMutableArray array];
            
            for (NSDictionary *dictionary in response) {
                DeliveryZone *zone = [[DeliveryZone alloc] initWithDictionary:dictionary];
                [zones addObject:zone];
            }
            
            callback(zones, error);
        } else {
            callback(nil, error);
        }
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/return
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(ResponseBlock)callback __deprecated {
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/return", kPostmatesCustomersURL, self.customerId, deliveryId];
    
    [self postWithURL:targetAddress parameters:nil block:^(NSDictionary *response, NSError *error) {
        if (!error) {
            callback(response, error);
        } else {
            callback(nil, error);
        }
    }];
}


# pragma mark - HTTP Helpers

- (void)getWithURL:(NSString *)url parameters:(NSDictionary *)parameters block:(ResponseBlock)callback {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        callback(nil, [self errorWithError:error status:response.statusCode]);
    }];
}

- (void)postWithURL:(NSString *)url parameters:(NSDictionary *)parameters block:(ResponseBlock)callback {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
#ifdef DEBUG
    [manager.requestSerializer setValue:kPostmatesTestToken forHTTPHeaderField:@"Authorization"];
#else
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.apiKey password:@""];
#endif
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        callback(nil, [self errorWithError:error status:response.statusCode]);
    }];
}

# pragma mark - Error Helpers

- (NSError *)errorWithError:(NSError *)error status:(NSInteger)status {
    if (!error) return nil;
    
    NSDictionary *errorDict = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:nil];
    NSString *message = (errorDict) ? [errorDict objectForKey:@"message"] : @"";
    NSString *statusInfo = nil;
    
    switch (status) {
        case 304:
            statusInfo = @"Not Modified: Resource hasn't been updated since the date provided.";
            break;
        case 400:
            statusInfo = @"Bad Request: You did something wrong. Often a missing argument or parameter.";
            break;
        case 401:
            statusInfo = @"Unauthorized: Authentication was incorrect.";
            break;
        case 404:
            statusInfo = @"Not Found";
            break;
        case 500:
            statusInfo = @"Internal Server Error: We had a problem processing the request.";
            break;
        case 503:
            statusInfo = @"Service Unavailable: Try again later.";
            break;
        default:
            statusInfo = @"Unknown Error";
            break;
    }
    
    return [[NSError alloc] initWithDomain:@"com.postmates.error" code:status userInfo:@{ @"status" : @(status), @"description" : statusInfo, @"message" : message }];;
}

@end
