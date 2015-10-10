//
//  DeliveryQuote.m
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "DeliveryQuote.h"
#import "Postmates.h"

@implementation DeliveryQuote

- (instancetype)initWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress {
    self = [super init];
    if (!self) return nil;
    
    _pickUpAddress = pickUpAddress;
    _dropOffAddress = dropOffAddress;
    
    return self;
}

+ (instancetype)generateDeliveryQuoteWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress {
    DeliveryQuote *quote = [[self alloc] initWithPickUp:pickUpAddress dropOff:dropOffAddress];
    
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:pickUpAddress andDropAddress:dropOffAddress withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
        } else {
            NSLog(@"%@", res);
            
            quote.quoteId = [res objectForKey:@"id"];
            quote.kind = [res objectForKey:@"kind"];
            quote.created = [res objectForKey:@"created"];
            quote.expired = [res objectForKey:@"expired"];
            quote.fee = [res objectForKey:@"fee"];
            quote.currency = [res objectForKey:@"currency"];
            quote.dropOffEta = [res objectForKey:@"dropoff_eta"];
            quote.duration = [res objectForKey:@"duration"];
        }
    }];
    
    return quote;
}

@end
