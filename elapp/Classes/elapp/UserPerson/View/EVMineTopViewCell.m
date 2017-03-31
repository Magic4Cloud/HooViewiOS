 //
//  EVMineTopViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVMineTopViewCell.h"
#import "EVLineView.h"
#import "EVNickNameAndLevelView.h"
#import "EVMineBottomViewCell.h"
#import "UIButton+Extension.h"
#import "NSString+Extension.h"
#import "EVHVHeadButton.h"
#import "EVHVTagLabel.h"
#import "EVUserTagsView.h"

@interface EVMineTopViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) EVHVHeadButton *headImageView;

@property (nonatomic, weak) UIButton *editButton;

@property (nonatomic, weak) EVNickNameAndLevelView *nameLevelView;

@property (nonatomic, weak) UICollectionView *bottomCollectionView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, weak) UILabel *notLoginLabel;

@property (nonatomic, weak) UILabel *aboutLabel;



@property (nonatomic, assign) NSInteger unreadInteger;



@end

@implementation EVMineTopViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addUpView];
            [EVNotificationCenter addObserver:self selector:@selector(receiveShouldUpdateUnread:) name:EVShouldUpdateNotifyUnread object:nil];
    }
    return self;
}

- (void)addUpView
{
    
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];

    self.titleArray = [NSMutableArray arrayWithObjects:@"消息提醒",@"我的粉丝",@"我的关注",@"我的余额", nil];
    EVHVHeadButton *headImageView = [[EVHVHeadButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    headImageView.headImageFrame = headImageView.bounds;
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    [headImageView.headImageView addTarget:self action:@selector(headImageViewClick) forControlEvents:(UIControlEventTouchUpInside)];
    [headImageView.headImageView cc_setImageURL:loginInfo.logourl forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    EVNickNameAndLevelView *nameLevelView = [[EVNickNameAndLevelView alloc] init];
    nameLevelView.frame = CGRectMake(CGRectGetMaxX(headImageView.frame)+10, 10, ScreenWidth - headImageView.frame.size.width, 30);
    [self addSubview:nameLevelView];
    self.nameLevelView = nameLevelView;
    nameLevelView.nickNameLabel.text = loginInfo.nickname;
    
    UILabel *aboutLabel = [[UILabel alloc] init];
    [self addSubview:aboutLabel];
    self.aboutLabel = aboutLabel;
    aboutLabel.textColor = [UIColor evTextColorH2];
    aboutLabel.font = [UIFont textFontB3];
    [aboutLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLevelView withOffset:4];
    [aboutLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nameLevelView];
    [aboutLabel autoSetDimensionsToSize:CGSizeMake(150, 20)];
    
    EVUserTagsView *hvTagLabel = [[EVUserTagsView alloc] init];
    [self addSubview:hvTagLabel];
    self.hvTagLabel = hvTagLabel;
    [hvTagLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:aboutLabel withOffset:8];
    [hvTagLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nameLevelView];
    [hvTagLabel autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 80, 20)];
    
    
    UILabel *notloginLabel = [[UILabel alloc] init];
    [self addSubview:notloginLabel];
    self.notLoginLabel = notloginLabel;
    notloginLabel.textColor = [UIColor evTextColorH2];
    notloginLabel.font = [UIFont systemFontOfSize:16.f];
    notloginLabel.text = @"登录/注册";
    [notloginLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headImageView];
    [notloginLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:24];
    [notloginLabel autoSetDimensionsToSize:CGSizeMake(100, 22) ];
    
    
    
    UIButton *editButton = [[UIButton alloc] init];
    [self addSubview:editButton];
    self.editButton = editButton;
    editButton.backgroundColor = [UIColor clearColor];
    [editButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [editButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [editButton autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 110)];
    UIImage * buttonImage = [UIImage imageNamed:@"btn_next_n"];
    [editButton setImage:buttonImage forState:(UIControlStateNormal)];
    [editButton setImageEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth/2-buttonImage.size.width-15), 0, -(ScreenWidth/2-buttonImage.size.width-15))];
    [editButton addTarget:self action:@selector(editButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenWidth/4, 50);
    flowLayout.minimumLineSpacing = 1;
    UICollectionView *bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 110, ScreenWidth,60) collectionViewLayout:flowLayout];
    bottomCollectionView.delegate = self;
    bottomCollectionView.dataSource = self;
    [self addSubview:bottomCollectionView];
    bottomCollectionView.scrollEnabled = NO;
    bottomCollectionView.backgroundColor = [UIColor whiteColor];
    [bottomCollectionView registerClass:[EVMineBottomViewCell class] forCellWithReuseIdentifier:@"bottomCell"];
    self.bottomCollectionView = bottomCollectionView;
    [EVLineView addTopLineToView:bottomCollectionView];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    lineView.backgroundColor = [UIColor evLineColor];
    [self.bottomCollectionView addSubview:lineView];
    
}

