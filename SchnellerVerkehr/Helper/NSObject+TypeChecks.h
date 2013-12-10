//
//  NSObject+TypeChecks.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TypeChecks)

/**
 Checks, whether this is a NSArray
 and returns it. Otherwise, returns nil.
 
 @returns The NSArray instance or nil,
 when it is not of class NSArray.
 */
- (NSArray *)arrayValue;

/**
 Checks, whether this is a NSDate
 and returns it. Otherwise, returns nil.
 
 @returns The NSDate instance or nil,
 when it is not of class NSArray.
 */
- (NSDate *)dateValue;

/**
 Checks, whether this is a NSDictionary
 and returns it. Otherwise, returns nil.
 
 @returns The NSDictionary instance or nil,
 when it is not of class NSDictionary.
 */
- (NSDictionary *)dictionaryValue;

/**
 Checks, whether this is a non-empty NSArray
 and returns it. Otherwise, returns nil.
 
 @returns The non-empty NSArray instance or nil.
 */
- (NSArray *)nonEmptyArrayValue;

/**
 Checks, whether this is a non-empty NSString
 and returns it. Otherwise, returns nil.
 
 @returns The non-empty NSString instance or nil.
 */
- (NSString *)nonEmptyStringValue;

/**
 Checks, whether this is a NSMutableArray
 and returns it. Otherwise, returns nil.
 
 @returns The NSMutableArray instance or nil.
 */
- (NSMutableArray *)mutableArrayValue;

/**
 Checks, whether this is a NSNumber
 and returns it. Otherwise, returns nil.
 
 @returns The NSNumber instance or nil,
 when it is not of class NSNumber.
 */
- (NSNumber *)numberValue;

/**
 Checks, whether this is a NSString
 and returns it. Otherwise, returns nil.
 
 @returns The NSString instance or nil,
 when it is not of class NSString.
 */
- (NSString *)stringValue;

/**
 Checks, whether this is a valid ID
 and returns it as a NSString.
 Otherwise, returns nil.
 
 @returns The ID as a NSString or nil.
 */
- (NSString *)validID;

@end
