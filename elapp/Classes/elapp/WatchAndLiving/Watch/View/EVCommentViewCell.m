//
//  EVCommentViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVCommentViewCell.h"
#import "EVLineView.h"

@interface EVCommentViewCell ()

@property (nonatomic, weak) UIImageView *headImageView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) UILabel *contentLabel;

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
    UIImageView *headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
    [headImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 25.f;
    headImageView.image = [UIImage imageNamed:@"Account_bitmap_user"];
    _headImageView = headImageView;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:4];
    [nameLabel autoSetDimensionsToSize:CGSizeMake(200, 22)];
    [nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:headImageView];
    nameLabel.textColor = [UIColor colorWithHexString:@"#4d9fd4"];
    nameLabel.font = [UIFont textFontB2];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
    contentLabel.textColor = [UIColor evTextColorH1];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [contentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headImageView withOffset:4];
    [contentLabel autoSetDimension:ALDimensionWidth toSize:ScreenWidth - 86];
    [contentLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:16];
    [contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:nameLabel withOffset:6];
    
//    [EVLineView addCellBottomDefaultLineToView:self.contentView];
    EVLineView *lineView = [EVLineView new];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor evBackgroundColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [lineView autoSetDimension:ALDimensionHeight toSize:1.0f];
    
}


- (void)setVideoCommentModel:(EVHVVideoCommentModel *)videoCommentModel
{
    _videoCommentModel = videoCommentModel;
    
    [self.headImageView cc_setImageWithURLString:videoCommentModel.user_avatar placeholderImage:nil];
    [self.nameLabel setText:videoCommentModel.user_name];
    [self.contentLabel setText:videoCommentModel.content];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f]};
    
    CGSize nameSize = [videoCommentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 86, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
    
    videoCommentModel.cellHeight = nameSize.height+46;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
