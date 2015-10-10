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

+ (void)setCustomerId:(NSString *)customerId apiKey:(NSString *)apiKey;

+ (NSString *)getCustomerId;

+ (NSString *)getApiKey;

+ (APIManager *)currentManager;

+ (void)clearCurrentManager;

@end
