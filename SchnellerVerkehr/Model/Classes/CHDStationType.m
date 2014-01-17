#import "CHDStationType.h"


@interface CHDStationType ()

// Private interface goes here.

@end


@implementation CHDStationType

+ (void)populateWithDefaultTypes {
    NSUInteger count = [CHDStationType MR_countOfEntities];
    if (count == 0) {
        NSDictionary *types = @{
                                @"Stop":@"stopID",
                                @"POI":@"poiID",
                                @"Loc":@"placeID",
                                @"Coord":@"coordID",
                                @"Unknown":@"anyID",
                                @"House":@"anyID"
                                };

        [types enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            CHDStationType *stationType = [CHDStationType MR_createEntity];
            stationType.name        = key;
            stationType.searchType  = obj;
        }];
    }
}

+ (instancetype)typeByName:(NSString *)name {
    return [self MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"name ==[c] %@", name]];
}

@end
