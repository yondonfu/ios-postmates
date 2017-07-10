//
//  Postmates.m
//  PostmatesiOS
//

#import "Postmates.h"
#import "APIManager.h"

@implementation Postmates

static APIManager *currentApiManager = nil;

+ (APIManager *)currentManager {
    if (!currentApiManager.customerId || !currentApiManager.apiKey) {
        [NSException raise:@"Missing required fields" format:@"Customer ID or API key cannot be nil."];
    }
    
    return currentApiManager;
}

+ (void)setCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey {
    if (!customerId || !apiKey) {
        [NSException raise:@"Missing required fields" format:@"Customer ID or API key cannot be nil."];
    }
    
    APIManager *manager = [[APIManager alloc] initWithCustomerId:customerId apiKey:apiKey];
    currentApiManager = manager;
}

+ (void)clearCurrentManager {
    currentApiManager = nil;
}

+ (NSString *)getCustomerId {
    return currentApiManager.customerId;
}

+ (NSString *)getApiKey {
    return currentApiManager.apiKey;
}

@end
