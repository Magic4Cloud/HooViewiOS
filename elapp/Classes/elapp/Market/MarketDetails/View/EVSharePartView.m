//
//  EVSharePartView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSharePartView.h"


@implementation EVSharePartView

#pragma mark - system action

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //add subView
        [self addSubview:self.containView];
        [_containView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_containView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_containView autoSetDimension:ALDimensionHeight toSize:169];
        [_containView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        [self.containView addSubview:self.eVWebViewShareView];
        
        [_eVWebViewShareView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_eVWebViewShareView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_eVWebViewShareView autoSetDimension:ALDimensionHeight toSize:110];
        [_eVWebViewShareView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        
        [self.containView addSubview:self.cancelBtn];
        [_cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:120];
        [_cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_cancelBtn autoSetDimension:ALDimensionHeight toSize:49];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor evMainColor];
        titleLabel.font = [UIFont textFontB2];
        titleLabel.text = @"取消";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelBtn addSubview:titleLabel];
        titleLabel.frame = CGRectMake((ScreenWidth - 60)/2, 0, 60, 49);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

#pragma mark - custom action
//取消分享按钮的点击事件
- (void)cancelBtnOnClick {
    if (self.cancelShareBlock) {
        self.cancelShareBlock();
    }
}


#pragma mark - lazy loading
- (UIView *)containView {
    if (!_containView) {
        _containView = [[UIView alloc] init];
        _containView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    }
    return _containView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.cancelShareBlock) {
        self.cancelShareBlock();
    }
}

- (EVWebViewShareView *)eVWebViewShareView {
    if (!_eVWebViewShareView) {
        _eVWebViewShareView = [[EVWebViewShareView alloc] init];
    }
    return _eVWebViewShareView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        _cancelBtn.backgroundColor = [UIColor redColor];
//        _cancelBtn.titleLabel.font = [UIFont textFontB2];
//        _cancelBtn.titleLabel.backgroundColor = [UIColor greenColor];
//        _cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_cancelBtn setTitleColor:[UIColor evMainColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
