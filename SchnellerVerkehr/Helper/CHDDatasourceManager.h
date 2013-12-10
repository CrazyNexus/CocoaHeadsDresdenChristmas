//
//  CHDDatasourceManager.h
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CHDDataSourceManagerCellSetupBlock)(id cell, id data, NSIndexPath *indexPath);


@interface CHDDatasourceManager : NSObject

@property (nonatomic, strong) NSArray *sectionsDatasource;

+ (instancetype)managerForTableView:(UITableView *)tableView;
+ (instancetype)managerForCollectionView:(UICollectionView *)collectionView;

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier forDataObject:(Class)classType setupBlock:(CHDDataSourceManagerCellSetupBlock)setupBlock;
- (void)registerCellReuseIdentifier:(NSString *)reuseIdentifier forDataObject:(Class)classType setupBlock:(CHDDataSourceManagerCellSetupBlock)setupBlock;

- (id)dataForIndexPath:(NSIndexPath *)indexPath;

@end
