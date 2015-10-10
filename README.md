# iOS Objective-C Postmates Library
An Objective-C wrapper for Postmates REST API that gives iOS developers easier access to Postmates' on demand services within their mobile applications.

## Getting Started
### CocoaPods
Add the following line to your Podfile:

`pod 'PostmatesiOS', '~> 0.0.1'`

### Add PostmatesiOS to your app
In your AppDelegate.m file and under application:didFinishLaunchingWithOptions: add this line:

`[Postmates setCustomerId:@"YOUR-CUSTOMER-ID" apiKey:@"YOUR-API-KEY"];`
