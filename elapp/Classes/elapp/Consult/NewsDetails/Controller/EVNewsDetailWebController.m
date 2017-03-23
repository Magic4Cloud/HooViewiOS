//
//  EVNewsDetailWebController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/5.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVNewsDetailWebController.h"
#import <WebKit/WebKit.h>
#import "EVStockDetailBottomView.h"
#import "WebViewJavascriptBridge.h"
#import "EVMarketDetailsController.h"
#import "EVMarketTextView.h"
#import "EVLoginInfo.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVLoginViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVNewsCommentController.h"
#import "EVAlertManager.h"
#import "EVNullDataView.h"
#import "EVSharePartView.h"
#import "EVShareManager.h"
#import "EVVipCenterViewController.h"

@interface EVNewsDetailWebController ()<UIWebViewDelegate,EVStockDetailBottomViewDelegate,UITextFieldDelegate,EVWebViewShareViewDelegate>
@property (nonatomic, strong) UIWebView *newsWebView;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, weak) EVStockDetailBottomView *detailBottomView;

@property WebViewJavascriptBridge *webViewBridge;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIControl *touchLayer;

@property (nonatomic, weak) EVMarketTextView *marketTextView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, weak) EVNullDataView *nullDataView;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, assign) BOOL isCollect;


@end

@implementation EVNewsDetailWebController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.newsWebView.request.URL) {
        [self.newsWebView reload];
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addUpView];
    [self loadCommentListData];
}

- (void)loadCommentListData
{
    WEAK(self)
   [self.baseToolManager GETNewsDetailNewsID:self.newsID fail:^(NSError *error) {
       [EVProgressHUD showMessage:@"获取失败"];
   } success:^(NSDictionary *retinfo) {
       NSString *commentCount = [NSString stringWithFormat:@"%@",retinfo[@"retinfo"][@"data"][@"commentCount"]];
       EVLog(@"commentcount------ %@",commentCount);
       weakself.detailBottomView.commentCount = [commentCount integerValue];
   }];
}


- (void)addUpView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    self.newsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - 113)];
    
    if (self.newsID != nil) {
        self.urlStr =   [self requestUrlID:self.newsID];
        [self updateUrlStr:self.urlStr];
        EVLog(@"webviewurl---- %@",self.urlStr);
    }
    self.newsWebView.delegate = self;
    [self.view addSubview:self.newsWebView];
    
    
    EVStockDetailBottomView *stockDetailView = [[EVStockDetailBottomView alloc] init];
    NSArray *titleArray = @[@"分享",@"收藏",@"评论"];
    NSArray *seleteTitleArr = @[@"分享",@"已收藏",@"评论"];
    NSArray *imageArray = @[@"hv_share",@"btn_news_collect_n",@"btn_news_comment_n"];
    NSArray *seleteImageArr = @[@"hv_share",@"btn_news_collecte_s",@"btn_news_comment_n"];
    [stockDetailView addButtonTitleArray:titleArray seleteTitleArr:seleteTitleArr imageArray:imageArray seleteImage:seleteImageArr];
    stockDetailView.frame = CGRectMake(0, ScreenHeight - 113, ScreenWidth, 49);
    stockDetailView.backgroundColor = [UIColor whiteColor];
    stockDetailView.delegate = self;
    [self.view addSubview:stockDetailView];
    self.detailBottomView = stockDetailView;
    
    _webViewBridge = [WebViewJavascriptBridge bridgeForWebView:self.newsWebView];
    [_webViewBridge setWebViewDelegate:self];
    [self registerNativeFunctions];
 
    [self.view addSubview:self.eVSharePartView];


    //取消分享
    __weak typeof(self) weakSelf = self;
    self.eVSharePartView.cancelShareBlock = ^() {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        }];
    };
    
    
    EVNullDataView *nullDataView = [[EVNullDataView alloc] init];
    nullDataView.frame = CGRectMake(0, 1, ScreenWidth, ScreenHeight - 113);
    [self.view addSubview:nullDataView];
    nullDataView.topImage = [UIImage imageNamed:@"ic_cry"];
    nullDataView.title = @"很抱歉，访问出错了";
    self.nullDataView = nullDataView;
    nullDataView.hidden = YES;
    
    [self.baseToolManager GETUserCollectType:EVCollectTypeNews code:self.newsID action:0 start:^{
        
    } fail:^(NSError *error) {
        [EVProgressHUD showMessage:@"失败"];
        NSLog(@"error == %@",error);
    } success:^(NSDictionary *retinfo) {
        NSLog(@"retinfo----%@",retinfo);
        self.detailBottomView.isCollec = [retinfo[@"exist"] boolValue];
        self.isCollect = [retinfo[@"exist"] boolValue];
    } sessionExpire:^{
        
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addWindowView];
}

