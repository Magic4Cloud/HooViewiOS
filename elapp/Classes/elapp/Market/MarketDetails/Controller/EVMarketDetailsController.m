//
//  EVMarketDetailsController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVMarketDetailsController.h"
#import "EVStockDetailBottomView.h"
#import "EVSharePartView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "WKWebViewJavascriptBridge.h"
#import "EVNewsDetailWebController.h"
#import "EVNativeNewsDetailViewController.h"

#import "EVMarketTextView.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"
#import "EVAlertManager.h"
#import "EVShareManager.h"

//#define webUrl @"https://appgw.hooview.com/easyvaas/webapp/"
//
////#define webUrl @"http://dev.yizhibo.tv/hooview/stock/"
//#define webUrl   @"http://192.168.6.64:3000/"

@interface EVMarketDetailsController ()<WKNavigationDelegate,EVStockDetailBottomViewDelegate,WKUIDelegate,WKScriptMessageHandler,UIWebViewDelegate,EVWebViewShareViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) WKWebView *stockWebView;

@property (nonatomic, weak) UILabel *nameLabel;

@property (nonatomic, weak) EVStockDetailBottomView *detailBottomView;

/** 分享模块view*/
@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property WKWebViewJavascriptBridge *webViewBridge;

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIControl *touchLayer;

@property (nonatomic, weak) EVMarketTextView *marketTextView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) BOOL isMarketCollect;

@property (nonatomic, copy) NSString *chooseMarketPath;

@property (nonatomic, strong) NSMutableArray *addDataArray;
@end

@implementation EVMarketDetailsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self addUpView];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        return;
    }
    self.window.hidden = NO;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.3 animations:^{
        self.marketTextView.frame = CGRectMake(0, ScreenHeight - kbSize.height - 49, ScreenWidth, 49);
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        return;
    }
    self.window.hidden = YES;
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.3 animations:^{
        self.marketTextView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
    }];

}

- (void)addUpView
{
    self.addDataArray = [NSMutableArray arrayWithContentsOfFile:[self storyFilePath]];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.stockWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 113) configuration:configuration];
    
    if (self.stockBaseModel != nil) {
        self.urlStr =   [self requestUrlModel:self.stockBaseModel];
        [self updateUrlStr:self.urlStr];
        EVLog(@"webviewurl---- %@",self.urlStr);
    }
    self.stockWebView.UIDelegate = self;
    [self.view addSubview:self.stockWebView];
    
    
    
    EVStockDetailBottomView *stockDetailView = [[EVStockDetailBottomView alloc] init];
        NSArray *titleArray = @[@"+自选",@"分享",@"刷新"];
        NSArray *seleteTitleArr = @[@"已自选",@"分享 ",@"刷新 "];
        NSArray *imageArray = @[@"btn_market_n",@"btn_share_n",@"btn_market_refresh_g_n"];
        NSArray *seleteImageArr = @[@"btn_market_s",@"btn_share_n",@"btn_market_refresh_g_n"];
    [stockDetailView addButtonTitleArray:titleArray seleteTitleArr:seleteTitleArr imageArray:imageArray seleteImage:seleteImageArr];
    stockDetailView.frame = CGRectMake(0, ScreenHeight - 113, ScreenWidth, 49);
    stockDetailView.backgroundColor = [UIColor whiteColor];
    stockDetailView.delegate = self;
    [self.view addSubview:stockDetailView];
    self.detailBottomView = stockDetailView;
    [self.view addSubview:self.eVSharePartView];
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.stockWebView];
    [_webViewBridge setWebViewDelegate:self];
    //取消分享
    __weak typeof(self) weakSelf = self;
    self.eVSharePartView.cancelShareBlock = ^() {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, ScreenHeight);
        }];
    };
    
    
    [_webViewBridge registerHandler:@"showNewsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        EVNativeNewsDetailViewController *detailWebVC = [[EVNativeNewsDetailViewController alloc] init];
        NSDictionary *bodyDict = data;
        detailWebVC.newsID = bodyDict[@"newsid"];
        [self.navigationController pushViewController:detailWebVC animated:YES];
        
    }];
    
    
    //公告跳转
    [_webViewBridge registerHandler:@"showStockAnnouncementDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        EVNewsDetailWebController *detailWebVC = [[EVNewsDetailWebController alloc] init];
        NSDictionary *bodyDict = data;
        detailWebVC.announcementURL = bodyDict[@"url"];
        detailWebVC.announcementTitle = bodyDict[@"title"];
//        detailWebVC.detailBottomView.hidden = YES;
        [self.navigationController pushViewController:detailWebVC animated:YES];
        
    }];

    
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    
    self.touchLayer = [[UIControl alloc] initWithFrame:self.window.bounds];
    self.touchLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.window addSubview:self.touchLayer];
    [self.window makeKeyAndVisible];
    
    [self.touchLayer addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    EVMarketTextView *marketTextView = [[EVMarketTextView alloc] init];
    marketTextView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, 49);
    [self.window addSubview:marketTextView];
    self.marketTextView = marketTextView;
    marketTextView.hidden = NO;
    marketTextView.backgroundColor = [UIColor whiteColor];
    marketTextView.commentBlock = ^ (NSString *content) {
        [self sendCommentStr:content];
    };
    self.window.hidden = YES;
    
    //判断是否添加自选
