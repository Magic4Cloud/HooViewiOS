//
//  EVSpeciaColumnModel.m
//  elapp
//
//  Created by 周恒 on 2017/4/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSpeciaColumnModel.h"


@implementation EVSpeciaColumnModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"newsID":@"id",
             };
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    _cellHeight = 100;
    NSString *string = dic[@"title"];
    _cellWidth = (ScreenWidth - 36) / 2 - 20;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont textFontB2],
                                  NSParagraphStyleAttributeName: paragraphStyle};

    CGSize contentSize = [string boundingRectWithSize:CGSizeMake((ScreenWidth - 36) / 2 - 20 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attributes context:nil].size;
    NSLog(@"cont = %@",NSStringFromCGSize(contentSize));
    
    
    _cellHeight = contentSize.height + 90 + ((ScreenWidth - 36) / 2 - 20) * 10 / 17 + 20;
    return YES;
}





@end




