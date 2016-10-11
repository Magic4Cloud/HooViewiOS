//
//  EVGroupInfoMemberCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVGroupInfoMemberCell.h"
#import <PureLayout.h>
#import "EVGroupInfoModel.h"
#import "EVHeaderView.h"
#import "EVFriendItem.h"

@interface CCChatGroupMemberCell : UICollectionViewCell

@property (nonatomic,weak) CCHeaderImageView *logoImageView;
@property (nonatomic,strong) EVFriendItem *item;

@end

@implementation CCChatGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    CCHeaderImageView *logoImageView = [[CCHeaderImageView alloc] init];
    [self.contentView addSubview:logoImageView];
    [logoImageView autoPinEdgesToSuperviewEdges];
    self.logoImageView = logoImageView;
}

- (void)setItem:(EVFriendItem *)item
{
    _item = item;
    [self.logoImageView cc_setImageWithURLString:item.logourl isVip:item.vip vipSizeType:CCVipMiddle];
}

@end

@interface EVGroupInfoMemberCell ()

@property ( weak, nonatomic) UICollectionView *memberHeaderCollectionView;
@property ( weak, nonatomic ) UIButton *removeButton;
@property ( strong, nonatomic ) NSLayoutConstraint *addButtonRight;

@property ( weak, nonatomic ) EVHeaderButton *last1Button;
@property ( weak, nonatomic ) EVHeaderButton *last2Button;
@property (assign, nonatomic) BOOL isBigScreen;
@property (assign, nonatomic) NSInteger btnCount;
@property ( strong, nonatomic ) NSMutableArray *buttonArray;  // 所有button数组
@property ( strong, nonatomic ) UIImage *addImage;
@property ( strong, nonatomic ) UIImage *deleteImage;




@end

@implementation EVGroupInfoMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
//        [self setUpSubViews];
        [self setSubButtons];
    }
    return self;
}

- (void)setSubButtons
{
    self.titleLabelHorizontal.constant = - 25.f;
    // 所有按钮的容器
    UIView *btnContanerView = [[UIView alloc] init];
    [self.contentView addSubview:btnContanerView];
    [btnContanerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30.f];
    [btnContanerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel];
    [btnContanerView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [btnContanerView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    // 按钮的个数
    NSInteger btnCount = self.isBigScreen ? 6 : 5;
    self.btnCount = btnCount;
    // 标记左边的视图
    UIView *leftView;
    NSMutableArray *buttonArray = [NSMutableArray arrayWithCapacity:btnCount];
    for (int i = 0; i < btnCount; i ++)
    {
        UIView *bgView = [[UIView alloc] init];
        [btnContanerView addSubview:bgView];
        if ( i == 0 )
        {
            [bgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        }
        else
        {
            [bgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:leftView];
        }
        [bgView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:btnContanerView withMultiplier:1.0 / btnCount];
        [bgView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [bgView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        leftView = bgView; // 标记左侧视图为当前视图
        
        // 按钮宽度
        CGFloat width = 42.f;
        EVHeaderButton *button = [EVHeaderButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:button];
        [button autoCenterInSuperview];
        [button autoSetDimensionsToSize:CGSizeMake(width, width)];
        button.hidden = YES;
        if ( i == btnCount - 2 )
        {
            self.last2Button = button;
        }
        if ( i == btnCount - 1 )
        {
            self.last1Button = button;
        }
        [buttonArray addObject:button];
        self.buttonArray = buttonArray;
        // 按钮添加点击事件
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (BOOL)isBigScreen
{
    return ScreenWidth > 321.f;
}

- (void)setMemberStyle:(CCGroupInfoMemberCellStyle)memberStyle
{
    [super setMemberStyle:memberStyle];
    if ( memberStyle == CCGroupInfoMemberCellStyleMember )
    {
        self.removeButton.hidden = YES;
        self.addButtonRight.constant = 40;
    }
    else
    {
        self.removeButton.hidden = NO;
        self.addButtonRight.constant = - 10;
    }
}

- (void)setCellItem:(EVGroupInfoModel *)cellItem
{
    [super setCellItem:cellItem];
    self.memberStyle = cellItem.isOwner ? CCGroupInfoMemberCellStyleOwner : CCGroupInfoMemberCellStyleMember;
    // 1.是群主 带减号-------------------------------------
    if ( self.memberStyle == CCGroupInfoMemberCellStyleOwner )
    {
        NSInteger count = MIN(cellItem.members.count + 2, self.btnCount);
        // 其他按钮为成员头像
        for (int i = 0; i < _btnCount; i ++)
        {
            EVHeaderButton *button = self.buttonArray[i];
            // 清空button的图片
            [button setImage:nil forState:UIControlStateNormal];
            [button cc_setBackgroundImageURL:nil placeholderImageStr:nil isVip:NO vipSizeType:CCVipMiddle complete:nil];
            // 大于count - 1的按钮隐藏
            button.hidden = i > count - 1;
            
            if ( i < count - 2 )
            {
                EVFriendItem *item = cellItem.members[i];
                [button cc_setBackgroundImageURL:item.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:item.vip vipSizeType:CCVipMiddle];
            }
            // 最后两个按钮单独设置
            if ( i == count - 2 )
            {
                [button setImage:self.addImage forState:UIControlStateNormal];
            }
            if ( i == count - 1 )
            {
                [button setImage:self.deleteImage forState:UIControlStateNormal];
            }
        }
    }
    // 2. 如果不是群主 不显示加号
    if ( self.memberStyle == CCGroupInfoMemberCellStyleMember )
    {
        NSInteger count = MIN(cellItem.members.count + 1, self.btnCount);
        // 其他按钮为成员头像
        for (int i = 0; i < _btnCount; i ++)
        {
            EVHeaderButton *button = self.buttonArray[i];
            // 清空button的图片
            [button setImage:nil forState:UIControlStateNormal];
            [button cc_setBackgroundImageURL:nil placeholderImageStr:nil isVip:NO vipSizeType:CCVipMiddle complete:nil];
            // 大于count - 1的按钮隐藏
            button.hidden = i > count - 1;
            
            if ( i < count - 1 )
            {
                EVFriendItem *item = cellItem.members[i];
                [button cc_setBackgroundImageURL:item.logourl placeholderImage:[UIImage imageNamed:@"avatar"] isVip:item.vip vipSizeType:CCVipMiddle];
            }
            // 最后一个按钮单独设置
            if ( i == count - 1 )
            {
                [button setImage:self.addImage forState:UIControlStateNormal];
            }
        }
    }
    
}

- (UIImage *)addImage
{
    if ( _addImage == nil )
    {
        _addImage = [UIImage imageNamed:@"message_add_people"];
    }
    return _addImage;
}

- (UIImage *)deleteImage
{
    if ( _deleteImage == nil )
    {
        _deleteImage = [UIImage imageNamed:@"message_delect_people"];
    }
    return _deleteImage;
}

- (void)didClickButton:(EVHeaderButton *)button
{
    if ( [[button imageForState:UIControlStateNormal] isEqual:self.deleteImage] )
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(groupInfoMemberCell:didClickRemoveButton:)] )
        {
            [self.delegate groupInfoMemberCell:self didClickRemoveButton:button];
        }
    }
    if ( [[button imageForState:UIControlStateNormal] isEqual:self.addImage] )
    {
        if ( self.delegate && [self.delegate respondsToSelector:@selector(groupInfoMemberCell:didClickAddButton:)] )
        {
            [self.delegate groupInfoMemberCell:self didClickAddButton:button];
        }
    }
}


@end
