//
//  CHDGeoResolver.h
//  SchnellerVerkehr
//
//  Created by Steffen on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHDGeoResolverDelegate <NSObject>

- (void)geoResolverFinished:(NSArray*)stationList;

@end

@interface CHDGeoResolver : NSObject

- (void)resolveGPSToStationWithLatitude:(NSInteger)latittude logitude:(NSInteger)longitude;

@end
