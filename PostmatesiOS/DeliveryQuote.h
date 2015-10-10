//
//  DeliveryQuote.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryQuote : NSObject

@property (strong, nonatomic) NSString *pickUpAddress;
@property (strong, nonatomic) NSString *dropOffAddress;
@property (strong, nonatomic) NSString *quoteId;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *expired;
@property (strong, nonatomic) NSNumber *fee;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSDate *dropOffEta;
@property (strong, nonatomic) NSNumber *duration;

- (instancetype)initWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress;

+ (instancetype)generateDeliveryQuoteWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress;

@end
