//
//  NSObject+TypeChecks.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "NSObject+TypeChecks.h"

@implementation NSObject (TypeChecks)

- (NSArray *)arrayValue {
    if ([self isKindOfClass:[NSArray class]]) {
        return (NSArray *)self;
    }
    
    return nil;
}

- (NSDate *)dateValue {
    if ([self isKindOfClass:[NSDate class]]) {
        return (NSDate *)self;
    }
    
    return nil;
}

- (NSDictionary *)dictionaryValue {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)self;
    }
    
    return nil;
}

- (NSArray *)nonEmptyArrayValue {
    if (
        [self isKindOfClass:[NSArray class]] &&
        [(NSArray *)self count] != 0
        ) {
        return (NSArray *)self;
    }
    
    return nil;
}

- (NSString *)nonEmptyStringValue {
    if (![self isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedString      = [(NSString *)self stringByTrimmingCharactersInSet:characterSet];
    if (trimmedString.length == 0) {
        return nil;
    }
    
    return (NSString *)self;
}

- (NSMutableArray *)mutableArrayValue {
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)self;
    }
    
    return nil;
}

- (NSNumber *)numberValue {
    if ([self isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)self;
    }
    
    return nil;
}

- (NSString *)stringValue {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    return nil;
}

- (NSString *)validID {
    if ([self isKindOfClass:[NSNumber class]]) {
        if ([((NSNumber *) self) integerValue] != 0) {
            return [((NSNumber *) self) stringValue];
        }
    } else if ([self isKindOfClass:[NSString class]]) {
        NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimmedString      = [(NSString *)self stringByTrimmingCharactersInSet:characterSet];
        
        if (
            !trimmedString.length == 0               &&
            ![trimmedString isEqualToString:@"0"]    &&
            ![trimmedString isEqualToString:@"None"]
            ) {
            return trimmedString;
        }
    }
    
    return nil;
}

@end