//    [self.baseToolManager GETUserCollectType:EVCollectTypeStock code:self.stockBaseModel.symbol action:0 start:^{
//        
//    } fail:^(NSError *error) {
//        [EVProgressHUD showError:@"添加失败"];
//    } success:^(NSDictionary *retinfo) {
//        self.detailBottomView.isMarketCollect = [retinfo[@"exist"] boolValue];
//        self.isMarketCollect = [retinfo[@"exist"] boolValue];
//    } sessionExpire:^{
//        
//    }];
    
    //判断是否添加自选
    [self.baseToolManager GETIsAddSelfStockSymbol:self.stockBaseModel.symbol userid:[EVLoginInfo localObject].name Success:^(NSDictionary *retinfo) {
        NSLog(@"%@",retinfo);
        self.detailBottomView.isMarketCollect = [retinfo[@"exist"] boolValue];
        self.isMarketCollect = [retinfo[@"exist"] boolValue];
    } error:^(NSError *error) {
        
    }];
    
}

- (void)sendCommentStr:(NSString *)str
{
    if (str.length <= 0) {
        [EVProgressHUD showError:@"评论为空"];
        return;
    }
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
//    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
//        [self hide];
//        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
//        [self presentViewController:navighaVC animated:YES completion:nil];
//    }
    [self.baseToolManager POSTStockCommentContent:str stockCode:self.stockBaseModel.symbol userID:loginInfo.name userName:loginInfo.nickname userAvatar:loginInfo.logourl start:^{
        
    } fail:^(NSError *error) {
        [self hide];
        [EVProgressHUD showError:@"评论失败"];
    } success:^(NSDictionary *retinfo) {
        [self hide];
        [self updateUrlStr:self.urlStr];
        [EVProgressHUD showSuccess:@"评论成功"];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)addWindowView
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    
    self.touchLayer = [[UIControl alloc] initWithFrame:self.window.bounds];
    self.touchLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.window addSubview:self.touchLayer];
    [self.window makeKeyAndVisible];
    
    [self.touchLayer addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    EVMarketTextView *marketTextView = [[EVMarketTextView alloc] init];
    marketTextView.frame = CGRectMake(0, ScreenHeight, ScreenHeight, 49);
    [self.window addSubview:marketTextView];
    self.marketTextView = marketTextView;
    marketTextView.hidden = NO;
    marketTextView.inPutTextFiled.delegate = self;
    marketTextView.backgroundColor = [UIColor whiteColor];
    marketTextView.commentBlock = ^ (NSString *content) {
        [self sendCommentStr:content];
    };
    self.window.hidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addWindowView];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 34)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont textFontB3];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = [UIColor evTextColorH2];
    [self.navigationController.view addSubview:nameLabel];
    [self.navigationController.view bringSubviewToFront:nameLabel];
    self.nameLabel = nameLabel;
    self.nameLabel.text = [NSString stringWithFormat:@"%@\n%@",self.stockBaseModel.name,self.stockBaseModel.symbol ? : @""];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self deallocView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.nameLabel removeFromSuperview];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)updateUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.stockWebView loadRequest:request];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"ScanAction"]) {
        NSLog(@"--------- %@",message.body);
       
    }

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    EVLog(@"-----------------------------");
}


- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    EVLog(@"跳转的url------  %@",webView.URL);
    NSString *string = [NSString stringWithFormat:@"%@",webView.URL];
    [EVProgressHUD showSuccess:string];
}


- (NSString *)requestUrlModel:(EVStockBaseModel *)stockBaseModel
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *nameEncoding = [self.stockBaseModel.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setValue:nameEncoding forKey:@"name"];
    [params setValue:@"stock" forKey:@"page"];
    [params setValue:[NSString stringWithFormat:@"%@",self.stockBaseModel.symbol] forKey:@"code"];
    [params setValue:@(self.special) forKey:@"special"];
    NSInteger paramCount = params.count;
    __block NSInteger index = 0;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",webMarketUrl,paramStr];
    
    return urlStr;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentStr:textField.text];
    return YES;
}

