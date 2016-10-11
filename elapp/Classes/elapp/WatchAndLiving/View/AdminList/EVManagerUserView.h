//
//  EVManagerUserView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EVUserModel.h"
@protocol AlertDelegate <NSObject>

- (void)reportWithReason:(UIButton *)reason reportTitle:(NSString *)reportTitle;

@end

@interface EVManagerUserView : UIView
+ (instancetype)shareSheet;
@property (nonatomic,assign) id<AlertDelegate> delegate;
@property (nonatomic,strong) EVUserModel *userModel;
@property (nonatomic,strong)NSArray *reportArray;
@property (nonatomic,copy)NSString *reportTitle;
- (void)showAnimationViewArray:(NSArray *)array reportTitle:(NSString *)reportTitle  delegate:(id)delegate;
- (void)hideActionWindow;
@end
