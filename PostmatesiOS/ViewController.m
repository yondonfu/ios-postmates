//
//  ViewController.m
//  PostmatesiOS
//
//  Created by Cal Hacks Squad on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "ViewController.h"
#import "Postmates.h"
#import "APIManager.h"
#import "DeliveryQuote.h"
#import "Delivery.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // TESTS
    
    // Delivery quotes
    DeliveryQuote *quote = [[DeliveryQuote alloc] initWithPickUp:@"313B Eureka Street, San Francisco, CA" dropOff:@"637 Natoma Street, San Francisco, CA"];
    
    [quote generateDeliveryQuoteWithCallback:^(DeliveryQuote *quote, NSError *err) {
        if (!err) {
            NSLog(@"QUOTE: %@", quote);
        }
    }];
    
    // Delivery
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:quote.quoteId forKey:@"quote_id"];
    [params setValue:@"A test pkg" forKey:@"manifest"];
    [params setValue:@"Order #1" forKey:@"manifest_reference"];
    [params setValue:@"House" forKey:@"pickup_name"];
    [params setValue:quote.pickUpAddress forKey:@"pickup_address"];
    [params setValue:@"9173710368" forKey:@"pickup_phone_number"];
    [params setValue:@"Ring doorbell" forKey:@"pickup_notes"];
    [params setValue:@"Test" forKey:@"dropoff_name"];
    [params setValue:@"9173710368" forKey:@"dropoff_phone_number"];
    [params setValue:quote.dropOffAddress forKey:@"dropoff_address"];
    [params setValue:@"Knock" forKey:@"dropoff_notes"];
    
    Delivery *delivery = [[Delivery alloc] initWithParams:params];
    
    [delivery createDeliveryWithParams:params withCallback:^(Delivery *delivery, NSError *err) {
        if (!err) {
            NSLog(@"DELIVERY: %@", delivery);
            
////            // Get status
////            [delivery updateDeliveryStatusWithCallback:^(Delivery *delivery, NSError *err) {
////                if (!err) {
////                    NSLog(@"UPDATE STATUS: %@", delivery);
////                }
////            }];
//            
////            // Cancel delivery
////            [delivery cancelDeliveryWithCallback:^(Delivery *delivery, NSError *err) {
////                if (!err) {
////                    NSLog(@"%@", delivery);
////                }
////            }];
////
//            // Return delivery
//            [delivery returnDeliveryWithCallback:^(Delivery *delivery, NSError *err) {
//                if (!err) {
//                    NSLog(@"%@", delivery);
//                }
//            }];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
