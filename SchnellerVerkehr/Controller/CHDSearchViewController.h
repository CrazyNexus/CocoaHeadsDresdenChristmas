//
//  CHDSearchViewController.h
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CHDSearchViewController : UIViewController <UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
