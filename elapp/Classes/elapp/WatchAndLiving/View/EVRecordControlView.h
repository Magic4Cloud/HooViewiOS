//
//  EVRecordControlView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>

#define RECORD_BTN_BACK             100
#define RECORD_BTN_FORWARD          101
#define RECORD_BTN_PALY_OR_PAUSE    102

@protocol EVRecordControlViewDelegate <NSObject>


- (void)recordInfoViewDidDragToNewProgress:(double)progress;
- (void)recordInfoViewDidBeginDrag:(id)recordInfoView;

@end

@interface EVControlSlider : UISlider
{
    CGRect lastBounds;
}

@property (nonatomic,strong) UIColor *bufferProgressColor;

@property (nonatomic, assign) CGFloat bufferProgress;

@end

@interface EVRecordControlView : UIView

/** 代理 */
@property ( nonatomic, weak ) id<EVRecordControlViewDelegate> delegate;

/** 礼物 */
@property ( nonatomic, weak, readonly ) UIButton *giftButtton;

/** 分享 */
@property ( nonatomic, weak, readonly ) UIButton *shareButton;

@property (nonatomic, assign) CGFloat maxProgress;

@property (nonatomic, assign) CGFloat currProgress;

@property (nonatomic, assign) CGFloat bufferProgress;

@property (nonatomic, assign) BOOL pause;

/** 因为要对commentTableView的约束进行修改，会影响到这个视图的约束
    所以要先修改完commentTableView的约束再进行布局 */
- (void)setUp;

@end
