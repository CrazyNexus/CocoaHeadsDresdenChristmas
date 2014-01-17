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

- (BOOL)identifiable {
    NSString *type = self.type.searchType;
    DDLogInfo(@"Type: %@", type);
    
    if ([type isEqualToString:@"stopID"] || [type isEqualToString:@"poiID"] || [type isEqualToString:@"placeID"]) {
        DDLogInfo(@"self.id: %@", self.id);
        return self.id.length > 0;
    }
    else if ([type isEqualToString:@"coordID"]) {
        DDLogInfo(@"self.latitude: %@", self.latitude);
        return self.latitude != nil;
    }

    return NO;
}

- (void)setTypeWithString:(NSString *)typeString {
    CHDStationType *stationType = [CHDStationType typeByName:typeString];
    if (!stationType) {
        stationType = [CHDStationType typeByName:@"unknown"];
    }
    self.type = stationType;
}

+ (void)findByName:(NSString *)name completion:(StationSearchCompletionBlock)completion {
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

                                NSString *type = stationDict[@"anyType"];

                                NSString *stationID = stationDict[@"stateless"];

                                [temp addObject:@{ @"quality":quality, @"city":city, @"name":name, @"stationID":stationID, @"type":type }];
                                [temp sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
                                    return [obj2[@"quality"] compare:obj1[@"quality"]];                    // biggest quality is best
                                }];
                            }

                            [temp enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStation *station = [CHDStation stationWithCityName:obj[@"city"] stationName:obj[@"name"]];
                                station.id = obj[@"stationID"];
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
                                station.id = obj[@"id"];

                                /* do we need to set this? it's probably the distance from the search location,
                                 and most likely it's the line of sight distance so it's kind of useless,
                                 as its better to update and calculate this on the fly depending
                                 on the CURRENT user location (he's moving anyway!) */

                                //  station.distance = [obj[@"distance"] integerValue];

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
    NSString *type = self.type.searchType;
    if ([type isEqualToString:@"stopID"]) {
        return [self.id stringValue];
    }
    else if ([type isEqualToString:@"poiID"]) {
        return [[self.id stringValue] substringFromIndex:6];
    }
    else if ([type isEqualToString:@"placeID"]) {
        return [[self.id stringValue] substringFromIndex:8];
    }
    else if ([type isEqualToString:@"coordID"]) {
        return [NSString stringWithFormat:@"%f:%f:WGS84", self.longitudeValue, self.latitudeValue];
    }
    return self.name;
}

- (NSString *)mangledType {
    return self.type.searchType;
}

- (NSInteger)distance {
    return 666;
}

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@, %@", self.name, self.city.name];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@)", self.fullName, self.id];
}

@end
