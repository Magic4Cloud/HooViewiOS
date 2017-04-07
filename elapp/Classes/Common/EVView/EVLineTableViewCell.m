//
//  EVLineTableViewCell.m
//  elapp
//
//  Created by 唐超 on 4/7/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVLineTableViewCell.h"

@implementation EVLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setNoShowLine:(BOOL)noShowLine
{
    _noShowLine = noShowLine;
    [self setNeedsDisplay];
}
#pragma mark - 绘制Cell分割线
- (void)drawRect:(CGRect)rect {
    if (_noShowLine) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(12, rect.size.height, rect.size.width-12*2, 1));
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
