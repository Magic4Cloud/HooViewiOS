//
//  EVLimitSearchCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLimitSearchCell.h"
#import "AppDelegate.h"
#import "EVSearchTextField.h"
#import "EVTextField.h"

#define EVLimitSearchCellID @"EVLimitSearchCellID"

@interface EVLimitSearchCell () <UITextFieldDelegate, EVSearchTextFieldDelegate, EVTextFieldDelegate>

@property (nonatomic,weak) UIButton *searchImageView;
@property (nonatomic,weak) UITextField *searchTextField;
@property (nonatomic,weak) EVSearchTextField *assistTextField;
@property (nonatomic,weak) UIButton *textFieldButton;

@property (nonatomic,weak) UIView *bottomLine;

@end

@implementation EVLimitSearchCell

+ (NSString *)cellID
{
    return EVLimitSearchCellID;
}

- (void)dealloc
{
    [self removeNotification];
    [self endEditing];
    [_searchTextField removeFromSuperview];
}

- (void)beignEditing
{
    self.assistTextField.beginEdit = YES;
    [self.searchTextField becomeFirstResponder];
}

- (void)endEditing
{
    _assistTextField.beginEdit = NO;
    [_searchTextField resignFirstResponder];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{    
    UIButton *searchImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchImageView setImage:[UIImage imageNamed:@"living_ready_limit_icon_search"] forState:UIControlStateNormal];
    searchImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:searchImageView];
    self.searchImageView = searchImageView;
    
    EVTextField *searchTextField = [[EVTextField alloc] init];
    searchTextField.delegate = self;
    searchTextField.customeDelegate = self;
    searchTextField.backgroundColor = [UIColor redColor];
    UIView *view = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [view addSubview:searchTextField];
    self.searchTextField = searchTextField;
    searchTextField.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 44);
    
    EVSearchTextField *asistTextField = [[EVSearchTextField alloc] init];
    asistTextField.font = [UIFont systemFontOfSize:15];
    asistTextField.searchDelegate = self;
    asistTextField.placeholder = @"搜索好友";
    [self.contentView addSubview:asistTextField];
    self.assistTextField = asistTextField;
    
    UIButton *textFieldButton = [[UIButton alloc] init];
    [self.contentView addSubview:textFieldButton];
    self.textFieldButton = textFieldButton;
    [textFieldButton addTarget:self action:@selector(buttonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *bottomLine = [[UIView alloc] init];
//    bottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
//    [self.contentView addSubview:bottomLine];
//    self.bottomLine = bottomLine;
    
    [self setUpNotification];
}

- (void)buttonDidClicked
{
    self.assistTextField.beginEdit = YES;
    [self.searchTextField becomeFirstResponder];
}

- (void)setUpNotification
{
    [EVNotificationCenter addObserver:self selector:@selector(textChanged) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotification
{
    [EVNotificationCenter removeObserver:self];
}

- (void)textChanged
{
    self.assistTextField.text = self.searchTextField.text;
    if ( [self.delegate respondsToSelector:@selector(limitCell:textChange:)] )
    {
        NSString *text = self.searchTextField.text;
        if ( text.length && [[text substringToIndex:1] isEqualToString:@" "] )
        {
            text = [text substringFromIndex:1];
        }
        text = [text lowercaseString];
        [self.delegate limitCell:self textChange:text];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat superH = self.contentView.bounds.size.height;
    CGFloat superW = self.contentView.bounds.size.width;
    
    self.searchImageView.frame = CGRectMake(0, 0, superH, superH);
    self.assistTextField.frame = CGRectMake(superH, 0, superW - superH, superH);
    
    if ( self.textFieldButton.frame.size.width == 0 )
    {
        self.textFieldButton.frame = self.assistTextField.frame;
    }
    self.bottomLine.frame = CGRectMake(0, superH - kGlobalSeparatorHeight, superW, kGlobalSeparatorHeight);
}

#pragma mark - EVSearchTextFieldDelegate
- (void)searchTextFieldDidChangeLeftView:(CGRect)frame
{
    CGRect buttonFrame = self.textFieldButton.frame;
    buttonFrame.origin.x = self.searchImageView.frame.size.width + frame.size.width;
    self.textFieldButton.frame = buttonFrame;
}

- (void)searchTextFieldDidCancelItem:(EVFriendItem *)item
{
    if ( [self.delegate respondsToSelector:@selector(limitCellDidCancelItem:)] )
    {
        [self.delegate limitCellDidCancelItem:item];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *text = textField.text;
    if ( text.length && ![[text substringToIndex:1] isEqualToString:@""] )
    {
        textField.text = [NSString stringWithFormat:@"%@", textField.text];
    }
    else
    {
        textField.text = @"";
    }
    
    if ( [self.delegate respondsToSelector:@selector(limitCellDidBeginEdit:)] )
    {
        [self.delegate limitCellDidBeginEdit:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ( [textField.text isEqualToString:@" "] && string.length == 0 )
//    {   // 删除键
//        if ( [self.assistTextField deleteLastItem]  && [self.delegate respondsToSelector:@selector(limitCellDeleteLastItem:)] )
//        {
//            [self.delegate limitCellDeleteLastItem:self];
//        }
//        self.assistTextField.text = @"";
//        [self textChanged];
//        return NO;
//    }
    
    return YES;
}

- (void)selectFriendItem:(EVFriendItem *)item
{
    [self.assistTextField insertFriendItem:item];
    self.assistTextField.text = @"";
    self.searchTextField.text = @"";
}

- (void)deSelectFriendItem:(EVFriendItem *)item
{
    [self.assistTextField deleteFriendItem:item];
}

#pragma mark - EVTextFieldDelegate

- (void)backspacePressedBeforeDeleting:(NSString *)deleteBeforeStr afterDeleting:(NSString *)afterDeleteStr
{
    if ( deleteBeforeStr.length < 1 )
    {
        // 删除键
        if ( [self.assistTextField deleteLastItem]  && [self.delegate respondsToSelector:@selector(limitCellDeleteLastItem:)] )
        {
            [self.delegate limitCellDeleteLastItem:self];
        }
        self.assistTextField.text = @"";
    }
    [self textChanged];
    EVLog(@"backspace pressed!");
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.assistTextField.placeholder = placeHolder;
}

@end
