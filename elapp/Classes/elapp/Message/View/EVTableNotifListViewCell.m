//
//  EVTableNotifListViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVTableNotifListViewCell.h"
#import "EVNotifyList.h"
#import <PureLayout.h>
#import "NSString+Extension.h"
#import "UIView+Extension.h"

@interface EVTableNotifListViewCell ()
/**消息事件*/
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
/**消息内容*/
@property (weak, nonatomic) IBOutlet UILabel *contentText;
/**消息的背景图片*/
@property (weak, nonatomic)  UIImageView *contentImagebg;//text的背景图片
/**消息的头像*/
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeadingToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTrailingToLabelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTrailingToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelTopToSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TimeLabelToLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelBottomToIocnBottom;


@end

@implementation EVTableNotifListViewCell
//约束
- (void)awakeFromNib{
    CGFloat margin = 13;
    UIImageView *contentImagebg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_dialog"]];
    
    [self.contentView insertSubview:contentImagebg belowSubview:self.contentText];
    self.contentImagebg = contentImagebg;
    [contentImagebg autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentText withOffset:-margin * 2];

    
    [contentImagebg autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentText withOffset:margin];
    [contentImagebg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentText withOffset:-margin - 4];
    
    [contentImagebg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentText withOffset:margin * 2];
    self.contentText.textColor = [UIColor colorWithHexString:@"#222222" alpha:1.0];
    [self.iconImageView setRoundCorner];
    self.contentView.backgroundColor = CCBackgroundColor;
    
    self.contentText.userInteractionEnabled = YES;
}

/**赋值*/
-(void)setCellItem:(EVNotifyList *)cellItem
{
    if (_cellItem != cellItem)
    {
        _cellItem = cellItem;
    }
    NSString *stampFormat = @"MM/dd  HH:mm";
    self.updateTime.text = [self.cellItem.create_time translateDateToForm:stampFormat];
    self.contentText.text = self.cellItem.content;
//    self.contentText.text = @"lsjdljaljd大道将垃圾分\n类\n啊\n都\n发来的设计方腊时间都分了就爱上了对方将拉开数据东方科技阿克苏的减肥了卡斯交电费卡就是到了福建按数量可点击法拉盛";
}

- (void)setIconURL:(NSString *)iconURL {
    if (![_iconURL isEqualToString:iconURL])
    {
        _iconURL = [iconURL copy];
        [self.iconImageView cc_setImageWithURLString:self.iconURL placeholderImageName:@"system_message"];
    }
}




+ (CGFloat)cellHeightForCellItem:(EVNotifyList *)cellItem
{
    NSString *text = cellItem.content;
    
    //  计算label的宽度
    CGFloat iconLeft = 14.;
    CGFloat iconWidth = 40.;
    CGFloat iconToLabel = 27.;
    CGFloat LabelRight = 43;
    CGFloat labelWith = ScreenWidth - (iconLeft + iconWidth + iconToLabel + LabelRight);

    CGRect rect = [text boundingRectWithSize:CGSizeMake(labelWith, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:NULL];
    CGFloat labelHeight = rect.size.height;
    
    //  计算cell高度
    CGFloat timeLabelTop = 17.;
    CGFloat timeLabelHeight = 11.;
    CGFloat timeLabelToLabel = 20.;
    CGFloat cellHeight = timeLabelTop + timeLabelHeight + timeLabelToLabel + labelHeight + 28.;
    return cellHeight;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}


@end