- (void)registerNativeFunctions
{
    WEAK(self)
    
    [_webViewBridge registerHandler:@"showStockDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        EVMarketDetailsController *detailWebVC = [[EVMarketDetailsController alloc] init];
        EVStockBaseModel *baseModel = [[EVStockBaseModel alloc] init];
        NSDictionary *bodyDict = data;
        baseModel.symbol = bodyDict[@"code"];
        baseModel.name = bodyDict[@"name"];
        detailWebVC.stockBaseModel = baseModel;
        [weakself.navigationController pushViewController:detailWebVC animated:YES];
        
    }];
    
    
    [_webViewBridge registerHandler:@"showAllComments" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        NSString *newsid = [NSString stringWithFormat:@"%@",data[@"newsid"]];
       
        [self pushCommentListVCID:newsid];
    }];
    
    [_webViewBridge registerHandler:@"unLikeNews" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [[EVAlertManager shareInstance] configAlertViewWithTitle:@"" message:@"暂未实现 敬请期待" cancelTitle:@"取消" WithCancelBlock:^(UIAlertView *alertView) {
            
        }];
    }];
    
    [_webViewBridge registerHandler:@"showVipUserInfo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic = (NSDictionary *)data;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *name = [NSString stringWithFormat:@"%@", dic[@"name"]];
            EVWatchVideoInfo *watchInfo = [EVWatchVideoInfo new];
            watchInfo.name = name;
            EVVipCenterViewController *vipVC = [EVVipCenterViewController new];
            vipVC.watchVideoInfo = watchInfo;
            [self.navigationController pushViewController:vipVC animated:YES];
        }
        
    }];
    
    [_webViewBridge registerHandler:@"showNewsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        EVNewsDetailWebController *detailWebVC = [[EVNewsDetailWebController alloc] init];
        NSDictionary *bodyDict = data;
        detailWebVC.newsID = bodyDict[@"newsid"];
        detailWebVC.newsTitle = bodyDict[@"newstitle"];
        [self.navigationController pushViewController:detailWebVC animated:YES];
        
    }];
}


- (void)pushCommentListVCID:(NSString *)newsid
{
    EVNewsCommentController *newsCommnetVC = [[EVNewsCommentController alloc]init];
    
    if (([newsid isEqualToString:@""] || newsid == nil)) {
        [EVProgressHUD showMessage:@"新闻ID为空"];
        return;
    }
    newsCommnetVC.newsID = [NSString stringWithFormat:@"%@",newsid];
    [self.navigationController pushViewController:newsCommnetVC animated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentStr:textField.text];
    return YES;
}

- (void)hide
{
    self.marketTextView.inPutTextFiled.text = nil;
    [self.marketTextView.inPutTextFiled resignFirstResponder];
    self.marketTextView.sendButton.selected = NO;
}

