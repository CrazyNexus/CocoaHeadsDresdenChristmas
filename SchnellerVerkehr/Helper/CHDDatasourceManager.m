//
//  CHDDatasourceManager.m
//  SchnellerVerkehr
//
//  Created by Michael Berg on 09.12.13.
//  Copyright (c) 2013 CocoaHeads Dresden. All rights reserved.
//

#import "CHDDatasourceManager.h"

@interface CHDDatasourceManager () <UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableDictionary *setupBlocks;
@property (nonatomic, strong) NSMutableDictionary *reuseIdentifiers;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end


@implementation CHDDatasourceManager

+ (instancetype)managerForTableView:(UITableView *)tableView {
    CHDDatasourceManager *manager = [[CHDDatasourceManager alloc] init];
    
    manager.tableView       = tableView;
    tableView.dataSource    = manager;
    
    return manager;
}

+ (instancetype)managerForCollectionView:(UICollectionView *)collectionView {
    CHDDatasourceManager *manager = [[CHDDatasourceManager alloc] init];
    
    manager.collectionView      = collectionView;
    collectionView.dataSource   = manager;
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.shouldAutoReloadOnDatasourceChange = TRUE;
        self.setupBlocks                        = [NSMutableDictionary dictionary];
        self.reuseIdentifiers                   = [NSMutableDictionary dictionary];
        
        __weak CHDDatasourceManager *weakSelf = self;
        [RACObserve(self, data) subscribeNext:^(NSArray *data) {
            if (![data isKindOfClass:[NSArray class]]) {
                weakSelf.data = @[];
                return;
            }
            
            if (weakSelf.shouldAutoReloadOnDatasourceChange) {
                [weakSelf.tableView reloadData];
                [weakSelf.collectionView reloadData];
            }
        }];
    }
    return self;
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)reuseIdentifier forDataObject:(Class)classType setupBlock:(CHDDataSourceManagerCellSetupBlock)setupBlock {
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    [self registerCellReuseIdentifier:reuseIdentifier forDataObject:classType setupBlock:setupBlock];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)reuseIdentifier forDataObject:(Class)classType setupBlock:(CHDDataSourceManagerCellSetupBlock)setupBlock {
    [self.tableView registerClass:cellClass forCellReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:reuseIdentifier];
    
    [self registerCellReuseIdentifier:reuseIdentifier forDataObject:classType setupBlock:setupBlock];
}

- (void)registerCellReuseIdentifier:(NSString *)reuseIdentifier forDataObject:(Class)classType setupBlock:(CHDDataSourceManagerCellSetupBlock)setupBlock {
    NSString *classString = NSStringFromClass(classType);
    [self.reuseIdentifiers  setObject:reuseIdentifier   forKey:classString];
    [self.setupBlocks       setObject:setupBlock        forKey:classString];
}


#pragma mark - Data Accessor

- (id)dataForIndexPath:(NSIndexPath *)indexPath {
    return [self.data[indexPath.section] objectAtIndex:indexPath.row];
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *data          = [self dataForIndexPath:indexPath];
    NSString *classString   = NSStringFromClass(data.class);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.reuseIdentifiers objectForKey:classString]];
    
    CHDDataSourceManagerCellSetupBlock setupBlock = [self.setupBlocks objectForKey:classString];
    
    if (setupBlock) {
        setupBlock(cell,data,indexPath);
    }
    
    return cell;
}

#pragma mark - Collection View Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.data[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data          = [self dataForIndexPath:indexPath];
    NSString *classString   = NSStringFromClass(data.class);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.reuseIdentifiers objectForKey:classString] forIndexPath:indexPath];
    
    CHDDataSourceManagerCellSetupBlock setupBlock = [self.setupBlocks objectForKey:classString];
    
    if (setupBlock) {
        setupBlock(cell,data,indexPath);
    }
    
    return cell;
}

@end
