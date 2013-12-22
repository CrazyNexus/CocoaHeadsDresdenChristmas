//
//  CHDTripCell.m
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 16.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDTripCell.h"
#import "CHDTrip.h"
#import "CHDStop.h"
#import "CHDStation.h"
#import "CHDCarType.h"
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
    NSDate *departureDate = ((CHDStop *)((CHDLeg *)trip.legs[0]).stops[0]).departureDate;
    NSTimeInterval departure = [departureDate timeIntervalSinceDate:[NSDate date]];

    NSInteger minutes = (NSInteger)departure / 60;
    NSInteger seconds = (NSInteger)departure % 60;

    if (departure > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"Start in %d:%02d minutes", minutes, seconds];
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"Started %d:%2d minutes ago", -minutes, -seconds];
    }
    NSArray *legs = [trip.legs array];
    CHDLeg *firstLeg = [legs firstObject];
    CHDLeg *lastLeg = [legs lastObject];

    self.fromLabel.text = [NSString stringWithFormat:@"%@ %@\nfrom %@ (destination %@)", firstLeg.carType.localizedName, firstLeg.lineNumber, ((CHDStop *)firstLeg.stops[0]).station.name, firstLeg.destination];

    self.toLabel.text = [NSString stringWithFormat:@"%@", ((CHDStop *)[lastLeg.stops lastObject]).station.name];

    NSString *interchanges;
    if (trip.interchangesValue > 0) {
        if (trip.interchangesValue == 1) {
            interchanges = @"1 change";
        }
        else {
            interchanges = [NSString stringWithFormat:@"%@ changes", trip.interchanges];
        }
    }
    else {
        interchanges = @"No changes";
    }
    self.changesLabel.text = interchanges;
    DDLogInfo(@"changes label: %@ (%@)", NSStringFromCGRect(self.changesLabel.frame), self.changesLabel.text);
}

@end