- (void)receiveShouldUpdateUnread:(NSNotification *)notification
{
    NSString *unreadStr = [notification object];
    self.unreadInteger= [unreadStr integerValue];
    [self.bottomCollectionView reloadData];
}


#pragma - delegate/datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVMineBottomViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottomCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLabel.text = self.titleArray[indexPath.row];
    cell.userModel = self.userModel;
    cell.unreadCount = self.unreadInteger;
    if (indexPath.row == 0) {
       
        cell.topImageView.hidden = NO;
        cell.moneyLabel.hidden = YES;
    }else {
        cell.topImageView.hidden = YES;
        cell.moneyLabel.hidden = NO;
     
    }
    cell.separateLineView.hidden = NO;
    if (indexPath.row == 3) {
         cell.moneyLabel.text = [NSString shortNumber:[self.ecoin integerValue]];
        cell.separateLineView.hidden = YES;
    }else if(indexPath.row == 2){
        cell.moneyLabel.text = [NSString shortNumber:self.userModel.follow_count];
        
        
    }else if (indexPath.row == 1) {
        cell.moneyLabel.text = [NSString shortNumber:self.userModel.fans_count];
    }
    return cell;
}

- (void)headImageViewClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonType:)]) {
        [self.delegate didClickButtonType:UIMineClickButtonTypeHeadImage];
    }
}

- (void)editButtonClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonType:)]) {
        [self.delegate didClickButtonType:UIMineClickButtonTypeEditMsg];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickButtonType:)]) {
        switch (indexPath.row) {
            case 0:
                [self.delegate didClickButtonType:UIMineClickButtonTypeRemindMsg];
                self.unreadInteger = 0;
                [self.bottomCollectionView reloadData];
                break;
            case 1:
                [self.delegate didClickButtonType:UIMineClickButtonTypeMyLive];
                break;
            case 2:
                [self.delegate didClickButtonType:UIMineClickButtonTypeMyNews];
                break;
            case 3:
                [self.delegate didClickButtonType:UIMineClickButtonTypeMyCoin];
                break;
            default:
                break;
        }
    }
}

- (void)setEcoin:(NSString *)ecoin
{
    _ecoin = ecoin;
    [self.bottomCollectionView reloadData];
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    if ([userModel.logourl isEqualToString:@""] || userModel.logourl == nil || userModel.vip == 0) {
        self.headImageView.vipImageView.hidden = YES;
    }else {
        self.headImageView.vipImageView.hidden = NO;
    }
    [self.headImageView.headImageView cc_setImageURL:userModel.logourl forState:(UIControlStateNormal) placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    self.nameLevelView.nickNameLabel.text = userModel.nickname;
    self.aboutLabel.text = userModel.signature;
    
}


- (void)setIsSession:(BOOL)isSession
{
    _isSession = isSession;
    if (isSession) {
        self.nameLevelView.hidden = NO;
        self.aboutLabel.hidden = NO;
        self.hvTagLabel.hidden = NO;
        self.notLoginLabel.hidden = YES;
        self.editButton.hidden = NO;
    }else {
        self.nameLevelView.hidden = YES;
        self.aboutLabel.hidden = YES;
        self.hvTagLabel.hidden = YES;
        self.notLoginLabel.hidden = NO;
        self.editButton.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
