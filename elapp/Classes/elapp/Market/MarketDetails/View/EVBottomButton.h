//
//  EVBottomButton.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/6.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EVBottomButtonDelegate <NSObject>

- (void)buttonItem:(UIButton *)btn tag:(NSInteger)tag;

@end

@interface EVBottomButton : UIButton

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) BOOL hideCountL;

- (void)updateIsCollec:(BOOL)iscollec bottomBtn:(EVBottomButton *)bottomBtn;

@property (nonatomic, weak) id <EVBottomButtonDelegate> delegate;
- (instancetype)initWithSelectImage:(UIImage *)image nomalImg:(UIImage *)nomalImg selectTitle:(NSString *)selecttitle nomalTitle:(NSString *)title;

@end