- (void)setStockBaseModel:(EVStockBaseModel *)stockBaseModel
{
    _stockBaseModel = stockBaseModel;
 
}

#pragma mark - delegate
- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    switch (type) {
        //添加自选 & 取消添加
        case EVBottomButtonTypeAdd:
            {
                EVLoginInfo *loginInfo = [EVLoginInfo localObject];
                if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
                    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                    [self presentViewController:navighaVC animated:YES completion:nil];
                }else {
                    
                    int action = self.isMarketCollect ? 2 : 1;
                    
                    NSString *actionTypeStr = self.isMarketCollect ? @"移除自选" : @"添加自选";
                    btn.enabled = NO;
                    [EVProgressHUD showIndeterminateForView:self.view];
                    
                    [self.baseToolManager GETAddSelfStocksymbol:self.stockBaseModel.symbol type:action userid:[EVLoginInfo localObject].name Success:^(NSDictionary *retinfo) {
                        btn.enabled = YES;
                        [EVProgressHUD hideHUDForView:self.view];
                        
                        if (!_isMarketCollect) {
                            [EVProgressHUD showMessage:[actionTypeStr stringByAppendingString:@"成功"]];
                        }
                        
                        self.isMarketCollect = !self.isMarketCollect;
                        self.detailBottomView.isMarketCollect = self.isMarketCollect;

                    } error:^(NSError *error) {
                        btn.enabled = YES;
                        [EVProgressHUD hideHUDForView:self.view];
                        
                        [EVProgressHUD showMessage:[actionTypeStr stringByAppendingString:@"失败"]];
                    }];
                }
        }
            break;
        case EVBottomButtonTypeShare:
            EVLog(@"分享");
//            [EVProgressHUD showError:@"暂未实现 敬请期待"];
            [self shareViewShowAction];
            break;
        case EVBottomButtonTypeRefresh:
            [self updateUrlStr:self.urlStr];
            break;
            
        case EVBottomButtonTypeComment:
        {
            EVLoginInfo *loginInfo = [EVLoginInfo localObject];
            if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
                [self hide];
                UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                [self presentViewController:navighaVC animated:YES completion:nil];
            }else {
                [self.marketTextView.inPutTextFiled becomeFirstResponder];
            }
        }
            break;
        default:
            break;
    }
}

- (void)hide
{
    self.marketTextView.inPutTextFiled.text = nil;
    [self.marketTextView.inPutTextFiled resignFirstResponder];
    self.marketTextView.sendButton.selected = NO;
    self.window.hidden = YES;
}

- (void)shareType:(EVLiveShareButtonType)type
{
    NSString *shareUrlString = self.urlStr;
    
    if (self.urlStr == nil) {
        
        [EVProgressHUD showError:@"加载完成在分享"];
    
    }
    
    ShareType shareType = ShareTypeNews;
    UIImage *image = [UIImage imageNamed:@"icon_share"];
    
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:self.stockBaseModel.name descriptionReplaceName:self.stockBaseModel.symbol descriptionReplaceId:nil URLString:shareUrlString image:image outImage:nil];
    
}
//分享view
- (void)shareViewShowAction {
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64);
    }];
}


- (void)popBack
{
    [EVNotificationCenter postNotificationName:@"chooseMarketCommit" object:nil];
    [self deallocView];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazy loading
- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
    }
    return _eVSharePartView;
}

- (EVBaseToolManager *)baseToolManager {
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    
    return _baseToolManager;
}

- (void)deallocView
{
    [self.nameLabel removeFromSuperview];
    [self.marketTextView removeFromSuperview];
    [self.touchLayer removeFromSuperview];
    self.touchLayer = nil;
    [self.window removeFromSuperview];
   
    self.window = nil;
}

- (NSString *)storyFilePath
{
    if ( _chooseMarketPath == nil )
    {
        
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *userMarksDirPath = [cachePath stringByAppendingPathComponent:@"chooseMarketPath"];
        NSString *currentPath = [NSString stringWithFormat:@"chooseMarketPath_%@",[EVLoginInfo localObject].name];
        if (![[NSFileManager defaultManager] fileExistsAtPath:userMarksDirPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:userMarksDirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _chooseMarketPath = [userMarksDirPath stringByAppendingPathComponent:currentPath];
    }
    return _chooseMarketPath;
}

- (NSMutableArray *)addDataArray
{
    if (!_addDataArray) {
        _addDataArray = [NSMutableArray array];
    }
    return _addDataArray;
}
- (void)dealloc
{
    [self deallocView];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
