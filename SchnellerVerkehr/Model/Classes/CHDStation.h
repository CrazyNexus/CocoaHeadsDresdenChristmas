#import "_CHDStation.h"

typedef void (^StationSearchCompletionBlock)(NSArray *stations);

@class CHDStationType;

@interface CHDStation : _CHDStation {}

@property (nonatomic, readonly) NSInteger distance;
@property (nonatomic, readonly) BOOL identifiable;
@property (nonatomic, readonly) NSString *fullName;

+ (instancetype)stationWithCityName:(NSString *)cityName;
+ (instancetype)stationWithCityName:(NSString *)cityName stationName:(NSString *)stationName;

- (void)setTypeWithString:(NSString *)typeString;

+ (void)findByName:(NSString *)name completion:(StationSearchCompletionBlock)completion;
+ (void)findByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(StationSearchCompletionBlock)completion;

- (NSString *)mangledName;
- (NSString *)mangledType;

@end
