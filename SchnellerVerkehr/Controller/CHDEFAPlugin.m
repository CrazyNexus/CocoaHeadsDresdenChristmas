//
//  CHDEFAPlugin.m
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDEFAPlugin.h"
#import "CHDStop.h"

@implementation CHDEFAPlugin

- (void)findStopsWithName:(NSString *)name {
    NSLog(@"Find %@", name);

    NSString        *url        = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_STOPFINDER_REQUEST?locationServerActive=1&outputFormat=JSON&type_sf=any&name_sf=%@", name];

    NSURLSession    *session    = [NSURLSession sharedSession];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    [[session   dataTaskWithURL     :[NSURL URLWithString:url]
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
                                NSString *name = [[stopDict[@"name"] componentsSeparatedByString:@","] lastObject];
                                NSString *qualityString = stopDict[@"quality"];
                                NSNumber *quality = [f numberFromString:qualityString];
                                if (!quality) {
                                    quality = @0;
                                }

                                NSString *stopID = stopDict[@"ref"][@"id"];

                                [temp addObject:@{ @"quality":quality, @"city":city, @"name":name, @"stopID":stopID }];
                                [temp sortUsingComparator: ^NSComparisonResult (id obj1, id obj2) {
                                    return [obj1[@"quality"] compare:obj2[@"quality"]];
                                }];
                            }

                            [temp enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *cancel) {
                                CHDStop *stop = [[CHDStop alloc] initWithCity:obj[@"city"] name:obj[@"name"]];
                                stop.ID = obj[@"id"];
                                stop.distance = 666;
                                [stops addObject:stop];
                            }];

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                [self.delegate receivedStopsList:stops];
                            });
                        }
                    }
                }] resume];
}

@end
