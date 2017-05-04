//
//  EVSendImageView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/20.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVSendImageView.h"
#import "SGSegmentedControl.h"
#import "CCVerticalLayoutButton.h"

@interface EVSendImageView ()<SGSegmentedControlStaticDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, strong) UIButton *imageButton;



@end


@implementation EVSendImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    
    NSArray *titleArray = @[@"普通",@"高亮",@"置顶"];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, 150, 36) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        *segmentedControlStaticType = SGSegmentedControlStaticTypeBigTitle;
    }];
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor clearColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor colorWithHexString:@"#b04242"];
        *indicatorColor = [UIColor clearColor];
    }];
    self.topSView.selectedIndex = 0;
    [self addSubview:_topSView];
    
    
    UIButton *imageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:imageButton];
    [imageButton setImage:[UIImage imageNamed:@"btn_word_n_message"] forState:(UIControlStateNormal)];
    [imageButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [imageButton autoSetDimension:ALDimensionWidth toSize:54];
    [imageButton autoSetDimension:ALDimensionHeight toSize:36];
//    [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    imageButton.hidden = YES;
    
    
    
    UIView *imageButtonBottom = [[UIView alloc] init];
    [self addSubview:imageButtonBottom];
    [imageButtonBottom autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [imageButtonBottom autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [imageButtonBottom autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imageButton];
    self.imageButtonBottonHig =  [imageButtonBottom autoSetDimension:ALDimensionHeight toSize:105];
    self.imageButtonBottom = imageButtonBottom;
   
    
    
    // cameraButton
    CCVerticalLayoutButton *cameraButton = [CCVerticalLayoutButton buttonWithType:UIButtonTypeCustom];
    cameraButton.tag = 1000;
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont textFontB2];
    [cameraButton setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    [cameraButton setImage:[UIImage imageNamed:@"chatroom_icon_camera"] forState:UIControlStateNormal];
    [imageButtonBottom addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(chooseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cameraBtn = cameraButton;
    cameraButton.hidden = YES;
    
    // photoButton
    CCVerticalLayoutButton *photoButton = [CCVerticalLayoutButton buttonWithType:UIButtonTypeCustom];
    photoButton.tag = 1001;
    [photoButton setTitle:@"照片" forState:UIControlStateNormal];
    photoButton.titleLabel.font = [UIFont textFontB2];
    [photoButton setTitleColor:[UIColor evTextColorH2] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"chatroom_icon_photo"] forState:UIControlStateNormal];
    [imageButtonBottom addSubview:photoButton];
    [photoButton addTarget:self action:@selector(chooseButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.photoBtn  = photoButton;
    photoButton.hidden = YES;
    
    CGFloat buttonW = ScreenWidth/375*48;
    CGRect buttonFrame = CGRectMake(0, 18, buttonW, buttonW+ScreenWidth/375*20);
    
    for (NSInteger i = 0; i < imageButtonBottom.subviews.count; i++)
    {
        UIView *subView = imageButtonBottom.subviews[i];
        buttonFrame.origin.x = ScreenWidth/375*21.5 + (buttonW+ScreenWidth/375*23) * i;
        subView.frame = buttonFrame;
    }
}


- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(SGSegmentedIndex:)]) {
        [self.delegate SGSegmentedIndex:index];
    }
}
- (void)imageButtonClick:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseImageButton:)]) {
        [self.delegate chooseImageButton:btn];
    }
}

- (void)chooseButton:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseButton:)]) {
        [self.delegate chooseButton:btn];
    }
}
@end
