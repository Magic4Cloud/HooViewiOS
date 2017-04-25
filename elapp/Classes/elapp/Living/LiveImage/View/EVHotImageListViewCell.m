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
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end


@implementation EVHotImageListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 40;
    _headImageView.layer.masksToBounds = YES;
    _oneTagLabel.layer.cornerRadius = 4;
    _oneTagLabel.clipsToBounds = YES;
    _oneTagLabel.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _oneTagLabel.textColor = [UIColor colorWithHexString:@"#4281AD"];
    _oneTagLabel.font = [UIFont systemFontOfSize:ScreenWidth == 320?12:14];
    
    _oneTagLabel.textAlignment = NSTextAlignmentCenter;
    
    _twoTagLabel.layer.cornerRadius = 4;
    _twoTagLabel.clipsToBounds = YES;
    _twoTagLabel.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _twoTagLabel.textColor = [UIColor colorWithHexString:@"#4281AD"];
    _twoTagLabel.font = [UIFont systemFontOfSize:ScreenWidth == 320?12:14];
    _twoTagLabel.textAlignment = NSTextAlignmentCenter;
    
    _threeTagLabel.layer.cornerRadius = 4;
    _threeTagLabel.clipsToBounds = YES;
    _threeTagLabel.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _threeTagLabel.textColor = [UIColor colorWithHexString:@"#4281AD"];
    _threeTagLabel.font = [UIFont systemFontOfSize:ScreenWidth == 320?12:14];
    _threeTagLabel.textAlignment = NSTextAlignmentCenter;
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
    //NSString *viewCount = [NSString numFormatNumber:watchVideoInfo.viewcount];
    
    [self.headImageView cc_setImageWithURLString:watchVideoInfo.logourl placeholderImage:[UIImage imageNamed:@"Account_bitmap_user"]];
    
    NSMutableArray *titleAry = [NSMutableArray array];
    for (EVUserTagsModel *model in watchVideoInfo.tags) {
        [titleAry addObject:model.tagname];
    }
    [self labelAddTextDataArray:titleAry];
    
    self.introduceLabel.text = watchVideoInfo.signature;
    NSString *followCount = [NSString numFormatNumber:watchVideoInfo.viewcount];
    self.watchCountLabel.text = [NSString stringWithFormat:@"%@人参与",followCount];
}

- (void)labelAddTextDataArray:(NSMutableArray *)dataArray
{
    self.oneTagLabel.hidden = YES;
    self.twoTagLabel.hidden = YES;
    self.threeTagLabel.hidden = YES;
    
    
//    if (dataArray.count <= 0) {
//        self.oneTagLabel.hidden = YES;
//        self.twoTagLabel.hidden = YES;
//        self.threeTagLabel.hidden = YES;
//    }else if (dataArray.count == 1) {
//        self.twoTagLabel.hidden = YES;
//        self.threeTagLabel.hidden = YES;
//        self.oneTagLabel.hidden = NO;
//        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
//        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width + 10;
//        
//    }else if (dataArray.count == 2) {
//        
//        self.twoTagLabel.hidden = NO;
//        self.threeTagLabel.hidden = YES;
//        self.oneTagLabel.hidden = NO;
//        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
//        self.twoTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
//        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width + 10;
//        self.twoTagWid.constant = [self.twoTagLabel sizeThatFits:CGSizeZero].width + 10;
//        
//    }else if (dataArray.count >= 3) {
//        
//        self.twoTagLabel.hidden = NO;
//        self.threeTagLabel.hidden = NO;
//        self.oneTagLabel.hidden = NO;
//        self.oneTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
//        self.twoTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
//        self.threeTagLabel.text = [NSString stringWithFormat:@"%@",dataArray[2]];
//        self.oneTagWid.constant = [self.oneTagLabel sizeThatFits:CGSizeZero].width+10;
//        self.twoTagWid.constant = [self.twoTagLabel sizeThatFits:CGSizeZero].width+10;
//        self.threeTagWid.constant = [self.threeTagLabel sizeThatFits:CGSizeZero].width+10;
//    }
}



- (void)setLiveVideoInfo:(EVWatchVideoInfo *)liveVideoInfo
{
    _liveVideoInfo = liveVideoInfo;

}
@end
