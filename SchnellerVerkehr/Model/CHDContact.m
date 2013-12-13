//
//  CHDContact.m
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 11.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDContact.h"

@implementation CHDContact

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_type forKey:@"contactType"];
    [aCoder encodeObject:_firstName forKey:@"firstName"];
    [aCoder encodeObject:_lastName forKey:@"lastName"];
    [aCoder encodeObject:_street forKey:@"streetName"];
    [aCoder encodeObject:_city forKey:@"cityName"];
    [aCoder encodeObject:_location forKey:@"contactLocation"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        [self setType:[aDecoder decodeIntegerForKey:@"contactType"]];
        [self setFirstName:[aDecoder decodeObjectForKey:@"firstName"]];
        [self setLastName:[aDecoder decodeObjectForKey:@"lastName"]];
        [self setStreet:[aDecoder decodeObjectForKey:@"streetName"]];
        [self setCity:[aDecoder decodeObjectForKey:@"cityName"]];
        [self setLocation:[aDecoder decodeObjectForKey:@"contactLocation"]];
    }
    return self;
}

@end
