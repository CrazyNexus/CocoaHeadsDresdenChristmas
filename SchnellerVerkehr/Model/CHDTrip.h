//
//  CHDTrip.h
//  SchnellerVerkehr
//
//  Created by Steffen on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHDStation;

typedef void (^TripSearchCompletionBlock)(NSArray *trips);

@interface CHDTrip : NSObject

@property (nonatomic) NSTimeInterval    duration;
@property (nonatomic) NSInteger         interchange;
@property (nonatomic) NSArray           *legs;

- (instancetype)initWithDuration:(NSTimeInterval)duration interchange:(NSInteger)interchange legs:(NSArray *)legs;

+ (void)findTripWithOrigin:(CHDStation *)origin destination:(CHDStation *)destination calcNumberOfTrips:(NSUInteger)calcNumberOfTrips completion:(TripSearchCompletionBlock)completion;

@end
