//
//  EVNativeComentsViewController.m
//  elapp
//
//  Created by 唐超 on 5/10/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeComentViewController.h"
#import "EVBaseToolManager+EVHomeAPI.h"
#import "EVHVVideoCommentModel.h"
#import "EVCommentViewCell.h"
#import "EVWatchVideoInfo.h"
#import "EVVipCenterController.h"
#import "EVNormalPersonCenterController.h"
#import "EVHVChatTextView.h"
#import "YZInputView.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"

typedef NS_ENUM(NSInteger , EVCommentChooseType){
    EVOrderByhotButton = 100,
    EVOrderByDateButton,
};


@interface EVNativeComentViewController ()<UITableViewDelegate,UITableViewDataSource,EVHVChatTextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIButton *orderByhotButton;
@property (weak, nonatomic) IBOutlet UIButton *orderByDateButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EVBaseToolManager *baseToolManager;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *orderby;
@property (nonatomic, weak) EVHVChatTextView *chatTextView;
@property (nonatomic, strong) NSLayoutConstraint *chatTextViewHig;
@property (nonatomic, strong) NSLayoutConstraint *chatTextViewBom;
@property (nonatomic, assign)NSInteger selectedIndex;

//@property (nonatomic, strong) EVHVVideoCommentModel *
@end

@implementation EVNativeComentViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ♻️Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _start = @"0";
    self.selectedIndex = 0;
    _orderby = @"heats";
    [self initUI];
    [self initData];
    [self addChatTextView];
    [self.chatTextView.commentBtn resignFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    self.title = @"全部评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = CCColor(248, 248, 248);
    [self.view addSubview:self.tableView];
    _orderByhotButton.selected = YES;
    _orderByhotButton.tag = EVOrderByhotButton;
    _orderByDateButton.tag = EVOrderByDateButton;
    [_orderByhotButton setTitleColor:[UIColor evMainColor] forState:UIControlStateSelected];
    [_orderByDateButton setTitleColor:[UIColor evMainColor] forState:UIControlStateSelected];
}

#pragma mark - 🌐Networks
- (void)initData {
    WEAK(self)
    [self.tableView addRefreshHeaderWithRefreshingBlock:^{
        _start = @"0";
        [weakself loadCommentsStart:@"0" count:@"20"];
    }];
    
    [self.tableView addRefreshFooterWithRefreshingBlock:^{
        
        [weakself loadCommentsStart:weakself.start count:@"20"];
        
    }];
    [self.tableView startHeaderRefreshing];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadCommentsStart:(NSString *)start count:(NSString *)count {
    [self.baseToolManager GETVideoCommentListtopicid:self.newsid orderby:_orderby type:@"0" start:_start count:@"20" start:^{
        
    } fail:^(NSError *error) {
        [self.tableView endHeaderRefreshing];
        [self.tableView endFooterRefreshing];
        [EVProgressHUD showError:@"加载失败"];
    } success:^(NSDictionary *retinfo) {
        [self.tableView endHeaderRefreshing];
        [self.tableView endFooterRefreshing];
        if ([retinfo[@"retinfo"][@"start"] integerValue] == 0) {
            [self.dataArray removeAllObjects];
        }
        
        self.start = retinfo[@"retinfo"][@"next"];
        [self.tableView endFooterRefreshing];
        NSArray *commentArr = [EVHVVideoCommentModel objectWithDictionaryArray:retinfo[@"retinfo"][@"posts"]];
        [self.dataArray addObjectsFromArray:commentArr];
        [self.tableView reloadData];
        [self.tableView setFooterState:(commentArr.count < kCountNum ? CCRefreshStateNoMoreData : CCRefreshStateIdle)];
    }];
}


#pragma mark -👣 Target actions
- (IBAction)orderButtonClick:(UIButton *)sender {
    // 获得当前点击的Index
    NSInteger index = sender.tag - 100;
    if (index == self.selectedIndex) {
        return;
    }
    
    UIButton *button = (UIButton *)[self.view viewWithTag:self.selectedIndex + 100];
    button.selected = !button.selected;
    sender.selected = !sender.selected;
    self.selectedIndex = index;
    if (index == 0) {
        _orderby = @"heats";
    } else {
        _orderby = @"dateline";
    }
    _start = @"0";
    [self.tableView startHeaderRefreshing];
}

#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVVideoCommentModel *commentModel = self.dataArray[indexPath.row];
    return commentModel.cellHeight < 87 ? 87 : commentModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVCommentViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (!Cell) {
        Cell = [[EVCommentViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"commentCell"];
    }
    Cell.likeType = @"0";
    Cell.videoCommentModel = self.dataArray[indexPath.row];
    Cell.selectionStyle = NO;
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EVHVVideoCommentModel *commentModel = self.dataArray[indexPath.row];
    
    if (commentModel.user.vip == 1)
    {
        EVWatchVideoInfo *watchInfo = [EVWatchVideoInfo new];
        watchInfo.name = commentModel.user.id;
        EVVipCenterController *vc = [[EVVipCenterController alloc] init];
        vc.watchVideoInfo = watchInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        EVWatchVideoInfo *watchInfo = [EVWatchVideoInfo new];
        watchInfo.name = commentModel.user.id;
        EVNormalPersonCenterController  *vc = [[EVNormalPersonCenterController alloc] init];
        vc.watchVideoInfo = watchInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }

}


#pragma mark - 添加聊天输入框
- (void)addChatTextView
{
    EVHVChatTextView *chatTextView = [[EVHVChatTextView alloc] init];
    //    chatTextView.frame = CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49);
    [self.view addSubview:chatTextView];
    chatTextView.backgroundColor = [UIColor whiteColor];
    chatTextView.delegate = self;
    //    chatTextView.commentBtn.delegate = self;
    _chatTextView = chatTextView;
    _chatTextView.commentBtnRig.constant = -10;
    [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    self.chatTextViewHig =   [chatTextView autoSetDimension:ALDimensionHeight toSize:49];
    self.chatTextViewBom =  [chatTextView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    WEAK(self)
    chatTextView.commentBtn.yz_textHeightChangeBlock = ^(NSString *text,CGFloat textHeight){
        if (text.length <= 0) {
            weakself.chatTextViewHig.constant = 49;
            return;
        }
        weakself.chatTextViewHig.constant = textHeight + 16;
    };
    chatTextView.commentBtn.yz_beginTouchBlock = ^() {
        if (![EVLoginInfo hasLogged]) {
            [chatTextView resignFirstResponder];
            
            UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
            [self presentViewController:navighaVC animated:YES completion:nil];
        }
    };
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[self.chatTextView.commentBtn  class]]) {
        [self loginView];
    }
}

- (void)loginView
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if ([loginInfo.sessionid isEqualToString:@""] || loginInfo.sessionid == nil) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
        return;
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [self.view bringSubviewToFront:self.chatTextView];
    self.chatTextView.hidden = NO;
    self.chatTextView.giftButton.hidden = YES;
    self.chatTextView.sendImageViewRig.constant = 0;
    self.chatTextView.commentBtnRig.constant = -10;
    self.chatTextViewBom.constant = -kbSize.height;
    [UIView animateWithDuration:0.3 animations:^{
        [self chatNotSendGiftView:kbSize.height];
    }];
}

