//
//  EVLiveImageTextView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/17.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVLiveImageBottomViewDelegate <NSObject>

- (void)showKeyBoardClick;

@end

@interface EVLiveImageBottomTextView : UIView


@property (nonatomic, weak) id<EVLiveImageBottomViewDelegate> delegate;
@end
