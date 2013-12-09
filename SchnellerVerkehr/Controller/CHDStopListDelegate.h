//
//  CHDStopListDelegate.h
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHDStopListDelegate <NSObject>

- (void)receivedStopsList:(NSArray *)stops;

@end
