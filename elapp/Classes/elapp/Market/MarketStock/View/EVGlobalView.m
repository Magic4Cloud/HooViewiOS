//
//  EVGlobalView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVGlobalView.h"
#import "EVStockCollectionViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "NSString+Extension.h"

@interface EVGlobalView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    NSIndexPath *_currentIndexPath;
    CGPoint _deltaPoint;
}

@property(nonatomic,strong)UICollectionViewFlowLayout      *flowLayout;

@property(nonatomic,strong)UIPanGestureRecognizer          *panGesture;
@property(nonatomic,strong)UILongPressGestureRecognizer    *longPressGesture;


@property (nonatomic, strong) UILabel *tipLabel;
@property (strong, nonatomic) UIView *snapedImageView;
@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@end

static NSString *const TCellId = @"TCellId";
@implementation EVGlobalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tipLabel];
        [self addSubview:self.collectionView];
        [self.collectionView addGestureRecognizer:self.longPressGesture];
        [self addSubview:self.refreshButton];
    
        
    }
    return self;
}

- (void)loadData
{
    [self getLocalModels];
}

- (void)getLocalModels {
    [EVProgressHUD showIndeterminateForView:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [EVStockBaseModel getDefaultGlobalArray:^(NSArray<EVStockBaseModel *> *localStocks, BOOL hasChanged) {
            if (hasChanged) {
                if (localStocks.count == 0) {
                    [self _reloadCollectionViewWithArray:localStocks];
                    return ;
                }
                [self fetchTargetDataWithLocalModels:localStocks];
            }
            else {
                [self fetchAllGlobalDataWithLocalModels:localStocks];
            }
        }];
    });
}

#pragma mark - network
- (void)fetchAllGlobalDataWithLocalModels:(NSArray *)localModels {
    [self.baseToolManager GETRequestGlobalSuccess:^(NSDictionary *retinfo) {
        EVLog(@"全球成功");
        [self.collectionView endHeaderRefreshing];
        NSArray *stockArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"]];
        NSArray *sortedArray = [self _sortModelsWithLocalModels:localModels responseData:stockArray];
        [self _reloadCollectionViewWithArray:sortedArray];
    } error:^(NSError *error) {
        EVLog(@"全球失败");
        [EVProgressHUD hideHUDForView:self];
        [self.collectionView endHeaderRefreshing];
    }];
}

- (void)fetchTargetDataWithLocalModels:(NSArray *)localModels {
    NSMutableArray *symbols = @[].mutableCopy;
    [localModels enumerateObjectsUsingBlock:^(EVStockBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.symbol) {
            [symbols addObject:obj.symbol];
        }
    }];
    NSString *marketStr = [NSString stringWithArray:symbols.copy];
    [self.baseToolManager GETRealtimeQuotes:marketStr success:^(NSDictionary *retinfo) {
        [self.collectionView endHeaderRefreshing];
        NSArray *stockArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"]];
        NSArray *sortedArray = [self _sortModelsWithLocalModels:localModels responseData:stockArray];
        [self _reloadCollectionViewWithArray:sortedArray];
    } error:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self];
        [self.collectionView endHeaderRefreshing];
    }];
}

#pragma mark - private methods
- (void)_reloadCollectionViewWithArray:(NSArray *)dataArray {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:dataArray];
        [self.collectionView reloadData];
        [EVProgressHUD hideHUDForView:self];
    });
}

- (NSArray *)_sortModelsWithLocalModels:(NSArray<EVStockBaseModel *> *)localStocks
                           responseData:(NSArray<EVStockBaseModel *> *)array {
    NSMutableArray<EVStockBaseModel *> *tempArray = @[].mutableCopy;
    [array enumerateObjectsUsingBlock:^(EVStockBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSUInteger i = 0; i < localStocks.count; i++) {
            EVStockBaseModel *model = localStocks[i];
            if ([model.symbol isEqualToString:obj.symbol]) {
                obj.priority = model.priority;
                [tempArray addObject:obj];
            }
        }
    }];
    
    [tempArray sortUsingComparator:^NSComparisonResult(EVStockBaseModel *obj1, EVStockBaseModel *obj2) {
        return [@(obj1.priority) compare:@(obj2.priority)];
    }];
    
    return tempArray.copy;
}

