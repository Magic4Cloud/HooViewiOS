//
//  EVPayManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVPayManager.h"
#import "constants.h"
#import "EVLoginInfo.h"
#import "EVShareManager.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVProductInfoModel.h"
#import "EVAlertManager.h"
#import "EVBaseToolManager+EVLogAPI.h"
#import "EV3rdPartAPIManager.h"

#define kWeiXinSuccess @"SUCCESS"
#define CCDocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define CCReceiptDataFolder [CCDocumentsPath stringByAppendingPathComponent:@"ReceiptData"]
#define CCReceiptPlistName @"receipt.plist"
#define CCReceiptPlistFile [CCReceiptDataFolder stringByAppendingPathComponent:CCReceiptPlistName]
#define kCCPayFileName @"kCCPayFileName"
#define kCCPayFilleSendOk @"kCCPayFilleSendOk"

#define kReturnCodeKey  @"return_code"
#define kTimeStampKey   @"timestamp"
#define kPartnerIDKey   @"partnerid"
#define kPrepayIDKey    @"prepayid"
#define kNoneStringKey  @"noncestr"
#define kPackageKey     @"package"
#define kSignKey        @"sign"

@interface EVPayManager ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) EVBaseToolManager *engine; /**< 网络请求引擎 */
@property (copy, nonatomic) NSString *transactionReceiptString; /**< 验证信息字符串 */
@property (copy, nonatomic) NSString *cacheName; /**< 验证信息存储后的名字 */

@end

@implementation EVPayManager

#pragma mark - publice class methods

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static EVPayManager *instance;
    dispatch_once( &onceToken, ^{
        instance = [[EVPayManager alloc] init];
        instance.engine = [[EVBaseToolManager alloc] init];
        instance.engine.syschronizedCache = YES;
    } );
    
    return instance;
}

- (void)dealloc
{
    [_engine cancelAllOperation];
    _engine = nil;
    [CCNotificationCenter removeObserver:self];
}


#pragma mark - public instance methods

- (void)payByWeiXinWithOder:(EVProductInfoModel *)product
{
    // 添加监听微信对于订单的处理结果
    [CCNotificationCenter addObserver:self
                             selector:@selector(weixinPaySuccess:)
                                 name:WeixinPaySuccessNotification
                               object:nil];
    [CCNotificationCenter addObserver:self
                             selector:@selector(weixinPayFailed:)
                                 name:WeixinPayFailedNotification
                               object:nil];
    
    [EV3rdPartAPIManager sharedManager].authType = EVPayManagerAuthWeixin;
    
    if ( [self checkWeixinInstalled] )
    {
        [self jumpToWeixinPayWithOder:product];
    }
}

- (void)cancelWeiXinPay
{
    [self removeWeixinPayObserver];
}

- (void)payByInAppPurchase:(EVProductInfoModel *)product
{
    if ( ![SKPaymentQueue canMakePayments] )
    {
        if ( self.delgate &&
            [self.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] )
        {
            [self.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                        failMessage:kE_GlobalZH(@"noNetwork")];
        }
        
        return;
    }
    // 通过观察者监听交易状态
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    // 根据
    [self requestProductsWithProductIdentifier:product.productid];
}

- (void)cancelInAppPay
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)cancelPay
{
    [self cancelInAppPay];
    [self cancelWeiXinPay];
}

- (void)checkWhetherAnyBuyedProductDoNotUploadToServerAndThenPushThem
{
    NSMutableArray *receiptsArrM =[self readReceiptArr];
    NSMutableArray *arrMTemp = [NSMutableArray arrayWithArray:receiptsArrM];
    for (NSDictionary *dict in arrMTemp)
    {
        NSString *fileName = dict[kCCPayFileName];
        if ( [fileName isKindOfClass:[NSString class]] && fileName.length > 0 )
        {
            NSString *recieptStr = [NSString stringWithContentsOfFile:[CCReceiptDataFolder stringByAppendingPathComponent:fileName]
                                                             encoding:NSUTF8StringEncoding
                                                                error:NULL];
            if ( recieptStr.length > 0 )
            {
                [self verifyReceipt:recieptStr
                      withCacheName:fileName
                         isReupload:YES];
            }
        }
    }
}


#pragma mark - SKProductsRequestDelegate

/**
 *  当请求到可卖商品的结果会执行该方法
 *
 *  @param response response中存储了可卖商品的结果
 */
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
  
    // 1.存储所有的数据
    NSArray *products = response.products;
    products = [products sortedArrayWithOptions:NSSortConcurrent
                                usingComparator:^NSComparisonResult(SKProduct *obj1,
                                                                    SKProduct *obj2) {
        return [obj1.price compare:obj2.price];
    }];
    
    if ( products.count > 0 )
    {
        // 上传日志
        [self.engine POSTPayLogWithType:CCTypeGetProductValue
                              state:CCStateSuccessValue
                           moreInfo:nil];
        
        SKProduct *product = [products firstObject];
        [self appPayBuyProduct:product];
        
    }
    else if ( self.delgate &&
             [self.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] )
    {
        [self.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                    failMessage:kE_GlobalZH(@"not_server_product_data_again")];
        // 上传日志
        [self.engine POSTPayLogWithType:CCTypeGetProductValue
                              state:CCStateFailValue
                           moreInfo:@{@"type" : @"response"}];
    }
}

