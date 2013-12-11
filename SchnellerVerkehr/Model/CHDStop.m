//
//  CHDStop.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDStop.h"

@implementation CHDStop

- (instancetype)initWithStation:(CHDStation *)station {
    self = [super init];
    if (self) {
        _station = station;
    }
    return self;
}

@end
