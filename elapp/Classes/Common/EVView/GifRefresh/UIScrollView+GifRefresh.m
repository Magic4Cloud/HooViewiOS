//
//  UIScrollView+GifRefresh.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "UIScrollView+GifRefresh.h"
#import "EVRefreshGifHeader.h"

@implementation UIScrollView (GifRefresh)

#pragma mark - public instance methods

- (void)addRefreshHeaderWithTarget:(id)target action:(SEL)action
{
    // 设置回调（一旦进入刷新状态，就调用target的action方法）
    EVRefreshGifHeader *gifHeader = [EVRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    // 对头部初始化设置
    [self configGifHeader:gifHeader];
    self.mj_header = gifHeader;
}

- (void)addRefreshFooterWithiTarget:(id)target action:(SEL)action
{
    EVRefreshGifFooter *gifFooter = [EVRefreshGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    // 对尾部初始化设置
    [self configGifFooter:gifFooter];
    self.mj_footer = gifFooter;
}

- (void)addRefreshHeaderWithRefreshingBlock:(void(^)())refreshingBlock
{
    EVRefreshGifHeader *gifHeader = [EVRefreshGifHeader headerWithRefreshingBlock:refreshingBlock];
    [self configGifHeader:gifHeader];
    self.mj_header = gifHeader;
}

- (void)addRefreshFooterWithRefreshingBlock:(void(^)())refreshingBlock
{
    EVRefreshGifFooter *gifFooter =[EVRefreshGifFooter footerWithRefreshingBlock:refreshingBlock];
    [self configGifFooter:gifFooter];
    self.mj_footer = gifFooter;
}

- (void)addRefreshHeaderAutoEndingFooterWhenRefreshing:(void(^)())refreshingBlock
{
    void(^moreRefreshingBlock)() = ^()
    {
        [self endHeaderRefreshing];
        refreshingBlock();
    };
    EVRefreshGifHeader *gifHeader = [EVRefreshGifHeader headerWithRefreshingBlock:moreRefreshingBlock];
    [self configGifHeader:gifHeader];
    self.mj_header = gifHeader;
}

- (void)addRefreshFooterAutoEndingHeaderWhenRefreshing:(void(^)())refreshingBlock
{
    void(^moreRefreshingBlock)() = ^()
    {
        [self endFooterRefreshing];
        refreshingBlock();
    };
    EVRefreshGifFooter *gifFooter =[EVRefreshGifFooter footerWithRefreshingBlock:moreRefreshingBlock];
    [self configGifFooter:gifFooter];
    self.mj_footer = gifFooter;
}

- (BOOL)isTableViewHeaderRefreshing
{
    return self.mj_header.isRefreshing;
}

- (BOOL)isTableViewFooterRefreshing
{
    return self.mj_footer.isRefreshing;
}

- (void)startHeaderRefreshing
{
    [self.mj_header beginRefreshing];
}

- (void)startFooterRefreshing
{
    [self.mj_footer beginRefreshing];
}

- (void)endHeaderRefreshing
{
    [self.mj_header endRefreshing];
}

- (void)endFooterRefreshing
{
    [self.mj_footer endRefreshing];
}

- (void)hideHeader
{
    self.mj_header.hidden = YES;
}

- (void)hideFooter
{
    self.mj_footer.hidden = YES;
}

- (void)showHeader
{
    self.mj_header.hidden = NO;
}

- (void)showFooter
{
    self.mj_footer.hidden = NO;
}

- (void)setHeaderState:(CCRefreshState)state
{
    switch (state) {
        case CCRefreshStateIdle:
        {
            self.mj_header.state = MJRefreshStateIdle;
        }
            break;
            
        case CCRefreshStatePulling:
        {
            self.mj_header.state = MJRefreshStatePulling;
        }
            break;
            
        case CCRefreshStateNoMoreData:
        {
            self.mj_header.state = MJRefreshStateNoMoreData;
        }
            break;
            
        case CCRefreshStateRefreshing:
        {
            self.mj_header.state = MJRefreshStateRefreshing;
        }
            break;
            
        case CCRefreshStateWillRefresh:
        {
            self.mj_header.state = MJRefreshStateWillRefresh;
        }
            break;
    }
}

- (void)setFooterState:(CCRefreshState)state
{
    switch (state) {
        case CCRefreshStateIdle:
        {
            self.mj_footer.state = MJRefreshStateIdle;
        }
            break;
            
        case CCRefreshStatePulling:
        {
            self.mj_footer.state = MJRefreshStatePulling;
        }
            break;
            
        case CCRefreshStateNoMoreData:
        {
            self.mj_footer.state = MJRefreshStateNoMoreData;
        }
            break;
            
        case CCRefreshStateRefreshing:
        {
            self.mj_footer.state = MJRefreshStateRefreshing;
        }
            break;
            
        case CCRefreshStateWillRefresh:
        {
            self.mj_footer.state = MJRefreshStateWillRefresh;
        }
            break;
    }
}

- (CCRefreshState)hederState
{
    switch (self.mj_header.state) {
        case MJRefreshStateIdle:
        {
            return CCRefreshStateIdle;
        }
            break;
            
        case MJRefreshStatePulling:
        {
            return CCRefreshStatePulling;
        }
            break;
            
        case MJRefreshStateNoMoreData:
        {
            return CCRefreshStateNoMoreData;
        }
            break;
            
        case MJRefreshStateRefreshing:
        {
            return CCRefreshStateRefreshing;
        }
            break;
            
        case MJRefreshStateWillRefresh:
        {
            return CCRefreshStateWillRefresh;
        }
            break;
    }
}

- (CCRefreshState)footerState
{
    switch (self.mj_footer.state) {
        case MJRefreshStateIdle:
        {
            return CCRefreshStateIdle;
        }
            break;
            
        case MJRefreshStatePulling:
        {
            return CCRefreshStatePulling;
        }
            break;
            
        case MJRefreshStateNoMoreData:
        {
            return CCRefreshStateNoMoreData;
        }
            break;
            
        case MJRefreshStateRefreshing:
        {
            return CCRefreshStateRefreshing;
        }
            break;
            
        case MJRefreshStateWillRefresh:
        {
            return CCRefreshStateWillRefresh;
        }
            break;
    }
}

- (CGRect)headerBounds
{
    return self.mj_header.bounds;
}

- (CGRect)footerBounds
{
    return self.mj_footer.bounds;
}

- (void)addSubviewToFooterWithSubview:(UIView *)subview
{
    [self.mj_footer addSubview:subview];
}

- (void)setHeaderTitle:(NSString *)title forState:(CCRefreshState)state
{
    EVRefreshGifHeader *gifHeader = (EVRefreshGifHeader *)self.mj_header;
    if ( !gifHeader )
    {
        return;
    }
    switch (state) {
        case CCRefreshStateIdle:
        {
            [gifHeader setTitle:title forState:MJRefreshStateIdle];
        }
            break;
            
        case CCRefreshStatePulling:
        {
            [gifHeader setTitle:title forState:MJRefreshStatePulling];
        }
            break;
            
        case CCRefreshStateNoMoreData:
        {
            [gifHeader setTitle:title forState:MJRefreshStateNoMoreData];
        }
            break;
            
        case CCRefreshStateRefreshing:
        {
            [gifHeader setTitle:title forState:MJRefreshStateRefreshing];
        }
            break;
            
        case CCRefreshStateWillRefresh:
        {
            [gifHeader setTitle:title forState:MJRefreshStateWillRefresh];
        }
            break;
    }
}

- (void)setFooterTitle:(NSString *)title forState:(CCRefreshState)state
{
    EVRefreshGifFooter *gifFooter = (EVRefreshGifFooter *)self.mj_footer;
    if ( !gifFooter )
    {
        return;
    }
    switch (state) {
        case CCRefreshStateIdle:
        {
            [gifFooter setTitle:title forState:MJRefreshStateIdle];
        }
            break;
            
        case CCRefreshStatePulling:
        {
            [gifFooter setTitle:title forState:MJRefreshStatePulling];
        }
            break;
            
        case CCRefreshStateNoMoreData:
        {
            [gifFooter setTitle:title forState:MJRefreshStateNoMoreData];
        }
            break;
            
        case CCRefreshStateRefreshing:
        {
            [gifFooter setTitle:title forState:MJRefreshStateRefreshing];
        }
            break;
            
        case CCRefreshStateWillRefresh:
        {
            [gifFooter setTitle:title forState:MJRefreshStateWillRefresh];
        }
            break;
    }
}

- (void)hideHeaderLastUpdateTimeLabel
{
    EVRefreshGifHeader *gifHeader = (EVRefreshGifHeader *)self.mj_header;
    if ( !gifHeader )
    {
        return;
    }
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
}

- (void)hideHeaderStateLabel
{
    EVRefreshGifHeader *gifHeader = (EVRefreshGifHeader *)self.mj_header;
    if ( !gifHeader )
    {
        return;
    }
    gifHeader.stateLabel.hidden = YES;
}

- (void)setHeaderTitleTextColor:(UIColor *)textColor font:(UIFont *)font
{
    EVRefreshGifHeader *gifHeader = (EVRefreshGifHeader *)self.mj_header;
    if ( !gifHeader )
    {
        return;
    }
    if ( textColor )
    {
        gifHeader.stateLabel.textColor = textColor;
        gifHeader.lastUpdatedTimeLabel.textColor = textColor;
    }
    if ( font )
    {
        gifHeader.stateLabel.font = font;
        gifHeader.lastUpdatedTimeLabel.font = font;
    }
}


#pragma mark - private methods

- (void)configGifHeader:(EVRefreshGifHeader *)gifHeader
{
    // 设置文字展示的方式
    gifHeader.lastUpdatedTimeLabel.textColor = [UIColor evMainColor];
    gifHeader.lastUpdatedTimeLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:11.0f];
    gifHeader.stateLabel.textColor = [UIColor evTextColorH2];
    gifHeader.stateLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14.0f];
    [gifHeader setTitle:@"     下拉刷新" forState:MJRefreshStateWillRefresh];
    [gifHeader setTitle:@"    加载中..." forState:MJRefreshStateRefreshing];
    [gifHeader setTitle:@"     准备刷新" forState:MJRefreshStatePulling];
    [gifHeader setTitle:@"     下拉刷新" forState:MJRefreshStateIdle];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_downward%zd", i]];
        [idleImages addObject:image];
    }
    [gifHeader setImages:idleImages forState:MJRefreshStateIdle];
    gifHeader.stateLabel.hidden = NO;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i < 2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_loading_%zd", i]];
        [refreshingImages addObject:image];
    }
