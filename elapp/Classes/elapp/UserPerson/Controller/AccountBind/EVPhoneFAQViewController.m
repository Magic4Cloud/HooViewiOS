//
//  EVPhoneFAQViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPhoneFAQViewController.h"
#import <PureLayout.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface EVPhoneFAQViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation EVPhoneFAQViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.navTitle;
    
    if (self.showAppealBtn) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"self_appeal") style:UIBarButtonItemStylePlain target:self action:@selector(clickAppealItem)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15],UITextAttributeTextColor:[UIColor evSecondColor]} forState:(UIControlStateNormal)];
    }
    
    NSString *path = self.RTFFilePath ? : @"";
    UITextView *textView = [[UITextView alloc] init];
    [self.view addSubview:textView];
    [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:path] options:@{} documentAttributes:nil error:nil];
    textView.attributedText = attriStr;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.backgroundColor = [UIColor evBackgroundColor];
    textView.tintColor = [UIColor evMainColor];
    textView.editable = NO;
}

- (void)clickAppealItem
{
    if ( ![MFMailComposeViewController canSendMail] )
    {
        [EVProgressHUD showError:kE_GlobalZH(@"your_device_not_send_mail")];
        return;
    }
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];     //创建邮件controller
    
    mailPicker.mailComposeDelegate = self;  //设置邮件代理
    
    [mailPicker setSubject:kE_GlobalZH(@"motify_phone_num")]; //邮件主题
    
    [mailPicker setToRecipients:@[@"yzbkefu@cloudfocus.cn"]]; //设置发送给谁，参数是NSarray
    [self presentViewController:mailPicker animated:YES completion:NULL];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result

                        error:(NSError*)error

{
    
    switch (result){
            
        case MFMailComposeResultCancelled:
            EVLog(@"Mail send canceled…");
            
            break;
            
        case MFMailComposeResultSaved:
            EVLog(@"Mail saved…");
            
            break;
            
        case MFMailComposeResultSent:
            EVLog(@"Mail sent…");
            [EVProgressHUD showSuccess:kE_GlobalZH(@"success_send")];
            
            break;
            
        case MFMailComposeResultFailed:
            EVLog(@"Mail send errored: %@…", [error localizedDescription]);
            [EVProgressHUD showError:kE_GlobalZH(@"fail_send")];
            
            break;
            
        default:
            
            break; 
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
