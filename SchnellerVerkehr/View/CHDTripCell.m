//
//  CHDTripCell.m
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 16.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDTripCell.h"
#import "CHDLeg.h"

@interface CHDTripCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *changesLabel;

@end

@implementation CHDTripCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupFromTrip:(CHDTrip *)trip {
    self.titleLabel.text = @"A Trip";
    NSArray *legs = [trip.legs array];
    CHDLeg *firstLeg = [legs firstObject];
    CHDLeg *lastLeg = [legs lastObject];

    self.fromLabel.text = firstLeg.name;
    self.toLabel.text = lastLeg.name;
    self.changesLabel.text = [NSString stringWithFormat:@"%@", trip.interchanges];
}

@end
