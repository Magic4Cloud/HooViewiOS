//
//  EVNotifyViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

//

#import "EVNotifyViewCell.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "UIView+Extension.h"

#import "EVEaseMob.h"
#import "NSDateFormatter+Category.h"
#import "EVChatMessageManager.h"

@interface EVNotifyViewCell ()
/**消息头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/**昵称*/
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
/**消息标题*/
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/**消息时间*/
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) UIImageView *sendFailImgView;

@property ( weak, nonatomic ) UIImageView *ownerMarkView;

@property (assign, nonatomic) BOOL iconSuccess;


@end

@implementation EVNotifyViewCell

+ (instancetype)notifyViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EVNotifyViewCell" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    [self.contentView addSubview:line];
    [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [line autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
    
    RKNotificationHub* hub = [[RKNotificationHub alloc] initWithView:self];
    self.hub = hub;
    [hub setCircleAtFrame:CGRectMake(44, 10, 16, 16)];
    hub.countLabelFont = [UIFont systemFontOfSize:12];
    [hub setCircleColor:[UIColor colorWithHexString:@"#fb6655"] labelColor:[UIColor whiteColor]];
    
    UIImageView *sendFailImgView = [[UIImageView alloc] init];
    [self.titleLable addSubview:sendFailImgView];
    sendFailImgView.image = [UIImage imageNamed:@"chatroom_send_fail"];
    sendFailImgView.frame = CGRectMake(0, 0, 2.5, 13.5);
    sendFailImgView.hidden = YES;
    self.sendFailImgView = sendFailImgView;
    
    UIImageView *ownerMarkView = [[UIImageView alloc] init];
    [self.contentView addSubview:ownerMarkView];
    [ownerMarkView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.f];
    [ownerMarkView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.nicknameLabel];
    ownerMarkView.image = [UIImage imageNamed:@"message_main_people"];
    self.ownerMarkView = ownerMarkView;
    ownerMarkView.hidden = YES;
    
    self.iconSuccess = NO;
    
}

- (void)setContantLabelFont:(UIFont *)contantLabelFont
{
    _contantLabelFont = contantLabelFont;
    if (_contantLabelFont) {
        self.titleLable.font = contantLabelFont;
    }
}

/**给模型赋值*/
- (void)setCellItem:(EVNotifyItem *)cellItem{

    _cellItem = cellItem;
    
    NSString *placeHolder = nil;
    if ([UIImage imageNamed:cellItem.icon]) {
        placeHolder = cellItem.icon;
    }
    else
    {
        placeHolder = kUserLogoPlaceHolder;
    }
    [self.iconImage cc_setImageWithURLString:self.cellItem.icon placeholderImageName:placeHolder];
    [self.iconImage setRoundCorner];
    
    self.nicknameLabel.text = self.cellItem.title;
    
    self.sendFailImgView.hidden = !cellItem.send_fail;
    if ( cellItem.send_fail )
    {
        NSString *contentStr = [NSString stringWithFormat:@"  %@",self.cellItem.content];
        [self.titleLable cc_setEmotionWithText:contentStr];
    }
    else
    {
        if ( [self.cellItem.content isKindOfClass:[NSString class]] )
        {
            [self.titleLable cc_setEmotionWithText:self.cellItem.content];
        }
    }
    
    NSDate *date = [[NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"]dateFromString:cellItem.update_time];
    NSString *stampFormat = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:stampFormat];
    NSString *theDay = [dateFormatter stringFromDate:date];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay])
    {
        stampFormat = @"HH:mm";
    }
    else
    {
        stampFormat = @"yy-MM-dd";
    }
    self.timeLable.text = [self.cellItem.update_time translateDateToForm:stampFormat];
    if ( cellItem.unread >= 0 )
    {
        [self.hub setCount:cellItem.unread];
    }

}


- (void)setGroupItem:(EVGroupItem *)groupItem
{
    _groupItem = groupItem;
    [self.iconImage cc_setImageWithURLString:@"" placeholderImage:[UIImage imageNamed:@"message_my_group"]];
    [self requestForIconWithGroupItem:groupItem];
    [self.iconImage setRoundCorner];
    self.nicknameLabel.text = groupItem.subject;
    NSMutableAttributedString *attrText = nil;
    if ( _groupItem.lastMessage == nil )
    {
        _groupItem.lastMessage = @"";
    }
    attrText = [[NSMutableAttributedString alloc] initWithString:_groupItem.lastMessage];
    
    if ( groupItem.isAtMessage )
    {
        NSAttributedString *atString = [[NSAttributedString alloc] initWithString:@"[有人@我] " attributes:@{NSForegroundColorAttributeName : CCAppMainColor}];
        if ( _groupItem.firstAtMessage )
        {
            attrText = [[NSMutableAttributedString alloc] initWithString:_groupItem.firstAtMessage];
            [attrText insertAttributedString:atString atIndex:0];
        }
    }
    else if ( groupItem.isRedEnvelope )
    {
        [attrText replaceCharactersInRange:NSMakeRange(0, attrText.length) withString:@"[红包]"];
    }
    self.titleLable.attributedText = attrText;
    self.timeLable.text = groupItem.time;
    if ( groupItem.unread >= 0 )
    {
        [self.hub setCount:groupItem.unread];
    }
}


- (void)requestForIconWithGroupItem:(EVGroupItem *)groupItem
{
    __weak typeof(self) weakSelf = self;
    [[EVChatMessageManager shareInstance] iconForGroupId:groupItem.ID completion:^(NSString *logourl) {
        [weakSelf.iconImage cc_setImageWithURLString:logourl placeholderImage:[UIImage imageNamed:@"message_my_group"]];
        BOOL isOwner = [[EVEaseMob cc_shareInstance].currentUserName isEqualToString:groupItem.owner];
        self.timeLable.hidden = isOwner;
        self.ownerMarkView.hidden = !isOwner;
        self.iconSuccess = YES;
    }];
}

/**返回cell的高度*/
- (CGFloat)cellHeight{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return self.frame.size.height;
}

@end
