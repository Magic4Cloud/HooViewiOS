//
//  EVHVMessageCellModel.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/10.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVMessageCellModel.h"



@implementation EVHVMessageCellModel


- (void)setMessage:(EVMessage *)message
{
    _message = message;
    CGFloat nameX = ChatMargin;
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:16.f]};
  
    CGSize nameSize = [_message.nameStr boundingRectWithSize:CGSizeMake(ScreenWidth - nameSize.width - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
      CGSize contentSize = [_message.contentStr boundingRectWithSize:CGSizeMake(ScreenWidth - nameSize.width - 50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
    CGFloat contentX = ChatMargin + nameSize.width + 15;
    
    
    if (message.messageFrom == EVMessageFromMe) {
        contentX = ScreenWidth - nameSize.width - 45 - (contentSize.width);
    }
    if (message.messageFrom == EVMessageFromMe) {
        nameX = ScreenWidth - ChatMargin - nameSize.width;
    }
    _nameF = CGRectMake(nameX, 5, nameSize.width + 10, nameSize.height + 6);
    _contentF = CGRectMake(contentX, 0, contentSize.width + 25, contentSize.height+20);
    _cellHeight =  MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
    NSDictionary *tipDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.f]};
     CGSize tipSize = [_message.contentStr boundingRectWithSize:CGSizeMake(ScreenWidth - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:tipDict context:nil].size;
    
    if (message.messageFrom == EVMessageFromSystem) {
        _cellHeight = tipSize.height + 20;
        _tipLabelF = CGRectMake(20, 10, ScreenWidth - 40, tipSize.height);
    }

}

@end
