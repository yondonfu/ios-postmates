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

- (void)generateDeliveryQuoteWithCallback:(void (^)(DeliveryQuote *quote, NSError *err))callback {
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:self.pickUpAddress andDropAddress:self.dropOffAddress withCallback:^(NSDictionary *res, NSError *err) {
        if (err) {
            NSLog(@"%@", [err localizedDescription]);
            NSLog(@"%@", res);
            
            callback(nil, err);
        } else {
            NSLog(@"%@", res);
            
            [self updateDeliveryQuoteWithDict:res];
            
            callback(self, nil);
        }
    }];
}


- (void)updateDeliveryQuoteWithDict:(NSDictionary *)dict {
    self.quoteId = [dict objectForKey:@"id"];
    self.kind = [dict objectForKey:@"kind"];
    self.created = [dict objectForKey:@"created"];
    self.expires = [dict objectForKey:@"expires"];
    self.fee = [[dict objectForKey:@"fee"] integerValue];
    self.currency = [dict objectForKey:@"currency"];
    self.dropOffEta = [dict objectForKey:@"dropoff_eta"];
    self.duration = [[dict objectForKey:@"duration"] integerValue];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pickup_address: %@, dropoff_address: %@, kind: %@, id: %@, created: %@, expires: %@, fee: %ld, currency: %@, dropoff_eta: %@, duration: %ld",
            self.pickUpAddress, self.dropOffAddress, self.kind, self.quoteId, self.created, self.expires, (long)self.fee, self.currency, self.dropOffEta, (long)self.duration];
}

@end
