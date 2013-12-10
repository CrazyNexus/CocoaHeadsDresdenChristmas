//
//  CHDLeg.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHDLegCarType){
    CHDLegCarTypeTrain,
    CHDLegCarTypeSBahn,
    CHDLegCarTypeUBahn,
    CHDLegCarTypeStadtBahn,
    CHDLegCarTypeStrassenBahn,
    CHDLegCarTypeStadtBus,
    CHDLegCarTypeRegionalBus,
    CHDLegCarTypeSchnellBus,
    CHDLegCarTypeSeilBahn,
    CHDLegCarTypeSchiff,
    CHDLegCarTypeRufBus,
    CHDLegCarTypeUnknown
};

@interface CHDLeg : NSObject

@property (nonatomic, strong) NSString      *name;
@property (nonatomic, strong) NSString      *lineNumber;

@property (nonatomic, strong) NSString      *destination;
@property (nonatomic, assign) CHDLegCarType carType;

@property (nonatomic, strong) NSArray       *stops;

+ (instancetype)legWithDictionary:(NSDictionary *)dictionary;

@end
