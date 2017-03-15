//
//  EVBaseHeaderViewController.m
//  EVTableView
//
//  Created by 杨尚彬 on 2017/3/7.
//  Copyright © 2017年 YANGMOUMOU. All rights reserved.
//

#import "EVBaseHeaderViewController.h"


#define screenWid [UIScreen mainScreen].bounds.size.width
#define screenHig  [UIScreen mainScreen].bounds.size.height


@interface EVBaseHeaderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIScrollView *mainBackView;

@property (nonatomic, weak) UITableView *oneTableView;

@property (nonatomic, weak) UIView *headView;

@property (nonatomic, weak) UIView *segmentView;

@property (nonatomic, strong) UIView *navigationView;

@end

@implementation EVBaseHeaderViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView  *mainBackView = [[UIScrollView alloc] init];
    mainBackView.frame = CGRectMake(0, 0, screenWid , screenHig);
    [self.view addSubview:mainBackView];
    mainBackView.contentSize = CGSizeMake(screenWid * 3, 0);
    self.mainBackView = mainBackView;
    mainBackView.pagingEnabled = YES;
    mainBackView.showsHorizontalScrollIndicator = NO;
    
    
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, screenWid, 200);
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor yellowColor];
    self.headView = headView;
    
    
    UIView *segmentView = [[UIView alloc] init];
    segmentView.frame = CGRectMake(0, 200, screenWid, 44);
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    segmentView.backgroundColor = [UIColor greenColor];
    
    
    self.navigationView = [[UIView alloc] init];
    _navigationView.frame = CGRectMake(0, 0, ScreenWidth, 64);
    _navigationView.backgroundColor = [UIColor redColor];
//    [EVLineView addTopLineToView:_navigationView];
    [self.view addSubview:_navigationView];
    _navigationView.alpha = 0.0;
    
    UITableView *oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWid, screenHig) style:(UITableViewStylePlain)];
    oneTableView.delegate = self;
    oneTableView.dataSource = self;
    [mainBackView addSubview:oneTableView];
    oneTableView.contentInset = UIEdgeInsetsMake(244,0, 0, 0);
    self.oneTableView = oneTableView;
    oneTableView.backgroundColor = [UIColor greenColor];
    
    
    
    UITableView *twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWid, 0, screenWid, screenHig) style:(UITableViewStylePlain)];
    twoTableView.delegate = self;
    twoTableView.dataSource = self;
    [mainBackView addSubview:twoTableView];
    twoTableView.contentInset = UIEdgeInsetsMake(244,0, 0, 0);
//    self.oneTableView = twoTableView;
    
    
    UITableView *threeTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWid * 2, 0, screenWid, screenHig) style:(UITableViewStylePlain)];
    threeTableView.delegate = self;
    threeTableView.dataSource = self;
    [mainBackView addSubview:threeTableView];
    threeTableView.contentInset = UIEdgeInsetsMake(244,0, 0, 0);
    //    self.oneTableView = twoTableView;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    return Cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"sdjhahdkashjd0------- %f",scrollView.contentOffset.y);
    if (scrollView == self.oneTableView) {
        if (scrollView.contentOffset.y <= -244) {
            self.headView.frame = CGRectMake(0, 0, screenWid, 200);
            self.segmentView.frame = CGRectMake(0, 200, screenWid, 44);
        }else if(scrollView.contentOffset.y > 0){
           self.headView.frame = CGRectMake(0, -200, screenWid, 200);
        }else {
            NSLog(@"--------------------  %@",self.headView);
            CGRect oneFrame = self.headView.frame;
            oneFrame.origin.y = -((oneFrame.size.height+44) + scrollView.contentOffset.y);
            self.headView.frame = oneFrame;
            
            if (scrollView.contentOffset.y > -108) {
                self.segmentView.frame = CGRectMake(0, 64, screenWid, 44);
            }else{
                self.segmentView.frame = CGRectMake(0, CGRectGetMaxY(oneFrame), screenWid, 44);
            }
            
            if (scrollView.contentOffset.y > -190) {
                self.navigationView.alpha = 1.0;
            }else {
                self.navigationView.alpha = 0.0;
            }
           
            
        }
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
