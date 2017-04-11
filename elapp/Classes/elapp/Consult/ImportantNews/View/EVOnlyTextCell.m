//
//  EVOnlyTextCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVOnlyTextCell.h"
#import "EVNewsModel.h"
@implementation EVOnlyTextCell

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
    
    _cellContentLabel.text = newsModel.title;
    _cellViewCountLabel.text = newsModel.viewCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
