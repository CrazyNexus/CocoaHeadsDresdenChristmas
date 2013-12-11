//
//  CHDTrip.m
//  SchnellerVerkehr
//
//  Created by Steffen on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDTrip.h"
#import "CHDStation.h"
#import "CHDLeg.h"

@implementation CHDTrip

- (instancetype)initWithDuration:(NSTimeInterval)duration interchange:(NSInteger)interchange legs:(NSArray *)legs {
    self = [super init];
    if (self) {
        _duration       = duration;
        _interchange    = interchange;
        _legs           = legs;
    }
    return self;
}

+ (void)findTripWithOrigin:(CHDStation *)origin destination:(CHDStation *)destination calcNumberOfTrips:(NSUInteger)calcNumberOfTrips completion:(TripSearchCompletionBlock)completion {
    if (!origin.identifiable || !destination.identifiable) {
        if (completion) {
            completion(nil);
        }
        return;
    }

    NSString    *originName;
    NSString    *originType;
    NSString    *destinationName;
    NSString    *destinationType;

    switch (origin.type) {
        case CHDStationTypeStop:
            originName  = origin.ID;
            originType  = @"stopID";
            break;

        case CHDStationTypePOI:
            originName  = [origin.ID substringFromIndex:6];
            originType  = @"poiID";
            break;

        case CHDStationTypeLoc:
#warning Locations/Places not working
            originName  = [origin.ID substringFromIndex:8];
            originType  = @"placeID";
            break;

        case CHDStationTypeCoord:
            originName  = [NSString stringWithFormat:@"%f:%f:WGS84", origin.location.coordinate.longitude, origin.location.coordinate.latitude];
            originType  = @"coord";
            break;

        default:
            // lucky guess
            originName  = origin.name;
            originType  = @"any";
            break;
    }

    switch (destination.type) {
        case CHDStationTypeStop:
            destinationName = destination.ID;
            destinationType = @"stopID";
            break;

        case CHDStationTypePOI:
            destinationName = [destination.ID substringFromIndex:6];
            destinationType = @"poiID";
            break;

        case CHDStationTypeLoc:
            originName      = [origin.ID substringFromIndex:8];
            destinationType = @"locID";
            break;

        case CHDStationTypeCoord:
            destinationName = [NSString stringWithFormat:@"%f:%f:WGS84", destination.location.coordinate.longitude, destination.location.coordinate.latitude];
            destinationType = @"coord";
            break;

        default:
            destinationName = destination.name;
            destinationType = @"any";
            break;
    }

    NSString *url = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_TRIP_REQUEST2"
                     "?sessionID=0"
                     "&language=de"
                     "&calcNumberOfTrips=%lu"
                     "&name_origin=%@"
                     "&type_origin=%@"
                     "&name_destination=%@"
                     "&type_destination=%@"
                     "&changeSpeed=normal"
                     "&coordOutputFormat=WGS84[DD.ddddd]"
                     "&outputFormat=JSON",
                     (unsigned long)calcNumberOfTrips, originName, originType, destinationName, destinationType];

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

                        NSMutableArray *trips = [[NSMutableArray alloc] init];

                        if (!jsonError) {
                            for (NSDictionary * tripDictionary in JSON[@"trips"]) {
#warning needs to be fixed
                                NSDateFormatter * df = [[NSDateFormatter alloc] init];
                                df.dateFormat = @"mm:ss";
                                NSDate *date = [df dateFromString:[tripDictionary valueForKeyPath:@"trip.duration"]];
                                NSTimeInterval duration = [date timeIntervalSinceReferenceDate];

                                NSInteger interchange = [[tripDictionary valueForKeyPath:@"trip.interchange"] integerValue];
                                NSMutableArray *legs = [NSMutableArray array];

                                for (NSDictionary * legDictionary in[tripDictionary valueForKeyPath : @"trip.legs"]) {
                                    [legs addObject:[CHDLeg legWithDictionary:legDictionary]];
                                }

                                [trips addObject:[[CHDTrip alloc]   initWithDuration:duration
                                                                    interchange     :interchange
                                                                    legs            :legs]];
                            }

                            dispatch_async(dispatch_get_main_queue(), ^{
                                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

                                if (completion) {
                                    completion(trips);
                                }
                            });
                        }
                    }
                }] resume];
}

@end
