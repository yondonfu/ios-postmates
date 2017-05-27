//
//  Postmates.m
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "Postmates.h"
#import "APIManager.h"

@implementation Postmates

static APIManager *currentApiManager = nil;

+ (nonnull APIManager *)currentManager {
    if (!currentApiManager.customerId || !currentApiManager.apiKey) {
        [NSException raise:@"Missing required fields" format:@"Customer ID or API key cannot be nil."];
    }
    
    return currentApiManager;
}

+ (void)setCustomerId:(nonnull NSString *)customerId apiKey:(nonnull NSString *)apiKey {
    if (!customerId || !apiKey) {
        [NSException raise:@"Missing required fields" format:@"Customer ID or API key cannot be nil."];
    }
    
    APIManager *manager = [[APIManager alloc] initWithCustomerId:customerId apiKey:apiKey];
    currentApiManager = manager;
}

+ (void)clearCurrentManager {
    currentApiManager = nil;
}

+ (nonnull NSString *)getCustomerId {
    return currentApiManager.customerId;
}

+ (nonnull NSString *)getApiKey {
    return currentApiManager.apiKey;
}

@end
