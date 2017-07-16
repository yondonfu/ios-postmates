# Postmates iOS
An Objective-C wrapper for the Postmates REST API that gives iOS developers easier access to Postmates' on demand services within their mobile applications.

## Build Status
[![Build Status](https://travis-ci.org/imryan/ios-postmates.svg?branch=master)](https://travis-ci.org/imryan/ios-postmates)

## Getting Started
### CocoaPods
Add the following line to your Podfile:

`pod 'PostmatesiOS'

Add the following lines to your bridge file if you plan to use the framework with Swift:
```
#import "PostmatesiOS/Postmates.h"
#import "PostmatesiOS/Delivery.h"
#import "PostmatesiOS/DeliveryQuote.h"
#import "PostmatesiOS/Location.h"
#import "PostmatesiOS/APIManager.h"
```

Then, add this line in your class/classes to use the framework:    
`@import PostmatesiOS`

### Add PostmatesiOS to your app
In your `AppDelegate` file under `application:didFinishLaunchingWithOptions`, add this line:    
`[Postmates setCustomerId:@"YOUR-CUSTOMER-ID" apiKey:@"YOUR-API-KEY"];`
