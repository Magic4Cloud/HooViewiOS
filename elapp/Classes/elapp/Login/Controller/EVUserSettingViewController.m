//
//  EVUserSettingViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVUserSettingViewController.h"
#import "EVLoginInfo.h"
#import "EVUserSettingCell.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "EVAlertManager.h"
#import "EVSignatureViewController.h"
#import "NSString+Extension.h"
#import "EVStreamer+Extension.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "AppDelegate.h"
#import "EVSDKInitManager.h"
#import "EVSignatureEditView.h"
#import "EVUserTagsViewController.h"
#import "EVUserTagsView.h"
#import "EVUserTagsModel.h"

#define kDefaultTitle kE_GlobalZH(@"setting_user")
#define kTableFooterHeiht 44
#define kDefaultMargin 24

@interface EVUserSettingViewController () <UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *firstSectionItems;

@property (nonatomic, strong) NSMutableArray *secondSectionItems;

@property (nonatomic, strong) EVBaseToolManager *engin;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *credentials;

@property (nonatomic,strong)CCUserSettingItem *UserSettingItem;

@property (nonatomic, strong)CCUserSettingItem *headImageSettingItem;

@property (nonatomic, strong) UIBarButtonItem *barButtonItem;

@property (nonatomic, assign) BOOL upDateImageError;

@property (nonatomic, strong) EVSignatureEditView *signatureView;

@end

@implementation EVUserSettingViewController

#pragma mark - ***********         Init💧         ***********
+ (instancetype)userSettingViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"EVUserSettingViewController" bundle:nil];
    return storyBoard.instantiateInitialViewController;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


#pragma mark - life cycle
// 注册的时候前面的页面会隐藏导航条，这里显示出来
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor evTextColorH2];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor evTextColorH2]}];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.upDateImageError = NO;
    [self configView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.signatureView = nil;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}
- (void)dealloc
{
    self.signatureView = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [EVNotificationCenter removeObserver:self];
    
    EVLog(@" %@ dealloc", [self class]);
    [_engin cancelAllOperation];
    _engin = nil;
}


#pragma mark - ***********      Build UI 🎨       ***********
- (void)configView
{
//    self.tableView.rowHeight = 51;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    self.title = @"编辑资料";
    

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.separatorColor = [UIColor evGlobalSeparatorColor];
    // 右上角下一步按钮
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:self.isReedit ? kE_GlobalZH(@"carry_out") : kE_GlobalZH(@"next") style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem setTintColor:[UIColor evMainColor]];

    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:(UIControlStateNormal)];
    _barButtonItem = rightItem;
    
    CCUserSettingItem *headImageItem = [[CCUserSettingItem alloc] init];
    headImageItem.settingTitle = kE_GlobalZH(@"user_image");
    headImageItem.contentTitle = nil;
    headImageItem.loginInfo= self.userInfo;
    headImageItem.access = YES;
    headImageItem.placeHolder = nil;
    headImageItem.cellStyleType = EVCellStyleHeaderImage;
    headImageItem.logoUrl = self.userInfo.logourl;
    [self.firstSectionItems addObject:headImageItem];
    self.headImageSettingItem = headImageItem;
    
    CCUserSettingItem *nameItem = [[CCUserSettingItem alloc] init];
    nameItem.settingTitle = kNameTitle;
    nameItem.contentTitle = self.userInfo.nickname;
    nameItem.loginInfo= self.userInfo;
    nameItem.access = YES;
    nameItem.placeHolder = kE_GlobalZH(@"enter_name");
    nameItem.cellStyleType = EVCellStyleName;
    [self.firstSectionItems addObject:nameItem];
    
    CCUserSettingItem *sex = [[CCUserSettingItem alloc] init];
    sex.settingTitle = kSexTitle;
    sex.contentTitle = self.userInfo.sexStr;
    sex.loginInfo= self.userInfo;
    sex.keyBoardType = EVKeyBoardSex;
    sex.access = YES;
    sex.hiddenLine = YES;
    sex.placeHolder = kE_GlobalZH(@"user_setting");
    sex.cellStyleType = EVCellStyleNomal;
    [self.secondSectionItems addObject:sex];
    
    
    CCUserSettingItem *location = [[CCUserSettingItem alloc] init];
    location.settingTitle = kLocationTitle;
    location.contentTitle = self.userInfo.location;
    location.access = YES;
    location.loginInfo= self.userInfo;
    location.keyBoardType = EVKeyBoardLocation;
    location.placeHolder = kE_GlobalZH(@"user_setting");
    location.cellStyleType = EVCellStyleNomal;
    [self.secondSectionItems addObject:location];
    
    
    CCUserSettingItem *intro = [[CCUserSettingItem alloc] init];
    intro.settingTitle = @"介绍自己";
    intro.contentTitle = self.userInfo.signature;
    intro.access = YES;
    intro.loginInfo = self.userInfo;
    intro.placeHolder = @"火眼助你成为财经大师";
    intro.cellStyleType = EVCellStyleSignature;
    [self.secondSectionItems addObject:intro];
    
    if ([EVLoginInfo localObject].vip) {
        CCUserSettingItem *preNum = [[CCUserSettingItem alloc] init];
        preNum.settingTitle = @"执业证号";
        preNum.contentTitle = self.userInfo.credentials.length > 0 ? self.userInfo.credentials : @"请完善您的证券执业资格号";
        preNum.access = YES;
        preNum.loginInfo = self.userInfo;
        preNum.placeHolder = @"请完善您的证券执业资格号";
        preNum.cellStyleType = EVCellStylePreNum;
        [self.secondSectionItems addObject:preNum];
        
        CCUserSettingItem *birthday = [[CCUserSettingItem alloc] init];
        birthday.settingTitle = @"我的标签";
        birthday.contentTitle = self.userInfo.birthday;
        birthday.access = YES;
        birthday.loginInfo= self.userInfo;
        birthday.cellStyleType = EVCellStyleTags;
        [self.secondSectionItems addObject:birthday];
        
    }
   


    
}

