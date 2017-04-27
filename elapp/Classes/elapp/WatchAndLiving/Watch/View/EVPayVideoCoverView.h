//
//  EVPayVideoCoverView.h
//  elapp
//
//  Created by 唐超 on 4/25/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 付费直播 覆盖view
 */
@interface EVPayVideoCoverView : UIView
@property (weak, nonatomic) IBOutlet UILabel * viewPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton * viewPayButton;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (nonatomic, copy)void(^payButtonClickBlock)(void);
@property (nonatomic, copy)void(^backButtonClickBlock)(void);
@end
