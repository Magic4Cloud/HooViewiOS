//
//  EVThreeImageCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVThreeImageCell.h"
#import "EVNewsModel.h"
@implementation EVThreeImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setNewsModel:(EVNewsModel *)newsModel
{
    _newsModel = newsModel;
    
    _cellDateLabel.text = newsModel.time;
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",newsModel.time];
    timeStr =   [timeStr substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeLbl = [NSString stringWithFormat:@"%@",newsModel.time];
    NSString *lTime = [NSString stringWithFormat:@"%@/%@",[timeLbl substringWithRange:NSMakeRange(5, 2)],[timeLbl substringWithRange:NSMakeRange(8, 2)]];
    if (![currentDateStr isEqualToString:timeStr])
    {
        _cellDateLabel.text = [NSString stringWithFormat:@"%@",lTime];
        
    }
    else
    {
        _cellDateLabel.text = [NSString stringWithFormat:@"今天 %@",[timeLbl substringWithRange:NSMakeRange(11, 5)]];
    }
    
    _cellTitleLabel.text = newsModel.title;
    _cellViewCountLabel.text = [newsModel.viewCount thousandsSeparatorString];
    
    [_cellImageView1 cc_setImageWithURLString:newsModel.cover[0] placeholderImage:nil];
    [_cellImageView2 cc_setImageWithURLString:newsModel.cover[1] placeholderImage:nil];
    [_cellImageView3 cc_setImageWithURLString:newsModel.cover[2] placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
