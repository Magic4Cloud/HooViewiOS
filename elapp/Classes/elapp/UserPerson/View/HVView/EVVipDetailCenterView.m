//
//  EVVipCenterView.m
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipDetailCenterView.h"
#import "NSString+Extension.h"
#import "EVLoginInfo.h"
#import "EVUserTagsModel.h"

@interface EVVipDetailCenterView()

@property (weak, nonatomic) IBOutlet UIImageView *headerCoverImage;

@property (weak, nonatomic) IBOutlet UILabel *numberOfFans;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;//自我介绍
@property (weak, nonatomic) IBOutlet UILabel *credentialsLabel;//证券资格证号

@property (weak, nonatomic) IBOutlet UILabel *tagOfVipLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet UILabel *followLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfFollow;

@property (weak, nonatomic) IBOutlet UIButton *fansNumberButton;//点击粉丝跳转

@property (weak, nonatomic) IBOutlet UIButton *followNumberButton;//点击关注跳转

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;






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


//关注 & 取消关注
- (IBAction)followOrNot:(id)sender {
    
}


//点击粉丝跳转
- (IBAction)toFansVC:(id)sender {
    //粉丝
    if (self.fansAndFollowClickBlock) {
        self.fansAndFollowClickBlock(FANS);
    }
}

//点击关注跳转
- (IBAction)toFollowVC:(id)sender {
    //关注
    if (self.fansAndFollowClickBlock) {
        self.fansAndFollowClickBlock(FOCUSES);
    }
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
    _credentialsLabel.text = @"A11402385478";
    _numberOfFans.text = [NSString stringWithFormat:@"%ld",userModel.fans_count];
    
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in userModel.tags) {
        [titleAry addObject:model.tagname];
    }
    _tagOfVipLabel.text = [NSString stringWithArray:titleAry];
    
    
    
    if ([EVLoginInfo hasLogged] && userModel.vip == 1)
    {
        //是大v
        _followNumberButton.hidden = YES;
        _followLabel.hidden = YES;
        _numberOfFollow.hidden = YES;
        _vipImage.hidden = NO;
    } else {
        _followNumberButton.hidden = NO;
        _followLabel.hidden = NO;
        _numberOfFollow.hidden = NO;
        _vipImage.hidden = YES;
    }
    
    if ([EVLoginInfo hasLogged] && [userModel.name isEqualToString:[EVLoginInfo localObject].name]) {
        //进入自己的主页
        _followOrNotButton.hidden = YES;
    }
    
}




@end
