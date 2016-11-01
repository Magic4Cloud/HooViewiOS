//
//  EVEditChatGroupNameViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVEditChatGroupNameViewController.h"
#import <PureLayout.h>
#import "EVChatMessageManager.h"
#import "EVEaseMob.h"
#import "EVAlertManager.h"

#define KMaxNoticeTextLength 50
#define kMaxNameTextLength  10

@interface EVEditChatGroupNameViewController ()<UITextViewDelegate>

@property (weak, nonatomic)UITextField *textFiled;
@property ( weak, nonatomic ) UITextView *textView;
@property (copy, nonatomic) void(^succeed)(NSString *description);


@end

@implementation EVEditChatGroupNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCBackgroundColor;
    self.title = @"群组设置";
    // 提示
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
    [label autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [label autoSetDimension:ALDimensionHeight toSize:35.f];
    label.backgroundColor = [UIColor clearColor];
    label.font = CCNormalFont(14);
    label.textColor = CCTextBlackColor;
    NSString *text = nil;
    if ( self.type == CCEditChatGroupNameViewControllerTypeName )
    {
        text = @"群聊名称";
    }
    else if (self.type == CCEditChatGroupNameViewControllerTypeNotice)
    {
        text = @"群公告";
    }
    label.text = text;
    
    // 完成按钮
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didFinished:)];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(0, 0, 60, 40);
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton setTitleColor:CCButtonDisableColor forState:UIControlStateDisabled];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    confirmButton.titleLabel.font = CCNormalFont(15);
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(didFinished:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirmButton];
    [confirmButton setEnabled:NO];
    // 输入框
    if ( self.type == CCEditChatGroupNameViewControllerTypeName )
    {
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
        [view autoSetDimension:ALDimensionHeight toSize:55.f];
        view.backgroundColor = [UIColor whiteColor];
        
        UITextField *textFiled = [[UITextField alloc] init];
        [self.view addSubview:textFiled];
        self.textFiled = textFiled;
        [textFiled autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.f];
        [textFiled autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.f];
        [textFiled autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
        [textFiled autoSetDimension:ALDimensionHeight toSize:55.f];
        textFiled.text = self.group.groupSubject;
        textFiled.textColor = CCTextBlackColor;
        textFiled.tintColor = CCAppMainColor;
        textFiled.font = CCNormalFont(15);
        textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textFiled becomeFirstResponder];
        [CCNotificationCenter addObserver:self selector:@selector(textFiledTextDidChange:) name:UITextFieldTextDidChangeNotification object:textFiled];
    }
    else if (self.type == CCEditChatGroupNameViewControllerTypeNotice)
    {
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        self.textView = textView;
        [textView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [textView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [textView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
        [textView autoSetDimension:ALDimensionHeight toSize:155.f];
        textView.textContainerInset = UIEdgeInsetsMake(10, 15.f, 10, 15.f);
        textView.text = self.group.groupDescription;
        textView.textColor = CCTextBlackColor;
        textView.tintColor = CCAppMainColor;
        textView.font = CCNormalFont(15);
        [textView becomeFirstResponder];
        textView.delegate = self;
        // 如果是群公告,不是群主不显示完成按钮且不可编辑
        if ( self.isOwner == NO )
        {
            self.textView.editable = NO;
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textFiled resignFirstResponder];
}

- (void)didFinished:(id)sender
{
    if ( self.type == CCEditChatGroupNameViewControllerTypeName )
    {
        [self changeGroupName];
    }
    else if (self.type == CCEditChatGroupNameViewControllerTypeNotice)
    {
        [self changeGroupNotice];
    }
}

- (void)changeGroupName
{
    NSString *name = self.textFiled.text;
    if ( [name isEqualToString:self.group.groupSubject] || name.length == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [CCProgressHUD showMessage:@"请稍后..." toView:self.view];
        [[EVChatMessageManager shareInstance]changeGroupSubject:self.textFiled.text forGroup:self.group.groupId completion:^(EMGroup *group, EMError *error)
         {
             [CCProgressHUD hideHUDForView:self.view];
             if ( !error )
             {
                 [CCProgressHUD showSuccess:@"修改成功"];
                 [self.navigationController popViewControllerAnimated:YES];
             }
             else
             {
                 [CCProgressHUD showError:@"修改失败"];
             }
         }];
    }
}

- (void)changeGroupNotice
{
    NSString *description = self.textView.text;
    if ( [description isEqualToString:self.group.groupDescription] || description.length == 0 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.textView resignFirstResponder];
        [[EVAlertManager shareInstance] performComfirmTitle:@"提示" message:@"该公告会通知所有群成员,是否发布" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
            [self sendGroupNotice];
        } cancel:nil];
    }
}

- (void)sendGroupNotice
{
    [CCProgressHUD showMessage:@"请稍后..." toView:self.view];
    [[EVChatMessageManager shareInstance] changegroupDescription:self.textView.text forGroup:self.group.groupId completion:^(EMGroup *group, EMError *error) {
        [CCProgressHUD hideHUDForView:self.view];
        if ( !error )
        {
            [CCProgressHUD showSuccess:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            self.succeed(self.textView.text);
        }
        else
        {
            [CCProgressHUD showError:@"发布失败"];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( textView.text.length > KMaxNoticeTextLength )
    {
        NSMutableString *text = [textView.text mutableCopy];
        [text deleteCharactersInRange:NSMakeRange(KMaxNoticeTextLength, textView.text.length - KMaxNoticeTextLength)];
        textView.text = text;
        NSString *msg = [NSString stringWithFormat:@"群公告最多%zd个字",KMaxNoticeTextLength];
        [CCProgressHUD showMessageInAFlashWithMessage:msg];
    }
}

- (void)textFiledTextDidChange:(NSNotification *)notification
{
    if ( notification.object == self.textFiled )
    {
        if ( self.textFiled.text.length > KMaxNoticeTextLength )
        {
            NSMutableString *text = [self.textFiled.text mutableCopy];
            [text deleteCharactersInRange:NSMakeRange(kMaxNameTextLength, self.textFiled.text.length - kMaxNameTextLength)];
            self.textFiled.text = text;
            NSString *msg = [NSString stringWithFormat:@"群名称最多%zd个字",kMaxNameTextLength];
            [CCProgressHUD showMessageInAFlashWithMessage:msg];
        }
    }
}

- (void)setChangeSucceed:(void (^)(NSString *))succeed
{
    self.succeed = succeed;
}

@end
