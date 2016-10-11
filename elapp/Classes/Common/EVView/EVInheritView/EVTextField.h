//
//  EVTextField.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVTextField;

@protocol EVTextFieldDelegate <NSObject>

@optional

/**
 * 点击了删除键
 * @param   textfield   按下删除键，还没有删除文字时的textfield
 */
- (void)backspacePressedBeforeDeleting:(NSString *)deleteBeforeStr afterDeleting:(NSString *)afterDeleteStr;

@end

@interface EVTextField : UITextField

@property (weak, nonatomic) id<EVTextFieldDelegate> customeDelegate;   /**< 代理 */

@end
