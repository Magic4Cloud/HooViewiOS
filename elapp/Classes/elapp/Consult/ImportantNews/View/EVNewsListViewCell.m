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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setConsultNewsModel:(EVNewsModel *)consultNewsModel
{
    [self.newsBackImage cc_setImageWithURLString:consultNewsModel.cover[0] placeholderImage:nil];
    self.newsTitleLabel.text = consultNewsModel.title;
    NSString *timeStr = [NSString stringWithFormat:@"%@",consultNewsModel.time];
    timeStr =   [timeStr substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeLbl = [NSString stringWithFormat:@"%@",consultNewsModel.time];
    NSString *lTime = [NSString stringWithFormat:@"%@/%@",[timeLbl substringWithRange:NSMakeRange(5, 2)],[timeLbl substringWithRange:NSMakeRange(8, 2)]];
    if (![currentDateStr isEqualToString:timeStr]) {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"%@",lTime];
        
    }else {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"今天 %@",[timeLbl substringWithRange:NSMakeRange(11, 5)]];
    }
    self.newsReadLabel.text = [NSString stringWithFormat:@" %@",[consultNewsModel.viewCount thousandsSeparatorString]];
    
}


- (void)setSearchNewsModel:(EVBaseNewsModel *)searchNewsModel
{
    _searchNewsModel = searchNewsModel;
    [self.newsBackImage cc_setImageWithURLString:searchNewsModel.cover placeholderImage:nil];
    self.newsTitleLabel.text = searchNewsModel.title;
    NSString *timeStr = [NSString stringWithFormat:@"%@",searchNewsModel.time];
    timeStr =   [timeStr substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeLbl = [NSString stringWithFormat:@"%@",searchNewsModel.time];
    NSString *lTime = [NSString stringWithFormat:@"%@/%@",[timeLbl substringWithRange:NSMakeRange(5, 2)],[timeLbl substringWithRange:NSMakeRange(8, 2)]];
    if (![currentDateStr isEqualToString:timeStr]) {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"%@",lTime];
        
    }else {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"今天 %@",[timeLbl substringWithRange:NSMakeRange(11, 5)]];
    }
    self.newsReadLabel.text = [NSString stringWithFormat:@" %@",[searchNewsModel.viewCount thousandsSeparatorString]];
    
}


- (void)setEyesModel:(EVHVEyesModel *)eyesModel
{
    _eyesModel = eyesModel;
    [self.newsBackImage cc_setImageWithURLString:eyesModel.cover placeholderImage:[UIImage imageNamed:@"Account_bitmap_list"]];
    self.newsTitleLabel.text = eyesModel.title;
    NSString *timeStr = [NSString stringWithFormat:@"%@",eyesModel.time];
    timeStr =   [timeStr substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeLbl = [NSString stringWithFormat:@"%@",eyesModel.time];
    NSString *lTime = [NSString stringWithFormat:@"%@/%@",[timeLbl substringWithRange:NSMakeRange(5, 2)],[timeLbl substringWithRange:NSMakeRange(8, 2)]];
    if (![currentDateStr isEqualToString:timeStr]) {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"%@",lTime];
        
    }else {
        self.newsTimeLabel.text = [NSString stringWithFormat:@"今天 %@",[timeLbl substringWithRange:NSMakeRange(11, 5)]];
    }
    self.newsReadLabel.text = [NSString stringWithFormat:@"%@",[eyesModel.viewCount thousandsSeparatorString]];
    
}


- (void)setCollectNewsModel:(EVBaseNewsModel *)collectNewsModel
{
    _collectNewsModel = collectNewsModel;
}
@end
