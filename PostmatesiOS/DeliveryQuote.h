//
//  DeliveryQuote.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryQuote : NSObject

@property (strong, nonatomic, readonly) NSString *quoteId;
@property (strong, nonatomic, readonly) NSString *kind;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *expired;
@property (assign, nonatomic) NSInteger fee;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSDate *dropOffEta;
@property (assign, nonatomic) NSInteger *duration;

+ (instancetype)generateDeliveryQuoteWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress;

@end
