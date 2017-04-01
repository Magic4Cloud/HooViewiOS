//
//  EVConsumptionDetailsViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/25.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVConsumptionDetailsViewCell.h"



@interface EVConsumptionDetailsViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dayMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@end


@implementation EVConsumptionDetailsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}


- (void)setListItemModel:(EVRecordlistItemModel *)listItemModel
{
    _listItemModel = listItemModel;
    NSString *monthStr = [listItemModel.time substringWithRange:NSMakeRange(5, 2)];//截取范围类的字符串
    NSString *dayStr = [listItemModel.time substringWithRange:NSMakeRange(8, 2)];
    NSString *mStr = [NSString stringWithFormat:@"%@/%@",monthStr,dayStr];
    self.dayMonthLabel.text = [self contrastDateIsDayNow:[self getCurrentTimes] serverData:listItemModel.time] == YES ? @"今天" :mStr;
    if (![listItemModel.time isEqualToString:@""] && listItemModel.time != nil) {
        NSString *timeStr = [listItemModel.time substringWithRange:NSMakeRange(11, 5)];//截取范围类的字符串
//        NSString *dayStr = [listItemModel.time substringWithRange:NSMakeRange(1, 2)];
        self.timeLabel.text = timeStr;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%ld",listItemModel.ecoin];
    
  
}

- (void)setType:(EVDetailType)type
{
    _type = type;
    switch (type) {
        case EVDetailType_prepaid:
        {
            self.contentLabel.text = _listItemModel.descriptionss;
            self.symbolLabel.text = @"火眼豆";
        }
            break;
        case EVDetailType_withdrawal:
        {
//            self.contentLabel.text = @"提现";
            self.symbolLabel.text = @"火眼币";
        }
            break;
        default:
            break;
    }
}


- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

- (BOOL)contrastDateIsDayNow:(NSString *)nowData serverData:(NSString *)serverData
{
    NSString *nMonthStr = [nowData substringWithRange:NSMakeRange(5, 2)];//截取范围类的字符串
    NSString *nDayStr = [nowData substringWithRange:NSMakeRange(8, 2)];
    
    NSString *monthStr = [serverData substringWithRange:NSMakeRange(5, 2)];//截取范围类的字符串
    NSString *dayStr = [serverData substringWithRange:NSMakeRange(8, 2)];
    
    if ([nMonthStr isEqualToString:monthStr] && [dayStr isEqualToString:nDayStr]) {
        return YES;
    }else {
        return NO;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
