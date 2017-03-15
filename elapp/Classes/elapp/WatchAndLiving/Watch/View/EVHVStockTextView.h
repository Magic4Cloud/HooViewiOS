//
//  EVHVStockTextView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EVHVStockTextViewDelegate <NSObject>

- (void)searchButton;

@end

@interface EVHVStockTextView : UIView

@property (nonatomic, weak) id<EVHVStockTextViewDelegate> delegate;

@property (nonatomic, weak) UITextField *stockTextFiled;
@end
