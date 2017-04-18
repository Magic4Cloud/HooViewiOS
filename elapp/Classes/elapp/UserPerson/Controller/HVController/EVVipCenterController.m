//
//  EVVipCenterController.m
//  elapp
//
//  Created by 周恒 on 2017/4/18.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVVipCenterController.h"

@interface EVVipCenterController ()

@end

@implementation EVVipCenterController


#pragma mark - ♻️Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupView];
//    [self loadImageCarousel];
//    
//    WEAK(self)
//    [_iNewsTableview addRefreshHeaderWithRefreshingBlock:^{
//        [weakself loadImageCarousel];
//        [weakself loadNewData];
//    }];
//    
//    [_iNewsTableview addRefreshFooterWithRefreshingBlock:^{
//        [weakself loadMoreData];
//    }];
//    
//    [self.iNewsTableview.mj_footer setHidden:YES];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self loadNewData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - 🖍 User Interface layout
- (void)setupView {
    
    
    
}



#pragma mark - 🌐Networks





#pragma mark -👣 Target actions




#pragma mark - 🌺 TableView Delegate & Datasource


















@end
