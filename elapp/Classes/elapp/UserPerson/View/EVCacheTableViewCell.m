//
//  EVCacheTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCacheTableViewCell.h"
#import <PureLayout.h>

@interface EVCacheTableViewCell ()

@property (weak, nonatomic) UILabel *titleLbl;  /**< 标题 */
@property (weak, nonatomic) UILabel *detailLbl;  /**< 缓存 */
@property (weak,nonatomic) UIActivityIndicatorView *activityView; /**< 清除缓存提示动画控件 */

@end

@implementation EVCacheTableViewCell

#pragma mark - 重写父类方法

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        [self setUpUI];
    }
    
    return self;
}

#pragma mark - public instance methods

- (void)startAnimating
{
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

#pragma mark - private methods

- (void)setUpUI
{
    // 添加标题
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:15];
    titleLbl.textColor = [UIColor textBlackColor];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    // 标题约束
    CGFloat space = 15.0f;
    [titleLbl autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(.0f, space, .0f, space)];
    
    // 添加缓存显示label
    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    detailLbl.textAlignment = NSTextAlignmentRight;
    detailLbl.font = [[EVAppSetting shareInstance] normalFontWithSize:15];
    detailLbl.textColor = [UIColor textBlackColor];
    [self.contentView addSubview:detailLbl];
    self.detailLbl = detailLbl;
    
    // 缓存约束
    [detailLbl autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [detailLbl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [detailLbl autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.titleLbl];
    
    // 添加清除缓存处理中的动画
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:activityView];
    self.activityView = activityView;
    self.activityView.hidesWhenStopped = YES;
    self.activityView.hidden = YES;
    
    [activityView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [activityView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [activityView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.detailLbl];
    
    [self.contentView layoutIfNeeded];
}


#pragma mark - setters and getters

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLbl.text = self.titleStr;
}

- (void)setDetailTitleStr:(NSString *)detailTitleStr
{
    _detailTitleStr = detailTitleStr;
    self.detailLbl.text = self.detailTitleStr;
}

- (void)setIsCleaning:(BOOL)isCleaning
{
    _isCleaning = isCleaning;
//    self.activityView.hidden = !isCleaning;
    [self.activityView stopAnimating];
    self.detailLbl.hidden = isCleaning;
}
@end
