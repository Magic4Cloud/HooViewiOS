//
//  EVCopyRightViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVCopyRightViewController.h"


@interface EVCopyRightViewController ()


@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;


@end


@implementation EVCopyRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kE_GlobalZH(@"copy_about");
    self.view.backgroundColor = [UIColor whiteColor];
    self.aboutTextView.text = kE_GlobalZH(@"copy_about_detail");
    self.aboutTextView.font = [UIFont systemFontOfSize:18.f];
    self.aboutTextView.textAlignment = NSTextAlignmentLeft;
}

@end
