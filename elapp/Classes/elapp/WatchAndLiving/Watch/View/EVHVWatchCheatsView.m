//
//  EVHVWatchCheatsView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchCheatsView.h"
#import "EVNotOpenView.h"


@implementation EVHVWatchCheatsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
    }
    return self;
}


- (void)addUpViewFrame:(CGRect)frame
{
    EVNotOpenView *openView = [[EVNotOpenView alloc] init];
    [self addSubview:openView];
    [openView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}
@end
