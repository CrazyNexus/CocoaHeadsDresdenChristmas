//
//  CHDStopCell.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDStopCell.h"

@interface CHDStopCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end


@implementation CHDStopCell

- (void)setupFromStop:(CHDStop *)stop {
    self.titleLabel.text    = stop.name;
    self.distanceLabel.text = [NSString stringWithFormat:@"%ld Meter",stop.distance];
}

@end