- (void)  request:(SKRequest *)request
 didFailWithError:(NSError *)error
{
    if ( self.delgate &&
        [self.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] )
    {
        [self.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                    failMessage:kE_GlobalZH(@"noNetwork")];
    }
    // 上传日志
    [self.engine POSTPayLogWithType:CCTypeGetProductValue
                          state:CCStateSuccessValue
                       moreInfo:@{@"type" : [NSString stringWithFormat:@"err:%@", error.description]}];
}


#pragma mark - SKPaymentTransactionObserver

/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    /*
     SKPaymentTransactionStatePurchasing, 正在购买
     SKPaymentTransactionStatePurchased, 购买完成(销毁交易)
     SKPaymentTransactionStateFailed, 购买失败(销毁交易)
     SKPaymentTransactionStateRestored, 恢复购买(销毁交易)
     SKPaymentTransactionStateDeferred 最终状态未确定
     */
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                CCLog(@"用户正在购买");
                if ( self.delgate
                    && [self.delgate respondsToSelector:@selector(appPayInProcessing)] )
                {
                    [self.delgate appPayInProcessing];
                }
            }
                
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                CCLog(@"购买成功");
                // 上传日志
                NSMutableDictionary *moreInfoDict = [NSMutableDictionary dictionary];
                [moreInfoDict setValue:transaction.payment.productIdentifier
                                forKey:CCProductID];
                [self.engine POSTPayLogWithType:CCTypePayWithItuneStoreValue
                                      state:CCStateSuccessValue
                                   moreInfo:moreInfoDict];
                
                [queue finishTransaction:transaction];
                
                // 验证苹果支付
                [self veryfyAppPay];
            }
                
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                CCLog(@"购买失败");
                // 上传日志
                NSString *moreInfoStr = [NSString stringWithFormat:@"%@%zd", transaction.error.userInfo[@"NSLocalizedDescription"], transaction.error.code];
                NSMutableDictionary *moreInfoDict = [NSMutableDictionary dictionary];
                [moreInfoDict setValue:transaction.payment.productIdentifier
                                forKey:CCProductID];
                [moreInfoDict setValue:moreInfoStr forKey:CCMoreInfoKey];
                [self.engine POSTPayLogWithType:CCTypePayWithItuneStoreValue
                                      state:CCStateFailValue
                                   moreInfo:moreInfoDict];
                
                [queue finishTransaction:transaction];
                if ( self.delgate &&
                    [self.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] )
                {
                    EVPayFailedType type = EVPayFailedTypeError;
                    if ( transaction.error.code == SKErrorPaymentCancelled )
                    {
                        type = EVPayFailedTypeCancel;
                    }
                    [self.delgate appPayDidFailWithFailType:type
                                                failMessage:transaction.error.userInfo[@"NSLocalizedDescription"]];
                }
            }
                
                break;
                
            case SKPaymentTransactionStateRestored:
            {
                CCLog(@"恢复购买");
                // 上传日志
                [self.engine POSTPayLogWithType:CCTypePayWithItuneStoreValue
                                      state:CCStateFailValue
                                   moreInfo:@{@"type" : kE_GlobalZH(@"regain_bug")}];
                
                [queue finishTransaction:transaction];

            }
                
                break;
                
            case SKPaymentTransactionStateDeferred:
            {
                CCLog(@"最终状态未确定");
                // 上传日志
                [self.engine POSTPayLogWithType:CCTypePayWithItuneStoreValue
                                      state:CCStateFailValue
                                   moreInfo:@{@"type" : kE_GlobalZH(@"status_wei_determine")}];
                

            }
                
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - notifications

#pragma 微信相关的通知

- (void)weixinPaySuccess:(NSNotification *)notification
{
    [self removeWeixinPayObserver];
    if ( self.delgate &&
        [self.delgate respondsToSelector:@selector(weixinPayDidSucceed)] )
    {
        [self.delgate weixinPayDidSucceed];
    }
}

- (void)weixinPayFailed:(NSNotification *)notification
{
    [self removeWeixinPayObserver];
    // TODO: 处理通知类型

    if ( self.delgate &&
        [self.delgate respondsToSelector:@selector(weixinPayDidFailWithFailType:failMessage:)] )
    {
        [self.delgate weixinPayDidFailWithFailType:EVPayFailedTypeUnknown
                                       failMessage:kE_GlobalZH(@"wechat_pay_fail")];
    }
}

