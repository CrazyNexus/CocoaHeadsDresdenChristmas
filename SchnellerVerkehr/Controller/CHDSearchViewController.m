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
#import "CHDContactCell.h"
#import "CHDContact.h"
#import "CHDTrip.h"
#import "CHDTripCell.h"

@interface CHDSearchViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager     *locationManager;

@property (nonatomic, strong) CHDDatasourceManager  *datasourceManager;
@property (nonatomic, strong) NSMutableArray        *contactItems;
@property (nonatomic, strong) NSMutableArray        *favoriteItems;
@property (nonatomic, strong) NSDate                *dateWhenLocationUpdatesStarted;
@property (nonatomic, strong) CHDStation            *startStation;
@property (nonatomic, strong) CHDStation            *destinationStation;


@end

@implementation CHDSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;

    // two new buttons in the navigation bar
    //    UIBarButtonItem *addressButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(selectBookmark)];
    //    UIBarButtonItem *favoritButton  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorit"] style:UIBarButtonItemStyleBordered target:self action:@selector(saveFavorite)];
    //    self.navigationItem.rightBarButtonItems = @[addressButton, favoritButton];

    __weak CHDSearchViewController *weakSelf = self;
    [[self.destinationTextField.rac_textSignal
      filter: ^BOOL (NSString *string) {
          return [string length] >= 3;
      }]
     subscribeNext: ^(NSString *name) {
         [CHDStation findByName:name completion: ^(NSArray *stops) {
             weakSelf.datasourceManager.sectionsDatasource = @[[stops copy]];
         }];
     }];

    [[self.startTextField.rac_textSignal
      filter: ^BOOL (NSString *string) {
          return [string length] >= 3;
      }]
     subscribeNext: ^(NSString *name) {
         [CHDStation findByName:name completion: ^(NSArray *stops) {
             weakSelf.datasourceManager.sectionsDatasource = @[[stops copy]];
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
    [self.datasourceManager registerCellReuseIdentifier:@"ContactCell" forDataObject:[CHDContact class] setupBlock: ^(CHDContactCell *cell, CHDContact *contact, NSIndexPath *indexPath) {
        [cell setupFromContact:contact];
    }];
    [self.datasourceManager registerCellReuseIdentifier:@"TripCell" forDataObject:[CHDTrip class] setupBlock: ^(CHDTripCell *cell, CHDTrip *trip, NSIndexPath *indexPath) {
        [cell setupFromTrip:trip];
    }];

    [self startLocationService];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.datasourceManager tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.bounds = CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.contentView.bounds));

    [cell.contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CHDStation *station;

    switch (indexPath.section) {
        case 0:
        {
            station = [self.datasourceManager dataForIndexPath:indexPath];

            if (self.didSelectStationBlock) {
                self.didSelectStationBlock(station);
            }
            break;
        }

        case 1:
        {
            [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
            [self extendValuesForContactsInTableView:tableView forIndexPath:indexPath];
            break;
        }

        case 2:
        {
            [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView changeImageInMenuCellAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CHDMenueCell *cell;
        cell = (CHDMenueCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.menuItemImage.image == [UIImage imageNamed:@"arrow_right"]) {
            cell.menuItemImage.image = [UIImage imageNamed:@"arrow_down"];
        }
        else {
            cell.menuItemImage.image = [UIImage imageNamed:@"arrow_right"];
        }
    }
}

#pragma mark - Location Service
#pragma mark Current Location

- (void)startLocationService {
    self.locationManager                    = [[CLLocationManager alloc] init];
    self.locationManager.delegate           = self;
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyHundredMeters;
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManager startUpdatingLocation];
        self.dateWhenLocationUpdatesStarted = [NSDate date];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle       :nil
                                                    message             :@"Error to get the current location"
                                                    delegate            :nil
                                                    cancelButtonTitle   :@"OK"
                                                    otherButtonTitles   :nil];
//        [alert show];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    if (signbit(location.horizontalAccuracy)) {
        DDLogWarn(@"Accuracity is negative, coordinates are not avaliable");
    }
    else {
        NSTimeInterval timeSinceLocationUpdatesStarted = [location.timestamp timeIntervalSinceDate:self.dateWhenLocationUpdatesStarted];
        if (timeSinceLocationUpdatesStarted >= 10) {
            // Positionsbestimmung stoppen
            [manager stopUpdatingLocation];
        }
        DDLogVerbose(@"Latitude: %f", location.coordinate.latitude);
        DDLogVerbose(@"Longitude: %f", location.coordinate.longitude);

        // save new location values for further processing
        [self getStreetFromLocation:location];

        // get the stops for current location and show in table
        [CHDStation findByLatitude  :location.coordinate.latitude
                    longitude       :location.coordinate.longitude
                    completion      : ^(NSArray *stops) {
                        self.datasourceManager.sectionsDatasource = @[[stops copy]];
                    }];
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
//        [alert show];
    }
    // if no WiFi or internet is available
    if (error.code == kCLErrorLocationUnknown) {
        UIAlertView *alert = [[UIAlertView alloc]   initWithTitle       :nil
                                                    message             :[error localizedDescription]
                                                    delegate            :nil
                                                    cancelButtonTitle   :@"OK"
                                                    otherButtonTitles   :nil];
//        [alert show];
    }
}

#pragma mark - reverse geocoding

- (void)getStreetFromLocation:(CLLocation *)currentLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *aPlacemark = [placemarks objectAtIndex:0];
        //        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@ %@", aPlacemark.name, aPlacemark.postalCode, aPlacemark.locality];
        self.startTextField.placeholder = [NSString stringWithFormat:@"%@, %@", aPlacemark.name, aPlacemark.locality];
        self.startTextField.leftViewMode = UITextFieldViewModeAlways;
        self.startTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"geolocation"]];
    }];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    __weak CHDSearchViewController *weakSelf = self;

    self.datasourceManager.sectionsDatasource = @[];
    [self.tableView reloadData];

    self.didSelectStationBlock = ^(CHDStation *station) {
        if (textField == weakSelf.startTextField) {
            weakSelf.startStation = station;
        }
        else {
            weakSelf.destinationStation = station;
        }
        textField.text = station.name;

        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)selectBookmark {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:NULL];
}

