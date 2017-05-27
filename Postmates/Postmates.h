//
//  Postmates.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIManager.h"

@interface Postmates : NSObject

/**
 Set customer ID
 
 @param customerId Postmates customer ID
 @param apiKey     Postmates API key
 */
+ (void)setCustomerId:(nonnull NSString *)customerId apiKey:(nonnull NSString *)apiKey;

/**
 Current manager
 
 @return Shared instance of API manager
 */
+ (nonnull APIManager *)currentManager;

/**
 Sets current manager to nil
 */
+ (void)clearCurrentManager;

/**
 Customer ID
 
 @return Postmates customer ID in use
 */
+ (nonnull NSString *)getCustomerId;

/**
 API key
 
 @return Postmates API key in use
 */
+ (nonnull NSString *)getApiKey;

@end
