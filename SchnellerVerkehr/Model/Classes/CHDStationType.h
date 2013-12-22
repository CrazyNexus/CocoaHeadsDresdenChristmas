#import "_CHDStationType.h"

@interface CHDStationType : _CHDStationType {}

+ (instancetype)typeByName:(NSString *)name;
+ (void)populateWithDefaultTypes;

@end
