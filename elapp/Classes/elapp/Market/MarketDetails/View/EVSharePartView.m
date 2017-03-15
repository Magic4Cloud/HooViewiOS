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
        [self.containView addSubview:self.eVWebViewShareView];
        [self.containView addSubview:self.cancelBtn];
        
        [_containView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_containView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 169)];
        [_containView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        
        [_eVWebViewShareView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_eVWebViewShareView autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [_eVWebViewShareView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 110)];
        
        
        [_cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:120];
        [_cancelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_cancelBtn autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 49)];
        
        
    }
    return self;
}

- (void)layoutSubviews {
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
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
//        _cancelBtn.frame = CGRectMake(0, 120, ScreenWidth, 49);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont textFontB2];
        [_cancelBtn setTitleColor:[UIColor evMainColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
