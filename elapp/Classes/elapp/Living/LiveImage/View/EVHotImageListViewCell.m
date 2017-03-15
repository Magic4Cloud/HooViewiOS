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
@property (weak, nonatomic) IBOutlet UILabel *oneTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchCountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneTagWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoTagWid;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *threeTagWid;

@end


@implementation EVHotImageListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
    NSString *viewCount = [NSString numFormatNumber:watchVideoInfo.viewcount];
    
    [self.headImageView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in watchVideoInfo.tags) {
        [titleAry addObject:model.tagname];
    }
    [self labelAddTextDataArray:titleAry];
    NSString *followCount = [NSString numFormatNumber:watchVideoInfo.follow_count];
    self.watchCountLabel.text = [NSString stringWithFormat:@"%@人关注",followCount];
}

- (void)labelAddTextDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count <= 0) {
        self.oneTagLabel.hidden = YES;
        self.twoTagLabel.hidden = YES;
        self.threeTagLabel.hidden = YES;
    }else if (dataArray.count == 1) {
        self.twoTagLabel.hidden = YES;
        self.threeTagLabel.hidden = YES;
        self.oneTagLabel.hidden = NO;
        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count == 2) {
        
        self.twoTagLabel.hidden = NO;
        self.threeTagLabel.hidden = YES;
        self.oneTagLabel.hidden = NO;
        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width + 10;
        self.twoTagWid.constant = [self.twoTagLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count >= 3) {
        
        self.twoTagLabel.hidden = NO;
        self.threeTagLabel.hidden = NO;
        self.oneTagLabel.hidden = NO;
        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.threeTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[2]];
        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width+10;
        self.twoTagWid.constant = [self.twoTagLabel sizeThatFits:CGSizeZero].width+10;
        self.threeTagWid.constant = [self.threeTagLabel sizeThatFits:CGSizeZero].width+10;
    }
}



- (void)setLiveVideoInfo:(EVWatchVideoInfo *)liveVideoInfo
{
    _liveVideoInfo = liveVideoInfo;

}
@end
