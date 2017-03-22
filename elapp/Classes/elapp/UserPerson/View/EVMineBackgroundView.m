//
//  EVMineBackgroundView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/19.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMineBackgroundView.h"
#import "EVMineTableViewCell.h"
#import "EVMineTopViewCell.h"
#import "EVUserTagsView.h"
#import "EVUserTagsModel.h"

@interface EVMineBackgroundView ()<UITableViewDelegate,UITableViewDataSource,EVMineTopViewCellDelegate>
@property (nonatomic, strong) NSArray *mineArray;
@property (nonatomic, weak) EVMineTopViewCell *mineCell;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *secondRowArray;
@property (nonatomic, strong) NSArray *secondImageArray;

@end


@implementation EVMineBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    NSArray *firstRowArray = @[@"name"];
    NSLog(@"vip == %d",[EVLoginInfo localObject].vip);
    if ([EVLoginInfo localObject].vip == 0) {
        self.secondRowArray = @[@"我的秘籍",@"我的收藏",@"历史记录"];
        self.secondImageArray = @[@"ic_book",@"ic_collect",@"ic_history"];
    } else {
        self.secondRowArray = @[@"我的直播",@"我的秘籍",@"我的收藏",@"历史记录"];
        self.secondImageArray = @[@"ic_live",@"ic_book",@"ic_collect",@"ic_history"];
    }
    
    NSArray *threeImageArray  = @[@"ic_feedback"];
    NSArray *threeRowArray = @[@"意见反馈"];
    self.mineArray = @[firstRowArray,_secondRowArray,threeRowArray];
    self.imageArray = @[firstRowArray,_secondImageArray,threeImageArray];
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,EVContentHeight+49) style:(UITableViewStyleGrouped)];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    [self addSubview:mineTableView];
    self.mineTableView = mineTableView;
    mineTableView.backgroundColor = [UIColor evBackgroundColor];
    mineTableView.separatorStyle = NO;
    self.mineTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)updateTableViewDatasource {
    NSArray *firstRowArray = @[@"name"];
    NSLog(@"vip == %d",[EVLoginInfo localObject].vip);
    if ([EVLoginInfo localObject].vip == 0) {
        self.secondRowArray = @[@"我的秘籍",@"我的收藏",@"历史记录"];
        self.secondImageArray = @[@"ic_book",@"ic_collect",@"ic_history"];
    } else {
        self.secondRowArray = @[@"我的直播",@"我的秘籍",@"我的收藏",@"历史记录"];
        self.secondImageArray = @[@"ic_live",@"ic_book",@"ic_collect",@"ic_history"];
    }
    NSArray *threeImageArray  = @[@"ic_feedback"];
    NSArray *threeRowArray = @[@"意见反馈"];
    self.mineArray = @[firstRowArray,_secondRowArray,threeRowArray];
    self.imageArray = @[firstRowArray,_secondImageArray,threeImageArray];
    [self.mineTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.mineArray[section];
    return sectionArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mineArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    view.backgroundColor = [UIColor evBackgroundColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 170;
    }
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EVMineTopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
        
        if (!cell) {
            cell = [[EVMineTopViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mineCell"];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ecoin = self.ecoin;
        cell.isSession = self.isSession;
        cell.userModel = self.userModel;
        return cell;
    }
    
    EVMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineCell"];
    if (!cell) {
            cell = [[EVMineTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mineCell"];
    }
    [cell setCellImage:self.imageArray[indexPath.section][indexPath.row] name:self.mineArray[indexPath.section][indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didButtonClickType:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
}

- (void)didClickButtonType:(UIMineClickButtonType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didButtonClickType:)]) {
        [self.delegate didButtonClickType:type];
    }
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    [self.mineTableView reloadData];
}
- (void)setIsSession:(BOOL)isSession
{
    _isSession = isSession;
    [self.mineTableView reloadData];
}

- (void)setEcoin:(NSString *)ecoin
{
    _ecoin = ecoin;
    [self.mineTableView reloadData];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    NSMutableArray *nameAry = [NSMutableArray array];
    for (EVUserTagsModel *model in dataArray) {
        [nameAry addObject:model.tagname];
    }
    EVMineTopViewCell *firstGroupCell = [self.mineTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    firstGroupCell.hvTagLabel.dataArray = nameAry;
}
@end
