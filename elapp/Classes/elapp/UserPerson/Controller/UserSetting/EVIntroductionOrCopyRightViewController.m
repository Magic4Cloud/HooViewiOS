//
//  EVIntroductionOrCopyRightViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVIntroductionOrCopyRightViewController.h"

@interface EVIntroductionOrCopyRightViewController ()
@property (weak, nonatomic) IBOutlet UITextView *easyvaasTextView;

@end

@implementation EVIntroductionOrCopyRightViewController

#pragma mark - life cirle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kE_GlobalZH(@"e_easyvaas");
    self.view.backgroundColor = [UIColor whiteColor];
        self.easyvaasTextView.text = kE_GlobalZH(@"easyvaas_about");
        self.easyvaasTextView.textColor = [UIColor evTextColorH1];
        self.easyvaasTextView.font = [UIFont systemFontOfSize:18.f];
        self.easyvaasTextView.textAlignment = NSTextAlignmentJustified;
}


@end
