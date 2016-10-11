//
//  EVTableViewSectionHeader.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVTableViewSectionHeader.h"
#import "PureLayout.h"

@interface EVTableViewSectionHeader ()

@property (nonatomic, weak) UIButton *headerBtn;        /**< 头部视图 */
@property (nonatomic, weak) UIView *bottonLineView;     /**< 底部细线 */

@end

@implementation EVTableViewSectionHeader

// 重载初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = CCBackgroundColor;
        [self setUI];
    }
    return self;
}

// 自定义带参的初始化方法
- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title
{
    EVTableViewSectionHeader *sectionHeader = [[EVTableViewSectionHeader alloc] init];
    sectionHeader.imageName = imageName;
    sectionHeader.title = title;
    return sectionHeader;
}

#pragma mark - setters

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self.headerBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.headerBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)setUI
{
//    self.backgroundColor = [UIColor whiteColor];
    // header左侧图片和文字
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14];
    [btn setTitleColor:[UIColor colorWithHexString:@"#403B37"] forState:UIControlStateNormal];
//    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [self addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [btn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];// 根据产品需求修改边距为10
    [btn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    
    // header左侧图片和文字
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rightBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:14];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#403B37"] forState:UIControlStateNormal];
    [rightBtn setTitle:kE_More forState:(UIControlStateNormal)];
    [rightBtn setImage:[UIImage imageNamed:@"hot_icon_more"] forState:(UIControlStateNormal)];
    [self addSubview:rightBtn];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -20.0f, 0.0f, 0.0f)];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 0.0f)];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:(UIControlEventTouchDown)];
    [rightBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];// 根据产品需求修改边距为10
    [rightBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    _headerBtn = btn;
    // header底部的线
    UIView *bottonLineView = [[UIView alloc]init];
    bottonLineView.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA" alpha:0.5];
    [self addSubview:bottonLineView];
    [bottonLineView autoSetDimension:ALDimensionHeight toSize:1.0];
    [bottonLineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [bottonLineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self];
    [bottonLineView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self];
    
    _bottonLineView = bottonLineView;
    
    
    
}

- (void)rightBtnClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(rightButton:headTitle:)]) {
        [self.delegate rightButton:btn headTitle:self.headerBtn.titleLabel.text];
    }
}

@end
