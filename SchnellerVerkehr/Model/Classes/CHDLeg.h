#import "_CHDLeg.h"

@interface CHDLeg : _CHDLeg {}

+ (instancetype)legWithDictionary:(NSDictionary *)dictionary;
- (NSArray *)orderedStopsArray;

@end