- (void)sendCommentStr:(NSString *)str
{
    if (str.length <= 0) {
        [EVProgressHUD showMessage:@"评论为空"];
        return;
    }
    WEAK(self);
   EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    [self.baseToolManager POSTNewsCommentContent:str stockCode:self.newsID userID:loginInfo.name userName:loginInfo.nickname userAvatar:loginInfo.logourl start:^{
        
    } fail:^(NSError *error) {
        [self hide];
        [EVProgressHUD showMessage:@"评论失败"];
    } success:^(NSDictionary *retinfo) {
        [self hide];
        [EVProgressHUD showMessage:@"评论成功"];
        [weakself loadCommentListData];
    }];
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
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self deallocView];
}


- (void)popBack
{
    [self deallocView];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateUrlStr:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求
    [self.newsWebView loadRequest:request];
}

- (NSString *)requestUrlID:(NSString *)ID
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:ID forKey:@"newsid"];
    [params setValue:@"news" forKey:@"page"];
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
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",webNewsUrl,paramStr];
    
    return urlStr;
}


#pragma mark - delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"ScanAction"]) {
        
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //如果在一个请求没加载完毕就加载下一个请求  会走这个方法  加上判断  如果不是请求取消导致的error  才显示加载失败界面
    if ([error code] != NSURLErrorCancelled) {
        [EVProgressHUD showError:@"网页加载失败"];
        self.nullDataView.hidden = NO;
    }
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [self.baseToolManager GETUserHistoryType:EVCollectTypeNews code:self.newsID action:1 start:^{
//        
//    } fail:^(NSError *error) {
//        
//    } success:^(NSDictionary *retinfo) {
//        
//    } sessionExpire:^{
//        
//    }];
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    EVLog(@"跳转的url------  %@",webView.URL);
    NSString *string = [NSString stringWithFormat:@"%@",webView.URL];
    [EVProgressHUD showSuccess:string];
}

#pragma mark - delegate
- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    switch (type) {
        case EVBottomButtonTypeAdd:
            EVLog(@"添加");
        {
            [self shareViewShowAction];
        }
            break;
        case EVBottomButtonTypeShare:
        {
            [self presentLoginVC];
            
            NSLog(@"---------%d",self.isCollect);
            int action = self.isCollect ? 2 : 1;
            
            [self.baseToolManager GETUserCollectType:EVCollectTypeNews code:self.newsID action:action start:^{
//                NSLog(@"ssss = %@",);
            } fail:^(NSError *error) {
                NSLog(@"eeeee = %@",error);
                [EVProgressHUD showMessage:@"失败"];
            } success:^(NSDictionary *retinfo) {
                
                [EVProgressHUD showMessage:@"成功"];
                self.isCollect = !self.isCollect;
                self.detailBottomView.isCollec = self.isCollect;
            } sessionExpire:^{
                
            }];
        }
//
            break;
        case EVBottomButtonTypeRefresh:
        {
             [self pushCommentListVCID:self.newsID];
        
//            [EVProgressHUD showError:@"暂未实现 敬请期待"];
//            EVNewsCommentController *newsCommnetVC = [[EVNewsCommentController alloc]init];
//            newsCommnetVC.newsID = self.newsID;
//            [self.navigationController pushViewController:newsCommnetVC animated:YES];
        }
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

- (void)shareType:(EVLiveShareButtonType)type
{
    NSString *shareUrlString = self.urlStr;
    
    if (self.urlStr == nil) {
        
        [EVProgressHUD showError:@"加载完成在分享"];

    }
    
    ShareType shareType = ShareTypeNewsWeb;
    UIImage *image = [UIImage imageNamed:@"icon_share"];
   [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:self.newsTitle descriptionReplaceName:@"#火眼财经#" descriptionReplaceId:nil URLString:shareUrlString image:image outImage:nil];
}

- (void)presentLoginVC
{
    
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }
}

- (void)shareViewShowAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenHeight,  ScreenHeight - 64);
    }];
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
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

- (void)deallocView
{
    [self.touchLayer removeFromSuperview];
    self.touchLayer = nil;
    [self.window removeFromSuperview];
    self.window = nil;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    

}

- (void)dealloc
{
    [EVNotificationCenter removeObserver:self];
    EVLog(@"-----------------DEALLOC NEWSwebView");
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
