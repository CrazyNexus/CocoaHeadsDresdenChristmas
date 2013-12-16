#import "CHDLeg.h"
#import "CHDStation.h"
#import "CHDStop.h"
#import "CHDCarType.h"
#import <CoreLocation/CoreLocation.h>

@interface CHDLeg ()

// Private interface goes here.

@end


@implementation CHDLeg

+ (instancetype)legWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary dictionaryValue]) {
        return nil;
    }

    CHDLeg *leg = [[self alloc] init];
    [leg setupFromData:dictionary];
    return leg;
}

+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter  *formatter = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMdd HH:mm";
    });

    return formatter;
}

- (void)setupFromData:(NSDictionary *)dictionary {
    NSDictionary *mode = [[dictionary valueForKey:@"mode"] dictionaryValue];

    if (mode) {
        self.name           = [mode[@"name"] nonEmptyStringValue];
        self.lineNumber     = [mode[@"number"] nonEmptyStringValue];
        self.destination    = [mode[@"destination"] nonEmptyStringValue];
        self.carType        = [CHDCarType MR_findFirstByAttribute:@"id" withValue:[mode[@"type"] numberValue]];
    }

    NSArray *stops = [[dictionary objectForKey:@"stopSeq"] arrayValue];

    if (stops.count > 0) {
        NSMutableArray *stopsArray = [NSMutableArray arrayWithCapacity:stops.count];

        for (NSDictionary *stopDict in stops) {
            NSNumber    *stationID  = [stopDict[@"ref"][@"id"] numberValue];
            CHDStation  *station    = [CHDStation MR_findFirstByAttribute:@"id" withValue:stationID];
            if (!station) {
                station     = [CHDStation MR_createEntity];
                station.id  = stationID;

                NSString *name = [stopDict[@"nameWO"] nonEmptyStringValue];
                station.name = name;

                NSArray *coords = [stopDict[@"ref"][@"coords"] componentsSeparatedByString:@","];
                if ([coords count] == 2) {
                    station.longitudeValue  = [coords[0] floatValue];
                    station.latitudeValue   = [coords[1] floatValue];
                }
            }

            CHDStop *stop = [CHDStop MR_createEntity];
            stop.arrivalDate    = [[CHDLeg sharedDateFormatter] dateFromString:stopDict[@"ref"][@"arrDateTime"]];
            stop.departureDate  = [[CHDLeg sharedDateFormatter] dateFromString:stopDict[@"ref"][@"depDateTime"]];

            [stopsArray addObject:stop];
        }

        self.stops = [NSOrderedSet orderedSetWithArray:stopsArray];
    }
}

@end