- (void)setTagsAry:(NSArray *)tagsAry
{
    _tagsAry = tagsAry;
}
- (void)loadTagsData
{
    [self.engin GETUserTagsListfail:^(NSError *error) {
        
    } success:^(NSDictionary *info) {
        NSArray *tagArray = info[@"tags"];
        NSMutableArray *titleAry = [NSMutableArray array];
        for (NSDictionary *dict in tagArray) {
            [titleAry addObject:dict[@"tagname"]];
        }
      
    
    }];
}
#pragma mark - ***********      Actions 🌠        ***********
- (void)upLoadLogoSuccess
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.barButtonItem.enabled = YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 直接进入的注册，root view controller 为 loginVC
    [appDelegate setUpHomeController];
    
}

#pragma mark - network
- (void)next
{
    [self.view endEditing:YES];
    if ( !self.isReedit && !self.userInfo.selectImage && !self.userInfo.logourl )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kE_GlobalZH(@"not_user_image") delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    NSString *nickNameNoSpace = [self.userInfo.nickname deleteSpace];
    if ( nickNameNoSpace.length == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kE_GlobalZH(@"not_user_name") delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ( [nickNameNoSpace numOfWordWithLimit:10] > 10 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:kE_GlobalZH(@"not_length_ten_num_user_name") delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.userInfo.nickname = nickNameNoSpace;
    
    __weak typeof(self) wself = self;
    if ( !self.isReedit )
    { // 新注册信息
        if (self.upDateImageError == YES) {
            [self upLoadLogoImage];
            return;
        }
        [self.engin GETNewUserRegistMessageWithParams:[self.userInfo userRegistParams] start:^{
            wself.barButtonItem.enabled = NO;
            [EVProgressHUD showMessage:kE_GlobalZH(@"logining_user_information") toView:wself.view];
        } fail:^(NSError *error) {
            [EVProgressHUD hideHUDForView:wself.view];
            wself.barButtonItem.enabled = YES;
            NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_user_information")];
            [EVProgressHUD showError:errorStr toView:wself.view];
            
        } success:^(EVLoginInfo *loginInfo) {
            loginInfo.registeredSuccess = YES;
            [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
            [loginInfo synchronized];
            [EVProgressHUD hideHUDForView:wself.view];
            wself.userInfo.sessionid = loginInfo.sessionid;
            if ( wself.userInfo.selectImage )
            {
                [wself upLoadLogoImage];
            }
            else
            {
                [wself upLoadLogoSuccess];
            }
        }];
    }
    else
    {
        NSMutableString *mTagStr = [NSMutableString string];
        NSString *tagStr = @"";
        
        if (mTagStr.length > 0)
        {
            tagStr = [mTagStr substringToIndex:mTagStr.length - 1];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.userInfo.userInfoParams];
        [params setValue:self.userInfo.userInfoParams[kDisplayname] forKey:kNickName];
        [self.engin GETUsereditinfoWithParams:params start:^{
            [EVProgressHUD showMessage:kE_GlobalZH(@"save_user_data") toView:wself.view];
        } fail:^(NSError *error) {
            NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_change_date")];
            [EVProgressHUD hideHUDForView:wself.view];
            [EVProgressHUD showError:errorStr toView:wself.view];
            if ([errorStr isEqualToString:@"昵称包含不当词语"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    EVUserSettingCell *nicknameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                    [nicknameCell textFieldBecomeFirstResponse];
                });
            }
        } success:^{
            [EVProgressHUD hideHUDForView:wself.view];
            if ( wself.userInfo.selectImage )
            {
                [wself upLoadLogoImage];
            }
            else
            {
                [wself.navigationController popViewControllerAnimated:YES];
                [EVBaseToolManager notifyLoginViewDismiss];
            }
            [EVNotificationCenter postNotificationName:@"modifyUserInfoSuccess" object:nil];
        } sessionExpire:^{
            [EVProgressHUD hideHUDForView:wself.view];
            [EVProgressHUD showError:kE_GlobalZH(@"fail_account_again_login") toView:wself.view];
            [wself.navigationController popViewControllerAnimated:YES];
            [EVProgressHUD hideHUD];
        }];
    }
}

- (void)upLoadLogoImage
{
    [EVProgressHUD hideHUDForView:self.view];
    __weak typeof(self) wself = self;
    [self.engin GETUploadUserLogoWithImage:self.userInfo.selectImage uname:self.userInfo.nickname start:^{
        [EVProgressHUD showMessage:kE_GlobalZH(@"update_image") toView:wself.view];
        
    } fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:wself.view];
        self.barButtonItem.enabled = YES;
        self.upDateImageError = YES;
        NSString *customErrorInfo = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_update_image")];
        if ( customErrorInfo ) {
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:customErrorInfo comfirmTitle:kOK WithComfirm:nil];
        } else {
            [EVProgressHUD showError:kE_GlobalZH(@"again_fail_update_image") toView:wself.view];
        }
    } success:^(NSDictionary *retinfo){
        wself.barButtonItem.enabled = YES;
        wself.upDateImageError = NO;
        wself.userInfo.logourl = retinfo[@"logourl"];
        [EVNotificationCenter postNotificationName:CCUpdateLogolURLNotification object:nil userInfo:retinfo];
        [wself.userInfo synchronized];
        [EVProgressHUD hideHUDForView:wself.view];
        [EVProgressHUD showSuccess:kE_GlobalZH(@"update_iamge_success") toView:wself.view];
//        if (self.isReedit) {
//            
//        }else {
//            [wself upLoadLogoSuccess];
//        }
        [EVNotificationCenter postNotificationName:@"newUserRefusterSuccess" object:nil];
        [wself.navigationController popViewControllerAnimated:YES];
        
    } sessionExpire:^{
        wself.barButtonItem.enabled = YES;
    }];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    switch ( buttonIndex )
    {
        case 0: // 从相册中选取
            [self.navigationController presentViewController:picker animated:YES completion:nil];
            break;
        case 1: // 拍摄选取
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            __weak typeof(self) weakself = self;
            [EVStreamer requestCameraAuthedUserAuthed:^{
                [weakself.navigationController presentViewController:picker animated:YES completion:nil];
            } userDeny:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image cc_reSizeImageToSize:CGSizeMake(640, 640)];
#ifdef EVDEBUG
    NSAssert(image, @"get image fail");
#endif
    self.headImageSettingItem.logoImage  = image;
    self.userInfo.selectImage = image;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    for ( int i = 0; i < self.firstSectionItems.count; i++ )
    {
        EVUserSettingCell *firstGroupCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [firstGroupCell textFiledResignFirstResponse];
    }
    
    for ( int i = 0; i < self.secondSectionItems.count; i++ )
    {
        EVUserSettingCell *secondGroupCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:1]];
        [secondGroupCell textFiledResignFirstResponse];
        if (indexPath.section == 0 && indexPath.row == 1) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    //点击个性签名
    NSArray *itemArray = nil;
    if ( indexPath.section == 0 )
    {
        itemArray = self.firstSectionItems;
    }
    else
    {
        itemArray = self.secondSectionItems;
    }
    
    CCUserSettingItem *item = itemArray[indexPath.row];
    //__weak typeof(self) wself = self;
    if ( [item.settingTitle isEqualToString:@"介绍自己"] )
    {
        [self addSignatureView:item.contentTitle];
        
        //点击个性签名跳转到个性签名设置
//        EVSignatureViewController *svc = [[EVSignatureViewController alloc] init];
//        svc.text = item.contentTitle;
//        __block NSIndexPath *wIndexPath = indexPath;
//        svc.commitBlock = ^(NSString *text) {
//            wself.signature = text;
//            [wself.tableView reloadRowsAtIndexPaths:@[wIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [self.navigationController pushViewController:svc animated:YES];
        
        //点击进入个性标签
    }
    if ( [item.settingTitle isEqualToString:@"我的标签"] )
    {
        //        [self addSignatureView];
//        
//        //点击个性签名跳转到个性签名设置
//        EVSignatureViewController *svc = [[EVSignatureViewController alloc] init];
//        svc.text = item.contentTitle;
//        __block NSIndexPath *wIndexPath = indexPath;
//        svc.commitBlock = ^(NSString *text) {
//            wself.signature = text;
//            [wself.tableView reloadRowsAtIndexPaths:@[wIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//        };
//        [self.navigationController pushViewController:svc animated:YES];
        EVUserSettingCell *firstGroupCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:1]];
        NSLog(@"跳转标签设置页面");
        EVUserTagsViewController *userTagsVC = [[EVUserTagsViewController alloc] init];\
        __weak typeof(firstGroupCell) gCell = firstGroupCell;
        userTagsVC.userTLBlock = ^(NSMutableArray *tagAry) {
            gCell.userTagsView.dataArray = tagAry;
        };
        [self.navigationController pushViewController:userTagsVC animated:YES];
        //点击进入个性标签
    }
    
    if ([item.settingTitle isEqualToString:kE_GlobalZH(@"user_image")]) {
        UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:kCancel
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:kE_GlobalZH(@"photo_album"),kE_GlobalZH(@"photo_capture"), nil];
        [action showInView:self.view];
    }
}

