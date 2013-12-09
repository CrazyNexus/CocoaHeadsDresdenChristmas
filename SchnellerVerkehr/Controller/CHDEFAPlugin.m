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

    NSString        *url        = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_STOPFINDER_REQUEST?locationServerActive=1&outputFormat=JSON&type_sf=stop&name_sf=%@", name];

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

                        if (!jsonError) {
                            NSArray *stopList = JSON[@"stopFinder"];

                            for (NSDictionary * stopDict in stopList) {
                                NSString *city = stopDict[@"ref.place"];
                                NSString *name = [[stopDict[@"name"] componentsSeparatedByString:@","] lastObject];

                                [stops addObject:[[CHDStop alloc] initWithCity:city name:name]];
                            }

                            NSLog(@"found %@", stops);

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                [self.delegate receivedStopsList:stops];
                            });
                        }
                    }
                }] resume];
}

@end
