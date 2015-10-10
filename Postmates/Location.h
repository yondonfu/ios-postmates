//
//  Location.h
//  PostmatesiOS
//
//  Created by Yondon Fu on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@interface Location : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *notes;
@property (assign, nonatomic) CLLocationCoordinate2D coordinates;

- (instancetype)initWithParams:(NSDictionary *)params;

@end
