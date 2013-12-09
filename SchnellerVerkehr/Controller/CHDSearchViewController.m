//
//  CHDSearchViewController.m
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDSearchViewController.h"
#import "CHDStop.h"

@interface CHDSearchViewController ()

@property (nonatomic, strong) NSArray *menueItems;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation CHDSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //_menueItems = [[NSMutableArray alloc] initWithObjects:@"Detailsuche", @"Kontakte", @"Favoriten", nil];

    [self startLocationService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (_menueItems == nil ? 0 : 1);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_menueItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *menuCellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    CHDStop *stop = [_menueItems objectAtIndex:indexPath.row];
    cell.textLabel.text = stop.name;
    return cell;
}

#pragma mark - Location Service
#pragma mark Current Location

-(void)startLocationService {
    _locationManager          = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Error to get the current location"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    if (signbit(location.horizontalAccuracy)) {
        NSLog(@"Accuracity is negative, coordinates are not avaliable");
    }
    else {
        NSDate *eventDate = location.timestamp;
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (howRecent < -0.0 && howRecent > -10.0) {
            // Positionsbestimmung stoppen
            [manager stopUpdatingLocation];
            NSLog(@"Latitude: %f", location.coordinate.latitude);
            NSLog(@"Longitude: %f", location.coordinate.longitude);
            
            // save new location values for further processing
            [self getStreetFromLocation:location];
            
            // get the stops for current location and show in table
            [CHDStop findByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completion:^(NSArray *stops) {
                self.menueItems = stops;
                [self.tableView reloadData];
            }];

        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    if (error.code == kCLErrorDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"LocationDeniedMsgKey", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OKKey", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    // if no WiFi or internet is available
    if (error.code == kCLErrorLocationUnknown) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"NoInternetKey", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OKKey", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - reverse geocoding

-(void)getStreetFromLocation:(CLLocation *)currentLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *aPlacemark = [placemarks objectAtIndex:0];
        _addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", aPlacemark.name, aPlacemark.postalCode, aPlacemark.locality];
    }];
}

@end
