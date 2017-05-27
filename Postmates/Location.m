//
//  Location.m
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "Location.h"
#import "Postmates.h"

@implementation Location

- (instancetype)initWithParams:(NSDictionary *)params {
    self = [super init];
    
    if (self) {
        _name = [params objectForKey:@"name"];
        _phoneNumber = [params objectForKey:@"phone_number"];
        _address = [params objectForKey:@"address"];
        _notes = [params objectForKey:@"notes"];
        
        NSDictionary *location = [params objectForKey:@"location"];
        _coordinates = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]);
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{name: %@, phone_number: %@, address: %@, notes: %@, location: {lat: %f, lng: %f}}", self.name, self.phoneNumber, self.address, self.notes, self.coordinates.latitude, self.coordinates.longitude];
}

@end
