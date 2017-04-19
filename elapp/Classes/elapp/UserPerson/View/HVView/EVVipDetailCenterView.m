//
//  EVVipCenterView.m
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipDetailCenterView.h"
#import "NSString+Extension.h"

@interface EVVipDetailCenterView()

@property (weak, nonatomic) IBOutlet UIImageView *headerCoverImage;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOfFans;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;//自我介绍
@property (weak, nonatomic) IBOutlet UILabel *credentialsLabel;//证券资格证号

@property (weak, nonatomic) IBOutlet UILabel *tagOfVipLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;




@end


@implementation EVVipDetailCenterView

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setup
{
    
    UIView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    [self addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(@"view", view);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:bindings]];
//    self.frame.size.height = view.frame.size.height;
    self.bounds = view.bounds;
    [self setNeedsLayout];
}


- (IBAction)action_follow:(id)sender {
    
    
}

- (void)setUserModel:(EVUserModel *)userModel {
    _userModel = userModel;
    if (!userModel) {
        return;
    }
    [_headerCoverImage cc_setImageWithURLString:userModel.logourl placeholderImage:nil];
    _nameLabel.text = userModel.nickname;
    _signatureLabel.text = userModel.signature;
    _introduceLabel.text = @"火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经火眼财经";//详细资料
    _credentialsLabel.text = userModel.credentials;
    _numberOfFans.text = [NSString stringWithFormat:@"%ld",userModel.fans_count];
    NSLog(@"userModel.tags = %@",userModel.tags[0]);
//    NSString *marketStr = [NSString stringWithArray:userModel.tags];
//    NSLog(@"marketstr = %@",marketStr);
//    _tagOfVipLabel.text = [NSString stringWithArray:userModel.tags];
    
    
    
}




@end
