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
                                @"Unknown":@11,
                                @"Walk":@97
                                };

        [types enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
            CHDCarType *carType = [CHDCarType MR_createEntity];
            carType.name    = key;
            carType.id      = obj;
        }];
    }
}

+ (instancetype)typeByName:(NSString *)name {
    return [self MR_findFirstByAttribute:@"name" withValue:name];
}

+ (instancetype)typeByID:(NSNumber *)typeID {
    DDLogInfo(@"find cartype by id: %@", typeID);
    return [self MR_findFirstByAttribute:@"id" withValue:typeID];
}

- (NSString *)localizedName {
    return NSLocalizedString(self.name, @"");
}

@end
