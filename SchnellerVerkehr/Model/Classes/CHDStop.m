#import "CHDStop.h"

@interface CHDStop ()

// Private interface goes here.

@end


@implementation CHDStop

- (instancetype)initWithStation:(CHDStation *)station {
    self = [super init];
    if (self) {
        self.station = station;
    }
    return self;
}

@end
