//
//  PostmatesiOSTests.m
//  PostmatesiOSTests
//
//  Created by Ryan Cohen on 5/30/17.
//  Copyright © 2017 Cal Hacks Squad. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Postmates.h"

@interface PostmatesiOSTests : XCTestCase

@end

@implementation PostmatesiOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testGetDeliveries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"get deliveries"];
    
    // Get all deliveries for user
    [[Postmates currentManager] getDeliveriesWithCallback:^(NSArray<Delivery *> *deliveries, NSError *error) {
        if (!error) {
            NSLog(@"Deliveries: %@", deliveries);
            XCTAssertGreaterThan(deliveries, 0);
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
