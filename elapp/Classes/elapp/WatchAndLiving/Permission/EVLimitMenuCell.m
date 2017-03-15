//
//  EVLimitMenuCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLimitMenuCell.h"
#import <PureLayout.h>

#define kAnimationTime 0.2

@implementation CCLimitMenuCellItem

@end

@interface EVLimitMenuCell ()

@property (weak, nonatomic) IBOutlet UIImageView *privateImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *indecateImageView;

@property (nonatomic, weak) UIView *seperateLine;

@property (nonatomic, weak) UIImageView *rightIconImageView;        /**< 右侧提示的Image */
@property (nonatomic, weak) UILabel     *rightTextLab;              /**< 右侧提示的Text */

@end

@implementation EVLimitMenuCell

- (void)awakeFromNib
{
//    self.privateButton.layer.cornerRadius = 4;
//    self.privateButton.layer.borderWidth = 1;
//    self.privateButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    UIView *seperateLine = [[UIView alloc] init];
    seperateLine.backgroundColor = [UIColor evGlobalSeparatorColor];
    [self.contentView addSubview:seperateLine];
    self.seperateLine = seperateLine;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *rightText = [UILabel new];
    rightText.font      = [UIFont systemFontOfSize:13];
    rightText.textColor = [UIColor colorWithHexString:@"#bbbbbb"];
    [self.contentView addSubview:rightText];
    [rightText autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [rightText autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    self.rightTextLab = rightText;
    
    UIImageView *rightIcon = [UIImageView new];
    [self.contentView addSubview:rightIcon];
    [rightIcon autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:rightText];
    [rightIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [rightIcon autoSetDimensionsToSize:CGSizeMake(15.f, 15.f)];
    self.rightIconImageView = rightIcon;
    
}

- (void)setMenuCellItem:(CCLimitMenuCellItem *)menuCellItem{
    if ( _menuCellItem.hasIndecator  ) {
        [self rotateIndecateImageView:menuCellItem.extend];
    }
    _menuCellItem = menuCellItem;
    self.privateImageView.hidden   = !menuCellItem.selected;
    self.titleLabel.text           = menuCellItem.title;
    self.descriptionLabel.text     = menuCellItem.cellDescription;
    self.indecateImageView.hidden  = !menuCellItem.hasIndecator;
    self.rightTextLab.hidden       = !menuCellItem.showRightNotice;
    self.rightIconImageView.hidden = !menuCellItem.showRightNotice;
    
    if (menuCellItem.showRightNotice) {
        NSString *showString;
        if (menuCellItem.permission == EVLivePermissionPay) {
            showString = [NSString stringWithFormat:@" %@", menuCellItem.price];
        } else if (menuCellItem.permission == EVLivePermissionPassWord) {
            showString = [NSString stringWithFormat:@" %@", menuCellItem.password];
        } else {
            showString = @"";
        }
        self.rightIconImageView.image = [self rightImageWithType:menuCellItem.permission];
        self.rightTextLab.text        = showString;
    }
}

- (UIImage *)rightImageWithType:(EVLivePermission)permission {
    UIImage *resultImage;
    if (permission == EVLivePermissionPay) {
        resultImage = [UIImage imageNamed:@"living_ready_limit_icon_money"];
    } else if (permission == EVLivePermissionPassWord) {
        resultImage = [UIImage imageNamed:@"living_ready_limit_icon_private"];
    }
    return resultImage;
}

- (void)rotateIndecateImageView:(BOOL)extend{
    CGAffineTransform transform;
    if ( extend ) {
        transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        transform = CGAffineTransformIdentity;
    }
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.indecateImageView.transform = transform;
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat seperateW = self.contentView.bounds.size.width;
    CGFloat seperateH = kGlobalSeparatorHeight;
    CGFloat superH = self.contentView.bounds.size.height;
    
    self.seperateLine.frame = CGRectMake(0, superH - seperateH, seperateW, seperateH);
}
@end
