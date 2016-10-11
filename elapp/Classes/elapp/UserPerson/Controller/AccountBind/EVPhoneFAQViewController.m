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
    self.title = kE_GlobalZH(@"appeal_about");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"self_appeal") style:UIBarButtonItemStylePlain target:self action:@selector(clickAppealItem)];
       [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{UITextAttributeFont:[UIFont systemFontOfSize:15],UITextAttributeTextColor:[UIColor evSecondColor]} forState:(UIControlStateNormal)];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"申诉说明.rtf" ofType:nil];
    UITextView *textView = [[UITextView alloc] init];
    [self.view addSubview:textView];
    [textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithData:[NSData dataWithContentsOfFile:path] options:@{} documentAttributes:nil error:nil];
    textView.attributedText = attriStr;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.backgroundColor = CCBackgroundColor;
    textView.tintColor = CCAppMainColor;
    textView.editable = NO;
}

- (void)clickAppealItem
{
    if ( ![MFMailComposeViewController canSendMail] )
    {
        [CCProgressHUD showError:kE_GlobalZH(@"your_device_not_send_mail")];
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
            CCLog(@"Mail send canceled…");
            
            break;
            
        case MFMailComposeResultSaved:
            CCLog(@"Mail saved…");
            
            break;
            
        case MFMailComposeResultSent:
            CCLog(@"Mail sent…");
            [CCProgressHUD showSuccess:kE_GlobalZH(@"success_send")];
            
            break;
            
        case MFMailComposeResultFailed:
            CCLog(@"Mail send errored: %@…", [error localizedDescription]);
            [CCProgressHUD showError:kE_GlobalZH(@"fail_send")];
            
            break;
            
        default:
            
            break; 
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}




@end
