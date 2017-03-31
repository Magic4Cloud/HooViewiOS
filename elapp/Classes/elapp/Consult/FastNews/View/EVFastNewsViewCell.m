//
//  EVFastNewsViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVFastNewsViewCell.h"


@interface EVFastNewsViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *fastTipImage;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end


@implementation EVFastNewsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    
}

- (void)setFastNewsModel:(EVFastNewsModel *)fastNewsModel
{
    _fastNewsModel = fastNewsModel;
    UIImage *image = [fastNewsModel.importance integerValue] > 1 ?[UIImage imageNamed:@"ic_news_point"] :  [UIImage imageNamed:@"ic_news_flash"];
    [self.fastTipImage setImage:image];
    
    UIColor *timeColor = [fastNewsModel.importance integerValue] > 1 ? [UIColor colorWithHexString:@"#5f85d0"] : [UIColor evTextColorH2];
    UIColor *contentColor = [fastNewsModel.importance integerValue] > 1 ? [UIColor colorWithHexString:@"#5f85d0"] : [UIColor evTextColorH1];
    [self.timeLabel setTextColor:timeColor];
    [self.contentLabel setTextColor:contentColor];


    NSString *timeStr = [NSString stringWithFormat:@"%@",fastNewsModel.time];
    [self.timeLabel setText:[self compareCurrentTime:timeStr]];
    [self.contentLabel setText:fastNewsModel.body];

}

- (NSString *)compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = - timeInterval;
    //标准时间和北京时间差8个小时
//    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) < 24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else {
        result = [NSString stringWithFormat:@"%@/%@ %@",[str substringWithRange:NSMakeRange(5, 2)],[str substringWithRange:NSMakeRange(8, 2)],[str substringWithRange:NSMakeRange(11, 5)]];
    }
    
    return  result;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
