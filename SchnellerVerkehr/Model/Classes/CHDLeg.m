#import "CHDLeg.h"
#import "CHDStation.h"
#import "CHDStop.h"
#import "CHDCarType.h"
#import <CoreLocation/CoreLocation.h>

@interface CHDLeg ()

// Private interface goes here.
@property (nonatomic, strong) NSString *dict;

@end


@implementation CHDLeg

@synthesize dict;

+ (instancetype)legWithDictionary:(NSDictionary *)dictionary {
    if (![dictionary dictionaryValue]) {
        return nil;
    }

    CHDLeg *leg = [CHDLeg MR_createEntity];
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

+ (NSNumberFormatter *)sharedDecimalFormatter {
    static NSNumberFormatter    *formatter = nil;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });

    return formatter;
}

- (void)setupFromData:(NSDictionary *)dictionary {
    NSDictionary *mode = [[dictionary valueForKey:@"mode"] dictionaryValue];
    self.dict = [NSString stringWithFormat:@"%@", dictionary];

    if (mode) {
        self.name           = [mode[@"name"] nonEmptyStringValue];
        self.lineNumber     = [mode[@"number"] nonEmptyStringValue];
        self.destination    = [mode[@"destination"] nonEmptyStringValue];
        self.carType        = [CHDCarType typeByID:[[CHDLeg sharedDecimalFormatter] numberFromString:mode[@"type"]]];
    }

    NSArray *stops = [[dictionary objectForKey:@"stopSeq"] arrayValue];

    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait: ^(NSManagedObjectContext *localContext) {
        NSUInteger idx = 0;
        for (NSDictionary *stopDict in stops) {
            NSString *stationID  = stopDict[@"ref"][@"id"];

            CHDStation *station = [CHDStation MR_findFirstByAttribute:@"id" withValue:stationID inContext:localContext];
            if (!station) {
                station     = [CHDStation MR_createInContext:localContext];
                station.id  = stationID;

                NSString *name = [stopDict[@"nameWO"] nonEmptyStringValue];
                station.name = name;

                NSArray *coords = [stopDict[@"ref"][@"coords"] componentsSeparatedByString:@","];
                if ([coords count] == 2) {
                    station.longitudeValue  = [coords[0] doubleValue];
                    station.latitudeValue   = [coords[1] doubleValue];
                }
            }

            CHDStop *stop = [CHDStop MR_createInContext:localContext];
            stop.arrivalDate    = [[CHDLeg sharedDateFormatter] dateFromString:stopDict[@"ref"][@"arrDateTime"]];
            stop.departureDate  = [[CHDLeg sharedDateFormatter] dateFromString:stopDict[@"ref"][@"depDateTime"]];
            stop.station = station;
            stop.order = @(idx);

            DDLogInfo(@"---> Stop: %@", stop);

            idx++;
            
            [self addStopsObject:stop];
        };
    }];
}

- (NSArray *)orderedStopsArray {
    return [self.stops sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.orderedStopsArray, self.dict];
}

@end
