//
//  EVVideoPayBottomView.h
//  elapp
//
//  Created by 唐超 on 4/25/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVUserAsset;
/**
 付费视频  付费弹窗
 */
@interface EVVideoPayBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *viewTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewBeansShortLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewchargeButton;
@property (nonatomic, strong) EVUserAsset * assetModel;
@property (nonatomic, assign) NSInteger payFee;

@property (nonatomic, copy)void(^payOrChargeButtonClick)(EVVideoPayBottomView * view);
- (void)dismissPayView;
- (void)showPayViewWithPayFee:(NSInteger )fee userAssetModel:(EVUserAsset *)assetModel addtoView:(UIView *)view;
@end
