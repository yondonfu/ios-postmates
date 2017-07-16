//
//  DeliveryZone.m
//  PostmatesiOS
//

#import "DeliveryZone.h"

#import <MapKit/MKPolygon.h>

@interface DeliveryZone ()

@property (nonatomic, strong) NSString *zoneName;
@property (nonatomic, strong) NSString *marketName;
@property (nonatomic, strong) NSArray<CLLocation *> *coordinates;

@end

@implementation DeliveryZone

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _zoneName = dictionary[@"properties"][@"zone_name"];
        _marketName = dictionary[@"properties"][@"market_name"];
        
        NSDictionary *coordinates = dictionary[@"features"][0];
        _coordinates = (coordinates) ? MKPolygonsFromGeoJSONMultiPolygonFeature(coordinates) : [NSArray array];
    }
    
    return self;
}

# pragma mark - GeoJSONSerialization

//
// The following code was both modified and taken from the GeoJSONSerialization project.
// https://github.com/mattt/GeoJSONSerialization/blob/master/GeoJSONSerialization/GeoJSONSerialization.m
//

static inline double CLLocationCoordinateNormalizedLatitude(double latitude) {
    return fmod((latitude + 90.0f), 180.0f) - 90.0f;
}

static inline double CLLocationCoordinateNormalizedLongitude(double latitude) {
    return fmod((latitude + 180.0f), 360.0f) - 180.0f;
}

static inline CLLocationCoordinate2D CLLocationCoordinateFromCoordinates(NSArray *coordinates) {
    NSCParameterAssert(coordinates && [coordinates count] >= 2);
    
    NSNumber *longitude = coordinates[0];
    NSNumber *latitude = coordinates[1];
    
    return CLLocationCoordinate2DMake(CLLocationCoordinateNormalizedLatitude([latitude doubleValue]), CLLocationCoordinateNormalizedLongitude([longitude doubleValue]));
}

static inline CLLocationCoordinate2D * CLCreateLocationCoordinatesFromCoordinatePairs(NSArray *coordinatePairs) {
    NSUInteger count = [coordinatePairs count];
    CLLocationCoordinate2D *locationCoordinates = malloc(sizeof(CLLocationCoordinate2D) * count);
    
    for (NSUInteger idx = 0; idx < count; idx++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinateFromCoordinates(coordinatePairs[idx]);
        locationCoordinates[idx] = coordinate;
    }
    
    return locationCoordinates;
}

static MKPolygon * MKPolygonFromGeoJSONPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];
    
    NSCParameterAssert([geometry[@"type"] isEqualToString:@"Polygon"]);
    
    NSArray *coordinateSets = geometry[@"coordinates"];
    
    NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
    for (NSArray *coordinatePairs in coordinateSets) {
        CLLocationCoordinate2D *polygonCoordinates = CLCreateLocationCoordinatesFromCoordinatePairs(coordinatePairs);
        
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
        [mutablePolygons addObject:polygon];
        
        free(polygonCoordinates);
    }
    
    MKPolygon *polygon = nil;
    switch ([mutablePolygons count]) {
        case 0:
            return nil;
        case 1:
            polygon = [mutablePolygons firstObject];
            break;
        default: {
            MKPolygon *exteriorPolygon = [mutablePolygons firstObject];
            NSArray *interiorPolygons = [mutablePolygons subarrayWithRange:NSMakeRange(1, [mutablePolygons count] - 1)];
            polygon = [MKPolygon polygonWithPoints:exteriorPolygon.points count:exteriorPolygon.pointCount interiorPolygons:interiorPolygons];
        }
            break;
    }
    
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    polygon.title = properties[@"name"];
    
    return polygon;
}

static NSArray * MKPolygonsFromGeoJSONMultiPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];
    
    NSCParameterAssert([geometry[@"type"] isEqualToString:@"MultiPolygon"]);
    
    NSArray *coordinateGroups = geometry[@"coordinates"];
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    
    NSMutableArray *mutablePolylines = [NSMutableArray arrayWithCapacity:[coordinateGroups count]];
    for (NSArray *coordinateSets in coordinateGroups) {
        NSDictionary *subFeature = @{
                                     @"type" : @"Feature",
                                     @"geometry" : @{
                                             @"type" : @"Polygon",
                                             @"coordinates" : coordinateSets
                                             },
                                     @"properties" : properties
                                     };
        
        [mutablePolylines addObject:MKPolygonFromGeoJSONPolygonFeature(subFeature)];
    }
    
    return [NSArray arrayWithArray:mutablePolylines];
}

@end
