//
//  CHDTestSearchViewController.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDTestSearchViewController.h"
#import "CHDStation.h"
#import "CHDSearchViewController.h"
#import "CHDTrip.h"


@interface CHDTestSearchViewController ()

@property (nonatomic, weak) IBOutlet UIButton   *startButton;
@property (nonatomic, weak) IBOutlet UIButton   *destinationButton;
@property (nonatomic, weak) IBOutlet UIButton   *searchButton;

@property (nonatomic, strong) CHDStation        *startStation;
@property (nonatomic, strong) CHDStation        *destinationStation;

- (IBAction)didTapSearchButton:(id)sender;

@end


@implementation CHDTestSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RAC(self.searchButton, enabled) = [RACSignal combineLatest:@[RACObserve(self, startStation), RACObserve(self, destinationStation)] reduce: ^id (CHDStation *startStation, CHDStation *destinationStation) {
        return @((startStation != nil) && (destinationStation != nil));
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CHDSearchViewController class]]) {
        CHDSearchViewController             *searchController   = segue.destinationViewController;

        __weak CHDTestSearchViewController  *weakSelf           = self;
        searchController.didSelectStationBlock = ^(CHDStation *station) {
            if (sender == weakSelf.startButton) {
                weakSelf.startStation = station;
                [weakSelf.startButton setTitle:station.name forState:UIControlStateNormal];
            }
            else {
                weakSelf.destinationStation = station;
                [weakSelf.destinationButton setTitle:station.name forState:UIControlStateNormal];
            }

            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
}

#pragma mark - User Interaction

- (IBAction)didTapSearchButton:(id)sender {
    [CHDTrip findTripWithOrigin:self.startStation destination:self.destinationStation calcNumberOfTrips:3 completion: ^(NSArray *trips) {
        NSLog(@"trips: %@", trips);
    }];
}

@end
