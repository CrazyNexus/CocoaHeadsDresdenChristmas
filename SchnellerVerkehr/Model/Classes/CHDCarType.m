#import "CHDCarType.h"


@interface CHDCarType ()

// Private interface goes here.

@end


@implementation CHDCarType

+ (void)populateWithDefaultTypes {
    NSUInteger count = [CHDCarType MR_countOfEntities];
    if (count == 0) {
        NSDictionary *types = @{
                                @"Train":@0,
                                @"SBahn":@1,
                                @"UBahn":@2,
                                @"StadtBahn":@3,
                                @"StrassenBahn":@4,
                                @"StadtBus":@5,
                                @"RegionalBus":@6,
                                @"SchnellBus":@7,
                                @"SeilBahn":@8,
                                @"Schiff":@9,
                                @"RufBus":@10,
                                @"Unknown":@11
                                };

        for (NSString *key in types.allKeys) {
            CHDCarType *carType = [CHDCarType MR_createEntity];
            carType.name    = key;
            carType.id      = types[key];
        }
    }
}

@end
