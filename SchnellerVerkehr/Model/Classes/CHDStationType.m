#import "CHDStationType.h"


@interface CHDStationType ()

// Private interface goes here.

@end


@implementation CHDStationType

+ (void)populateWithDefaultTypes {
    NSUInteger count = [CHDStationType MR_countOfEntities];
    if (count == 0) {
        NSDictionary *types = @{
                                @"Stop":@0,
                                @"POI":@1,
                                @"Loc":@2,
                                @"Coord":@3,
                                @"Unknown":@4,
                                };

        for (NSString *key in types.allKeys) {
            CHDStationType *carType = [CHDStationType MR_createEntity];
            carType.name    = key;
            carType.id      = types[key];
        }
    }
}

@end
