//
//  CHDStopCell.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDStation.h"


@interface CHDStationCell : UITableViewCell

- (void)setupFromStation:(CHDStation *)stop;

@end
