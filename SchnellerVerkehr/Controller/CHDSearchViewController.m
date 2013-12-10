//
//  CHDSearchViewController.m
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 09.12.13.
//  Copyright (c) 2013 Couchfunk. All rights reserved.
//

#import "CHDSearchViewController.h"
#import "CHDStop.h"
#import "CHDDatasourceManager.h"
#import "CHDStopCell.h"
#import "CHDEFAPlugin.h"
#import "CHDStopListDelegate.h"

@interface CHDSearchViewController () <CHDStopListDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CHDEFAPlugin      *efaPlugin;

@property (nonatomic, strong) CHDDatasourceManager *datasourceManager;

@end

@implementation CHDSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    if (self) {
        self.efaPlugin          = [[CHDEFAPlugin alloc] init];
        self.efaPlugin.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_menueItems = [[NSMutableArray alloc] initWithObjects:@"Detailsuche", @"Kontakte", @"Favoriten", nil];

    [[self.destinationTextField.rac_textSignal
      filter: ^BOOL (NSString *string) {
          return [string length] >= 3;
      }]
     subscribeNext: ^(NSString *name) {
         [self.efaPlugin findStopsWithName:name];
     }];

    
    self.datasourceManager = [CHDDatasourceManager managerForTableView:self.tableView];
    
    [self.datasourceManager registerCellReuseIdentifier:@"StopCell" forDataObject:[CHDStop class] setupBlock:^(CHDStopCell *cell, CHDStop *stop, NSIndexPath *indexPath) {
        [cell setupFromStop:stop];
    }];
    
    [self startLocationService];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.datasourceManager dataForIndexPath:indexPath] isKindOfClass:[CHDStop class]]) {
        return 65.0;
    }
    return tableView.rowHeight;
}

#pragma mark - Location Service
#pragma mark Current Location

- (void)startLocationService {
    _locationManager                    = [[CLLocationManager alloc] init];
    _locationManager.delegate           = self;
    _locationManager.desiredAccuracy    = kCLLocationAccuracyHundredMeters;
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle       :nil
                                                    message             :@"Error to get the current location"
                                                    delegate            :nil
                                                    cancelButtonTitle   :@"OK"
                                                    otherButtonTitles   :nil];
        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    if (signbit(location.horizontalAccuracy)) {
        NSLog(@"Accuracity is negative, coordinates are not avaliable");
    }
    else {
        NSDate          *eventDate  = location.timestamp;
        NSTimeInterval  howRecent   = [eventDate timeIntervalSinceNow];
        if (howRecent < -0.0 && howRecent > -10.0) {
            // Positionsbestimmung stoppen
            [manager stopUpdatingLocation];
            NSLog(@"Latitude: %f", location.coordinate.latitude);
            NSLog(@"Longitude: %f", location.coordinate.longitude);

            // save new location values for further processing
            [self getStreetFromLocation:location];

            // get the stops for current location and show in table
            [CHDStop findByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completion: ^(NSArray *stops) {
                self.datasourceManager.sectionsDatasource = @[[stops copy]];
            }];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    if (error.code == kCLErrorDenied) {
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle       :nil
                                                    message             :[error localizedDescription]
                                                    delegate            :nil
                                                    cancelButtonTitle   :@"OK"
                                                    otherButtonTitles   :nil];
        [alert show];
    }
    // if no WiFi or internet is available
    if (error.code == kCLErrorLocationUnknown) {
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle       :nil
                                                    message             :[error localizedDescription]
                                                    delegate            :nil
                                                    cancelButtonTitle   :@"OK"
                                                    otherButtonTitles   :nil];
        [alert show];
    }
}

#pragma mark - reverse geocoding

- (void)getStreetFromLocation:(CLLocation *)currentLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *aPlacemark = [placemarks objectAtIndex:0];
        _addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", aPlacemark.name, aPlacemark.postalCode, aPlacemark.locality];
    }];
}

#pragma mark - Stop List Delegate

- (void)receivedStopsList:(NSArray *)stops {
    self.datasourceManager.sectionsDatasource = @[[stops copy]];
}

@end
