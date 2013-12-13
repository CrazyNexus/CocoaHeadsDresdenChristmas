//
//  CHDContactCell.h
//  SchnellerVerkehr
//
//  Created by Dubiel, Thomas on 10.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDContact.h"

@interface CHDContactCell : UITableViewCell

- (void)setupFromContact:(CHDContact *)contact;

@end
