//
//  EVHVTLWatchBtnView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/25.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVHVLWatchViewDelegate <NSObject>

- (void)buttonTag:(UIButton *)tag;

@end

@interface EVHVTLWatchBtnView : UIView

@property (nonatomic, weak) id<EVHVLWatchViewDelegate> delegate;

@end
