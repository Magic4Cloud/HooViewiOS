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
#import "EVSpeciaColumnModel.h"
#import "WaterFlowLayout.h"
#import "EVNewsDetailWebController.h"
#import "EVWatchVideoInfo.h"
#import "EVVipCenterViewController.h"
#import "EVNullDataView.h"

@interface EVSpeciaColumnViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate>
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *datasourceArray;

@property (nonatomic, weak) EVNullDataView *noDataView;

@property (nonatomic, assign) int start;

@end

@implementation EVSpeciaColumnViewController

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
    WEAK(self)
    [self.collectionView.mj_footer setHidden:YES];
    [_collectionView addRefreshHeaderWithRefreshingBlock:^{
        [weakself initData];
    }];
    
    [_collectionView addRefreshFooterWithRefreshingBlock:^{
        [weakself initMoreData];
    }];
    [_collectionView startHeaderRefreshing];
    _collectionView.mj_footer.hidden = YES;

}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    
    [self.view addSubview:self.collectionView];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.collectionView autoSetDimension:ALDimensionHeight toSize:ScreenHeight - 113];
    
    EVNullDataView *noDataView = [[EVNullDataView alloc] init];
    noDataView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    noDataView.topImage = [UIImage imageNamed:@"ic_smile"];
    noDataView.title = @"当前没有相关专栏文章";
    [self.collectionView addSubview:noDataView];
    self.noDataView = noDataView;
    noDataView.hidden = YES;

    
}

#pragma mark - 🌐 Networks
- (void)initData {
    _start = 0;
    
    
    [self.baseToolManager GETSpeciaColumnNewsRequestStart:@"0" count:@"20" Success:^(NSDictionary *retinfo) {
        [self endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
        NSLog(@"专栏 = %@",retinfo);
        [self.datasourceArray removeAllObjects];
        
        NSArray *array = retinfo[@"news"];
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVSpeciaColumnModel * model = [EVSpeciaColumnModel yy_modelWithDictionary:obj];
                [weakSelf.datasourceArray addObject:model];
            }];
        }
        
        if (_start == 0 && array.count <= 0) {
            self.noDataView.hidden = NO;
        }else {
            self.noDataView.hidden = YES;
        }

        if (self.datasourceArray.count < 20)
        {
            //没有更多数据
            [self.collectionView.mj_footer setHidden:YES];
        }
        else
        {
            [self.collectionView.mj_footer setHidden:NO];
        }
        
        _start += self.datasourceArray.count;
        [self.collectionView reloadData];
    } error:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"新闻请求失败"];
    }];
}

- (void)initMoreData {
    [self.baseToolManager GETSpeciaColumnNewsRequestStart:[NSString stringWithFormat:@"%d",_start] count:@"20" Success:^(NSDictionary *retinfo) {

        [self endRefreshing];
        
        NSArray *array = retinfo[@"news"];
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVSpeciaColumnModel * model = [EVSpeciaColumnModel yy_modelWithDictionary:obj];
                [weakSelf.datasourceArray addObject:model];
            }];
        }
        
        if (array.count == 0)
        {
            //没有更多数据
            [self.collectionView setFooterState:CCRefreshStateNoMoreData ];
            self.noDataView.hidden = NO;
        }
        else
        {
            _start += array.count;
            self.noDataView.hidden = YES;
        }
        
        [self.collectionView reloadData];
        
        } error:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"专栏新闻请求失败"];
    }];

}

- (void)endRefreshing
{
    [_collectionView endHeaderRefreshing];
    [_collectionView endFooterRefreshing];
}

#pragma mark - 👣 Target actions

#pragma mark - 🌺 CollectionView Delegate & Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasourceArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"EVSpeciaColumnCell";
    EVSpeciaColumnModel * columnModel = _datasourceArray[indexPath.row];
    
    EVSpeciaColumnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.columnModel = columnModel;
    cell.collectionSeletedBlock = ^(EVSpeciaAuthor *userInfo) {
        
        EVWatchVideoInfo *watchInfo = [EVWatchVideoInfo new];
        watchInfo.name = userInfo.nameID;
        EVVipCenterViewController *vipVC = [EVVipCenterViewController new];
        vipVC.watchVideoInfo = watchInfo;
        [self.navigationController pushViewController:vipVC animated:YES];
        
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVNewsDetailWebController *newsWebVC = [[EVNewsDetailWebController alloc] init];
    EVSpeciaColumnModel * columnModel = _datasourceArray[indexPath.row];
    newsWebVC.newsID = columnModel.newsID;
    newsWebVC.newsTitle = columnModel.title;
    if ([columnModel.newsID isEqualToString:@""] || columnModel.newsID == nil) {
        return;
    }
    [self.navigationController pushViewController:newsWebVC animated:YES];
    
}


- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width {
    EVSpeciaColumnModel * columnModel = _datasourceArray[index];
    return columnModel.cellHeight;
}

- (NSInteger)cloumnCountInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 2;
}

//决定cell 的列的距离
- (CGFloat)columMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 12;
}

//决定cell 的行的距离
- (CGFloat)rowMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 36;
}

//决定cell 的边缘距
- (UIEdgeInsets)edgeInsetInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(12, 12, 12, 12);
}
#pragma mark - ✍️ Setters & Getters

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
//        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        WaterFlowLayout *layout = [[WaterFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.estimatedItemSize = CGSizeMake(120, 252);
//        layout.minimumLineSpacing = 36;//滑动方向的距离
//        layout.minimumInteritemSpacing = 0;//与滑动方向垂直的距离
//        layout.sectionInset = UIEdgeInsetsMake(12, 12, 20, 12);
        layout.delegate = self;
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