- (void)saveFavorite {
}

- (void)extendValuesForContactsInTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    if ([_contactItems count] == 1) {
        [_contactItems addObjectsFromArray:_contactItems];
        [tableView reloadData];
        [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
    }
    else {
        [tableView reloadData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.startStation != nil
        && self.destinationStation != nil) {
        [CHDTrip findTripWithOrigin:self.startStation destination:self.destinationStation calcNumberOfTrips:3 completion: ^(NSArray *trips) {
            NSLog(@"trips: %@", trips);
            if (trips) {
                self.datasourceManager.sectionsDatasource = @[[trips copy]];
            }
        }];
    }
    return YES;
}

#pragma mark - People Picker Delegate

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    CHDContact *newContact = [[CHDContact alloc] init];
    newContact.firstName    = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    newContact.lastName     = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);

    ABMultiValueRef addresses;
    addresses = ABRecordCopyValue(person, kABPersonAddressProperty);

    if (ABMultiValueGetCount(addresses) > 0) {
        CFDictionaryRef address = ABMultiValueCopyValueAtIndex(addresses, 0);
        newContact.street   = (__bridge_transfer NSString *)CFDictionaryGetValue(address, kABPersonAddressStreetKey);
        newContact.city     = (__bridge_transfer NSString *)CFDictionaryGetValue(address, kABPersonAddressCityKey);

        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressDictionary:CFBridgingRelease(address) completionHandler: ^(NSArray *placemarks, NSError *error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                DDLogVerbose(@"%f, %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                newContact.location = placemark.location;
            }
            else {
                DDLogError(@"Goocoding error: %@", [error localizedDescription]);
            }
        }];
    }

    [self.contactItems addObject:newContact];

    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.tableView reloadData];

    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

@end
