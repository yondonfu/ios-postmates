//
//  PostmatesiOSTests.m
//  PostmatesiOSTests
//

#import <XCTest/XCTest.h>

#import "Postmates.h"

#define DELIVERY_ID       @"del_LJUeMxq_Qh9Qkk"
#define DELIVERY_QUOTE_ID @"dqt_LKaZ8vUDjWZ1_-"
#define DELIVERY_PICKUP   @"20 McAllister St, San Francisco, CA"
#define DELIVERY_DROPOFF  @"101 Market St, San Francisco, CA"
#define TIMEOUT_SEC       10

@interface PostmatesiOSTests : XCTestCase
@end

@implementation PostmatesiOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testGetDeliveries {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get deliveries"];
    
    // Get all deliveries for user
    [[Postmates currentManager] getDeliveriesWithCallback:^(NSArray<Delivery *> *deliveries, NSError *error) {
        XCTAssertNotNil(deliveries);
        [expectation fulfill];
    } filterOngoing:NO];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testGetDeliveryForId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get delivery for identifier"];
    
    // Get delivery by identifier
    [[Postmates currentManager] getDeliveryForId:DELIVERY_ID withCallback:^(Delivery *delivery, NSError *error) {
        XCTAssertNotNil(delivery);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testGetDeliveryQuote {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get delivery quote"];
    
    // Get delivery quote
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:DELIVERY_PICKUP
                                                   andDropAddress:DELIVERY_DROPOFF
                                                     withCallback:^(DeliveryQuote *quote, NSError *error) {
                                                         XCTAssertNotNil(quote);
                                                         [expectation fulfill];
                                                     }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testPostDeliveryWithDictionary {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Post delivery request with dictionary"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{ @"manifest"              : @"A box of trees",
                                                                                       @"manifest_reference"    : @"Optional reference that identifies the box of trees",
                                                                                       @"pickup_name"           : @"The Warehouse",
                                                                                       @"pickup_address"        : DELIVERY_PICKUP,
                                                                                       @"pickup_phone_number"   : @"555-555-5555",
                                                                                       @"pickup_business_name"  : @"Optional Pickup Business Name, Inc.",
                                                                                       @"pickup_notes"          : @"Optional note that this is Invoice #123",
                                                                                       @"dropoff_name"          : @"Alice",
                                                                                       @"dropoff_address"       : DELIVERY_DROPOFF,
                                                                                       @"dropoff_phone_number"  : @"415-555-1234",
                                                                                       @"dropoff_business_name" : @"Optional Dropoff Business Name, Inc.",
                                                                                       @"dropoff_notes"         : @"Optional note to ring the bell" }];
#if DEBUG
    // Test mode
    // https://postmates.com/developer/docs#testing
    
    parameters[@"robo_pickup"] = @"00:10:00";
    parameters[@"robo_pickup_complete"] = @"00:20:00";
    parameters[@"robo_dropoff"] = @"00:21:00";
    parameters[@"robo_delivered"] = @"00:34:00";
#endif
    
    // Create delivery request
    [[Postmates currentManager] postDeliveryWithParams:parameters withCallback:^(NSDictionary *response, NSError *error) {
        XCTAssertNotNil(response);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testPostDeliveryWithInit {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Post delivery request with init"];
    
    [[Postmates currentManager] postDeliveryWithManifest:@"A box of trees"
                                       manifestReference:@"Some reference"
                                              pickupName:@"The Warehouse"
                                           pickupAddress:DELIVERY_PICKUP
                                             pickupPhone:@"555-555-5555"
                                      pickupBusinessName:@"My Office"
                                             pickupNotes:@"Please?"
                                             dropoffName:@"Ryan"
                                          dropoffAddress:DELIVERY_DROPOFF
                                               dropPhone:@"415-555-1234"
                                        dropBusinessName:@"Business Inc."
                                                andNotes:@"Ring the bell!"
                                            withCallback:^(NSDictionary *response, NSError *error) {
                                                XCTAssertNotNil(response);
                                                [expectation fulfill];
                                            }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testAddTipForDelivery {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Add tip to a delivery"];
    
    // Add tip to delivery
    [[Postmates currentManager] addTipForDelivery:DELIVERY_ID tip:@3.50 withCallback:^(Delivery *delivery, NSError *error) {
        // Delivery past tip window
        if (error.code == 400) {
            XCTAssertTrue(error.code == 400);
            [expectation fulfill];
        } else {
            XCTAssertNotNil(delivery);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testCancelDeliveryForId {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Cancel a delivery"];
    
    // Cancel delivery
    [[Postmates currentManager] cancelDeliveryForId:DELIVERY_ID withCallback:^(NSDictionary *response, NSError *error) {
        // Delivery cannot be cancelled (old ID)
        if (error.code == 400) {
            XCTAssertTrue(error.code == 400);
            [expectation fulfill];
        } else {
            XCTAssertNotNil(response);
            [expectation fulfill];
        }
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)testGetDeliveryZones {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get delivery zones"];
    
    // Get delivery zones
    [[Postmates currentManager] getDeliveryZonesWithCallback:^(NSArray<DeliveryZone *> *zones, NSError *error) {
        XCTAssertNotNil(zones);
        [expectation fulfill];
    }];
    
    [self waitForExpectations:@[expectation] timeout:TIMEOUT_SEC];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
