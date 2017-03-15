//
//  EVFeedbackTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVFeedbackTableViewController.h"
#import "EVTextViewWithPlaceHolderAndClearButton.h"
#import "EVBaseToolManager+EVAccountAPI.h"
#import "NSString+Extension.h"
#import "NSString+Checking.h"


@interface EVFeedbackTableViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet EVTextViewWithPlaceHolderAndClearButton *selectTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactEmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (assign, nonatomic) NSUInteger numOfWord;

@property (strong, nonatomic) EVBaseToolManager *engine;

@end

@implementation EVFeedbackTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [EVNotificationCenter addObserver:self selector:@selector(textChange:) name:UITextViewTextDidChangeNotification object:nil];
    
    self.title = kE_GlobalZH(@"opinion_feedback");
    UIBarButtonItem *rightCommit = [[UIBarButtonItem alloc] initWithTitle:kE_GlobalZH(@"e_submit") style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    [rightCommit setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightCommit;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.selectTextView.placeHolder = kE_GlobalZH(@"feedback_tech_question");
}

- (void)textChange:(NSNotification *)noti {
    _numOfWord = [self.selectTextView.text numOfWordWithLimit:0];
    
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)_numOfWord];
    if (_numOfWord > 140)
    {
        self.numberLabel.textColor = [UIColor redColor];
    }
    else
    {
        self.numberLabel.textColor = [UIColor evGlobalSeparatorColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IOS8_OR_LATER)
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

#pragma mark - event response

- (void)commit {
    [self.view endEditing:YES];
    if ([self.selectTextView.text isEqualToString:@""])
    {
        [EVProgressHUD showError:kE_GlobalZH(@"feedback_not_nil") toView:self.view];
        return;
    }
    
    if ([self.contactEmailTextField.text isEqualToString:@""] || self.contactEmailTextField.text == nil)
    {
        [EVProgressHUD showError:kE_GlobalZH(@"mail_not_nil") toView:self.view];
        return;
    }
    
//    if ([CCBaseTool checkEmailByRegx:self.contactEmailTextField.text] == NO) {
    if ([self.contactEmailTextField.text isEmail] == NO) {
        [EVProgressHUD showError:kE_GlobalZH(@"mail_fail") toView:self.view];
        return;
    }
    
    if (_numOfWord > 140)
    {
        [EVProgressHUD showError:kE_GlobalZH(@"feedback_length_please_correct") toView:self.view];
        return;
    }
    
    __weak typeof(self) weakself = self;
    NSString *email = self.contactEmailTextField.text;
    NSString *feedback = self.selectTextView.text;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.selectTextView endEditing:YES];
    [self.contactEmailTextField endEditing:YES];
}

#pragma mark - getters and setters
- (EVBaseToolManager *)engine {
    if (!_engine)
    {
        _engine = [[EVBaseToolManager alloc] init];
    }
    
    return _engine;
}

@end
