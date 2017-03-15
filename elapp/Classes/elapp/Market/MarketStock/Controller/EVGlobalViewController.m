//
//  EVGlobalViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2016/12/20.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import "EVGlobalViewController.h"
#import "EVGlobalView.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVStockBaseModel.h"
#import "EVEditGlobalViewController.h"
#import "EVLoginInfo.h"
#import "EVLoginViewController.h"


@interface EVGlobalViewController ()<EVGlobalViewDelegate>





@end

@implementation EVGlobalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    EVGlobalView *globalView = [[EVGlobalView alloc]init];
    globalView.frame = CGRectMake(0, 0, ScreenWidth,EVContentHeight);
    [self.view addSubview:globalView];
    self.globalView = globalView;
    globalView.delegate = self;

    
}




#pragma MARK - delegate
- (void)editButtonWithSelectedStocks:(NSArray *)stocks
{
    EVLog(@"编辑");
    
    if ([EVLoginInfo localObject].sessionid == nil || [[EVLoginInfo localObject].sessionid isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }else {
        EVEditGlobalViewController *editVC= [[EVEditGlobalViewController alloc] init];
        editVC.selectedStocks = stocks;
        editVC.popBlock = ^(){
            [self.globalView loadData];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (void)refreshButton
{
    EVLog(@"刷新");
//    [self loadData];
    
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
