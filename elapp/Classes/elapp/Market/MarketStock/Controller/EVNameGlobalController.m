//
//  EVNameGlobalController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/30.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVNameGlobalController.h"
#import "EVSelfGlobalViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"

@interface EVNameGlobalController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UICollectionView *editCollectionView;

@property (nonatomic, weak) UIButton *rightButton;
@property (nonatomic, assign) BOOL status;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@end

@implementation EVNameGlobalController {
    NSMutableArray *_stocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _stocks = [NSMutableArray arrayWithArray:self.selectedStocks];
    [self addUpView];
    [self loadData];
}

- (void)addUpView
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize =  CGSizeMake((ScreenWidth)/3,54);
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0.f;
    UICollectionView *editCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, ScreenHeight-64) collectionViewLayout:flowLayout];
    editCollectionView.delegate = self;
    editCollectionView.dataSource = self;
    [self.view addSubview:editCollectionView];
    self.editCollectionView = editCollectionView;
    self.editCollectionView.backgroundColor = [UIColor evBackgroundColor];
    [self.editCollectionView registerClass:[EVSelfGlobalViewCell  class] forCellWithReuseIdentifier:@"editCell"];
    
    
    
}


//- (void)addRightBarButton
//{
//    UIButton *rightButton = [[UIButton alloc] init];
//    
//    [rightButton setTitle:@"完成" forState:(UIControlStateNormal)];
//    rightButton.frame = CGRectMake(0, 0, rightButton.imageView.image.size.width, rightButton.imageView.image.size.height);
//    self.rightButton = rightButton;
//    [rightButton addTarget:self action:@selector(rightClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
//}
//
//- (void)rightClick:(UIButton *)btn
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    //    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//    //
//    //    [self presentViewController:navighaVC animated:YES completion:nil];
//}

- (void)popBack
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    [self.baseToolManager GETRequestGlobalSuccess:^(NSDictionary *retinfo) {
        NSArray *dataArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"]];
        [self _filterSelectedStock:dataArray];
        [self.dataArray addObjectsFromArray:dataArray];
        [self.editCollectionView reloadData];
    } error:^(NSError *error) {
        
    }];
}

- (void)_filterSelectedStock:(NSArray *)infos {
    if (!infos || infos.count == 0) {
        return;
    }
    
    [infos enumerateObjectsUsingBlock:^(EVStockBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (EVStockBaseModel *model in _stocks) {
            if ([obj.symbol isEqualToString:model.symbol]) {
                obj.status = YES;
            }
        }
    }];
}

- (void)loadStockDataStr:(NSString *)str
{
//    [self.baseToolManager GETRealtimeQuotes:str success:^(NSDictionary *retinfo) {
//        NSArray *collectArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"]];
//        [self.collectArray addObjectsFromArray:collectArray];
//        [self updateSuccessDataAry:self.dataArray collectAry:self.collectArray];
////        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
////        [self.editCollectionView reloadData];
//    } error:^(NSError *error) {
//        
//    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVSelfGlobalViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"editCell" forIndexPath:indexPath];
    
    cell.stockBaseModel = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVSelfGlobalViewCell *cell = (EVSelfGlobalViewCell *)[collectionView  cellForItemAtIndexPath:indexPath];
    
    self.status = self.status ? NO : YES;
    cell.status = cell.stockBaseModel.status ? NO : YES;
    EVStockBaseModel *currentModel = cell.stockBaseModel;
    currentModel.status = cell.status;
    
    if (cell.status) {
        EVStockBaseModel *lastSelectedModel = _stocks.lastObject;
        currentModel.priority = lastSelectedModel.priority + 1;
        [_stocks addObject:currentModel];
        [_stocks enumerateObjectsUsingBlock:^(EVStockBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.priority = idx;
        }];
        [EVStockBaseModel updateStocksToLocal:_stocks];
    }
    else {
        __block EVStockBaseModel *removeModel;
        [_stocks enumerateObjectsUsingBlock:^(EVStockBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.symbol isEqualToString:currentModel.symbol]) {
                removeModel = obj;
            }
        }];
        if ([_stocks containsObject:removeModel]) {
            [_stocks removeObject:removeModel];
        }
        [EVStockBaseModel removeStock:currentModel];
    }
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager  = [[EVBaseToolManager alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
