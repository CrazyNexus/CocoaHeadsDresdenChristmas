//
//  CHDStop.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHDStation;

@interface CHDStop : NSObject

@property (nonatomic, strong) CHDStation    *station;
@property (nonatomic, strong) NSDate        *arrivalDate;
@property (nonatomic, strong) NSDate        *departureDate;

- (instancetype)initWithStation:(CHDStation *)station;

@end
