//
//  APIManager.m
//  TestiOSPostmates
//
//  Created by Cal Hacks Squad on 10/9/15.
//  Copyright © 2015 calhackssquad. All rights reserved.
//

#import "APIManager.h"
#import "AFNetworking.h"

@implementation APIManager

- (instancetype)initWithCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey {
    self = [super init];
    if (!self) return nil;
    
    _customerId = [customerId copy];
    _apiKey = [apiKey copy];
    
    return self;
}

+ (NSString *)baseAPIUrl {
    return @"https://api.postmates.com";
}

// POST /v1/customers/:customer_id/delivery_quotes
- (void)getDeliveryQuoteWithPickupAddress:(NSString *)pickupStr andDropAddress: (NSString *)dropStr withCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/delivery_quotes", baseAddress, _customerId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager POST:targetAddress parameters:@{@"dropoff_address" : dropStr, @"pickup_address" : pickupStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

// GET /v1/customers/:customer_id/deliveries
- (void)getDeliveriesWithCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", baseAddress, _customerId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager GET:targetAddress parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

// POST /v1/customers/:customer_id/deliveries
- (void)postDeliveryWithQuoteId:(NSString *)quoteId manifest:(NSString *)manifest manifest_reference:(NSString *)optionalRef pickupName:(NSString *)pickupName pickupAddress:(NSString *) pickupAddress pickupPhone:(NSString *)pickupPhone pickupBusinessName: (NSString *)optionalbusName pickupNotes: (NSString *)pickupNotes dropoffName: (NSString *)dropName dropAddress: (NSString *)dropAdd dropPhone: (NSString *)dropPhone dropBusinessName: (NSString *)optionalBusName andNotes: (NSString *)notes withCallback:(void (^)(NSDictionary *, NSError *))callback {
    
    NSDictionary *mand = @{@"quote_id" : quoteId, @"manifest" : manifest, @"manifest_reference" : optionalRef , @"pickup_name" : pickupName , @"pickup_address" : pickupAddress, @"pickup_phone_number" : pickupPhone, @"pickup_business_name" : pickupName, @"pickup_notes" : pickupNotes, @"dropoff_name" : dropName, @"dropoff_address" : dropAdd, @"dropoff_phone_number" : dropPhone, @"dropoff_business_name" : dropName, @"dropoff_notes" : notes};
    
    [self postDeliveryWithParams:mand withCallback:callback];
}

- (void)postDeliveryWithParams:(NSDictionary *)dict withCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries", baseAddress, _customerId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager POST:targetAddress parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

// GET /v1/customers/:customer_id/deliveries/:delivery_id
- (void)getDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@", baseAddress, _customerId, deliveryId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager GET:targetAddress parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/return
- (void)returnDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/return", baseAddress, _customerId, deliveryId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager POST:targetAddress parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

// POST /v1/customer/:customer_id/deliveries/:delivery_id/cancel
- (void)cancelDeliveryForId:(NSString *)deliveryId withCallback:(void (^)(NSDictionary *, NSError *))callback {
    NSString *baseAddress = [[self.class baseAPIUrl] stringByAppendingString:@"/v1/customers/"];
    NSString *targetAddress = [NSString stringWithFormat:@"%@%@/deliveries/%@/cancel", baseAddress, _customerId, deliveryId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiKey password:@""];
    
    [manager POST:targetAddress parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSError *dictError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:&dictError];
        
        callback(json, error);
    }];
}

@end