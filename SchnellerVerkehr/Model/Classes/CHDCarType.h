#import "_CHDCarType.h"

@interface CHDCarType : _CHDCarType {}

+ (void)populateWithDefaultTypes;
+ (instancetype)typeByName:(NSString *)name;
+ (instancetype)typeByID:(NSNumber *)typeID;

- (NSString *)localizedName;

@end