- (void)addSignatureView:(NSString *)text
{
    
    self.signatureView = [[EVSignatureEditView alloc] init];
    self.signatureView.originText = text;
    self.signatureView.frame = [UIScreen mainScreen].bounds;
    self.signatureView.backgroundColor = [UIColor clearColor];
    WEAK(self)
    self.signatureView.hideViewBlock = ^(NSString *inputStr){
        weakself.signatureView = nil;
        [weakself.signatureView resignKeyWindow];
    };
    self.signatureView.confirmBlock = ^(NSString *inputStr) {
        weakself.signature = inputStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        weakself.signatureView = nil;
        [weakself.signatureView resignKeyWindow];
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0 )
    {
        return self.firstSectionItems.count;
    }
    else
    {
        return self.secondSectionItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVUserSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EVUserSettingCell"];
    NSArray *itemArray = nil;
    if ( indexPath.section == 0 )
    {
        itemArray = self.firstSectionItems;
    }
    else
    {
        itemArray = self.secondSectionItems;
        
    }
    WEAK(self)
    cell.constellationB = ^(NSString *sssss){
        NSString *ConstellationStr = [NSString judConstellationDateStr:self.userInfo.birthday];
        weakself.UserSettingItem.contentTitle = ConstellationStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    CCUserSettingItem *item = itemArray[indexPath.row];
    if ( [item.settingTitle isEqualToString:@"介绍自己"] )
    {
        if ( self.signature )
        {
            item.contentTitle = self.signature;
        }
        self.userInfo.signature = item.contentTitle;
    }
    cell.settingItem = item;
    if (indexPath.section == 1 && indexPath.row == 4) {
        NSMutableArray *titleAry = [NSMutableArray array];
        for (EVUserTagsModel *model in self.tagsAry) {
            [titleAry addObject:model.tagname];
        }
        cell .userTagsView.dataArray = titleAry;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 100;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor evBackgroundColor];
    return view;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - setter and getter

- (EVBaseToolManager *)engin
{
    if ( _engin == nil )
    {
        _engin = [[EVBaseToolManager alloc] init];
    }
    return _engin;
}

- (NSMutableArray *)firstSectionItems
{
    if ( _firstSectionItems == nil )
    {
        _firstSectionItems = [NSMutableArray arrayWithCapacity:3];
    }
    return _firstSectionItems;
}

- (NSMutableArray *)secondSectionItems
{
    if ( _secondSectionItems == nil )
    {
        _secondSectionItems = [NSMutableArray arrayWithCapacity:5];
    }
    return _secondSectionItems;
}
@end
