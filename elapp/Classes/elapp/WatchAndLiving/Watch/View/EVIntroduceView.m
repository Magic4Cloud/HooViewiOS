//
//  EVIntroduceView.m
//  elapp
//
//  Created by 周恒 on 2017/5/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVIntroduceView.h"
#import "EVShopLiveCell.h"
#import "EVHVWatchViewController.h"
#import "EVIntroduceTableViewCell.h"
#import "EVBaseToolManager+EVHomeAPI.h"



@interface EVIntroduceView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *introTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@end

@implementation EVIntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
        
        WEAK(self);
        [self.introTableView addRefreshHeaderWithRefreshingBlock:^{
            [weakself loadTopicVideoDataWithTopicId:weakself.watchVideoInfo.vid start:0 count:20];
        }];
        [self.introTableView addRefreshFooterWithRefreshingBlock:^{
            [weakself loadTopicVideoDataWithTopicId:weakself.watchVideoInfo.vid start:weakself.start count:20];
        }];
        [self.introTableView startHeaderRefreshing];
        [self.introTableView hideFooter];

    }
    return self;
}

//获取热门数据
- (void)loadTopicVideoDataWithTopicId:(NSString *)topicId
                                start:(NSInteger)start
                                count:(NSInteger)count
{
    __weak typeof(self) weakself = self;
    [self.baseToolManager GETRecommendVideolistStart:start count:count topicid:topicId start:^{
        
    } fail:^(NSError *error) {
        [self endRefreshing];
        [EVProgressHUD showError:@"请求错误"];
    } success:^(NSDictionary *videoInfo) {
        [self endRefreshing];
//        self.start = [videoInfo[@"start"] integerValue];
//        self.start = [videoInfo[@"next"] integerValue];
      
        [self.introTableView reloadData];
        
        NSArray *array = (NSArray *)videoInfo;
        
        if (array && array.count>0) {
            __weak typeof(self) weakSelf = self;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                EVVideoAndLiveModel * livemodel = [EVVideoAndLiveModel yy_modelWithDictionary:obj];
                [weakSelf.dataArray addObject:livemodel];
                [self.introTableView reloadData];
            }];
        }
        
        [self.introTableView showFooter];
        [self.introTableView setFooterState:(array.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    } sessionExpired:^{
        EVRelogin(weakself);
    }];
}

- (void)endRefreshing
{
    [self.introTableView endHeaderRefreshing];
    [self.introTableView endFooterRefreshing];
}


- (void)addUpViewFrame:(CGRect)frame
{
    UITableView *introTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height - 49) style:(UITableViewStyleGrouped)];
    introTableView.delegate = self;
    introTableView.dataSource = self;
    [self addSubview:introTableView];
    introTableView.backgroundColor = [UIColor evBackgroundColor];
    introTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _introTableView = introTableView;
    
    [self.introTableView registerNib:[UINib nibWithNibName:@"EVShopLiveCell" bundle:nil] forCellReuseIdentifier:@"EVShopLiveCell"];
    [self.introTableView registerNib:[UINib nibWithNibName:@"EVIntroduceTableViewCell" bundle:nil] forCellReuseIdentifier:@"EVIntroduceTableViewCell"];
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString * identifer = @"EVIntroduceTableViewCell";
        EVIntroduceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        cell.contentLabel.text = _watchVideoInfo.descriptionStr;
        return cell;
    }
    static NSString * identifer = @"EVShopLiveCell";
    EVShopLiveCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.liveModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    {
        if (indexPath.section == 0) {
            if (_watchVideoInfo.descriptionStr.length == 0) {
                return 15;
            }
            NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
            CGSize nameSize = [_watchVideoInfo.descriptionStr boundingRectWithSize:CGSizeMake(ScreenWidth - 25, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
            return nameSize.height+30;
            
        } else {
            return 100;
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSArray *titleArray = @[@" 热门推荐",@" 相关视频"];
    NSArray *imageArray = @[@"hv_recommend_n",@"hv_list_live"];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
    [backView addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *imageButton = [[UIButton alloc] init];
    [contentView addSubview:imageButton];
    [imageButton setImage:[UIImage imageNamed:imageArray[section]] forState:(UIControlStateNormal)];
    [imageButton setTitle:titleArray[section] forState:(UIControlStateNormal)];
    [imageButton setTitleColor:[UIColor evTextColorH2] forState:(UIControlStateNormal)];
    imageButton.titleLabel.font = [UIFont textFontB2];
    imageButton.frame = CGRectMake(16, 9, 100, 22);
    imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (section == 0) {
        backView.hidden = YES;
    }
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    } else {
        return 40;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EVLog(@"简介");
        return;
    }
    
    EVVideoAndLiveModel * videoAndLiveModel = self.dataArray[indexPath.row];
    EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
    watchViewVC.videoAndLiveModel = videoAndLiveModel;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
    [[self viewController] presentViewController:nav animated:YES completion:nil];
}



- (UIViewController*)viewController {
    for (UIView* next = [self superview];
         next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                         class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
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
    if (!_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}




@end