- (void)chatNotSendGiftView:(CGFloat)sizeHig
{
    self.chatTextView.giftButton.hidden = NO;
    self.chatTextView.sendImageViewRig.constant = 0;
    self.chatTextView.commentBtnRig.constant = -10;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //NSDictionary* info = [notification userInfo];
    //kbSize即為鍵盤尺寸 (有width, height)
    [self.view bringSubviewToFront:self.chatTextView];
    self.chatTextViewBom.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self chatNotSendGiftView:0];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendChatStr:textField.text];
    [self.chatTextView.commentBtn setText:nil];
    [self.chatTextView.commentBtn textDidChange];
    [self resignBackView];
    return YES;
}

- (void)sendChatStr:(NSString *)str
{
    if (str.length  <= 0) {
        [EVProgressHUD showError:@"输入为空"];
        return;
    }
    EVLoginInfo *loginfo = [EVLoginInfo localObject];
    //发送评论
    [self.baseToolManager POSTVideoCommentContent:str topicid:self.newsid type:@"0" start:^{
        
    } fail:^(NSError *error) {
        NSString *errorMsg = @"评论失败";
        if (![EVLoginInfo localObject]) {
            errorMsg = [errorMsg stringByAppendingString:@"请先登录"];
        }
        [EVProgressHUD showError:errorMsg];
        
    } success:^(NSDictionary *info) {
        [EVProgressHUD showSuccess:@"评论成功"];
        [self.tableView startHeaderRefreshing];
    } sessionExpired:^{
        
    }];
}

- (void)chatViewButtonType:(EVHVChatTextViewType)type
{
    switch (type) {
        case EVHVChatTextViewTypeSend:
        {
            if (self.chatTextView.commentBtn.text.length > 140) {
                [EVProgressHUD showError:@"字数不能超过140"];
                return;
            }
            [self sendChatStr:self.chatTextView.commentBtn.text];
            [self.chatTextView.commentBtn setText:nil];
            [self.chatTextView.commentBtn textDidChange];
            [self resignBackView];
        }
            break;
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.chatTextView.commentBtn) {
        if (range.length == 1) {
            return YES;
        }else if (textField.text.length >= 140) {
            return NO;
        }
        return YES;
    }
    return YES;
}


- (void)resignBackView
{
    [self.chatTextView.commentBtn resignFirstResponder];
    self.chatTextView.commentBtn.text = nil;
}

#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight-64-44-47) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = CCColor(248, 248, 248);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}



@end
