//
//  EVCommentViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVCommentViewCell.h"
#import "EVLineView.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"


@interface EVCommentViewCell ()

@property (nonatomic, weak) UIImageView *headImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *heatLabel;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;


@end

@implementation EVCommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = CCColor(248, 248, 248);
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
    [headImageView autoSetDimensionsToSize:CGSizeMake(30, 30)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 15.f;
    headImageView.image = [UIImage imageNamed:@"Account_bitmap_user"];
    _headImageView = headImageView;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:8];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(160, 20)];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    nameLabel.textColor = [UIColor evTextColorH1];
    nameLabel.font = [UIFont textFontB3];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textColor = [UIColor evTextColorH1];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nameLabel];
    [contentLabel autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 81];
//    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLabel withOffset:8];
    

    UILabel *heatLabel = [[UILabel alloc] init];
    [self addSubview:heatLabel];
    self.heatLabel = heatLabel;
    heatLabel.textAlignment = NSTextAlignmentRight;
    [heatLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
    [heatLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:26];
    [heatLabel autoSetDimension:ALDimensionHeight toSize:20.0f];
    heatLabel.textColor = [UIColor evTextColorH2];
    heatLabel.font = [UIFont textFontB3];
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:likeButton];
    self.likeButton = likeButton;
    [likeButton addTarget:self action:@selector(action_likeOrNot:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton autoSetDimensionsToSize:CGSizeMake(30, 30)];
    [likeButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
    [likeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:heatLabel];
    [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_news_like_n"] forState:UIControlStateNormal];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];
    [timeLabel autoSetDimensionsToSize:CGSizeMake(250, 17)];
    [timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:contentLabel];
    timeLabel.textColor = [UIColor evTextColorH2];
    timeLabel.font = [UIFont textFontB4];
    
    
//    EVLineView *lineView = [EVLineView new];
//    [self addSubview:lineView];
//    lineView.backgroundColor = [UIColor evAssistColor];
//    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
//    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
//    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
//    [lineView autoSetDimension:ALDimensionHeight toSize:1.0f];
    
}


- (void)setVideoCommentModel:(EVHVVideoCommentModel *)videoCommentModel
{
    _videoCommentModel = videoCommentModel;
    
    [self.headImageView cc_setImageWithURLString:videoCommentModel.user_avatar placeholderImage:nil];
    [self.nameLabel setText:videoCommentModel.user_name];
    [self.contentLabel setText:videoCommentModel.content];
    [self.heatLabel setText:@"1.4万"];
    self.timeLabel.text = @"2分钟前";
    
    if ([videoCommentModel.like integerValue] == 0) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_news_like_n"] forState:UIControlStateNormal];
        _heatLabel.textColor = CCColor(153, 153, 153);
    } else {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"btn_news_like_s"] forState:UIControlStateNormal];
        _heatLabel.textColor = CCColor(255, 139, 101);
    }

    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
    CGSize nameSize = [videoCommentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
    videoCommentModel.cellHeight = nameSize.height+90;
}


- (void)action_likeOrNot:(UIButton *)sender {
//    WEAK(self)
    
//    NSString *likeType = [_videoCommentModel.like integerValue] == 0 ? @"1" : @"0";
//    [self.baseToolManager GETLikeOrNotWithUserName:nil Type:_videoCommentModel.topic.type action:likeType postid:self.commentModel.id start:^{
//        
//    } fail:^(NSError *error) {
//        NSLog(@"error = %@",error);
//    } success:^{
//        sender.selected = !sender.selected;
//        [weakself buttonStatus:likeType button:sender];
//    } essionExpire:^{
//        
//    }];
    
}


- (void)buttonStatus:(NSString *)status button:(UIButton *)button
{
    if ([status integerValue] == 1) {
        _heatLabel.text = [NSString stringWithFormat:@"%ld",_videoCommentModel.heats + 1];
        _videoCommentModel.heats = _videoCommentModel.heats + 1;
        _videoCommentModel.like = @"1";
        _heatLabel.textColor = CCColor(255, 139, 101);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_news_like_s"] forState:UIControlStateNormal];
        
    }else {
        _heatLabel.text = [NSString stringWithFormat:@"%ld",_videoCommentModel.heats - 1];
        _videoCommentModel.heats = _videoCommentModel.heats - 1;
        _videoCommentModel.like = @"0";
        
        _heatLabel.textColor = CCColor(153, 153, 153);
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



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
