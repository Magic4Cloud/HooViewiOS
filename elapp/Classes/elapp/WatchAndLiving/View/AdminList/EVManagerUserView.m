//
//  EVManagerUserView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVManagerUserView.h"
#import "EVBaseToolManager+EVLiveAPI.h"

#define cellHeight 47
@interface EVManagerUserView ()
@property (nonatomic,strong)UIWindow *sheetWindow;
@property (nonatomic,strong)UIView *sheetView;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;
@property (nonatomic,strong)UIView *selectView;
@property (nonatomic,strong)UILabel *reportLabel;
/** 网络请求工具 */
@property (nonatomic, weak) EVBaseToolManager *engine;

///** 视频消息服务器：包括了点赞、评论、观众进出等内容 */
//@property (nonatomic, strong) EVLiveMessageEngine *chatServer;
@end

@implementation EVManagerUserView
- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    
    
    
}
+ (instancetype)shareSheet
{
    static id shareSheet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareSheet = [[[self class]alloc]init];
        
    });
    return shareSheet;
}
- (void)showAnimationViewArray:(NSArray *)array reportTitle:(NSString *)reportTitle delegate:(id)delegate
{
    self.reportArray = [NSArray arrayWithArray:array];
    self.reportTitle = reportTitle;
    self.delegate = delegate;
    if (!_sheetWindow) {
        [self setUpView];
    }
    _sheetWindow.hidden = NO;
    [self showSheetAnimation];
}
- (UIWindow *)sheetWindow
{
    if (_sheetWindow == nil) {
        _sheetWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _sheetWindow.backgroundColor = [UIColor clearColor];
        _sheetWindow.hidden = YES;
    }
    return _sheetWindow;
}
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _backView;
}
- (UITapGestureRecognizer *)tapGesture
{
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        _tapGesture.numberOfTapsRequired  =1;
        
    }
    return _tapGesture;
}
- (void)setUpView
{
    [self.sheetWindow addSubview:self.backView];

    [self.backView addGestureRecognizer:self.tapGesture];
    
    [self.sheetWindow addSubview:self.selectView];
}
- (UIView *)selectView
{
    if (_selectView == nil) {
        _selectView = [self creatSelectButton];
    }
    return _selectView;
}
- (UILabel *)reportLabel
{
    if (_reportLabel == nil) {
        _reportLabel = [[UILabel alloc]init];
        _reportLabel.frame = CGRectMake(0, 0, ScreenWidth, cellHeight);
        _reportLabel.textAlignment = NSTextAlignmentCenter;
        [_reportLabel setTextColor:[UIColor colorWithHexString:@"#5D5854"]];
        _reportLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _reportLabel;
}
- (UIView *)creatSelectButton
{
    UIView *sheetView = [[UIView alloc]init];
    sheetView.frame = CGRectMake(0,ScreenHeight ,ScreenWidth, ScreenHeight);
    sheetView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.95];
    self.sheetView = sheetView;
    
    
    self.reportLabel.text = self.reportTitle;
    [self.sheetView addSubview:self.reportLabel];
    
    for (int i = 0; i <self.reportArray.count;i++) {
        UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, (i+1) * cellHeight, ScreenWidth, cellHeight);
        [button setTitle:self.reportArray[i] forState:(UIControlStateNormal)];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor: [UIColor colorWithHexString:@"#403B37"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(buttonSelectAction:) forControlEvents:(UIControlEventTouchDown)];
        button.tag = 1000+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_sheetView addSubview:button];
        
        UIView *btnLine = [[UIView alloc]initWithFrame:CGRectMake(0,(i+1)*cellHeight,ScreenWidth,0.5)];
        btnLine.backgroundColor = [UIColor colorWithHexString:@"#403B37" alpha:0.1];
        [_sheetView addSubview:btnLine];
        
    }
    return _sheetView;
}
- (void)buttonSelectAction:(UIButton *)btn
{    
    if ([self.delegate respondsToSelector:@selector(reportWithReason:reportTitle:)]) {
        [self.delegate reportWithReason:btn reportTitle:self.reportTitle];
    }
    [self hideSheetAnimation];
}

-(void)singleTap:(UITapGestureRecognizer*)recognizer
{
    [self hideSheetAnimation];
}
- (void)showSheetAnimation
{
    CGFloat viewHeight = cellHeight*(self.reportArray.count+1);
    [UIView animateWithDuration:0.3 animations:^{
        _sheetView.frame = CGRectMake(0, ScreenHeight - viewHeight,ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)hideSheetAnimation
{
    CGFloat viewHeight = cellHeight * (self.reportArray.count+1);
    [UIView animateWithDuration:0.2 animations:^{
        _sheetView.frame = CGRectMake(0, ScreenHeight, ScreenWidth,viewHeight);
    } completion:^(BOOL finished) {
        [self hideActionWindow];
    }];
}
- (void)hideActionWindow
{
    self.sheetWindow.hidden = YES;
    [self.sheetWindow removeFromSuperview];
    [self.sheetView removeFromSuperview];
    self.selectView = nil;
    self.sheetWindow = nil;
    for (UIView *view in self.sheetView.subviews) {
        [view removeFromSuperview];
    }
}
- (void)dealloc
{
    self.sheetWindow.hidden = YES;
    [self.sheetWindow removeFromSuperview];
    [self.sheetView removeFromSuperview];
    self.sheetWindow= nil;
    self.selectView = nil;
}

@end
