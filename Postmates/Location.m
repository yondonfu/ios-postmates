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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _name = [dictionary objectForKey:@"name"];
        _phoneNumber = [dictionary objectForKey:@"phone_number"];
        _address = [dictionary objectForKey:@"address"];
        _notes = [dictionary objectForKey:@"notes"];
        
        NSDictionary *location = [dictionary objectForKey:@"location"];
        _coordinates = CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]);
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{ name: %@, phone_number: %@, address: %@, notes: %@, location: (%f, %f) }", self.name, self.phoneNumber, self.address, self.notes, self.coordinates.latitude, self.coordinates.longitude];
}

@end
