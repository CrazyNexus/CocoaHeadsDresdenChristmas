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

static NSString *kContactFile = @"CHDContacts.plist";
static NSString *kFavoritFile = @"CHDFavorits.plist";

@interface CHDSearchViewController () <UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic, strong) CLLocationManager     *locationManager;

@property (nonatomic, strong) CHDDatasourceManager  *datasourceManager;
@property (nonatomic, strong) NSMutableArray        *contactItems;
@property (nonatomic, strong) NSMutableArray        *favoritItems;

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
    
    // two new buttons in the navigation bar
    UIBarButtonItem *addressButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(selectBookmark)];
    UIBarButtonItem *favoritButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorit"] style:UIBarButtonItemStyleBordered target:self action:@selector(saveFavorit)];
    self.navigationItem.rightBarButtonItems = @[addressButton, favoritButton];
    
    __weak CHDSearchViewController *weakSelf = self;
    [[self.destinationTextField.rac_textSignal
      filter: ^BOOL (NSString *string) {
          return [string length] >= 3;
      }]
     subscribeNext: ^(NSString *name) {
         [CHDStation findByName:name completion: ^(NSArray *stops) {
             //weakSelf.datasourceManager.sectionsDatasource = @[[stops copy]];
             weakSelf.datasourceManager.sectionsDatasource = @[[stops copy], _contactItems, _favoritItems];
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
    [self.datasourceManager registerCellReuseIdentifier:@"ContactCell" forDataObject:[CHDContact class] setupBlock:^(CHDContactCell *cell, CHDContact *contact, NSIndexPath *indexPath) {
        [cell setupFromContact:contact];
    }];
    
    [self startLocationService];
    
    // load saved contacts and favorits
    _contactItems = [self loadArrayFromFile:kContactFile];
    _favoritItems = [self loadArrayFromFile:kFavoritFile];
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

    switch (indexPath.section) {
        case 0:
            station = [self.datasourceManager dataForIndexPath:indexPath];
            
            if (self.didSelectStationBlock) {
                self.didSelectStationBlock(station);
            }
            break;

        case 1:
            [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
            [self extendValuesForContactsinTableView:tableView forIndexPath:indexPath];
            break;
            
        case 2:
            [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
            break;
    }
}

-(void)tableView:(UITableView *)tableView changeImageInMenuCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CHDMenueCell    *cell;
        cell = (CHDMenueCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (cell.menuItemImage.image == [UIImage imageNamed:@"arrow_right"])
            cell.menuItemImage.image = [UIImage imageNamed:@"arrow_down"];
        else
            cell.menuItemImage.image = [UIImage imageNamed:@"arrow_right"];
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
                self.datasourceManager.sectionsDatasource = @[[stops copy], _contactItems, _favoritItems];
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
        self.destinationTextField.placeholder = [NSString stringWithFormat:@"%@, %@", aPlacemark.name, aPlacemark.locality];
    }];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.destinationTextField.text = self.destinationTextField.placeholder;
}

#pragma mark - Additional Information for Menu Items

-(BOOL)saveArray:(NSArray *)data inFile:(NSString *)fileName {
    NSString *docPath   = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath  = [docPath stringByAppendingPathComponent:fileName];
    return [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

-(NSMutableArray *)loadArrayFromFile:(NSString *)fileName {
    NSMutableArray *data;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath          = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath         = [docPath stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath])
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    else {
        data = [[NSMutableArray alloc] init];
        if ([fileName isEqualToString:kContactFile])
            [data addObject:@"Kontakt"];
        else
            [data addObject:@"Favoriten"];
    }
    
    return data;
}

-(void)selectBookmark {
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self presentViewController:peoplePicker animated:YES completion:NULL];
    
}

-(void)saveFavorit {
    
}

-(void)extendValuesForContactsinTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    if ([_contactItems count] == 1) {
        [_contactItems addObjectsFromArray:_contactItems];
        [tableView reloadData];
        [self tableView:tableView changeImageInMenuCellAtIndexPath:indexPath];
    }
    else {
        //[_contactItems removeObjectAtIndex:1];
        [tableView reloadData];
    }
}

#pragma mark - People Picker Delegate 

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    CHDContact *newContact  = [[CHDContact alloc] init];
    newContact.type         = CHDContactTypeContact;
    newContact.firstName    = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    newContact.lastName     = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    ABMultiValueRef addresses;
    addresses = ABRecordCopyValue(person, kABPersonAddressProperty);

    if (ABMultiValueGetCount(addresses) > 0) {
        CFDictionaryRef address = ABMultiValueCopyValueAtIndex(addresses, 0);
        newContact.street = (__bridge_transfer NSString *)CFDictionaryGetValue(address, kABPersonAddressStreetKey);
        newContact.city   = (__bridge_transfer NSString *)CFDictionaryGetValue(address, kABPersonAddressCityKey);
    
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressDictionary:CFBridgingRelease(address) completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                NSLog(@"%f, %f", placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                newContact.location = placemark.location;
            }
            else {
                NSLog(@"Goocoding error: %@", [error localizedDescription]);
            }
        }];
    }
    
    [_contactItems addObject:newContact];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [_tableView reloadData];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self dismissViewControllerAnimated:YES completion:NULL];
    return NO;
}

-(BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return NO;
}

@end
