//
//  Postmates.h
//  PostmatesiOS
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface Postmates : NSObject

/**
 Set customer ID
 
 @param customerId Postmates customer ID
 @param apiKey     Postmates API key
 */
+ (void)setCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

/**
 Current manager
 
 @return Shared instance of API manager
 */
+ (APIManager *)currentManager;

/**
 Sets current manager to nil
 */
+ (void)clearCurrentManager;

/**
 Customer ID
 
 @return Postmates customer ID in use
 */
+ (NSString *)getCustomerId;

/**
 API key
 
 @return Postmates API key in use
 */
+ (NSString *)getApiKey;

@end

NS_ASSUME_NONNULL_END
