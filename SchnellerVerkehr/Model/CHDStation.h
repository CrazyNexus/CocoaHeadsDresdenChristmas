//
//  CHDStation.h
//  SchnellerVerkehr
//
//  Created by Steffen on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^StationSearchCompletionBlock)(NSArray *stations);

typedef NS_ENUM (NSInteger, CHDStationType) {
    CHDStationTypeStop,
    CHDStationTypePOI,
    CHDStationTypeLoc,
    CHDStationTypeCoord, // used for own coordinates
    CHDStationTypeUnknown
};

@interface CHDStation : NSObject

@property (nonatomic, strong) NSString                          *ID;
@property (nonatomic, assign) CHDStationType                    type;
@property (nonatomic, strong) NSString                          *city;
@property (nonatomic, strong) NSString                          *name;
@property (nonatomic, assign) NSInteger                         distance;
@property (nonatomic, strong) CLLocation                        *location;
@property (nonatomic, readonly, getter = isIdentifiable) BOOL   identifiable;

- (instancetype)initWithCity:(NSString *)city;
- (instancetype)initWithCity:(NSString *)city name:(NSString *)name;

- (void)setTypeByString:(NSString *)typeString;

+ (void)findByName:(NSString *)name completion:(StationSearchCompletionBlock)completion;
+ (void)findByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude completion:(StationSearchCompletionBlock)completion;

@end
