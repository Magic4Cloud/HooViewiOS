//
//  EVBaseLoginView.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVBaseLoginView.h"


@interface EVBaseLoginView ()

@end

@implementation EVBaseLoginView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
     
    }
    return self;
}

- (IBAction)closeButton:(id)sender {
    if (self.closeClick) {
        self.closeClick(sender);
    }
}


@end
