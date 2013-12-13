//
//  CHDContact.h
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 11.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM (NSInteger, CHDContactType) {
    CHDContactTypeContact,
    CHDContactTypeFavorit,
};

@interface CHDContact : NSObject <NSCoding>

@property (nonatomic, assign) CHDContactType    type;
@property (nonatomic, strong) NSString          *firstName;
@property (nonatomic, strong) NSString          *lastName;
@property (nonatomic, strong) NSString          *street;
@property (nonatomic, strong) NSString          *city;
@property (nonatomic, strong) CLLocation        *location;

@end
