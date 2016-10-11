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

#define kDefaultTitle kE_GlobalZH(@"setting_user")
#define kTableFooterHeiht 44
#define kDefaultMargin 24

@interface EVUserSettingViewController () <UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray *firstSectionItems;

@property (nonatomic, strong) NSMutableArray *secondSectionItems;

@property (nonatomic, strong) EVBaseToolManager *engin;

@property (nonatomic, copy) NSString *signature;

@property (nonatomic,strong)CCUserSettingItem *UserSettingItem;

@property (nonatomic, strong)CCUserSettingItem *headImageSettingItem;

@property (nonatomic, strong) UIBarButtonItem *barButtonItem;

@property (nonatomic, assign) BOOL upDateImageError;

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [CCNotificationCenter removeObserver:self];
    
    CCLog(@" %@ dealloc", [self class]);
    [_engin cancelAllOperation];
    _engin = nil;
}


#pragma mark - ***********      Build UI 🎨       ***********
- (void)configView
{
// fix by 施志昂 检查约束
//    self.tableView.rowHeight = 51;
    self.tableView.sectionHeaderHeight = CGFLOAT_MIN;
    self.title = kDefaultTitle;
    

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.separatorColor = [UIColor colorWithHexString:kGlobalSeparatorColorStr];
    // 右上角下一步按钮
    self.tableView.backgroundColor = [UIColor evBackgroundColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:self.isReedit ? kE_GlobalZH(@"carry_out") : kE_GlobalZH(@"next") style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem setTintColor:[UIColor evSecondColor]];
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
    
    CCUserSettingItem *birthday = [[CCUserSettingItem alloc] init];
    birthday.settingTitle = kBirthDayTitle;
    birthday.contentTitle = self.userInfo.birthday
    ;
    birthday.access = YES;
    birthday.loginInfo= self.userInfo;
    birthday.keyBoardType = EVKeyBoardBirthday;
    birthday.placeHolder = @"1990-06-15";
    birthday.cellStyleType = EVCellStyleNomal;
    [self.secondSectionItems addObject:birthday];
    
    CCUserSettingItem *Constellation = [[CCUserSettingItem alloc] init];
//    NSString *ConstellationStr = [NSString judConstellationDateStr:self.userInfo.birthday];
    Constellation.settingTitle = kConstellation;
//    Constellation.contentTitle = ConstellationStr;
    Constellation.access = NO;
    if (!self.isReedit) {
        
    }else {
        NSString *ConstellationStr = [NSString judConstellationDateStr:self.userInfo.birthday];
        Constellation.contentTitle = ConstellationStr;
        Constellation.placeHolder = @"双子座";
    }
    Constellation.cellStyleType = EVCellStyleConstellation;
    [self.secondSectionItems addObject:Constellation];
    self.UserSettingItem = Constellation;
   

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
    intro.settingTitle = kIntroTitle;
    intro.contentTitle = self.userInfo.signature;
    intro.access = YES;
    intro.loginInfo = self.userInfo;
    intro.placeHolder = kE_GlobalZH(@"write_signature");
    intro.cellStyleType = EVCellStyleSignature;
    [self.secondSectionItems addObject:intro];
    
}

#pragma mark - ***********      Actions 🌠        ***********
- (void)upLoadLogoSuccess
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    self.barButtonItem.enabled = YES;
    // fix by 马帅伟 测试 (已经测试通过，不再执行页面消失的动画，直接切换到主页面，根据情况采用不同的切换方式)
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 直接进入的注册，root view controller 为 loginVC
    [appDelegate setUpHomeController];
    
}

