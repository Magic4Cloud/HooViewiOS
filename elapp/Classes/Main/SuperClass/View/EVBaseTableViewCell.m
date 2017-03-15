//
//  EVBaseTableViewCell.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/21.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseTableViewCell.h"
#import "EVLineView.h"

@implementation EVBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addLineView];
    }
    return self;
}

- (void)addLineView
{
    
    [EVLineView addCellTopDefaultLineToView:self];
}

@end
