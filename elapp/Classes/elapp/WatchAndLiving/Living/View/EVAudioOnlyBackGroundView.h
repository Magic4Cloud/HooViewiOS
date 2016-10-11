//
//  EVAudioOnlyBackGroundView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
@class EVAudioOnlyCollectionViewCellItem, EVAudioOnlyBackGroundView;

@protocol CCAudioOnlyBackGroundViewDelegate <NSObject>

@optional
- (void)audioOnlyBackGroundViewDidClickComfirm:(EVAudioOnlyBackGroundView *)view;

@end

@interface EVAudioOnlyBackGroundView : UIView

@property (nonatomic,weak) id<CCAudioOnlyBackGroundViewDelegate> delegate;

@property (nonatomic,strong) EVAudioOnlyCollectionViewCellItem *selectedItem;

@property (nonatomic,weak) NSLayoutConstraint *marginSuperViewTop;

- (void)show;
- (void)dismiss;

@end
