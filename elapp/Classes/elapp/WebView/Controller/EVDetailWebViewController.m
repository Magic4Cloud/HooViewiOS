//
//  EVDetailWebViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVDetailWebViewController.h"
#import <PureLayout.h>
#import "EVLiveShareView.h"
#import "EVShareManager.h"
#import "UIViewController+Extension.h"
#import "EVLiveViewController.h"
#import "EVAccountPhoneBindViewController.h"
#import "NSString+Extension.h"

@interface EVDetailWebViewController () <CCLiveShareViewDelegate, UIWebViewDelegate, CCLiveViewControllerDelegate>

@property (nonatomic, weak) UIWebView *webView;      /**< h5页面 */
@property (nonatomic, weak) EVLiveShareView *shareView;      /**< 分享按钮的视图 */
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;/**< 加载页面 */
@property (nonatomic, strong) NSMutableArray<NSURLRequest *> *loadedRequests;    /**< 加载过的URL */
@property (nonatomic, assign) BOOL isBacking;   /**< 正在向前翻页 */
@property (assign, nonatomic) UIWebViewNavigationType lastRequestType; /**< 上次请求类型 */

@end

@implementation EVDetailWebViewController

+ (instancetype)activityDetailWebViewControllerWithURL:(NSString *)url
{
    EVDetailWebViewController *vc = [[EVDetailWebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.url = url;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setLeftItem];
}

- (void)setLeftItem
{
    // 返回上一级页面
    UIButton *backBtn = [[UIButton alloc] initWithTitle:kEBack];
    [backBtn setImage:[UIImage imageNamed:@"nav_icon_return"] forState:UIControlStateNormal];
    backBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    backBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [backBtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    // 关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.titleLabel.font = backBtn.titleLabel.font;
    closeBtn.frame = CGRectMake(0, 0, 44, 44);
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    [closeBtn setTitle:kEClose forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
}

- (void)startLiveWithActivityId:(NSString *)activityId
{
    NSMutableDictionary *startLiveInfo = [NSMutableDictionary dictionary];
    [startLiveInfo setValue:activityId forKey:kId];
    [startLiveInfo setValue:self.activityTitle forKey:kVideo_title];
    [self requestActivityLivingWithActivityInfo:startLiveInfo delegate:self];
}

- (void)popBack
{
    if (self.loadedRequests.count >= 2)
    {
        self.isBacking = YES;
        [self.loadedRequests removeLastObject];
        [self.webView loadRequest:[self.loadedRequests lastObject]];
    }
    else
    {
        if ( self.navigationController.viewControllers.count <= 1 )
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)closeVC
{
    if ( self.navigationController.viewControllers.count <= 1 )
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - CCLiveViewControllerDelegate
// 直播需要绑定手机, 请监听改回调
- (void)liveNeedToBindPhone:(EVLiveViewController *)liveVC
{
    EVAccountPhoneBindViewController *phoneBindVC = [EVAccountPhoneBindViewController accountPhoneBindViewController];
    EVRelationWith3rdAccoutModel *model = [[EVRelationWith3rdAccoutModel alloc] init];
    model.type = @"phone";
    [self presentViewController:phoneBindVC animated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ( [request.URL.absoluteString cc_containString:@"elapp://"] )
    {
        return YES;
    }
    
    if ( self.isBacking )
    {
        self.lastRequestType = navigationType;
        
        return YES;
    }
    
    switch ( navigationType )
    {
        case UIWebViewNavigationTypeBackForward:
        {
            [self removeRequest:request];
        }
            break;
            
        default:
        {
            [self addRequest:request withType:navigationType];
        }
            break;
    }
    
    self.lastRequestType = navigationType;
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isBacking = NO;
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.isBacking = NO;
    [self.indicatorView stopAnimating];
}

#pragma mark - live share view delegate
// 分享
- (void)liveShareViewDidClickButton:(CCLiveShareButtonType)type
{
    NSString *title = self.activityTitle;
    NSString *shareUrlString = self.url;
    
    if ( self.shareurl )
    {
        shareUrlString = self.shareurl;
    }
    UIImage *shareImage = self.image;
   
    shareUrlString = [shareUrlString cc_deleteSessionID];
    [CCProgressHUD showMessage:kReady_share toView:self.view];
    [UIImage gp_imageWithURlString:self.imageStr comolete:^(UIImage *image) {
        [CCProgressHUD hideHUDForView:self.view];
        
        UIImage *img = shareImage ? : image;
        [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:ShareTypeActivity titleReplace:title descriptionReplaceName:title descriptionReplaceId:nil URLString:shareUrlString image:img];
    }];
         
}

#pragma mark - private mathod

- (void)addRequest:(NSURLRequest *)request withType:(UIWebViewNavigationType)type
{
    NSArray *requests = [NSArray arrayWithArray:self.loadedRequests];
    NSURLRequest *urlRequest = [requests lastObject];
    if ( self.lastRequestType == type &&
        type == UIWebViewNavigationTypeOther &&
        ![urlRequest.URL.absoluteString isEqualToString:request.URL.absoluteString] )
    {
        [self.loadedRequests replaceObjectAtIndex:(NSInteger)requests.count - 1 withObject:request];
    }
    else if ( ![urlRequest.URL.absoluteString isEqualToString:request.URL.absoluteString])
    {
        [self.loadedRequests addObject:request];
    }
}

- (void)removeRequest:(NSURLRequest *)request
{
    NSArray *requests = [NSArray arrayWithArray:self.loadedRequests];
    NSURLRequest *urlRequest = [requests lastObject];
    if ( [urlRequest.URL.absoluteString isEqualToString:request.URL.absoluteString] )
    {
        [self.loadedRequests removeLastObject];
    }
}

- (void)setUp
{
    self.title = self.activityTitle;
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    if (![self.url hasPrefix:@"http"])
    {
        
        self.url = [NSString stringWithFormat:@"http://%@", self.url];
        
    }else{
        
        self.url = [NSString stringWithFormat:@"%@", self.url];
        
    }
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.webView = webView;
    
    EVLiveShareView *shareView = [EVLiveShareView liveShareViewToTargetView:self.view menuHeight:202 delegate:self];
    shareView.hidden = YES;
    self.shareView = shareView;

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 - 10, self.view.bounds.size.height/2-10, 20, 20)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // change by 佳南 to  set button
    if (self.activityTitle && !self.isEnd)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kEShare style:UIBarButtonItemStylePlain target:self action:@selector(shareActivity)];
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
        [shareBtn.titleLabel setFont:[[CCAppSetting shareInstance] normalFontWithSize:15.0f]];
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        [shareBtn setTitle:kEShare forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = shareItem;
    }
    
    self.loadedRequests = [NSMutableArray array];
}

- (void)shareActivity
{
    self.shareView.hidden = NO;
}

@end
