//
//  CHDTripCell.h
//  SchnellerVerkehr
//
//  Created by Pit Garbe on 16.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDTrip.h"

@interface CHDTripCell : UITableViewCell

- (void)setupFromTrip:(CHDTrip *)trip;

@end
