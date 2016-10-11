//
//  EVAlertManager.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVAlertManager.h"

typedef  void(^NoParamsBlockType)();
typedef  void(^OneParamsBlockType)(id param);
typedef  void(^TwoParamBlockType)(UIAlertView *alert, id param);

@interface CCAlertUserInfo : NSObject

@property (nonatomic, copy) NSString           *idString;
@property (nonatomic, copy) NoParamsBlockType  cancelBlock;
@property (nonatomic, copy) NoParamsBlockType  comfirmBlock;
@property (nonatomic, copy) OneParamsBlockType editblock;
@property (nonatomic, copy) TwoParamBlockType  twoBlock;

- (instancetype)initWithComfirm:(NoParamsBlockType)comfirmBlock
                         cancel:(NoParamsBlockType)cancelBlock;
+ (instancetype)alertUserInfoWithComfirm:(NoParamsBlockType)comfirmBlock
                                  cancel:(NoParamsBlockType)cancelBloc;

@end

@implementation CCAlertUserInfo

- (instancetype)initWithComfirm:(NoParamsBlockType)comfirmBlock
                         cancel:(NoParamsBlockType)cancelBlock
{
    if ( self = [super init] )
    {
        self.comfirmBlock = comfirmBlock;
        self.cancelBlock = cancelBlock;
    }
    
    return self;
}

+ (instancetype)alertUserInfoWithComfirm:(NoParamsBlockType)comfirmBlock
                                  cancel:(NoParamsBlockType)cancelBlock
{
    return [[self alloc] initWithComfirm:comfirmBlock
                                  cancel:cancelBlock];
}

@end

@interface CCAlertView : UIAlertView

typedef void(^CancelBlock)(UIAlertView *alertView);

@property (nonatomic, strong) CCAlertUserInfo *alertInfo;

@property (copy, nonatomic) CancelBlock cancelBlock;


@end

@implementation CCAlertView


@end

@interface EVAlertManager ()<UIAlertViewDelegate>


@end

@implementation EVAlertManager


+ (instancetype)shareInstance
{
    static EVAlertManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      manager = [[self alloc] init];
                  });
    
    return manager;
}

//- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock {
//    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:comfirmTitle otherButtonTitles:nil];
//    CCAlertUserInfo *userInfo = [CCAlertUserInfo alertUserInfoWithComfirm:nil cancel:comfirmBlock];
//    alert.alertInfo = userInfo;
//    [alert show];
//    return alert;
//}

- (UIAlertView *)performComfirmTitle:(NSString *)title
                             message:(NSString *)message
                        comfirmTitle:(NSString *)comfirmTitle
                         WithComfirm:(void(^)())comfirmBlock
{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:comfirmTitle, nil];
    CCAlertUserInfo *userInfo = [CCAlertUserInfo alertUserInfoWithComfirm:comfirmBlock
                                                                   cancel:comfirmBlock];
    alert.alertInfo = userInfo;
    [alert show];
    return (UIAlertView *)alert;
}

- (void)configAlertViewWithTitle:(NSString *)title
                         message:(NSString *)message
                     cancelTitle:(NSString *)cancelTitle
                 WithCancelBlock:(void(^)(UIAlertView *alertView))cancelblock
{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:nil, nil];
    if ( cancelblock )
    {
        alert.cancelBlock = cancelblock;
    }
    [alert show];
}

- (UIAlertView *)performComfirmTitle:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancelTitle
                        comfirmTitle:(NSString *)comfirmTitle
                         WithComfirm:(void(^)())comfirmBlock
                              cancel:(void(^)())cancelBlock
{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:comfirmTitle, nil];
    CCAlertUserInfo *userInfo = [CCAlertUserInfo alertUserInfoWithComfirm:comfirmBlock
                                                                   cancel:cancelBlock];
    alert.alertInfo = userInfo;
    [alert show];
    
    return (UIAlertView *)alert;
}

- (UIAlertView *)performEditComfirmTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelTitle
                            comfirmTitle:(NSString *)comfirmTitle
                             WithComfirm:(void(^)(NSString *editMessage))comfirmBlock
                                  cancel:(void(^)())cancelBlock
{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:comfirmTitle, nil];
    CCAlertUserInfo *userInfo = [CCAlertUserInfo alertUserInfoWithComfirm:comfirmBlock
                                                                   cancel:cancelBlock];
    userInfo.editblock = comfirmBlock;
    userInfo.comfirmBlock = nil;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.alertInfo = userInfo;
    [alert show];
    
    return alert;
}

- (UIAlertView *)performEditComfirmTitle:(NSString *)title
                            keyboardType:(UIKeyboardType)type
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelTitle
                            comfirmTitle:(NSString *)comfirmTitle
                             WithComfirm:(void(^)(NSString *editMessage))comfirmBlock
                                  cancel:(void(^)())cancelBlock
{
    CCAlertView *alert = [[CCAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelTitle
                                          otherButtonTitles:comfirmTitle, nil];
    CCAlertUserInfo *userInfo = [CCAlertUserInfo alertUserInfoWithComfirm:comfirmBlock
                                                                   cancel:cancelBlock];
    userInfo.editblock = comfirmBlock;
    userInfo.comfirmBlock = nil;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textfield = [alert textFieldAtIndex:0];
    textfield.keyboardType = type;
    alert.alertInfo = userInfo;
    [alert show];
    
    return alert;
}

#pragma mark - UIAlertViewDelegate
- (void)    alertView:(CCAlertView *)alertView
 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CCAlertUserInfo *userInfo = alertView.alertInfo;
    NSString *editStr = nil;
    if ( alertView.alertViewStyle == UIAlertViewStylePlainTextInput )
    {
        editStr = [[alertView textFieldAtIndex:0].text mutableCopy];
        [alertView endEditing:YES];
    }
    switch (buttonIndex)
    {
        case 0: //  取消
            if ( userInfo.cancelBlock )
            {
                userInfo.cancelBlock();
            }
            if ( alertView.cancelBlock )
            {
                alertView.cancelBlock(alertView);
            }
            break;
            
        case 1: //  确定
            if ( userInfo.comfirmBlock )
            {
                userInfo.comfirmBlock();
            }
            else if ( userInfo.editblock )
            {
                userInfo.editblock(editStr);
            }
            break;
            
        default:
            break;
    }
    userInfo.cancelBlock = nil;
    userInfo.comfirmBlock = nil;
    userInfo.editblock = nil;
}

-(void)addObserver:(NSObject *)observer
        forKeyPath:(NSString *)keyPath
           options:(NSKeyValueObservingOptions)options
           context:(void *)context
{
    
}
@end
