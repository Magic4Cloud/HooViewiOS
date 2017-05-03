//
//  EVStockDetailBottomView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger , EVBottomButtonType){
    EVBottomButtonTypeAdd = 1000,
    EVBottomButtonTypeShare,
    EVBottomButtonTypeRefresh,
    EVBottomButtonTypeComment,
};

@protocol EVStockDetailBottomViewDelegate <NSObject>

- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn;

@end

@interface EVStockDetailBottomView : UIView


@property (nonatomic, weak) id <EVStockDetailBottomViewDelegate> delegate;

- (void)addButtonTitleArray:(NSArray *)title seleteTitleArr:(NSArray *)seletetitle imageArray:(NSArray *)image seleteImage:(NSArray *)seleteimage;


@property (nonatomic, copy) void(^backButtonClickBlock)();

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) BOOL isCollec;

@property (nonatomic, assign) BOOL isMarketCollect;

@property (nonatomic, assign) BOOL isBottomBack;

- (instancetype)initWithFrame:(CGRect)frame isBottomBack:(BOOL)isBottom;
@end
