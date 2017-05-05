//
//  EVNewsListViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsListViewCell.h"
#import "EVNewsModel.h"
@implementation EVNewsListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if (ScreenWidth == 320) {
        _newsTimeLabel.font = [UIFont systemFontOfSize:12];
        _newsReadLabel.font = [UIFont systemFontOfSize:12];
        _leading.constant = -8;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConsultNewsModel:(EVNewsModel *)consultNewsModel
{
    [self.newsBackImage cc_setImageWithURLString:consultNewsModel.cover[0] placeholderImage:nil];
    self.newsTitleLabel.text = consultNewsModel.title;
    self.newsTimeLabel.text = consultNewsModel.time;
    self.newsReadLabel.text = [NSString stringWithFormat:@" %@",[consultNewsModel.viewCount thousandsSeparatorStringNoMillion]];
    
}


- (void)setSearchNewsModel:(EVBaseNewsModel *)searchNewsModel
{
    _searchNewsModel = searchNewsModel;
    [self.newsBackImage cc_setImageWithURLString:searchNewsModel.cover placeholderImage:nil];
    self.newsTitleLabel.text = searchNewsModel.title;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",searchNewsModel.time];
    self.newsTimeLabel.text = [timeStr timeFormatter];
    self.newsReadLabel.text = [NSString stringWithFormat:@" %@",[searchNewsModel.viewCount thousandsSeparatorStringNoMillion]];
    
}


- (void)setEyesModel:(EVHVEyesModel *)eyesModel
{
    _eyesModel = eyesModel;
    [self.newsBackImage cc_setImageWithURLString:eyesModel.cover placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
    self.newsTitleLabel.text = eyesModel.title;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",eyesModel.time];
    self.newsTimeLabel.text = [timeStr timeFormatter];
    self.newsReadLabel.text = [NSString stringWithFormat:@"%@",[eyesModel.viewCount thousandsSeparatorStringNoMillion]];
    
}


- (void)setCollectNewsModel:(EVBaseNewsModel *)collectNewsModel
{
    _collectNewsModel = collectNewsModel;
}
@end
