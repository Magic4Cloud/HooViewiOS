//
//  EVAccountBindTableViewCell.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAccountBindTableViewCell.h"
#import "EVRelationWith3rdAccoutModel.h"

NSString *const QQTYPE = @"qq";
NSString *const PHONETYPE = @"phone";
NSString *const WEIXINTYPE = @"weixin";
NSString *const WEIBOTYPE = @"sina";

@interface EVAccountBindTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *bind;

@end

@implementation EVAccountBindTableViewCell

#pragma mark - life circle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.bind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark - event response

- (IBAction)bindOrUndoBind:(id)sender
{
    CCLog(@"bind");
    if (!self.model.token && self.bindBlock)
    { // 未绑定情况下去解绑
        CCLog(@"绑定");
        self.bindBlock(self.model.type);
    }
    else if (self.model.token && self.bindBlock)
    {    // 绑定后，去解绑
        self.undoBindBlock(self.model.type);
    }
}

#pragma getter and setters

- (void)setModel:(EVRelationWith3rdAccoutModel *)model
{
//    if (_model != model)
//    {
        _model = model;
        if ( [_model.type isEqualToString:PHONETYPE] )
        {
            // 添加绑定按钮的逻辑
            // 如果没有绑定，设置绑定按钮显示，绑定成功后，绑定按钮隐藏
            [self.bind setTitle:kE_GlobalZH(@"e_binding") forState:UIControlStateNormal];
            self.bind.backgroundColor = [UIColor colorWithHexString:kGlobalGreenColor];
            if ( _model.token )
            {
                self.bind.hidden = YES;
            }
            else
            {
                self.bind.hidden = NO;
            }
            
            [self bringSubviewToFront:self.detail];
        }
        else
        {
            if ( _model.token )
            {
                [self.bind setTitle:kE_GlobalZH(@"relieve_binding") forState:UIControlStateNormal];
                self.bind.backgroundColor = [UIColor whiteColor];
                [self.bind setTitleColor:[UIColor evMainColor] forState:UIControlStateNormal];
                
                self.bind.layer.borderColor = [UIColor evMainColor].CGColor;
                self.bind.layer.borderWidth = .5f;
            }
            else
            {
                [self.bind setTitle:kE_GlobalZH(@"e_binding") forState:UIControlStateNormal];
                self.bind.backgroundColor = [UIColor evMainColor];
                [self.bind setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               
            }
            
            self.bind.layer.cornerRadius = 3.f;
            self.bind.layer.masksToBounds = YES;
        }
    
        if ([_model.type isEqualToString:QQTYPE])
        {
            self.icon.image = [UIImage imageNamed:@"personal_icon_qq"];
            self.title.text = kE_GlobalZH(@"e_QQ_num");
        }
        else if ([self.model.type isEqualToString:WEIXINTYPE])
        {
            self.icon.image = [UIImage imageNamed:@"personal_icon_wechat"];
            self.title.text = kE_GlobalZH(@"e_wechat_num");
            
        }
        else if ([_model.type isEqualToString:WEIBOTYPE])
        {
            self.icon.image = [UIImage imageNamed:@"personal_icon_weibo"];
            self.title.text = kE_GlobalZH(@"e_weibo_num");
            
        }
        else if ([_model.type isEqualToString:PHONETYPE])
        {
            self.icon.image = [UIImage imageNamed:@"personal_icon_phone"];
            self.title.text = kE_GlobalZH(@"e_phone_num");
            if (self.model.token)
            {
                NSMutableString *detailTemp = [NSMutableString stringWithFormat:@"+%@", self.model.token];
                if (self.model.login)
                {
                    [detailTemp appendString:kE_GlobalZH(@"already_login")];
                }
                self.detail.text = detailTemp;
            }
        }
//    }
    
}

- (void)setCanShowBindButton:(BOOL)canShowBindButton
{
    _canShowBindButton = canShowBindButton;
    self.bind.hidden = !_canShowBindButton;
}

@end
