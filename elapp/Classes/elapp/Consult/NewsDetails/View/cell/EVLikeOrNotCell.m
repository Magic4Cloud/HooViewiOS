//
//  EVLikeOrNotCell.m
//  elapp
//
//  Created by 周恒 on 2017/5/9.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVLikeOrNotCell.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"

@interface EVLikeOrNotCell()
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@end

@implementation EVLikeOrNotCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _likeButton.layer.cornerRadius = 4;
    _likeButton.layer.borderWidth = 1;
    _likeButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    _likeButton.layer.masksToBounds = YES;
    
    _notLikeButton.layer.cornerRadius = 4;
    _notLikeButton.layer.borderWidth = 1;
    _notLikeButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
    _notLikeButton.layer.masksToBounds = YES;
    
    
    // Initialization code
}




-(void)setLike:(NSString *)like {
    _like = like;
    if ([like integerValue] == 0 ) {
        _likeButton.layer.borderColor = [UIColor evGlobalSeparatorColor].CGColor;
        _numberOfLike.textColor = [UIColor evGlobalSeparatorColor];
        _likeImage.image = [UIImage imageNamed:@"btn_news_like_n"];
    } else if ([like integerValue] == 1 ) {
        _likeButton.layer.borderColor = CCColor(255, 128, 89).CGColor;
        _numberOfLike.textColor = CCColor(255, 128, 89);
        _likeImage.image = [UIImage imageNamed:@"btn_news_like_s"];
    }
}

- (IBAction)notLike:(id)sender {
    [EVProgressHUD showMessage:@"暂未实现！"];
}


- (IBAction)action_like:(id)sender {
    WEAK(self)
    
    NSString *likeType = [_like integerValue] == 0 ? @"1" : @"0";
    [self.baseToolManager GETLikeOrNotWithUserName:nil Type:@"0" action:likeType postid:_newsId start:^{
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    } success:^{
        [weakself buttonStatus:likeType button:sender];
    } essionExpire:^{
        
    }];

}


- (void)buttonStatus:(NSString *)status button:(UIButton *)button
{
    if ([status integerValue] == 1) {
        _numberOfLike.text = [NSString stringWithFormat:@"%ld",[_likeCount integerValue] + 1];
        _likeCount = [NSString stringWithFormat:@"%ld",[_likeCount integerValue] + 1];
        _like = @"1";
        _numberOfLike.textColor = CCColor(255, 139, 101);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_news_like_s"] forState:UIControlStateNormal];
    }else {
        _numberOfLike.text = [NSString stringWithFormat:@"%ld",[_likeCount integerValue] - 1];
        _likeCount = [NSString stringWithFormat:@"%ld",[_likeCount integerValue] - 1];
        _like = @"0";
        _numberOfLike.textColor = CCColor(153, 153, 153);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_news_like_n"] forState:UIControlStateNormal];
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
