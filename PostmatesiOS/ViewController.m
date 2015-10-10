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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DeliveryQuote *quote = [[DeliveryQuote alloc] initWithPickUp:@"20 McAllister St, San Francisco, CA" dropOff:@"678 Green St, San Francisco, CA"];
    
    [quote generateDeliveryQuoteWithCallback:^(DeliveryQuote *quote, NSError *err) {
        if (!err) {
            NSLog(@"%@", quote);
        }
    }];
    
    
    
//    [[Postmates currentManager] getDeliveriesWithCallback:^(NSDictionary *res, NSError *err) {
//        if (err) {
//            NSLog(@"%@", [err localizedDescription]);
//            NSLog(@"%@", res);
//        } else {
//            NSLog(@"%@", res);
//        }
//    }];
    
//    [[Postmates currentManager] getDeliveryQuoteWithPickupAddress:@"20 McAllister St, San Francisco, CA" andDropAddress:@"678 Green St, San Francisco, CA" withCallback:^(NSDictionary *res, NSError *err){
//        if(!err){
//            NSLog(@"Quote: %@" , res);
//        }
//        else{
//            NSLog(@"Error getting quote: %@", err.description);
//        }
//    }];
    
    /*
     
        TEST METHODS:
     
        [example getDeliveriesWithCallback:^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"All deliveries: %@" , res);
            }
            else{
                NSLog(@"Error getting all deliveries: %@", err.description);
            }
        }];
        
        [example getDeliveryQuoteWithPickupAddress:@"20 McAllister St, San Francisco, CA" andDropAddress:@"" withCallback:^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"Quote: %@" , res);
            }
            else{
                NSLog(@"Error getting quote: %@", err.description);
            }
        }];
        
        [example getDeliveryForId:@"1" withCallback:^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"Delivery: %@" , res);
            }
            else{
                NSLog(@"Error getting delivery: %@", err.description);
            }
        }];
        
        [example postDeliveryWithParams:@{} withCallback: ^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"Posted delivery: %@" , res);
            }
            else{
                NSLog(@"Error posting delivery: %@", err.description);
            }
        }];
        
        [example returnDeliveryForId:@"1" withCallback:^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"Return delivery: %@" , res);
            }
            else{
                NSLog(@"Error doing return delivery: %@", err.description);
            }
        }];
        
        [example cancelDeliveryForId:@"1" withCallback:^(NSDictionary *res, NSError *err){
            if(!err){
                NSLog(@"Cancel delivery: %@" , res);
            }
            else{
                NSLog(@"Error cancelling delivery: %@", err.description);
            }
        }];
    */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
