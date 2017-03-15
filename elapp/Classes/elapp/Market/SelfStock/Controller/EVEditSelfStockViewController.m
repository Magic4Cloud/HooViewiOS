//
//  EVEditSelfStockViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVEditSelfStockViewController.h"
#import <PureLayout.h>
#import "JXMovableCellTableView.h"
#import "EVEditTableViewCell.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"
#import "EVNotOpenView.h"
#import "EVSearchStockViewController.h"
#import "EVLoginInfo.h"
#import "NSString+Extension.h"

@interface EVEditSelfStockViewController ()<JXMovableCellTableViewDataSource,JXMovableCellTableViewDelegate,EVEditTableViewDelegate>

@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) JXMovableCellTableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *chooseMarketPath;

@property (nonatomic, strong) NSMutableArray *chooseArray;
@end


@implementation EVEditSelfStockViewController

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self addUpTableView];
    [self addRightBarItem];
    [self loadData];
}

- (void)addUpTableView
{
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor colorWithHexString:@"#5c2d7e" alpha:0.3];
    [self.view addSubview:tipLabel];
    tipLabel.font = [UIFont systemFontOfSize:14.f];
    tipLabel.text = [NSString stringWithFormat:@"  长按拖动排列顺序"];
    tipLabel.textColor = [UIColor whiteColor];
    [tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [tipLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    self.tipLabel = tipLabel;
    
//    EVNotOpenView *twoView = [[EVNotOpenView alloc] init];
//    twoView.frame =  CGRectMake(0 , 0, ScreenWidth, EVContentHeight -10);
//    [self.view addSubview:twoView];
    
    UIView *tableBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    tableBottomView.backgroundColor = [UIColor evBackgroundColor];
    UIButton *addButton = [[UIButton alloc] init];
    addButton.frame = CGRectMake(ScreenWidth/2 - (210 /2 ), 36, 210, 40);
    [tableBottomView addSubview:addButton];
    addButton.backgroundColor = [UIColor evMainColor];
    [addButton setTitle:@"添加自选" forState:(UIControlStateNormal)];
    [addButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    JXMovableCellTableView *mainTableView = [[JXMovableCellTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    [self.view addSubview:mainTableView];
    self.mainTableView = mainTableView;
    mainTableView.gestureMinimumPressDuration = 1.0f;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipLabel];
    [mainTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    mainTableView.backgroundColor = [UIColor evBackgroundColor];
    [mainTableView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 20 - 64)];
    
    mainTableView.tableFooterView = tableBottomView;
    
    mainTableView.drawMovalbeCellBlock = ^ (UIView *moveCell) {
        moveCell.layer.shadowColor = [UIColor grayColor].CGColor;
        moveCell.layer.masksToBounds = NO;
        moveCell.layer.cornerRadius = 0;
        moveCell.layer.shadowOffset = CGSizeMake(-5, 0);
        moveCell.layer.shadowOpacity = 0.4;
        moveCell.layer.shadowRadius = 5;
    };
    
}

- (void)addRightBarItem
{
    // 右上角完成按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"完成"] style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor evMainColor],NSFontAttributeName:[UIFont systemFontOfSize:16.f]} forState:(UIControlStateNormal)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)addButtonClick:(UIButton *)btn
{
    EVLog(@"添加自选");
    EVSearchStockViewController *searchStockVC = [[EVSearchStockViewController alloc] init];
    [searchStockVC setAddStockBlock:^(NSString *symbol) {
        if (!symbol || symbol.length == 0) {
            return ;
        }
        
        [self.chooseArray addObject:symbol];
        [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
        [self loadData];
    }];
    [self.navigationController pushViewController:searchStockVC animated:YES];
}

- (void)popBack
{
    [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
    [EVNotificationCenter postNotificationName:@"chooseMarketCommit" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commit
{
    EVLog(@"完成");
    if (self.commitBlock) {
        self.commitBlock();
    }
    [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
    [EVNotificationCenter postNotificationName:@"chooseMarketCommit" object:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}

#pragma mark - *********** Delegate/DataSource 💍 ***********
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVEditTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"editCell"] ;
    if (!cell) {
        cell = [[EVEditTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"editCell"];
    }
    cell.delegate = self;
    cell.stockBaseModel = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return EVBaseCellHeight;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];
    
    EVStockBaseModel  *object = [self.dataArray objectAtIndex:fromRow];
    [self.dataArray removeObjectAtIndex:fromRow];
    [self.dataArray insertObject:object atIndex:toRow];
 
    EVLog(@"%@ ---------- %@",sourceIndexPath,destinationIndexPath);
}

- (NSArray *)dataSourceArrayInTableView:(JXMovableCellTableView *)tableView
{
    return _dataArray.copy;
}

- (void)deleteTableCell:(EVEditTableViewCell *)cell model:(EVStockBaseModel *)model
{
    
    [self.dataArray removeObject:model];
    [self.mainTableView reloadData];
    [self.chooseArray removeObject:model.symbol];
    [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
    [self.baseToolManager GETUserCollectType:EVCollectTypeStock code:model.symbol action:2 start:^{
        
    } fail:^(NSError *error) {
        
    } success:^(NSDictionary *retinfo) {
        [EVProgressHUD showSuccess:@"删除成功"];
    } sessionExpire:^{
        
    }];
}

- (void)tableView:(JXMovableCellTableView *)tableView newDataSourceArrayAfterMove:(NSArray *)newDataSourceArray
{
    _dataArray = newDataSourceArray.mutableCopy;
    [self.chooseArray removeAllObjects];
  
    for (EVStockBaseModel *baseModel in newDataSourceArray) {
        [self.chooseArray addObject:baseModel.symbol];
    }
   
    
}

- (void)loadData
{
    self.chooseArray = [NSMutableArray arrayWithContentsOfFile:[self storyFilePath]];
    if (self.chooseArray.count <= 0) {
        [self.baseToolManager GETUserCollectListType:EVCollectTypeStock start:^{
            
        } fail:^(NSError *error) {
            [EVProgressHUD showError:@"加载错误"];
        } success:^(NSDictionary *retinfo) {
            [EVProgressHUD showSuccess:@"加载成功"];
            NSArray *marketStr = [retinfo[@"collectlist"] componentsSeparatedByString:@","];
            [self.chooseArray addObjectsFromArray:marketStr];
            [self.chooseArray writeToFile:[self storyFilePath] atomically:YES];
            [self loadStockDataStr:retinfo[@"collectlist"]];
        } sessionExpire:^{
            [EVProgressHUD showError:@"没有登录"];
        }];
    }else {
        NSString *market = [NSString stringWithArray:self.chooseArray];
        [self loadStockDataStr:market];
    }
    
}

- (void)loadStockDataStr:(NSString *)str
{
    [self.baseToolManager GETRealtimeQuotes:str success:^(NSDictionary *retinfo) {
        NSArray *dataArray = [EVStockBaseModel objectWithDictionaryArray:retinfo[@"data"]];
        self.dataArray = [NSMutableArray arrayWithArray:dataArray];
        [self.mainTableView reloadData];
    } error:^(NSError *error) {
        
    }];
}
#pragma mark - ***********     Lazy Loads 💤      ***********
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)storyFilePath
{
    if ( _chooseMarketPath == nil )
    {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *userMarksDirPath = [cachePath stringByAppendingPathComponent:@"chooseMarketPath"];
        NSString *currentPath = [NSString stringWithFormat:@"chooseMarketPath_%@",[EVLoginInfo localObject].name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userMarksDirPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:userMarksDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _chooseMarketPath = [userMarksDirPath stringByAppendingPathComponent:currentPath];
    }
    return _chooseMarketPath;
}

- (NSMutableArray *)chooseArray
{
    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
    }
    return _chooseArray;
}
- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
        
    }
    return _baseToolManager;
}

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
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
