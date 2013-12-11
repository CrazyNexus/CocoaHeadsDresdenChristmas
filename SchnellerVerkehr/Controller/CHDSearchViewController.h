//
//  CHDSearchViewController.h
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CHDStation.h"

typedef void (^CHDSearchDidSelectStationBlock)(CHDStation *station);

@interface CHDSearchViewController : UIViewController <UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField            *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField            *destinationTextField;
@property (weak, nonatomic) IBOutlet UITableView            *tableView;

@property (nonatomic, copy) CHDSearchDidSelectStationBlock  didSelectStationBlock;

@end
