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

static APIManager *currentApiManager;

+ (void)setCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey {
    APIManager *manager = [[APIManager alloc] initWithCustomerId:customerId apiKey:apiKey];
    
    currentApiManager = manager;
}

+ (NSString *)getCustomerId {
    return currentApiManager.customerId;
}

+ (NSString *)getApiKey {
    return currentApiManager.apiKey;
}

+ (APIManager *)currentManager {
    return currentApiManager;
}

+ (void)clearCurrentManager {
    currentApiManager = nil;
}

@end
