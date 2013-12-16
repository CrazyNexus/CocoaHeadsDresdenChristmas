#import <CoreLocation/CoreLocation.h>
#import "CHDStation.h"
#import "CHDCity.h"
#import "CHDStationType.h"


@interface CHDStation ()

// Private interface goes here.

@end


@implementation CHDStation

@dynamic distance;

+ (instancetype)stationWithCityName:(NSString *)cityName {
    return [self stationWithCityName:cityName stationName:@"Hauptbahnhof"];
}

+ (instancetype)stationWithCityName:(NSString *)cityName stationName:(NSString *)stationName {
    CHDStation  *station    = [CHDStation MR_createEntity];
    CHDCity     *city       = [CHDCity MR_findFirstByAttribute:@"name" withValue:cityName];
    if (!city) {
        city        = [CHDCity MR_createEntity];
        city.name   = cityName;
    }
    station.city    = city;
    station.name    = stationName;

    return station;
}

- (BOOL)isIdentifiable {
    NSString *type = self.type.name;
    if ([type isEqualToString:@"Stop"] || [type isEqualToString:@"POI"] || [type isEqualToString:@"Loc"]) {
        return self.id > 0;
    }
    else if ([type isEqualToString:@"Coord"]) {
        return self.latitude != nil;
    }

    return NO;
}

- (void)setTypeWithString:(NSString *)typeString {
    CHDStationType *stationType = [CHDStationType MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name ==[c] %@", typeString]];
    if (!stationType) {
        stationType = [CHDStationType MR_findFirstByAttribute:@"name" withValue:@"unknown"];
    }
    self.type = stationType;
}

+ (void)findByName:(NSString *)name completion:(StationSearchCompletionBlock)completion {
#if DEBUG
    NSLog(@"Find %@", name);
#endif

    NSString *url = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_STOPFINDER_REQUEST"
                     "?locationServerActive=1"
                     "&outputFormat=JSON"
                     "&type_sf=any"
                     "&name_sf=%@", name];

    NSURLSession *session = [NSURLSession sharedSession];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[session   dataTaskWithURL     :[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                completionHandler   : ^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                    // handle response
                    NSHTTPURLResponse *HTTPresponse = (NSHTTPURLResponse *)response;
                    if (HTTPresponse.statusCode == 200) {
                        NSError *jsonError;

                        NSDictionary *JSON = [NSJSONSerialization   JSONObjectWithData  :data
                                                                    options             :NSJSONReadingAllowFragments
                                                                    error               :&jsonError];

                        NSMutableArray *stations = [[NSMutableArray alloc] init];
                        NSMutableArray *temp = [[NSMutableArray alloc] init];

                        if (!jsonError) {
                            NSArray *stationList = JSON[@"stopFinder"];

                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

                            for (NSDictionary * stationDict in stationList) {
                                NSString *city = stationDict[@"ref"][@"place"];
                                NSString *name = [[[stationDict[@"name"] componentsSeparatedByString:@","] lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString *qualityString = stationDict[@"quality"];
                                NSNumber *quality = [formatter numberFromString:qualityString];
                                if (!quality) {
                                    quality = @0;
                                }

                                NSString *stationID = stationDict[@"stateless"];

                                NSString *type = stationDict[@"anyType"];
                                [temp addObject:@{ @"quality":quality, @"city":city, @"name":name, @"stationID":stationID, @"type":type }];
                                [temp sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
                                    return [obj2[@"quality"] compare:obj1[@"quality"]];            // biggest quality is best
                                }];
                            }

                            [temp enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStation *station = [CHDStation stationWithCityName:obj[@"city"] stationName:obj[@"name"]];
                                station.id = [obj[@"stationID"] numberValue];
                                [station setTypeWithString:obj[@"type"]];

                                [stations addObject:station];
                            }];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                if (completion) {
                                    completion(stations);
                                }
                            });
                        }
                    }
                }] resume];
}

+ (void)findByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(StationSearchCompletionBlock)completion {
    if (!completion)
        return;

    NSString *url = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST"
                     "?coord=%f:%f:WGS84"
                     "&coordOutputFormat=WGS84[DD.ddddd]"
                     "&max=5"
                     "&inclFilter=1"
                     "&radius_1=1000"
                     "&type_1=any"
                     "&outputFormat=JSON",
                     longitude, latitude];

    NSURLSession *session = [NSURLSession sharedSession];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[session   dataTaskWithURL     :[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                completionHandler   : ^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                    // handle response
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)response;
                    if (httpResp.statusCode == 200) {
                        NSError *jsonError;

                        NSDictionary *JSON = [NSJSONSerialization   JSONObjectWithData  :data
                                                                    options             :NSJSONReadingAllowFragments
                                                                    error               :&jsonError];

                        NSMutableArray *stations = [NSMutableArray array];

                        if (!jsonError) {
                            NSArray *stationList = JSON[@"pins"];

                            [stationList enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStation *station = [CHDStation stationWithCityName:obj[@"locality"] stationName:obj[@"desc"]];
                                station.id = [obj[@"id"] numberValue];

                                //  do we need to set this? it's probably the distance from the search location, and most likely it's the line of sight distance
                                //  so it's kind of useless, as its better to update and calculate this on the fly depending on the CURRENT user location (he's moving anyway!)
                                //                                station.distance = [obj[@"distance"] integerValue];

                                [stations addObject:station];
                            }];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                if (completion) {
                                    completion(stations);
                                }
                            });
                        }
                    }
                }] resume];
}

- (NSString *)mangledName {
    NSString *type = self.type.name;
    if ([type isEqualToString:@"Stop"]) {
        return [self.id stringValue];
    }
    else if ([type isEqualToString:@"POI"]) {
        return [[self.id stringValue] substringFromIndex:6];
    }
    else if ([type isEqualToString:@"Loc"]) {
        return [[self.id stringValue] substringFromIndex:8];
    }
    else if ([type isEqualToString:@"Coord"]) {
        return [NSString stringWithFormat:@"%f:%f:WGS84", self.longitudeValue, self.latitudeValue];
    }
    return self.name;
}

- (NSString *)mangledType {
    NSString *type = self.type.name;
    if ([type isEqualToString:@"Stop"]) {
        return @"stopID";
    }
    else if ([type isEqualToString:@"POI"]) {
        return @"poiID";
    }
    else if ([type isEqualToString:@"Loc"]) {
        return @"placeID";
    }
    else if ([type isEqualToString:@"Coord"]) {
        return @"coordID";
    }
    return @"any";
}

- (NSInteger)distance {
    return 666;
}

@end
