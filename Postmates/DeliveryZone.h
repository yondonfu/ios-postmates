//
//  DeliveryZone.h
//  PostmatesiOS
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryZone : NSObject

@property (nonatomic, readonly) NSString *zoneName;
@property (nonatomic, readonly) NSString *marketName;
@property (nonatomic, readonly) NSArray<CLLocation *> *coordinates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
