//
//  CHDStopCell.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDStationCell.h"

@interface CHDStationCell ()

@property (weak, nonatomic) IBOutlet UILabel    *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel    *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *cityLabel;


@end


@implementation CHDStationCell

- (void)setupFromStation:(CHDStation *)stop {
    self.titleLabel.text    = stop.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%ld Meter", (long)stop.distance];
    self.cityLabel.text     = stop.city;
}

@end
