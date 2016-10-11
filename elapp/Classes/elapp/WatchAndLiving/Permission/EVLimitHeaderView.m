//
//  EVLimitHeaderView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVLimitHeaderView.h"

@interface EVLimitHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *titleContainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (nonatomic, weak) IBOutlet UIView *seperateView;

@end

@implementation EVLimitHeaderView

+ (instancetype)limitHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"EVLimitHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{


    self.titleContainView.backgroundColor = [UIColor colorWithHexString:@"#fffcf9"];
    self.seperateView.backgroundColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
}

- (void)configTitle:(NSString *)titleString {
    self.titleLab.text = titleString;
}

- (IBAction)cancelButtonDidClicked {
    if ( [self.delegate respondsToSelector:@selector(limitHeaderViewDidClickButton:)] ) {
        [self.delegate limitHeaderViewDidClickButton:EVLimitHeaderViewButtonCancel];
    }
    
}

- (IBAction)comfirmButtonDid {
    if ( [self.delegate respondsToSelector:@selector(limitHeaderViewDidClickButton:)] ) {
        [self.delegate limitHeaderViewDidClickButton:EVLimitHeaderViewButtonComfirm];
    }
    
}

@end
