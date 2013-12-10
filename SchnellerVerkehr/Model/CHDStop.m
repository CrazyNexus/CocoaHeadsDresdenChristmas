//
//  CHDStop.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDStop.h"

@implementation CHDStop

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

+ (void)findByName:(NSString *)name completion:(StopSearchCompletionBlock)completion {
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

                        NSMutableArray *stops = [[NSMutableArray alloc] init];
                        NSMutableArray *temp = [[NSMutableArray alloc] init];

                        if (!jsonError) {
                            NSArray *stopList = JSON[@"stopFinder"];

                            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                            [f setNumberStyle:NSNumberFormatterDecimalStyle];

                            for (NSDictionary * stopDict in stopList) {
                                NSString *city = stopDict[@"ref"][@"place"];
                                NSString *name = [[[stopDict[@"name"] componentsSeparatedByString:@","] lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString *qualityString = stopDict[@"quality"];
                                NSNumber *quality = [f numberFromString:qualityString];
                                if (!quality) {
                                    quality = @0;
                                }

                                NSString *stopID = stopDict[@"stateless"];

                                [temp addObject:@{ @"quality":quality, @"city":city, @"name":name, @"stopID":stopID }];
                                [temp sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
                                    return [obj2[@"quality"] compare:obj1[@"quality"]];                 // biggest quality is best
                                }];
                            }

                            [temp enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStop *stop = [[CHDStop alloc] initWithCity:obj[@"city"] name:obj[@"name"]];
                                stop.ID = obj[@"stopID"];
                                stop.distance = 666;
                                [stops addObject:stop];
                            }];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                if (completion) {
                                    completion(stops);
                                }
                            });
                        }
                    }
                }] resume];
}

+ (void)findByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(StopSearchCompletionBlock)completion {
    if (!completion)
        return;

    NSString *url = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST"
                     "?coord=%f:%f:WGS84"
                     "&coordOutputFormat=WGS84"
                     "&max=5"
                     "&inclFilter=1"
                     "&radius_1=1000"
                     "&type_1=STOP"
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

                        NSMutableArray *stops = [NSMutableArray array];

                        if (!jsonError) {
                            NSArray *stopList = JSON[@"pins"];

                            [stopList enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStop *stop = [[CHDStop alloc] initWithCity:obj[@"locality"] name:obj[@"desc"]];
                                stop.ID = obj[@"id"];
                                stop.distance = [obj[@"distance"] integerValue];
                                [stops addObject:stop];
                            }];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                if (completion) {
                                    completion(stops);
                                }
                            });
                        }
                    }
                }] resume];
}

@end
