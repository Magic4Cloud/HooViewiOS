//
//  EVHVCenterCommentTableViewCell.m
//  elapp
//
//  Created by 周恒 on 2017/4/24.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterCommentTableViewCell.h"

@interface EVHVCenterCommentTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *titleBackView;

@property (weak, nonatomic) IBOutlet UIImageView *cellTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *cellTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UILabel *numberOfLikeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


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
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
