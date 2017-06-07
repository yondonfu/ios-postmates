//
//  ViewController.m
//  PostmatesiOS
//
//  Created by Cal Hacks Squad on 10/10/15.
//  Copyright © 2015 Cal Hacks Squad. All rights reserved.
//

#import "ViewController.h"
#import "Postmates.h"

#ifdef DEBUG
    static NSString *kCustomerId = @"cus_Kf3bMZuhfEUbQV";
#else
    static NSString *kCustomerId = @"cus_LHaCYzKoaOhZTF"
#endif

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set keys
    [Postmates setCustomerId:kCustomerId apiKey:@"91bfcd0b-7a0e-443b-a568-481da0b05c0c"];
    
    // Get a delivery quote [√]
    // [self testGetDeliveryQuote];
    
    [[Postmates currentManager] getDeliveryForId:@"del_LHaTEJmnjhtbMV" withCallback:^(Delivery *delivery, NSError *error) {
        NSLog(@" ***  DEliv: %@", delivery);
    }];
}

- (void)testGetDeliveryQuote {
    NSString *pickupAddr = @"616 Garden Street Hoboken NJ", *dropoffAddr = @"1000 Washington Street Hoboken NJ";
    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:pickupAddr andDropAddress:dropoffAddr withCallback:^(DeliveryQuote *quote, NSError *error) {
        NSLog(@"Quote: %@", quote);
    }];
}

- (void)test {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