-(void)setEditState:(BOOL)editState
{
    _editState = editState;
    if (_delegate && [_delegate respondsToSelector:@selector(tagView:editState:)]) {
        [_delegate tagView:self editState:_editState];
    }
    [self.collectionView reloadData];
}

-(void)longPressHandler:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPressGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[longPressGesture locationInView:self.collectionView]];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editState) {
    }else
    {
        if (indexPath.section == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(tagView:selectedTag:)]) {
                [_delegate tagView:self selectedTag:indexPath.row];
            }
        }
    }
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    EVStockCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCellId forIndexPath:indexPath];
    
    cell.stockBaseModel = self.dataArray[indexPath.row];
    
    return cell ;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *footer = nil;
    if (kind == UICollectionElementKindSectionFooter) {
       footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footCell" forIndexPath:indexPath];
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake((ScreenWidth-210)/2, 34, 210, 40);
        button.layer.cornerRadius = 4.f;
        button.layer.masksToBounds = YES;
        [footer addSubview:button];
        button.backgroundColor = [UIColor evMainColor];
        [button setTitle:@"编辑" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(editClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
  
    return footer;
}

- (void)editClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonWithSelectedStocks:)]) {
        [self.delegate editButtonWithSelectedStocks:self.dataArray.copy];
    }
}

- (void)refreshClick
{
    [self loadData];
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(refreshButton)]) {
        [self.delegate refreshButton];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    EVStockBaseModel *model = [self.dataArray objectAtIndex:sourceIndexPath.item];
    [_dataArray removeObject:model];
    [_dataArray insertObject:model atIndex:destinationIndexPath.item];
    
    [_dataArray enumerateObjectsUsingBlock:^(EVStockBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.priority = idx;
    }];
    [EVStockBaseModel updateStocksToLocal:_dataArray];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tipLabel.frame)+10, ScreenWidth, EVContentHeight-20) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[EVStockCollectionViewCell class] forCellWithReuseIdentifier:TCellId];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footCell"];
        _collectionView.backgroundColor = [UIColor evBackgroundColor];
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.itemSize =  CGSizeMake((ScreenWidth)/3,100);
        _flowLayout.minimumInteritemSpacing = 0.f;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.footerReferenceSize = CGSizeMake(ScreenWidth, 100);
    }
    return _flowLayout;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.frame = CGRectMake(0, 10, ScreenWidth, 20);
        _tipLabel.backgroundColor = [UIColor colorWithHexString:@"#5c2d7e" alpha:0.3];
        _tipLabel.text = @"  长按拖动单个指数可调整顺序";
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:14.f];
    }
    
    return _tipLabel;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        _refreshButton.frame = CGRectMake(ScreenWidth - 64, ScreenHeight-212, 44, 44);
        [_refreshButton addTarget:self action:@selector(refreshClick) forControlEvents:(UIControlEventTouchUpInside)];
        _refreshButton.backgroundColor = [UIColor blackColor];
        _refreshButton.layer.masksToBounds = YES;
        _refreshButton.layer.cornerRadius = 22;
        _refreshButton.alpha = 0.7;
        [_refreshButton setImage:[UIImage imageNamed:@"hv_refresh_white"] forState:(UIControlStateNormal)];
    }
    return _refreshButton;
}


//- (UIPanGestureRecognizer *)panGesture {
//    if (!_panGesture) {
//        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
//        _panGesture.delegate = self;
//    }
//    return _panGesture;
//}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        _longPressGesture.delegate = self;
    }
    return _longPressGesture;
}

- (void)updateDataArray:(NSMutableArray *)dataArray
{
//    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
//    EVLog(@"self.collectionview----- %@",self.collectionView);
//    [self.collectionView reloadData];
}
- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)removeALL
{
    [self.dataArray removeAllObjects];
}

@end