//    [gifHeader setImages:idleImages forState:MJRefreshStateRefreshing];
    
    // 设置正在刷新状态的动画图片
    [gifHeader setImages:refreshingImages duration:refreshingImages.count * .1 forState:MJRefreshStateRefreshing];
}

- (void)configGifFooter:(EVRefreshGifFooter *)gifFooter
{
    gifFooter.stateLabel.textColor = [UIColor evTextColorH2];
    gifFooter.stateLabel.font = [[EVAppSetting shareInstance] normalFontWithSize:14.0f];
     [gifFooter setTitle:@"加载中..." forState:MJRefreshStatePulling];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_loading_%zd", i]];
        [idleImages addObject:image];
    }
    [gifFooter setImages:idleImages forState:MJRefreshStateRefreshing];
    gifFooter.stateLabel.hidden = NO;
    gifFooter.refreshingTitleHidden = NO;
    [gifFooter setTitle:@"已经到底了" forState:MJRefreshStateNoMoreData];
  
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i <= 1; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_loading_%zd", i]];
        [refreshingImages addObject:image];
    }
    [gifFooter setImages:idleImages forState:MJRefreshStatePulling];
    [gifFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    // 设置正在刷新状态的动画图片
    [gifFooter setImages:refreshingImages duration:refreshingImages.count * .1 forState:MJRefreshStateRefreshing];
}

- (EVRefreshGifFooter *)footer
{
    return (EVRefreshGifFooter *)self.mj_footer;
}

- (EVRefreshGifFooter *)header
{
    return (EVRefreshGifFooter *)self.mj_header;
}

@end
