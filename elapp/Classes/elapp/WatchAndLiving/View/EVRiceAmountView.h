//
//  EVRiceAmountView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVRiceAmountView;

@protocol CCRiceAmountViewDelegate <NSObject>

- (void)riceAmoutViewDidSelect;

@end

@interface EVRiceAmountView : UIView

/** delegate */
@property (nonatomic, assign) id<CCRiceAmountViewDelegate> delegate;

/** 上次直播结束总的云票数 */
@property (nonatomic, assign)unsigned long long lasttimeRiceCount;

/** 数量 */
@property (nonatomic, assign)unsigned long long riceAmount;

@end
