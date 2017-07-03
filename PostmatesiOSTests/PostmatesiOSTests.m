//
//  PostmatesiOSTests.m
//  PostmatesiOSTests
//
//  Created by Ryan Cohen on 5/30/17.
//  Copyright © 2017 Cal Hacks Squad. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Postmates.h"

#define DELIVERY_ID       @"del_LJUeMxq_Qh9Qkk"
#define DELIVERY_QUOTE_ID @"dqt_LKaZ8vUDjWZ1_-"
#define DELIVERY_PICKUP   @"616 Garden St Hoboken NJ 07030"
#define DELIVERY_DROPOFF  @"700 Washington St Hoboken, NJ 07030"

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
            [expectation fulfill];
            XCTAssertNotNil(deliveries);
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testGetDeliveryForId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"get delivery for identifier"];
    
    // Get delivery from identifier
    [[Postmates currentManager] getDeliveryForId:DELIVERY_ID withCallback:^(Delivery *delivery, NSError *error) {
        if (!error) {
            [expectation fulfill];
            XCTAssertNotNil(delivery);
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testGetDeliveryQuote {
    XCTestExpectation *expectation = [self expectationWithDescription:@"get delivery quote"];
    
    // Get delivery quote
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:DELIVERY_PICKUP
                                                   andDropAddress:DELIVERY_DROPOFF
                                                     withCallback:^(DeliveryQuote *quote, NSError *error) {
                                                         [expectation fulfill];
                                                         XCTAssertNotNil(quote);
                                                     }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testPostDelivery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"post delivery request"];
    
    // Post delivery request
    [[Postmates currentManager] postDeliveryWithQuoteId:DELIVERY_QUOTE_ID
                                               manifest:@""
                                     manifest_reference:@""
                                             pickupName:@""
                                          pickupAddress:DELIVERY_PICKUP
                                            pickupPhone:@""
                                     pickupBusinessName:@""
                                            pickupNotes:@""
                                            dropoffName:@""
                                            dropAddress:DELIVERY_DROPOFF
                                              dropPhone:@""
                                       dropBusinessName:@""
                                               andNotes:@""
                                           withCallback:^(NSDictionary *response, NSError *error) {
                                               [expectation fulfill];
                                               XCTAssertNotNil(response);
                                           }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testCancelDeliveryForId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"cancel a delivery"];
    
    // Cancel delivery
    [[Postmates currentManager] cancelDeliveryForId:DELIVERY_ID withCallback:^(NSDictionary *response, NSError *error) {
        [expectation fulfill];
        XCTAssertNotNil(response);
    }];
    
    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
