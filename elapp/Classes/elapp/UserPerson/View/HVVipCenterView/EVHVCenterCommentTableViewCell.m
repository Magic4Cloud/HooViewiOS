//
//  EVHVCenterCommentTableViewCell.m
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterCommentTableViewCell.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"


@interface EVHVCenterCommentTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *titleBackView;

@property (weak, nonatomic) IBOutlet UIImageView *cellTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;//点赞

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikeLabel;//点赞数

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;


@end

@implementation EVHVCenterCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCommentModel:(EVHVCenterCommentModel *)commentModel {
    if (!commentModel) {
        return;
    }
    _commentModel = commentModel;
    _cellTitleLabel.text = commentModel.topic.title;
    _timeLabel.text = commentModel.time;
    _contentLabel.text = commentModel.content;
    _numberOfLikeLabel.text = commentModel.heats;
    _nameLabel.text = commentModel.user.nickname;
    [_headerImage cc_setImageWithURLString:commentModel.user.avatar placeholderImage:nil];
    
    if ([commentModel.topic.type isEqualToString:@"0"]) {
        //新闻
        _titleBackView.backgroundColor = CCColor(142, 193, 235);
        _cellTypeImage.image = [UIImage imageNamed:@"ic_user_new"];
    } else if([commentModel.topic.type isEqualToString:@"1"]) {
        //视频
        _titleBackView.backgroundColor = CCColor(179, 162, 233);
        _cellTypeImage.image = [UIImage imageNamed:@"ic_user_video"];
    } else if([commentModel.topic.type isEqualToString:@"2"]) {
        //股票
        _titleBackView.backgroundColor = CCColor(235, 188, 142);
        _cellTypeImage.image = [UIImage imageNamed:@"ic_user_shares"];
    }
    
    if ([commentModel.like integerValue] == 0) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_news_like_n"] forState:UIControlStateNormal];
        _numberOfLikeLabel.textColor = CCColor(153, 153, 153);
    } else {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_news_like_s"] forState:UIControlStateNormal];
        _numberOfLikeLabel.textColor = CCColor(255, 139, 101);
    }
    
    
    
}

- (IBAction)action_likeOrNot:(UIButton *)sender {
    WEAK(self)
    
    NSString *likeType = [self.commentModel.like integerValue] == 0 ? @"1" : @"0";
    [self.baseToolManager GETLikeOrNotWithUserName:nil Type:self.commentModel.topic.type action:likeType postid:self.commentModel.id start:^{
        
    } fail:^(NSError *error) {
        NSLog(@"error = %@",error);
    } success:^{
        sender.selected = !sender.selected;
        [weakself buttonStatus:likeType button:sender];
    } essionExpire:^{
        
    }];
    
}


- (void)buttonStatus:(NSString *)status button:(UIButton *)button
{
    if ([status integerValue] == 1) {
        _numberOfLikeLabel.text = [NSString stringWithFormat:@"%ld",[_commentModel.heats integerValue] + 1];
        _commentModel.heats = [NSString stringWithFormat:@"%ld",[_commentModel.heats integerValue] + 1];
        _commentModel.like = @"1";
        _numberOfLikeLabel.textColor = CCColor(255, 139, 101);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_news_like_s"] forState:UIControlStateNormal];

    }else {
        _numberOfLikeLabel.text = [NSString stringWithFormat:@"%ld",[_commentModel.heats integerValue] - 1];
        _commentModel.heats = [NSString stringWithFormat:@"%ld",[_commentModel.heats integerValue] - 1];
        _commentModel.like = @"0";

        _numberOfLikeLabel.textColor = CCColor(153, 153, 153);
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
