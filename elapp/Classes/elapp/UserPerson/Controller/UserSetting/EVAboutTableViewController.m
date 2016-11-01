//
//  EVAboutTableViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAboutTableViewController.h"
#import "EVLoginInfo.h"
#import "EVWebViewCtrl.h"
#import "EVStartResourceTool.h"

@interface EVAboutTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *abouteasyvaas;

@property (weak, nonatomic) IBOutlet UILabel *copyrightAboutLabel;

@property (weak, nonatomic) IBOutlet UILabel *fenghaoLabel;


@end

@implementation EVAboutTableViewController

#pragma mark - public class or instance methods

+ (instancetype)instanceFromStoryboard {
    EVAboutTableViewController *aboutTVC = [[UIStoryboard storyboardWithName:@"EVAbout" bundle:nil] instantiateViewControllerWithIdentifier:@"EVAboutTableViewController"];
    return aboutTVC;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    headView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = kE_GlobalZH(@"in_regard_to");
    self.versionLabel.textColor = [UIColor evMainColor];
    self.versionLabel.text = [NSString stringWithFormat:@"v%@", CCAppVersion];
    
    [self addCellLabel];
    
}

- (void)addCellLabel
{
    self.abouteasyvaas.text = kE_GlobalZH(@"about_easyvaas_label");
    self.copyrightAboutLabel.text = kE_GlobalZH(@"copy_about");
    self.fenghaoLabel.text = kE_GlobalZH(@"seal_account");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath                                                                                                                                            
{

//    if ( indexPath.row == 3)
//    {
//        EVWebViewCtrl * webCtrl = [[EVWebViewCtrl alloc] init];
//        webCtrl.title = kE_GlobalZH(@"seal_account");
//        webCtrl.requestUrl = [[EVStartResourceTool shareInstance] freeuserinfoUrl];
//        [self.navigationController pushViewController:webCtrl animated:YES];
//    }
}

#pragma mark - segue

@end
