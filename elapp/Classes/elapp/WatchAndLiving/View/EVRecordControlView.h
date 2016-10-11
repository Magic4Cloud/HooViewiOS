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

@protocol CCRecordControlViewDelegate <NSObject>

/**
 *  @author zhaoyunlong, 16-04-14 18:02:43
 *
 *  点击按钮的回调
 *
 *  @param button 被点击的按钮
 */
- (void)watchBottomViewBtnClick:(UIButton *)button;

- (void)recordInfoViewDidAutoHidden:(id)recordInfoView;
- (void)recordInfoView:(id)recordInfoView didClickButton:(UIButton *)btn;
- (void)recordInfoViewDidDragToNewProgress:(double)progress;
- (void)recordInfoViewDidBeginDrag:(id)recordInfoView;
//- (void)recordInfoView:(id)recordInfoView valueChaged:(float)value;

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
@property ( nonatomic, weak ) id<CCRecordControlViewDelegate> delegate;

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
