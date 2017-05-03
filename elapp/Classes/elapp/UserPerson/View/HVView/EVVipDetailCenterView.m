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
#import "EVBaseToolManager+EVUserCenterAPI.h"

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

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverImageHeight;


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
//    _headerCoverImage.contentMode = UIViewContentModeRight;
//    _headerCoverImage.layer.masksToBounds = YES;
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
    self.followOrNotButton.layer.cornerRadius = 6;
    [self setNeedsLayout];
}


//关注 & 取消关注
- (IBAction)followOrNot:(UIButton *)sender {
    if (![EVLoginInfo hasLogged]) {
//        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//        [self presentViewController:navighaVC animated:YES completion:nil];
//        return;
    }
    
    WEAK(self)
    BOOL followType = self.watchVideoInfo.followed ? NO : YES;
    [self.baseToolManager GETFollowUserWithName:self.watchVideoInfo.name followType:followType start:^{
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    } success:^{
        sender.selected = !sender.selected;
        [weakself buttonStatus:sender.selected button:sender];
        weakself.watchVideoInfo.followed = followType;
    }
      essionExpire:^{
                                       
    }];
    
}

- (void)buttonStatus:(BOOL)status button:(UIButton *)button
{
    if (status == YES) {
        [button setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
        [button setTitle:@"已关注" forState:(UIControlStateNormal)];
    }else {
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [button setTitle:@"+关注" forState:(UIControlStateNormal)];
    }
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
    _introduceLabel.text = userModel.introduce;//详细资料
    _credentialsLabel.text = userModel.credentials;
    _numberOfFans.text = [NSString stringWithFormat:@"%ld",userModel.fans_count];
    _numberOfFollow.text = [NSString stringWithFormat:@"%ld",userModel.follow_count];
    
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in userModel.tags) {
        [titleAry addObject:model.tagname];
    }
    _tagOfVipLabel.text = [NSString stringWithArray:titleAry];
    
    
    if (userModel.followed == YES) {
        [_followOrNotButton setTitleColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1] forState:UIControlStateNormal];
        [_followOrNotButton setTitle:@"已关注" forState:(UIControlStateNormal)];
    } else {
        [_followOrNotButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_followOrNotButton setTitle:@"+关注" forState:(UIControlStateNormal)];
    }
    
    
    
    
    
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
        _lineView.hidden = YES;
        _tagsLabel.hidden = YES;
        _coverImageHeight.constant = ScreenWidth * 210 / 375;
    }
    
    if ([EVLoginInfo hasLogged] && [userModel.name isEqualToString:[EVLoginInfo localObject].name]) {
        //进入自己的主页
        _followOrNotButton.hidden = YES;
    }
    
}


- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}



@end
