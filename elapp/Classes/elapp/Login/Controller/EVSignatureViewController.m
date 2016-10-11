//
//  EVSignatureViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVSignatureViewController.h"
#import "PureLayout.h"
#import "EVTextViewWithPlaceHolderAndClearButton.h"
#import "NSString+Extension.h"

#define kLimitTipText  kSignature_length
#define kLimitLen       20

@interface EVSignatureViewController ()<UITextViewDelegate>

/** 编辑个人签名的textView */
@property (strong, nonatomic) EVTextViewWithPlaceHolderAndClearButton *signatureTV;

@end

@implementation EVSignatureViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    self.title = kE_signation;
    self.view.backgroundColor = CCBackgroundColor;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:kE_submit style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem setTintColor:[UIColor evSecondColor]];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:(UIControlStateNormal)];
}

- (void)commit
{
    [self.view endEditing:YES];
    if ([self.signatureTV.text numOfWordWithLimit:kLimitLen] > kLimitLen)
    {
        [CCProgressHUD showError:[NSString stringWithFormat:kLimitTipText, kLimitLen]
                          toView:self.view];
        return;
    }
    NSString *signatureStr = [NSString stringWithFormat:@"%@",self.signatureTV.text];
    signatureStr = [signatureStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    signatureStr = [signatureStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    signatureStr = [signatureStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.commitBlock(signatureStr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI {
    [self.view addSubview:self.signatureTV];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.signatureTV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.signatureTV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.signatureTV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.signatureTV autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:200];
    [self.signatureTV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
}

- (UITextView *)signatureTV {
    if ( !_signatureTV )
    {
        _signatureTV = [[EVTextViewWithPlaceHolderAndClearButton alloc] init];
        _signatureTV.placeHolder = kE_signation;
        _signatureTV.text = self.text;
        _signatureTV.delegate = self;
    }
    return _signatureTV;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString * replacedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ( replacedText.length > kLimitLen )
    {
        textView.text = [replacedText substringToIndex:kLimitLen];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{

    if ( textView.text.length > kLimitLen )
    {
        textView.text = [textView.text substringToIndex:kLimitLen];
        return;
    }
}




@end
