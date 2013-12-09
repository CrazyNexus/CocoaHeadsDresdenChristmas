//
//  CHDStop.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^StopSearchCompletionBlock)(NSArray *stops);

@interface CHDStop : NSObject

@property (nonatomic, strong) NSString  *ID;
@property (nonatomic, strong) NSString  *city;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic) NSInteger         distance;

- (instancetype)initWithCity:(NSString *)city;
- (instancetype)initWithCity:(NSString *)city name:(NSString *)name;
+ (void)findByLatitude:(CGFloat)latittude logitude:(CGFloat)longitude completion:(StopSearchCompletionBlock)completion;

@end