#pragma session过期相关的通知

- (void)sessiondidUpdate
{
    [CCNotificationCenter removeObserver:self
                                    name:CCSessionIdDidUpdateNotification
                                  object:nil];
    [self verifyReceipt:_transactionReceiptString
          withCacheName:self.cacheName
             isReupload:YES];
}


#pragma mark - private methods

- (void)removeWeixinPayObserver
{
    [CCNotificationCenter removeObserver:self
                                    name:WeixinPaySuccessNotification object:nil];
    [CCNotificationCenter removeObserver:self
                                    name:WeixinPayFailedNotification object:nil];
}

/**
 *  从自己的服务器获取支付订单，跳转到微信支付
 *
 *  @return
 */
- (void)jumpToWeixinPayWithOder:(EVProductInfoModel *)product
{
    
}

/**
 *  处理微信订单支付
 */
- (void)handleWeixinOrderGetFailed
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:kE_GlobalZH(@"pay_fail")
                                                    message:kE_GlobalZH(@"please_time_again")
                                                   delegate:nil
                                          cancelButtonTitle:kOK
                                          otherButtonTitles:nil];
    
    [alter show];
    [alter release];
    if ( self.delgate &&
        [self.delgate respondsToSelector:@selector(weixinPayDidFailWithFailType:failMessage:)] )
    {
        [self.delgate weixinPayDidFailWithFailType:EVPayFailedTypeError
                                       failMessage:kE_GlobalZH(@"wechat_pay_fail")];
    }
}

/**
 *  请求可卖商品
 */
- (void)requestProductsWithProductIdentifier:(NSString *)productId
{
     
    // 获取productid的set(集合中)
    NSSet *set = [NSSet setWithArray:@[productId]];
    
    // 向苹果发送请求,请求可卖商品
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    
    // 上传日志
    [self.engine POSTPayLogWithType:CCTypeGetProductValue
                          state:CCStateStartValue
                       moreInfo:@{CCProductID : productId}];
}

/**
 *  苹果购买商品
 *
 *  @param product 要买的商品
 */
- (void)appPayBuyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    // 上传日志
    [self.engine POSTPayLogWithType:CCTypePayWithItuneStoreValue
                          state:CCStateStartValue
                       moreInfo:@{CCProductID : product.productIdentifier}];
}

/**
 *  向后台发送苹果支付成功的验证信息，并存储验证信息，等待验证成功后再删除本地存储的验证信息，
    如果验证上传失败，则在app下次启动时重传
 */
- (void)veryfyAppPay
{
    NSURLRequest *appstoreRequest = [NSURLRequest requestWithURL:[[NSBundle mainBundle] appStoreReceiptURL]];
    
    NSError *error = nil;
    
    NSData *receiptData = [NSURLConnection sendSynchronousRequest:appstoreRequest
                                                 returningResponse:nil
                                                             error:&error];
    if ( error && self.delgate &&
        [self.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] )
    {
        [self.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                    failMessage:kE_GlobalZH(@"pay_fail_pay_money_cell_phone_official")];
        return;
    }
    // 存储验证信息
    NSString *transactionReceiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    _transactionReceiptString = transactionReceiptString;
    
    NSString *fileName = [self cacheReceiptDataWithDataString:transactionReceiptString];
    
    // 向后台发送数据，后台拿到数据之后向苹果验证服务器验证
    [self verifyReceipt:transactionReceiptString
          withCacheName:fileName
             isReupload:NO];
}

/**
 *  本地存储验证信息
 *
 *  @param dataStr 要存储的验证信息
 *
 *  @return 存储后的验证信息的文件名
 */
- (NSString *)cacheReceiptDataWithDataString:(NSString *)dataStr
{
    if ( dataStr.length <= 0 )
    {
        return nil;
    }
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    // 获取沙盒路径下存放验证信息名字的plist并转化为数组，然后把新的添加到数组中
    NSMutableArray *arrM = [self readReceiptArr];
    
    // 要存的信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    // 设置验证信息存储的名字,使用当前系统时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyMMddHHmmss";
    NSString *cacheName = [formater stringFromDate:date];
    self.cacheName = [cacheName mutableCopy];
    [dict setValue:cacheName forKey:kCCPayFileName];
    [dict setValue:@(NO) forKey:kCCPayFilleSendOk];
    [arrM addObject:dict];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:CCReceiptDataFolder] )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:CCReceiptDataFolder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    [arrM writeToFile:CCReceiptPlistFile
           atomically:YES];
    [data writeToFile:[CCReceiptDataFolder stringByAppendingPathComponent:cacheName]
           atomically:YES];
    
//    NSString *path = CCReceiptPlistFile;
//    NSLog(@"path:%@", path);
    return cacheName;
}

