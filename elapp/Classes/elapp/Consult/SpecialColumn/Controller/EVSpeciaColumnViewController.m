//
//  EVSpeciaColumnViewController.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVSpeciaColumnViewController.h"
#import "EVSpeciaColumnCell.h"
#import "EVBaseToolManager.h"
#import "EVBaseToolManager+EVNewsAPI.h"

@interface EVSpeciaColumnViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datasourceArray;
@end

@implementation EVSpeciaColumnViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [self.view addSubview:self.collectionView];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.collectionView autoSetDimension:ALDimensionHeight toSize:ScreenHeight - 113];
    
    
}

#pragma mark - 🌐 Networks
- (void)initData {
    [self.baseToolManager GETSpeciaColumnNewsRequestStart:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        NSLog(@"专栏 = %@",retinfo);
        self.datasourceArray = [retinfo[@"news"] mutableCopy];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - 👣 Target actions

#pragma mark - 🌺 CollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"EVSpeciaColumnCell";
    EVSpeciaColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    NSArray *titleArray = @[@"江苏省原副省长李云峰严重违纪",@"菲总统信任度民调微降 或因禁毒制大量居民死亡",@"菲总统信任度民调微降  或因禁毒制大量居民死亡一二",@"江苏省原副省长",@"江苏省原副省长李云峰严重违纪被双开",@"江苏省原副省长李云峰严重违纪被双开"];
    cell.newsTitleLabel.text = titleArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - ✍️ Setters & Getters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.estimatedItemSize = CGSizeMake(120, 252);
        layout.minimumLineSpacing = 36;//滑动方向的距离
        layout.minimumInteritemSpacing = 0;//与滑动方向垂直的距离
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 20, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"EVSpeciaColumnCell" bundle:nil] forCellWithReuseIdentifier:@"EVSpeciaColumnCell"];
    }
    return _collectionView;

}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)datasourceArray
{
    if (!_datasourceArray) {
        _datasourceArray = [NSMutableArray array];
    }
    return _datasourceArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
