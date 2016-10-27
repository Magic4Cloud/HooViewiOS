//
//  EVSearchView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVSearchView.h"
#import <PureLayout.h>

@interface EVSearchView ()<UITextFieldDelegate>

@property (weak, nonatomic) UIImageView *searchIcon;  /**< 搜索图标*/
@property (weak, nonatomic) UITextField *searchTF;  /**< 搜索框 */
@property (weak, nonatomic) UIButton *cancelBtn;  /**< 取消按钮 */

@end

@implementation EVSearchView

/**
 * 01. 通过类方法创建一个实例
 * 02. 复写initWithFrame方法，添加控件，添加约束
 * 03. 复写setter方法
 * 04. 实现textfield的代理方法，并且给出外部的代理方法，完成相应的响应
 */

#pragma mark - public class methods

+ (instancetype)instanceWithFrame:(CGRect)frame
{
    EVSearchView *searchView = [[EVSearchView alloc] initWithFrame:frame];
    
    return searchView;
}


#pragma mark - public instance methods

- (void)begineEditting
{
    [self.searchTF becomeFirstResponder];
}

- (void)endEditting
{
    [self.searchTF endEditing:YES];
}


#pragma mark - rewrite methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self addSubviews];
    }
    
    return self;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1. 结束编辑
//    [textField endEditing:YES];
    // 2. 获取搜索关键字
    NSString *searchText = [textField.text mutableCopy];
    // 3. 开始搜索
    if ( _searchDelegate && [_searchDelegate respondsToSelector:@selector(searchView:didBeginSearchWithText:)] )
    {
        [_searchDelegate searchView:self didBeginSearchWithText:searchText];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CCLog(@"---text field:-%@-, range:%@, replacement string:-%@-", textField.text, NSStringFromRange(range), string);
    
    return [textField.text isEqualToString:@""] && [string isEqualToString:@" "] ? NO : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( _searchDelegate && [_searchDelegate respondsToSelector:@selector(searchView:didBeginEditing:)] )
    {
        [_searchDelegate searchView:self didBeginEditing:textField];
    }
}


#pragma mark - event actions

- (void)cancelSearch
{
    // 取消编辑
    [self endEditing:YES];
    
    // 响应代理
    if ( _searchDelegate && [_searchDelegate respondsToSelector:@selector(cancelSearch)] )
    {
        [_searchDelegate cancelSearch];
    }
}


#pragma mark - private methods

- (void)addSubviews
{
    CGFloat space = 13.0f;
    CGFloat fontSize = 16.0f;
//    CGFloat height = 31.0f;
    CGFloat cancelBtnW = 33.0f + 13.0f;
    
    // 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [cancelBtn setTitle:kCancel forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [[CCAppSetting shareInstance] normalFontWithSize:fontSize];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setContentMode:UIViewContentModeLeft];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(.0f, 13.0f, .0f, .0f)];
    cancelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    // 取消按钮约束
    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [cancelBtn autoSetDimension:ALDimensionWidth toSize:cancelBtnW];
    
    
    // 搜索容器，盛放搜索图标和搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectZero];
    searchView.layer.cornerRadius = 6.0f;
    searchView.layer.borderColor = [UIColor whiteColor].CGColor;
    searchView.layer.borderWidth = 0.9f;
    searchView.layer.masksToBounds = YES;
    [self addSubview:searchView];
    // 搜索容器的约束
    [searchView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [searchView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:6.f];
    [searchView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [searchView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:cancelBtn];
    
    // 搜索图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_navigation_searchbar_search"]];
    [searchView addSubview:searchIcon];
    _searchIcon = searchIcon;
    // 搜索图标约束
    [searchIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [searchIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [searchIcon autoSetDimensionsToSize:CGSizeMake(20, 20)];
    
    // 搜索框
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectZero];
    searchTF.placeholder = kSearch;
    searchTF.textColor = [UIColor whiteColor];
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.tintColor = [UIColor whiteColor];
    searchTF.font = [[CCAppSetting shareInstance] normalFontWithSize:15.0f];
    searchTF.delegate = self;
    [searchView addSubview:searchTF];
    _searchTF = searchTF;
    // 搜索框约束
    [searchTF autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:.0f];
    [searchTF autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:.0f];
    [searchTF autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:.0f];
    [searchTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:searchIcon withOffset:space - 5];
    
    
    [self layoutIfNeeded];
}


#pragma mark - setters and getters

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    if ( self.searchTF )
    {
        self.searchTF.placeholder = self.placeHolder;
    }
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    if ( placeHolderColor == nil )
    {
        return;
    }
    if ( self.searchTF )
    {
//        self.searchTF.tintColor = placeHolderColor;
        self.searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeHolder attributes:@{NSForegroundColorAttributeName : placeHolderColor}];
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    if ( self.searchTF )
    {
        self.searchTF.text = self.text;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if ( self.searchTF )
    {
        self.searchTF.textColor = self.textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    if ( self.searchTF )
    {
        self.searchTF.font = self.font;
    }
}

@end
