//
//  EVPayVideoViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPayVideoViewController.h"
#import "UIViewController+Extension.h"
#import "EVPayForLivingView.h"
#import <PureLayout/PureLayout.h>
#import "EVBaseToolManager.h"
#import "EVBaseToolManager+EVLiveAPI.h" 

@interface EVPayVideoViewController ()

@property (nonatomic, weak  ) EVPayForLivingView *payView;
@property (nonatomic, strong) EVBaseToolManager *engine;
@property (nonatomic, strong) NSString   *ecion;

@end


@implementation EVPayVideoViewController

#pragma mark - ***********         Init💧         ***********
/** 先获取数据，判断是否支付过，支付过则直接播放，未支付过则显示当前控制器 */
+ (void)fetchDataWithVid:(NSString *)vid complete:(void(^)(NSDictionary *retinfo, NSError *error))complete {
    EVPayVideoViewController *payVC = [EVPayVideoViewController new];
    [payVC fetchWatchPrepareWithVid:vid complete:complete];
}

#pragma mark - ***********     Life Cycle ♻️      ***********
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildPayVideoViewControllerUI];
    [self actionOfPayView];
    [self configViewWithInfo:self.payInfoDictionary];
}

#pragma mark - ***********      Build UI 🎨       ***********
- (void)buildPayVideoViewControllerUI {
    EVPayForLivingView *payView = [[EVPayForLivingView alloc] init];
    [self.view addSubview:payView];
    [payView autoPinEdgesToSuperviewEdges];
    self.payView = payView;
}

- (void)configViewWithInfo:(NSDictionary *)retinfo {
    [self.payView makeUpPayViewWithInfoDictionary:retinfo];
    self.ecion = retinfo[@"coin"];
}

#pragma mark - ***********    Notifications 📢    ***********

#pragma mark - ***********      Actions 🌠        ***********
#pragma mark 更新云币
- (void)updateEcion:(NSString *)ecion {
    [self.payView updatePayViewEcion:ecion];
}
/** payView的回调事件 */
- (void)actionOfPayView {
    [self.payView setTapPayBtn:^{
        [self postPayRequestWithComplete:^(BOOL success) {
            [self callBackWithPay:success isRecharge:NO ecion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    [self.payView setTapCloseBtn:^{
        [self callBackWithPay:NO isRecharge:NO ecion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.payView setTapRechargeBtn:^{
        [self callBackWithPay:NO isRecharge:YES ecion:_ecion];
    }];
}

- (void)callBackWithPay:(BOOL)isPay isRecharge:(BOOL)isRecharge ecion:(NSString *)ecion {
    if (self.payCallBack) {
        self.payCallBack(isPay, isRecharge, ecion);
    }
}

#pragma mark - ***********      Networks 🌐       ***********
- (void)fetchWatchPrepareWithVid:(NSString *)vid complete:(void(^)(NSDictionary *retinfo, NSError *error))complete {
    __weak __typeof(self)weakSelf = self;
 
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    paramsDict[@"vid"] = vid;

    
    [self.engine GETUserstartwatchvideoWithParams:paramsDict Start:^{
        
    } fail:^(NSError *error) {
         [CCProgressHUD showError:[error errorInfoWithPlacehold:@"获取付费直播信息失败"]];
    } success:^(NSDictionary *videoInfo) {
        NSLog(@"video-------- %@",videoInfo);
         complete(videoInfo, nil);
    } sessionExpire:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CCRelogin(strongSelf);
    }];
}

- (void)postPayRequestWithComplete:(void(^)(BOOL success))callBackBlock {
    WEAK(self);
    [self.engine GETLivePayWithVid:self.vid start:^{
        [CCProgressHUD showMessage:@"loading..." toView:weakself.view];
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:weakself.view];
        [CCProgressHUD showError:[error errorInfoWithPlacehold:@"云币数目不足"]];
    } successBlock:^(NSDictionary *retinfo) {
        [CCProgressHUD hideHUDForView:weakself.view];
        callBackBlock(YES);
    } sessionExpire:^{
        
    }];
   
}

#pragma mark - *********** Delegate/DataSource 💍 ***********

#pragma mark - ***********     Lazy Loads 💤      ***********
- (EVBaseToolManager *)engine {
    if (!_engine) {
        _engine = [EVBaseToolManager new];
    }
    return _engine;
}

@end
