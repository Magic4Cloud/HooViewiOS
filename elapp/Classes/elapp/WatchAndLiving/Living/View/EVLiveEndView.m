//
//  EVLiveEndView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVLiveEndView.h"
#import <PureLayout.h>
#import "EVShadowButton.h"

#define kDefaultAnimationTime 0.4

#define CC_ABSOLUTE_IMAGE_W     414.0
#define CC_ABSOLUTE_IMAGE_H     736.0

@implementation EVLiveEndViewData

@end

@interface EVLiveEndView ()

@property (nonatomic,weak) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic,weak) UIButton *saveButton;
@property (weak, nonatomic) UIButton *deleteBtn;  /**< 删除按钮 */
@property (weak, nonatomic) UILabel *deleteLbl;  /**< 删除title */
@property (weak, nonatomic) UILabel *noSaveHintLbl;  /**< 不准保存原因的提示 */
@property (nonatomic, weak) UIImageView *backgroundImageView;

@end

@implementation EVLiveEndView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    
    // 删除
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = EVLiveEndViewReadingDestroyButton;
    [self addSubview:deleteButton];
    [deleteButton setTitle:kE_GlobalZH(@"delete_video") forState:UIControlStateNormal];
    [deleteButton setTitleColor:CCColor(175, 153, 188) forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:.05]];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
    deleteButton.layer.borderColor = CCColor(175, 153, 188).CGColor;
    deleteButton.layer.borderWidth = 1.f;
    deleteButton.layer.cornerRadius = 6.;
    [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:105.f/2.f];
    [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [deleteButton autoSetDimension:ALDimensionHeight toSize:40];
    self.deleteBtn = deleteButton;
    
    
    CGFloat saveButtonHeight = 40.f;
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.tag = EVLiveEndViewSaveVideoButton;
    [self addSubview:saveButton];
    [saveButton setTitle:kE_GlobalZH(@"save_video") forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
    saveButton.backgroundColor = CCColor(175, 153, 188);
    saveButton.layer.cornerRadius = 6.;
    saveButton.layer.masksToBounds = YES;
    [saveButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:deleteButton];
    [saveButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:deleteButton];
    [saveButton autoSetDimension:ALDimensionHeight toSize:saveButtonHeight];
    [saveButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:deleteButton withOffset:-20];
    self.saveButton = saveButton;
    
    
    UILabel *noSaveHintLbl = [[UILabel alloc] init];
    noSaveHintLbl.text = kE_GlobalZH(@"not_save_video");
    noSaveHintLbl.textColor = [UIColor whiteColor];
    noSaveHintLbl.font = [UIFont systemFontOfSize:13];
    [self addSubview:noSaveHintLbl];
    [noSaveHintLbl autoAlignAxis:ALAxisVertical toSameAxisOfView:saveButton];
    [noSaveHintLbl autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:saveButton withOffset:-15];
    noSaveHintLbl.hidden = YES;
    self.noSaveHintLbl = noSaveHintLbl;
    
    
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingIndicator.hidesWhenStopped = YES;
    [self addSubview:loadingIndicator];
    [loadingIndicator autoCenterInSuperview];
    self.loadingIndicator = loadingIndicator;
    
    for ( UIButton *btn in self.subviews )
    {
        if ( [btn isKindOfClass:[UIButton class]] )
        {
            [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)buttonDidClicked:(UIButton *)button
{
    if ( [self.delegate respondsToSelector:@selector(liveEndView:didClicked:)] )
    {
        [self.delegate liveEndView:self didClicked:button.tag];
    }
}

- (void)setLiveViewData:(EVLiveEndViewData *)liveViewData
{
    _liveViewData = liveViewData;
    self.deleteBtn.hidden = liveViewData.noCanKeepVideo;
    self.deleteLbl.hidden = liveViewData.noCanKeepVideo;
    self.noSaveHintLbl.hidden = !liveViewData.noCanKeepVideo;
    if ( liveViewData.noCanKeepVideo )
    {
        [self.saveButton setTitle:kE_GlobalZH(@"back_home") forState:UIControlStateNormal];
    }
    self.loadingIndicator.hidden = YES;
    [self updateAnimation];
}

- (void)updateAnimation
{
    [self.audienceCountLabel animationWithCount:self.liveViewData.audienceCount];
    [self.commentCountLabel animationWithCount:self.liveViewData.commentCount];
    [self.likeCountLabel animationWithCount:self.liveViewData.likeCount];
    [self.riceCountLabel animationWithCount:self.liveViewData.riceCount];
}


- (UIButton *)menuButtonWithTitle:(NSString *)title
{
    CGFloat buttonW = cc_absolute_x(180);
    CGFloat buttonH = cc_absolute_y(60);
    EVWhiteShadowButton *button = [[EVWhiteShadowButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:CCAppMainColor forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:CCLiveEndBaseViewBUTTONFont];
    [button autoSetDimensionsToSize:CGSizeMake(buttonW, buttonH)];
    
    return button;
}


- (void)show:(void(^)())complete {
    if (self.backgroundImage) {
        self.backgroundImageView.image = self.backgroundImage;
    }
    [self.loadingIndicator startAnimating];
    __block CGRect frame = self.frame;
    frame.origin.y = ScreenHeight;
    self.frame = frame;
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:kDefaultAnimationTime animations:^{
        frame.origin.y = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        //        [self updateAnimation];
        if (complete) {
            complete();
        }
    }];
    
    [self updateAnimation];
}

- (void)dismiss
{
    CGRect frame = self.frame;
    frame.origin.y = self.superview.bounds.size.height;
//    [UIView animateWithDuration:kDefaultAnimationTime animations:^{
        self.frame = frame;
//    }];
}
@end
