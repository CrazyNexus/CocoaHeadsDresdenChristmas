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
    NSArray *legs = [trip.legs array];

    CHDLeg *firstLeg = [legs firstObject];
    CHDLeg *lastLeg = [legs lastObject];

    CHDStop *firstStop = [firstLeg.orderedStopsArray firstObject];
    CHDStop *lastStop = [lastLeg.orderedStopsArray lastObject];

    NSDate *departureDate = firstStop.departureDate;
    NSTimeInterval departure = [departureDate timeIntervalSinceDate:[NSDate date]];

    int minutes = (int)departure / 60;
    int seconds = (int)departure % 60;

    if (departure > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"Start in %d:%02d minutes", minutes, seconds];
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"Started %d:%02d minutes ago", -minutes, -seconds];
    }

    for (CHDLeg *leg in legs) {
        DDLogInfo(@"%@", leg);
    }

    self.fromLabel.text = [NSString stringWithFormat:@"%@ %@\nfrom %@ (destination %@)", firstLeg.carType.localizedName, firstLeg.lineNumber, firstStop.station.name, firstLeg.destination];

    self.toLabel.text = [NSString stringWithFormat:@"%@", lastStop.station.name];

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
}

@end
