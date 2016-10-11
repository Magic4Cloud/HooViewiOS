//
//  EVTextViewWithPlaceHolderAndClearButton.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EVTextViewWithPlaceHolderAndClearButton : UITextView

/*
 * placeHolder - 设置 placeHolder 显示的内容
 * hidePlaceHolder - 控制 placeHolder 的隐藏和显示，默认为 NO（显示），YES 为隐藏
 */
@property (copy, nonatomic) NSString *placeHolder;
@property (assign, nonatomic) BOOL hidePlaceHolder;

@end
