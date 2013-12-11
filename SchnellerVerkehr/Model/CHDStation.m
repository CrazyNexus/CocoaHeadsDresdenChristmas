//
//  CHDStation.m
//  SchnellerVerkehr
//
//  Created by Steffen on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDStation.h"

@implementation CHDStation

- (instancetype)initWithCity:(NSString *)city {
    return [self initWithCity:city name:@"Hauptbahnhof"];
}

- (instancetype)initWithCity:(NSString *)city name:(NSString *)name {
    self = [super init];
    if (self) {
        _city   = city;
        _name   = name;
    }
    return self;
}

- (BOOL)isIdentifiable {
    switch (self.type) {
        case CHDStationTypeStop:
        case CHDStationTypePOI:
        case CHDStationTypeLoc:
            return self.ID.length > 0;

        case CHDStationTypeCoord:
            return self.location != nil;

        default:
            return self.name.length > 0;
    }
}

- (void)setTypeByString:(NSString *)typeString {
    if ([typeString isEqualToString:@"stop"])
        self.type = CHDStationTypeStop;
    else if ([typeString isEqualToString:@"loc"])
        self.type = CHDStationTypeLoc;
    else if ([typeString isEqualToString:@"poi"])
        self.type = CHDStationTypePOI;
    else
        self.type = CHDStationTypeUnknown;
}

+ (void)findByName:(NSString *)name completion:(StationSearchCompletionBlock)completion {
#if DEBUG
    NSLog(@"Find %@", name);
#endif

    NSString        *url        = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_STOPFINDER_REQUEST?locationServerActive=1&outputFormat=JSON&type_sf=any&name_sf=%@", name];

    NSURLSession    *session    = [NSURLSession sharedSession];

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

                        NSMutableArray *stations = [[NSMutableArray alloc] init];
                        NSMutableArray *temp = [[NSMutableArray alloc] init];

                        if (!jsonError) {
                            NSArray *stationList = JSON[@"stopFinder"];

                            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                            [f setNumberStyle:NSNumberFormatterDecimalStyle];

                            for (NSDictionary * stationDict in stationList) {
                                NSString *city = stationDict[@"ref"][@"place"];
                                NSString *name = [[[stationDict[@"name"] componentsSeparatedByString:@","] lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString *qualityString = stationDict[@"quality"];
                                NSNumber *quality = [f numberFromString:qualityString];
                                if (!quality) {
                                    quality = @0;
                                }

                                NSString *stationID = stationDict[@"stateless"];

                                NSString *type = stationDict[@"anyType"];
                                [temp addObject:@{ @"quality":quality, @"city":city, @"name":name, @"stationID":stationID, @"type":type }];
                                [temp sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
                                    return [obj2[@"quality"] compare:obj1[@"quality"]];                                 // biggest quality is best
                                }];
                            }

                            [temp enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStation *station = [[CHDStation alloc] initWithCity:obj[@"city"] name:obj[@"name"]];
                                station.ID = obj[@"stationID"];
                                station.distance = 666;
                                [station setTypeByString:obj[@"type"]];

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
                     "&coordOutputFormat=WGS84"
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
                                CHDStation *station = [[CHDStation alloc] initWithCity:obj[@"locality"] name:obj[@"desc"]];
                                station.ID = obj[@"id"];
                                station.distance = [obj[@"distance"] integerValue];
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

@end
