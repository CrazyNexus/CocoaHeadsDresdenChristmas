#import "CHDStop.h"

@interface CHDStop ()

// Private interface goes here.

@end


@implementation CHDStop

- (instancetype)initWithStation:(CHDStation *)station {
    self = [CHDStop MR_createEntity];
    if (self) {
        self.station = station;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@: %@", self.arrivalDate, self.departureDate, self.station];
}

@end
