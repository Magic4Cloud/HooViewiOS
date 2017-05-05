//
//  EVHVWatchBottomView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/7.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVWatchBottomView.h"
#import "SGSegmentedControl.h"
#import "EVHVChatView.h"
#import "EVHVVideoCommentView.h"
#import "EVHVWatchStockView.h"
#import "EVHVWatchCheatsView.h"
#import "EVNotOpenView.h"
#import "EVIntroduceView.h"

@interface EVHVWatchBottomView ()<SGSegmentedControlStaticDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) SGSegmentedControlStatic *topSView;

@property (nonatomic, weak) UIScrollView *backScrollView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) EVWatchVideoInfo *watchVideoInfo;

@property (nonatomic, assign) CGFloat frameHig;


@end

@implementation EVHVWatchBottomView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray watchInfo:(EVWatchVideoInfo*)watchInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frameHig = frame.size.height;
        self.watchVideoInfo = watchInfo;
        [self addUpViewFrame:frame titleArray:titleArray];
    }
    return self;
}

- (void)addUpViewFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (titleArray.count == 3) {
        self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    } else if(titleArray.count == 4) {
        self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, ScreenWidth, 44) delegate:self childVcTitle:titleArray indicatorIsFull:NO];
    }
    
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    [self.topSView SG_setUpSegmentedControlStyle:^(UIColor *__autoreleasing *segmentedControlColor, UIColor *__autoreleasing *titleColor, UIColor *__autoreleasing *selectedTitleColor, UIColor *__autoreleasing *indicatorColor, BOOL *isShowIndicor) {
        *segmentedControlColor = [UIColor whiteColor];
        *titleColor = [UIColor evTextColorH2];
        *selectedTitleColor = [UIColor evMainColor];
        *indicatorColor = [UIColor evMainColor];
    }];
    self.topSView.selectedIndex = 0;
    [self addSubview:_topSView];
    
    
    UIScrollView *backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topSView.frame), ScreenWidth, frame.size.height - 44)];
    backScrollView.backgroundColor = [UIColor evBackgroundColor];
    backScrollView.delegate = self;
    [self addSubview:backScrollView];
    self.backScrollView = backScrollView;
    backScrollView.pagingEnabled = YES;
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(ScreenWidth * titleArray.count, frame.size.height - 44);
    
    
    //简介
    EVIntroduceView *introView = [[EVIntroduceView alloc] initWithFrame:CGRectMake(ScreenWidth * (titleArray.count - 4), 0, ScreenWidth, frame.size.height)];
    [backScrollView addSubview:introView];
    introView.watchVideoInfo = self.watchVideoInfo;
    introView.backgroundColor = [UIColor evBackgroundColor];

    //评论
    EVHVVideoCommentView * videoCommentView = [[EVHVVideoCommentView alloc] initWithFrame:CGRectMake(ScreenWidth * (titleArray.count - 3), 0,ScreenWidth, self.frameHig - 40 - 49)];
    [backScrollView addSubview:videoCommentView];
    self.videoCommentView = videoCommentView;
    videoCommentView.backgroundColor =[UIColor evBackgroundColor];
    
    
    //股票
    EVNotOpenView *notOpenView = [[EVNotOpenView alloc] initWithFrame:CGRectMake(ScreenWidth * (titleArray.count - 2), 0, ScreenWidth, frame.size.height - 44)];
    [backScrollView addSubview:notOpenView];
    notOpenView.imageName = @"ic_watch_stock_not_data";
    notOpenView.titleStr = @"搜索你想了解的股票";
    self.notOpenView = notOpenView;
    notOpenView.backgroundColor = [UIColor evBackgroundColor];
    
    
    EVHVWatchStockView *dataView = [[EVHVWatchStockView alloc] initWithFrame:CGRectMake(ScreenWidth * (titleArray.count - 2), 0, ScreenWidth, frame.size.height - 44)];
    [backScrollView addSubview:dataView];
    self.watchStockView = dataView;
    dataView.backgroundColor =[UIColor evBackgroundColor];
    self.watchStockView.hidden = YES;
    
    //秘籍
    EVHVWatchCheatsView *cheatsView = [[EVHVWatchCheatsView alloc] initWithFrame:CGRectMake(ScreenWidth * (titleArray.count - 1), 0, ScreenWidth, frame.size.height - 44)];
    [backScrollView addSubview:cheatsView];
    cheatsView.backgroundColor = [UIColor evBackgroundColor];
    
}

- (void)receiveChatContent:(NSString *)content nickName:(NSString *)nickName
{
    
}

// delegate 方法
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index
{
    CGFloat offsetX = index * self.frame.size.width;
    self.backScrollView.contentOffset = CGPointMake(offsetX, 0);
    if (self.delagate && [self.delagate respondsToSelector:@selector(scrollViewDidSeletedIndex:)]) {
        [self.delagate scrollViewDidSeletedIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
       NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (self.delagate && [self.delagate respondsToSelector:@selector(scrollViewDidSeletedIndex:)]) {
        [self.delagate scrollViewDidSeletedIndex:index];
    }
}


- (EVHVChatView *)chatView
{
    if (!_chatView) {
        _chatView = [[EVHVChatView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, self.frameHig - 47)];
    }
    return _chatView;
}

//- (EVHVVideoCommentView *)videoCommentView
//{
//    if (!_videoCommentView) {
//        _videoCommentView = [[EVHVVideoCommentView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, self.frameHig - 40 - 49)];
//    }
//    return _videoCommentView;
//}


- (EVHVGiftAniView *)giftAniView
{
    if (!_giftAniView) {
        _giftAniView = [[EVHVGiftAniView alloc] initWithFrame:CGRectMake(16, CGRectGetHeight(self.backScrollView.frame) - 49 - 16 -190, 80, 190)];
    }
    return _giftAniView;
}
- (void)setIsLiving:(NSInteger)isLiving
{
    _isLiving = isLiving;
    
    if (isLiving == 0 || isLiving == 1) {
    [self.backScrollView addSubview:self.chatView];
    [self.backScrollView addSubview:self.giftAniView];
    }else {
        [self.backScrollView addSubview:self.videoCommentView];
    }
}

-(void)setWatchVideoInfo:(EVWatchVideoInfo *)watchVideoInfo {
    _watchVideoInfo = watchVideoInfo;
}



#pragma mark -delegate
#pragma mark --  精品视频简介-推荐视频
-(void)videoListClickModel:(EVVideoAndLiveModel *)videoAndLiveModel {
//    EVHVWatchViewController *watchViewVC = [[EVHVWatchViewController alloc] init];
//    watchViewVC.videoAndLiveModel = videoAndLiveModel;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:watchViewVC];
//    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"搜到");
}




@end



