//
//  CHDTrip.m
//  SchnellerVerkehr
//
//  Created by Steffen on 10.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDTrip.h"
#import "CHDStop.h"
#import "CHDLeg.h"

@implementation CHDTrip

- (instancetype)initWithDuration:(NSTimeInterval)duration interchange:(NSInteger)interchange legs:(NSArray*)legs{
    self = [super init];
    if (self) {
        _duration = duration;
        _interchange = interchange;
        _legs = legs;
    }
    return self;
}

+ (void)findTripWithOrigin:(CHDStop *)origin destination:(CHDStop *)destination calcNumberOfTrips:(NSUInteger)calcNumberOfTrips completion:(TripSearchCompletionBlock)completion {
    NSString *url = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_TRIP_REQUEST2"
                     "?sessionID=0"
                     "&language=de"
                     "&calcNumberOfTrips=%lu"
                     "&coordOutputFormat=none"
                     "&name_origin=%@"
                     "&type_origin=stopID"
                     "&name_destination=%@"
                     "&type_destination=stopID"
                     "&changeSpeed=normal"
"&includedMeans=0&includedMeans=8&includedMeans=5&includedMeans=1&includedMeans=9&includedMeans=6&includedMeans=4&includedMeans=10&outputFormat=JSON",
                     (unsigned long)calcNumberOfTrips, origin.ID, destination.ID];

    NSURLSession *session = [NSURLSession sharedSession];

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

                        NSMutableArray *trips = [[NSMutableArray alloc] init];

                        if (!jsonError) {

                            for (NSDictionary *tripDictionary in JSON[@"trips"]) {

#warning needs to be fixed
                                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                                df.dateFormat = @"mm:ss";
                                NSDate *date = [df dateFromString:[tripDictionary valueForKeyPath:@"trip.duration"]];
                                NSTimeInterval duration = [date timeIntervalSinceReferenceDate];

                                NSInteger interchange = [[tripDictionary valueForKeyPath:@"trip.interchange"] integerValue];
                                NSMutableArray *legs = [NSMutableArray array];

                                for (NSDictionary *legDictionary in [tripDictionary valueForKeyPath:@"trip.legs"] ) {
                                    [legs addObject:[CHDLeg legWithDictionary:legDictionary]];
                                }

                                [trips addObject:[[CHDTrip alloc] initWithDuration:duration
                                                                       interchange:interchange
                                                                              legs:legs]];
                            }

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                //[self.delegate receivedStopsList:stops];
                            });
                        }
                    }
                }] resume];
}

@end
