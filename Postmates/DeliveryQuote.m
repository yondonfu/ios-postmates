//
//  DeliveryQuote.m
//  PostmatesiOS
//

#import "DeliveryQuote.h"
#import "Postmates.h"

@implementation DeliveryQuote

- (instancetype)initWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress {
    self = [super init];
    
    if (self) {
        _pickUpAddress = pickUpAddress;
        _dropOffAddress = dropOffAddress;
    }
    
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.quoteId = [dictionary objectForKey:@"id"];
        self.kind = [dictionary objectForKey:@"kind"];
        self.created = [dictionary objectForKey:@"created"];
        self.expires = [dictionary objectForKey:@"expires"];
        self.currency = [dictionary objectForKey:@"currency"];
        self.dropOffEta = [dictionary objectForKey:@"dropoff_eta"];
        self.duration = [[dictionary objectForKey:@"duration"] integerValue];
        
        int fee = [[dictionary objectForKey:@"fee"] intValue];
        self.fee = [NSNumber numberWithFloat:(fee * 0.01)];
    }
    
    return self;
}

- (void)generateDeliveryQuoteWithCallback:(DeliveryQuoteBlock)callback {
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:self.pickUpAddress andDropAddress:self.dropOffAddress withCallback:^(DeliveryQuote *quote, NSError *error) {
        if (!error) {
            callback(nil, error);
        } else {
            callback(quote, nil);
        }
    }];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"pickup_address: %@, dropoff_address: %@, kind: %@, id: %@, created: %@, expires: %@, fee: %@, currency: %@, dropoff_eta: %@, duration: %li",
            self.pickUpAddress, self.dropOffAddress, self.kind, self.quoteId, self.created, self.expires, self.fee, self.currency, self.dropOffEta, self.duration];
}

@end
