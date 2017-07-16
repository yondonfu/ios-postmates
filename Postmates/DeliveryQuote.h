//
//  DeliveryQuote.h
//  PostmatesiOS
//

#import <Foundation/Foundation.h>

@class DeliveryQuote;

typedef void (^DeliveryQuoteBlock)(DeliveryQuote * _Nullable quote, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryQuote : NSObject

@property (strong, nonatomic) NSString *pickUpAddress;
@property (strong, nonatomic) NSString *dropOffAddress;
@property (strong, nonatomic) NSString *quoteId;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *expires;
@property (strong, nonatomic) NSNumber *fee;
@property (strong, nonatomic) NSString *currency;
@property (strong, nonatomic) NSDate *dropOffEta;
@property (assign, nonatomic) NSInteger duration;

- (instancetype)initWithPickUp:(NSString *)pickUpAddress dropOff:(NSString *)dropOffAddress;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