/**
 *  读取本地存储验证信息的plist并初始化为数组
 *
 *  @return 验证信息数组
 */
- (NSMutableArray *)readReceiptArr
{
    // 获取沙盒路径下存放验证信息名字的plist并转化为数组，然后把新的添加到数组中
    NSMutableArray *arrM = [NSMutableArray arrayWithContentsOfFile:CCReceiptPlistFile];
    if ( !arrM )
    {
        arrM = [NSMutableArray array];
    }
    
    return arrM;
}

/**
 *  查找某个成功验证的验证信息名字对应的文件，并删除
 *
 *  @param name 成功验证的验证信息名字
 */
- (void)checkSeccessReceiptWithName:(NSString *)name
{
    if ( name.length <= 0 )
    {
        return;
    }
    NSMutableArray *arrM = [self readReceiptArr];
    NSMutableArray *arrMTemp = [NSMutableArray arrayWithArray:arrM];
    NSString *fileName = nil;
    for (NSDictionary *dict in arrMTemp)
    {
        fileName = [dict valueForKey:kCCPayFileName];
        if ( [fileName isEqualToString:name] )
        {
            [arrM removeObject:dict];
            [[NSFileManager defaultManager] removeItemAtPath:[CCReceiptDataFolder
                                                              stringByAppendingPathComponent:name]
                                                       error:nil];
            [arrM writeToFile:CCReceiptPlistFile
                   atomically:YES];
            break;
        }
    }
}

/**
 *  处理像苹果发送验证信息的网络请求，如果验证成功删除本地存储的验证信息，
    如果失败则在接口中重复调用验证
 *
 *  @param receipt  验证信息
 *  @param name     本地存储验证信息文件的名字
 */
- (void)verifyReceipt:(NSString *)receipt
        withCacheName:(NSString *)cacheName
           isReupload:(BOOL)isReupload
{
    __weak typeof(self) weakself = self;
    [self.engine POSTApplevalidWith:receipt
                          start:nil
                           fail:^(NSError *error)
     {
         NSDictionary *errDict = error.userInfo;
         NSString *errStr = errDict[kRetvalKye];
         if ( [errStr isEqualToString:kApplePayVerifyErrorUsed] )
         {
             // 读取存储的验证信息，并删除
             [weakself checkSeccessReceiptWithName:cacheName];
         }
         else
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakself verifyReceipt:receipt
                           withCacheName:cacheName
                              isReupload:YES];
             });
         }
         if ( weakself.delgate &&
             [weakself.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] &&
             !isReupload)
         {
             [weakself.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                             failMessage:kE_GlobalZH(@"pay_fail_pay_money_cell_phone_official")];
         }
     }
                        success:^(NSDictionary *info)
     {
         NSInteger ecoin = [info[@"ecoin"] integerValue];
         if ( weakself.delgate &&
             [weakself.delgate respondsToSelector:@selector(appPayDidSucceedWithEcoin:)] &&
             !isReupload)
         {
             [weakself.delgate appPayDidSucceedWithEcoin:ecoin];
         }
         if ( cacheName.length > 0 )
         {
             // 读取存储的验证信息，并删除
             [weakself checkSeccessReceiptWithName:cacheName];
         }
     }
                 sessionExpired:^
     {
         if ( weakself.delgate &&
             [weakself.delgate respondsToSelector:@selector(appPayDidFailWithFailType:failMessage:)] &&
             !isReupload )
         {
             [weakself.delgate appPayDidFailWithFailType:EVPayFailedTypeError
                                             failMessage:kE_GlobalZH(@"fail_account_again_login")];
         }
         [CCNotificationCenter addObserver:weakself
                                  selector:@selector(sessiondidUpdate)
                                      name:CCSessionIdDidUpdateNotification
                                    object:nil];
     }];
}

- (BOOL)checkWeixinInstalled
{
    BOOL installed = NO;
    if ( [EVShareManager weixinInstall] )
    {
        installed = YES;
        return installed;
    }
    [[EVAlertManager shareInstance] performComfirmTitle:nil
                                                message:kE_GlobalZH(@"add_wechat_again")
                                           comfirmTitle:kOK
                                            WithComfirm:^{
        if ( self.delgate &&
            [self.delgate respondsToSelector:@selector(weixinPayDidFailWithFailType:failMessage:)] )
        {
            [self.delgate weixinPayDidFailWithFailType:EVPayFailedTypeCancel
                                           failMessage:kE_GlobalZH(@"cancel_wechat_pay")];
        }
    }];
    
    return installed;
}


#pragma mark - getters and setters
// fix by 马帅伟 线程安全问题(使用直接初始化的方式)
//- (CCBaseTool *)engine
//{
//    if ( _engine == nil )
//    {
//        
//    }
//    return _engine;
//}

@end
