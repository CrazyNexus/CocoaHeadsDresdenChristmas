#import "CHDTrip.h"
#import "CHDStation.h"
#import "CHDLeg.h"

@interface CHDTrip ()

// Private interface goes here.

@end


@implementation CHDTrip

+ (instancetype)tripWithDuration:(NSTimeInterval)duration interchanges:(NSUInteger)interchanges legs:(NSArray *)legs {
    CHDTrip *trip = [CHDTrip MR_createEntity];
    trip.durationValue      = duration;
    trip.interchangesValue  = interchanges;
    trip.legs               = [NSOrderedSet orderedSetWithArray:legs];

    return trip;
}

+ (void)findTripWithOrigin  :(CHDStation *)origin destination:(CHDStation *)destination
        calcNumberOfTrips   :(NSUInteger)calcNumberOfTrips completion:(TripSearchCompletionBlock)completion {
    if (![origin identifiable] || ![destination identifiable]) {
        if (completion) {
            completion(nil); // completion block with no trips
        }
        return;
    }

    NSString    *originName         = [origin mangledName];
    NSString    *originType         = [origin mangledType];
    NSString    *destinationName    = [destination mangledName];
    NSString    *destinationType    = [destination mangledType];

    NSString    *url                = [NSString stringWithFormat:@"http://efa.vvo-online.de:8080/standard/XML_TRIP_REQUEST2"
                                       "?sessionID=0"
                                       "&language=de"
                                       "&calcNumberOfTrips=%d"
                                       "&name_origin=%@"
                                       "&type_origin=%@"
                                       "&name_destination=%@"
                                       "&type_destination=%@"
                                       "&changeSpeed=normal"
                                       "&coordOutputFormat=WGS84[DD.ddddd]"
                                       "&outputFormat=JSON",
                                       (int)calcNumberOfTrips, originName, originType, destinationName, destinationType];

    DDLogDebug(@"URL: %@", url);
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
                            NSRegularExpression *re = [NSRegularExpression  regularExpressionWithPattern:@"^[0-5][0-9]:[0-5][0-9]$"
                                                                            options                     :NSRegularExpressionAnchorsMatchLines
                                                                            error                       :nil];
                            for (NSDictionary * tripDictionary in JSON[@"trips"]) {
                                NSTimeInterval duration;
                                NSString *minSecDuration = [tripDictionary valueForKeyPath:@"trip.duration"];
                                NSUInteger matches = [[re   matchesInString :minSecDuration
                                                            options         :0
                                                            range           :NSMakeRange(0, minSecDuration.length)] count];
                                if (matches == 1) {
                                    duration = [[minSecDuration componentsSeparatedByString:@":"][0] integerValue] * 60 + [[minSecDuration componentsSeparatedByString:@":"][1] integerValue];
                                }

                                NSInteger interchanges = [[tripDictionary valueForKeyPath:@"trip.interchange"] integerValue];
                                NSMutableArray *legs = [NSMutableArray array];

                                for (NSDictionary * legDictionary in [tripDictionary valueForKeyPath:@"trip.legs"]) {
                                    [legs addObject:[CHDLeg legWithDictionary:legDictionary]];
                                }

                                [trips addObject:[CHDTrip   tripWithDuration:duration
                                                            interchanges    :interchanges
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