#pragma mark - network
- (void)next
{
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
    
    if (self.userInfo.birthday.length <= 0)
    {
        UIAlertView *dataalert = [[UIAlertView alloc] initWithTitle:nil message:kE_GlobalZH(@"not_birthday") delegate:nil cancelButtonTitle:kOK otherButtonTitles:nil, nil];
        [dataalert show];
        return;
    }
    
    __weak typeof(self) wself = self;
    if ( !self.isReedit )
    { // 新注册信息
        if (self.upDateImageError == YES) {
            [self upLoadLogoImage];
            return;
        }
        [self.engin GETNewUserRegistMessageWithParams:[self.userInfo userRegistParams] start:^{
            wself.barButtonItem.enabled = NO;
            [CCProgressHUD showMessage:kE_GlobalZH(@"logining_user_information") toView:wself.view];
        } fail:^(NSError *error) {
            [CCProgressHUD hideHUDForView:wself.view];
            wself.barButtonItem.enabled = YES;
            NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_user_information")];
            [CCProgressHUD showError:errorStr toView:wself.view];
        } success:^(EVLoginInfo *loginInfo) {
            loginInfo.registeredSuccess = YES;
            [EVSDKInitManager initMessageSDKUserData:loginInfo.name];
            [loginInfo synchronized];
            [CCProgressHUD hideHUDForView:wself.view];
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
        [params setValue:tagStr forKey:kTaglist];
        [self.engin GETUsereditinfoWithParams:params start:^{
            [CCProgressHUD showMessage:kE_GlobalZH(@"save_user_data") toView:wself.view];
        } fail:^(NSError *error) {
            NSString *errorStr = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_change_date")];
            [CCProgressHUD hideHUDForView:wself.view];
            [CCProgressHUD showError:errorStr toView:wself.view];
        } success:^{
            [wself.userInfo synchronized];
            [CCProgressHUD hideHUDForView:wself.view];
            if ( wself.userInfo.selectImage )
            {
                [wself upLoadLogoImage];
            }
            else
            {
                [wself.navigationController popViewControllerAnimated:YES];
                [EVBaseToolManager notifyLoginViewDismiss];
            }
        } sessionExpire:^{
            [CCProgressHUD hideHUDForView:wself.view];
            [CCProgressHUD showError:kE_GlobalZH(@"fail_account_again_login") toView:wself.view];
            [wself.navigationController popViewControllerAnimated:YES];
            [CCProgressHUD hideHUD];
        }];
    }
}

- (void)upLoadLogoImage
{
    [CCProgressHUD hideHUDForView:self.view];
    __weak typeof(self) wself = self;
    [self.engin GETUploadUserLogoWithImage:self.userInfo.selectImage uname:self.userInfo.nickname start:^{
        [CCProgressHUD showMessage:kE_GlobalZH(@"update_image") toView:wself.view];
        
    } fail:^(NSError *error) {
        [CCProgressHUD hideHUDForView:wself.view];
        self.barButtonItem.enabled = YES;
        self.upDateImageError = YES;
        NSString *customErrorInfo = [error errorInfoWithPlacehold:kE_GlobalZH(@"fail_update_image")];
        if ( customErrorInfo ) {
            [[EVAlertManager shareInstance] performComfirmTitle:kTooltip message:customErrorInfo comfirmTitle:kOK WithComfirm:nil];
        } else {
            [CCProgressHUD showError:kE_GlobalZH(@"again_fail_update_image") toView:wself.view];
        }
    } success:^(NSDictionary *retinfo){
        self.barButtonItem.enabled = YES;
        wself.upDateImageError = NO;
        wself.userInfo.logourl = retinfo[@"logourl"];
        [CCNotificationCenter postNotificationName:CCUpdateLogolURLNotification object:nil userInfo:retinfo];
        [wself.userInfo synchronized];
        [CCProgressHUD hideHUDForView:wself.view];
        [CCProgressHUD showSuccess:kE_GlobalZH(@"update_iamge_success") toView:wself.view];
        [wself upLoadLogoSuccess];
        
    } sessionExpire:^{
        self.barButtonItem.enabled = YES;
        // TODO
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
#ifdef CCDEBUG
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
    __weak typeof(self) wself = self;
    if ( [item.settingTitle isEqualToString:kIntroTitle] )
    {
        //点击个性签名跳转到个性签名设置
        EVSignatureViewController *svc = [[EVSignatureViewController alloc] init];
        svc.text = item.contentTitle;
        __block NSIndexPath *wIndexPath = indexPath;
        svc.commitBlock = ^(NSString *text) {
            wself.signature = text;
            [wself.tableView reloadRowsAtIndexPaths:@[wIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:svc animated:YES];
        
        //点击进入个性标签
    }
    
    if ([item.settingTitle isEqualToString:kE_GlobalZH(@"user_image")]) {
        UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:kCancel
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:kE_GlobalZH(@"photo_gallery_change"),kE_GlobalZH(@"camera_shooting"), nil];
        [action showInView:self.view];
    }
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
    cell.constellationB = ^(NSString *sssss){
        NSString *ConstellationStr = [NSString judConstellationDateStr:self.userInfo.birthday];
        self.UserSettingItem.contentTitle = ConstellationStr;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    CCUserSettingItem *item = itemArray[indexPath.row];
    if ( [item.settingTitle isEqualToString:kIntroTitle] )
    {
        if ( self.signature )
        {
            item.contentTitle = self.signature;
        }
        self.userInfo.signature = item.contentTitle;
    }
    cell.settingItem = item;
    
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
