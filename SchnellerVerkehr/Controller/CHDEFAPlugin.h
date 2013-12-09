//
//  CHDEFAPlugin.h
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHDStopListDelegate.h"

@interface CHDEFAPlugin : NSObject

@property (nonatomic, weak) id<CHDStopListDelegate> delegate;

- (void)findStopsWithName:(NSString *)name;

@end
