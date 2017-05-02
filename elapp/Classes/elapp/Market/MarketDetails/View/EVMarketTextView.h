//
//  EVMarketTextView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/12.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^userCommentBlock)(NSString *content);

@interface EVMarketTextView : UIView

@property (nonatomic, copy) userCommentBlock commentBlock;

@property (nonatomic, weak) UITextField *inPutTextFiled;

@property (nonatomic, weak) UILabel *numLabel;

@property (nonatomic, weak) UIButton *sendButton;



@end
