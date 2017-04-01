//
//  EVHVCenterImageLiveViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/16.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVCenterImageLiveViewCell.h"
#import "EVUserTagsView.h"
#import "NSString+Extension.h"
#import "EVUserTagsModel.h"

@interface EVHVCenterImageLiveViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *followLabel;

@property (nonatomic, weak) EVUserTagsView *userTagsView;

@end

@implementation EVHVCenterImageLiveViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    EVUserTagsView *userTagsView = [[EVUserTagsView alloc] init];
    [self addSubview:userTagsView];
    self.userTagsView = userTagsView;
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:24];
    [userTagsView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:44];
    [userTagsView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [userTagsView autoSetDimension:ALDimensionHeight toSize:20];

}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    self.nameLabel.text  = [NSString stringWithFormat:@"%@的直播间",watchVideoInfo.nickname];

}


- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    if (!userModel) {
        return;
    }
     self.nameLabel.text  = [NSString stringWithFormat:@"%@的直播间",userModel.nickname];
    NSString *followC = [NSString numFormatNumber:userModel.follow_count];
    self.followLabel.text = [NSString stringWithFormat:@"%@人关注",followC];
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in userModel.tags) {
        [titleAry addObject:model.tagname];
    }
    self.userTagsView.dataArray = titleAry.mutableCopy;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
