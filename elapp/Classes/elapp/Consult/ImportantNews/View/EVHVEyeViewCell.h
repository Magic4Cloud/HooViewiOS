//
//  EVHVEyeViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/4.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVBaseNewsModel.h"

@protocol EVHVEyeViewDelegate <NSObject>

- (void)newsButton:(UIButton *)button;

- (void)moreButton:(UIButton *)button;

@end

@interface EVHVEyeViewCell : UITableViewCell


@property (nonatomic, weak) id<EVHVEyeViewDelegate> delegate;

@property (nonatomic, strong) NSArray *eyesArray;

@end
