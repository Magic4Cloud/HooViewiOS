//
//  EVPersonalCenterViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVPersonalCenterViewController.h"
#import <PureLayout.h>
#import "EVProfileHeaderView.h"

#define kHeaderViewHeight                350.f
#define kTableHeaderViewHeightSmall      290.f  // 小屏手机的header高度
#define kTableHeaderViewHeightBig        290.f  // 大屏手机上的高度
#define tableViewMinContentOffset       (- 110.0f)
#define kBeyondTop                      90.f  //  顶部图片超出屏幕之外的高度


@implementation EVCollectionFlowLayout
- (void)prepareLayout
{
    [super prepareLayout];
}
@end


@interface EVPersonalCenterViewController ()

@property (strong, nonatomic) UIView *mask;
@property (nonatomic, weak) UIView *topView;                    /**< 导航条 */
@property (nonatomic, weak) UIView *navBottomLine;              /**< 导航条下面的黑线 */
@property (nonatomic, weak) UIButton *backBtn;                  /**< 返回按钮 */
@property (weak, nonatomic) UIImage *returnImg;                 /**< 返回按钮图片 */
@property ( weak, nonatomic ) EVProfileHeaderView *profileHeaderView;
@property (weak, nonatomic) UIView * frontView;



@end
 

@implementation EVPersonalCenterViewController

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    _collectionView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    UIView * frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 230, ScreenWidth, ScreenHeight)];
    frontView.backgroundColor = [UIColor evBackgroundColor];
    [self.view addSubview:frontView];
    self.frontView = frontView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorColor = [UIColor evGlobalSeparatorColor];
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
    [tableView autoPinEdgesToSuperviewEdges];
    self.tableView = tableView;
    
    EVCollectionFlowLayout * flowLayout = [[EVCollectionFlowLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    [collectionView autoPinEdgesToSuperviewEdges];
    self.collectionView = collectionView;
    
    CGFloat tableHeaderHeight = ScreenWidth > 320.f ? kTableHeaderViewHeightBig : kTableHeaderViewHeightSmall;
    /**
     *  >> tableHeaderHeight 需要加上‘房间’视图的高度(CCProfileHeaderViewRoomHeight)
     */
    tableHeaderHeight = tableHeaderHeight + EVProfileHeaderViewRoomHeight;
    EVProfileHeaderView *tableHeaderView = [[EVProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeaderHeight)];
    self.profileHeaderView = tableHeaderView;
    tableHeaderView.backgroundColor = [UIColor evBackgroundColor];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableHeaderView = tableHeaderView;
    
    [self setUpTop];
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    self.view.backgroundColor  = [UIColor evBackgroundColor];
    

    [self.tableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:NULL];
    [self.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == NULL && [keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))] )
    {
        UIScrollView * scrollView = self.tableView ? self.tableView : self.collectionView;
        CGPoint offset = scrollView.contentOffset;
        if ( offset.y < tableViewMinContentOffset)
        {
            scrollView.contentOffset = CGPointMake(0, tableViewMinContentOffset);
        }
        
        self.frontView.frame = CGRectMake(0, 230-offset.y, ScreenWidth, ScreenHeight);
        
        self.topView.alpha = (offset.y - 90) / 35.0f;
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




- (void) setUpTop
{
    
    UIView *topView = [[UIView alloc] init];
     topView.backgroundColor = [UIColor whiteColor];
     topView.alpha = 0;
     [self.view addSubview:topView];
    [topView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [topView autoSetDimension:ALDimensionHeight toSize:64];
     self.topView = topView;
     
     UIView *navBottomLine = [[UIView alloc] init];
     navBottomLine.backgroundColor = [UIColor evGlobalSeparatorColor];
     [self.topView addSubview:navBottomLine];
    [navBottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [navBottomLine autoSetDimension:ALDimensionHeight toSize:kGlobalSeparatorHeight];
     self.navBottomLine = navBottomLine;
    
     // 返回按钮
     UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:.0f];
    [backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.f];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(.0f, 10.0f, .0f, -10.f)];
    [backBtn autoSetDimensionsToSize:CGSizeMake(100, 44)];
     backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor evMainColor] forState:UIControlStateSelected];
     [backBtn setImage:[self.returnImg imageWithTintColor:[UIColor colorWithRed:51.0/255 green:66.0/255 blue:116.0/255 alpha:1]] forState:UIControlStateNormal];
    [backBtn setImage:[self.returnImg imageWithTintColor:[UIColor evMainColor]] forState:UIControlStateSelected];
     [backBtn setTitle:@"" forState:UIControlStateNormal];
     backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
     [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn = backBtn;
    

}

- (UIImage *)returnImg {
    if ( !_returnImg )
    {
        _returnImg = [UIImage imageNamed:@"hv_back_return"];
    }
    return _returnImg;
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- ( void )biggerAvatar:(UIImage *)lastAvatar
{
    self.mask = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mask.backgroundColor = [UIColor whiteColor];
    UIView *opacityMask = [[UIView alloc] initWithFrame:self.mask.bounds];
    [self.mask addSubview:opacityMask];
    opacityMask.layer.backgroundColor = [UIColor blackColor].CGColor;
    opacityMask.layer.opacity = 0.8;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigAvatar)];
    [_mask addGestureRecognizer:tapGes];

    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.mask];
    
    UIImageView *bigAvatar = [[UIImageView alloc] initWithFrame:self.mask.bounds];
    [self.mask addSubview:bigAvatar];
    
    [bigAvatar setImage:lastAvatar];
    [bigAvatar setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)removeBigAvatar {
    [self.mask removeFromSuperview];
    self.mask = nil;
}

@end
