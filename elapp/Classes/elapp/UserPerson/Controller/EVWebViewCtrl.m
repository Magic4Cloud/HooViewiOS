//
//  EVWebViewCtrl.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVWebViewCtrl.h"
#import "ALView+PureLayout.h"

@interface EVWebViewCtrl () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property ( strong, nonatomic ) UIButton *dismissBtn;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation EVWebViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    if ( self.isPresented )
    {
        UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_icon_close_bloack"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBtnClick)];
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem;
    }
    self.webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    [self.view addSubview: _webView];
    [_webView autoPinEdgesToSuperviewEdges];
    _webView.backgroundColor = [UIColor evBackgroundColor];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]];
    [_webView loadRequest:request];
}

#pragma mark - event response
- (void)dismissBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//返回的数
- (void) backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( self.navigationController )
    {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)setRequestUrl:(NSString *)requestUrl
{
    __weak typeof(self) wself = self;
    _requestUrl = [NSString stringWithFormat:@"%@?sessionid=%@", requestUrl,[self getSessionIdWithBlock:^{
        EVRelogin(wself);
    }]];
    if (![requestUrl hasPrefix:@"http://"] && ![requestUrl hasPrefix:@"https://"]) {
        _requestUrl = [NSString stringWithFormat:@"http://%@?sessionid=%@",requestUrl,[self getSessionIdWithBlock:^{
            EVRelogin(wself);
        }]];
    }
}

- (NSString *)getSessionIdWithBlock:(void(^)())sessionExpireBlock
{
    NSString *sessionID = [CCUserDefault objectForKey:SESSION_ID_STR];
    if ( sessionID == nil )
    {
        if ( sessionExpireBlock )
        {
            sessionExpireBlock();
        }
    }
    return sessionID;
}

- (void)dealloc
{
    
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.frame = CGRectMake(0.f, 0.f, 40.f, 40.f);
    [_activityIndicator setCenter:self.view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
}

@end
