//
//  EVHotImageListViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/13.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHotImageListViewCell.h"
#import "NSString+Extension.h"
#import "EVUserTagsModel.h"

@interface EVHotImageListViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end


@implementation EVHotImageListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 30;
    _headImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo
{
    _watchVideoInfo = watchVideoInfo;
    self.nameLabel.text = [NSString stringWithFormat:@"%@的直播间",watchVideoInfo.nickname];

    [self.headImageView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    self.introduceLabel.text = watchVideoInfo.signature;
    
}




- (void)setLiveVideoInfo:(EVWatchVideoInfo *)liveVideoInfo
{
    _liveVideoInfo = liveVideoInfo;
    
    NSString *followCount = [NSString numFormatNumber:liveVideoInfo.viewcount];
    self.watchCountLabel.text = [NSString stringWithFormat:@"%@人参与",followCount];
}
@end
