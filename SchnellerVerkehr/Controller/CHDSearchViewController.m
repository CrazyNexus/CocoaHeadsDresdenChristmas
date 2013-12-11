//
//  CHDSearchViewController.m
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDSearchViewController.h"
#import "CHDStation.h"
#import "CHDDatasourceManager.h"
#import "CHDStationCell.h"
#import "CHDMenueCell.h"

@interface CHDSearchViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager     *locationManager;

@property (nonatomic, strong) CHDDatasourceManager  *datasourceManager;
@property (nonatomic, strong) NSArray               *menuItems;

@end

@implementation CHDSearchViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuItems = [[NSArray alloc] initWithObjects:@"Kontakte", @"Favorit", nil];
    
    __weak CHDSearchViewController *weakSelf = self;
    [[self.destinationTextField.rac_textSignal
      filter: ^BOOL (NSString *string) {
          return [string length] >= 3;
      }]
     subscribeNext: ^(NSString *name) {
         [CHDStation findByName:name completion: ^(NSArray *stops) {
             //weakSelf.datasourceManager.sectionsDatasource = @[[stops copy]];
             weakSelf.datasourceManager.sectionsDatasource = @[[stops copy], [_menuItems copy]];
         }];
     }];
    
    self.datasourceManager = [CHDDatasourceManager managerForTableView:self.tableView];
    [self.datasourceManager registerCellReuseIdentifier:@"StopCell" forDataObject:[CHDStation class] setupBlock: ^(CHDStationCell *cell, CHDStation *station, NSIndexPath *indexPath) {
        [cell setupFromStation:station];
    }];
    [self.datasourceManager registerCellReuseIdentifier:@"MenuCell" forDataObject:[@"String" class] setupBlock: ^(CHDMenueCell *cell, NSString *item, NSIndexPath *indexPath) {
        cell.menuItemLabel.text = item;
        cell.menuItemImage.image = [UIImage imageNamed:@"arrow_right"];
    }];
    
    [self startLocationService];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.datasourceManager dataForIndexPath:indexPath] isKindOfClass:[CHDStation class]]) {
        return 65.0;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHDStation      *station;
    CHDMenueCell    *cell;
    switch (indexPath.section) {
        case 0:
            station = [self.datasourceManager dataForIndexPath:indexPath];
            
            if (self.didSelectStationBlock) {
                self.didSelectStationBlock(station);
            }
            break;
            
        case 1:
            cell = (CHDMenueCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.menuItemImage.image == [UIImage imageNamed:@"arrow_right"])
                cell.menuItemImage.image = [UIImage imageNamed:@"arrow_down"];
            else
                cell.menuItemImage.image = [UIImage imageNamed:@"arrow_right"];
            break;
    }
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
            [CHDStation findByLatitude:location.coordinate.latitude longitude:location.coordinate.longitude completion: ^(NSArray *stops) {
                //self.datasourceManager.sectionsDatasource = @[[stops copy]];
                self.datasourceManager.sectionsDatasource = @[[stops copy], [_menuItems copy]];
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
        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", aPlacemark.name, aPlacemark.postalCode, aPlacemark.locality];
        self.destinationTextField.placeholder = [NSString stringWithFormat:@"%@, ", aPlacemark.name];
    }];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.destinationTextField.text = self.destinationTextField.placeholder;
}

#pragma mark - Additional Information for Menu Items



@end
