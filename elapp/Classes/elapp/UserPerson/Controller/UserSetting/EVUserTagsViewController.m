//
//  EVUserTagsViewController.m
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVUserTagsViewController.h"
#import "EVBaseToolManager+EVUserCenterAPI.h"
#import "EVTagListView.h"
#import "EVUserTagsModel.h"
#import "EVUserTagsView.h"
#import "NSString+Extension.h"

@interface EVUserTagsViewController ()<CCTagsViewDelegate>

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, weak) EVTagListView *tagListView;

@property (nonatomic, weak) UIView *allTBackView;

@property (nonatomic, weak) UILabel *oneTLabel;

@property (nonatomic, weak) UILabel *twoTLabel;

@property (nonatomic, weak) UILabel *oneLabel;
@property (nonatomic, weak) UILabel *twoLabel;
@property (nonatomic, weak) UILabel *threeLabel;
@property (nonatomic, weak) UIView *userTBackView;


@property (nonatomic, strong) NSLayoutConstraint *oneLabelWid;
@property (nonatomic, strong) NSLayoutConstraint *twoLabelWid;

@property (nonatomic, strong) NSLayoutConstraint *threeLabelWid;

@property (nonatomic, strong) NSMutableArray *selectArray;

@property (nonatomic, strong) NSMutableArray *selectIDArray;
@property (nonatomic, strong ) NSMutableArray *selectTitleArray;

@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic, assign) BOOL userListB;
@property (nonatomic, assign) BOOL allUserListB;
@end

@implementation EVUserTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    [self addUpView];
}

- (void)loadData
{
    [self.baseToolManager GETUserTagsListfail:^(NSError *error) {
        
    } success:^(NSDictionary *info) {
        NSArray *array = [EVUserTagsModel objectWithDictionaryArray:info[@"tags"]];
        
        [self.selectArray addObjectsFromArray:array];
          [self.tagListView.selectTagAry addObjectsFromArray:array];
        self.userListB = YES;
        for (EVUserTagsModel *model in array) {
            [self.selectIDArray addObject:@(model.tagid)];
            [self.selectTitleArray addObject:model.tagname];
          
        }
        [self labelAddTextDataArray:self.selectTitleArray];
        [self updateTagState:self.allArray userList:self.selectArray];
    }];
    
    
    [self.baseToolManager GETAllUserTagsListfail:^(NSError *error) {
        
    } success:^(NSDictionary *info) {
        NSLog(@"%@",info);
        NSArray *tagArr = [EVUserTagsModel objectWithDictionaryArray:info[@"tags"]];
        self.allUserListB = YES;
      
         [self.allArray addObjectsFromArray:tagArr];
   
        [self updateTagState:tagArr userList:self.selectArray];
    }];
}

- (void)updateTagState:(NSArray *)tags userList:(NSArray *)userlist
{
    if (self.allUserListB > 0 && self.userListB > 0) {
        for (NSInteger j = 0; j < userlist.count; j++) {
            for(NSInteger i = 0;i<tags.count ;i++) {
                EVUserTagsModel *model = tags[i];
                EVUserTagsModel *sModel = userlist[j];
                if (sModel.tagid == model.tagid) {
                    model.tagSelect = YES;
                }
              
            }
        }
        _tagListView.tagAry = tags;
        [self.tagListView reloadData];
      
    }
    
}

- (void)popBack
{
    [EVProgressHUD showMessage:@"加载中..." toView:self.view];
    NSMutableArray *sAry = [NSMutableArray array];
    for (NSString *str in self.selectIDArray) {
        NSString *strN = [NSString stringWithFormat:@"%@",str];
        [sAry addObject:strN];
    }
    if (self.userTLBlock) {
        self.userTLBlock(self.selectTitleArray);
    }
    NSString *userTag = [NSString stringWithArray:sAry];
    [self.baseToolManager GETSetUserTagsList:userTag fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self.view];
    } success:^(NSDictionary *info) {
        [EVProgressHUD hideHUDForView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)addUpView
{
    
    UIView *userTBackView = [[UIView alloc] init];
    [self.view addSubview:userTBackView];
    userTBackView.backgroundColor = [UIColor whiteColor];
    [userTBackView setFrame:CGRectMake(0, 0, ScreenWidth, 96)];
    self.userTBackView = userTBackView;
    
    UILabel *oneLabel = [self addLabelTitle:@"已选标签"];
    [userTBackView addSubview:oneLabel];
    self.oneTLabel = oneLabel;
    

    
    
    
    UIView *allTBackView = [[UIView alloc] init];
    [self.view addSubview:allTBackView];
    allTBackView.backgroundColor = [UIColor evBackgroundColor];
    [allTBackView setFrame:CGRectMake(0, CGRectGetMaxY(userTBackView.frame)+10, ScreenWidth, ScreenHeight)];
    self.allTBackView = allTBackView;
    
    UIView *tagTView = [[UIView alloc] init];
    [allTBackView addSubview:tagTView];
    tagTView.backgroundColor = [UIColor whiteColor];
    tagTView.frame  = CGRectMake(0, 0, ScreenWidth, 50);
    UILabel *twoLabel = [self addLabelTitle:@"所有标签"];
    self.twoTLabel = twoLabel;
    [tagTView addSubview:twoLabel];
    
    EVTagListView *tagListView = [[EVTagListView alloc]initWithFrame:CGRectMake(0, 49, ScreenWidth, 0)];
    tagListView.type = 0;
    [allTBackView addSubview:tagListView];
    tagListView.backgroundColor = [UIColor whiteColor];
    _tagListView = tagListView;
    _tagListView.tagDelegate  = self;

    [self addSTagsView];

}


- (void)addSTagsView
{
    UILabel *oneLabel = [[UILabel alloc] init];
    [self setUpLabel:oneLabel];
    [_userTBackView addSubview:oneLabel];
    self.oneLabel = oneLabel;
    self.oneLabel.hidden = YES;
    [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
    [oneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    self.oneLabelWid =  [oneLabel autoSetDimension:ALDimensionWidth toSize:10];
    [oneLabel autoSetDimension:ALDimensionHeight toSize:30];
    
    UILabel *twoLabel = [[UILabel alloc] init];
    [self setUpLabel:twoLabel];
    [_userTBackView addSubview:twoLabel];
    self.twoLabel = twoLabel;
    self.twoLabel.hidden = YES;
    [twoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:oneLabel withOffset:8];
    [twoLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    self.twoLabelWid =   [twoLabel autoSetDimension:ALDimensionWidth toSize:10];
    [twoLabel autoSetDimension:ALDimensionHeight toSize:30];
    
    UILabel *threeLabel = [[UILabel alloc] init];
    [self setUpLabel:threeLabel];
    [_userTBackView addSubview:threeLabel];
    self.threeLabel = threeLabel;
    self.threeLabel.hidden = YES;
    [threeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:twoLabel withOffset:8];
    [threeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    self.threeLabelWid =  [threeLabel autoSetDimension:ALDimensionWidth toSize:10];
    [threeLabel autoSetDimension:ALDimensionHeight toSize:30];
}

- (void)setUpLabel:(UILabel *)label
{
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor hvPurpleColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.f];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)labelAddTextDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count <= 0) {
        self.oneLabel.hidden = YES;
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
    }else if (dataArray.count == 1) {
        self.twoLabel.hidden = YES;
        self.threeLabel.hidden = YES;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count == 2) {
        
        self.twoLabel.hidden = NO;
        self.threeLabel.hidden = YES;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width + 10;
        self.twoLabelWid.constant = [self.twoLabel sizeThatFits:CGSizeZero].width + 10;
        
    }else if (dataArray.count >= 3) {
        
        self.twoLabel.hidden = NO;
        self.threeLabel.hidden = NO;
        self.oneLabel.hidden = NO;
        self.oneLabel.text = [NSString stringWithFormat:@"%@",dataArray[0]];
        self.twoLabel.text = [NSString stringWithFormat:@"%@",dataArray[1]];
        self.threeLabel.text = [NSString stringWithFormat:@"%@",dataArray[2]];
        self.oneLabelWid.constant = [self.oneLabel sizeThatFits:CGSizeZero].width+10;
        self.twoLabelWid.constant = [self.twoLabel sizeThatFits:CGSizeZero].width+10;
        self.threeLabelWid.constant = [self.threeLabel sizeThatFits:CGSizeZero].width+10;
    }
}
- (UILabel *)addLabelTitle:(NSString *)title
{
    UILabel *oneLabel = [[UILabel alloc] init];
    [oneLabel setFrame:CGRectMake(16, 16, ScreenWidth - 16, 22)];
    oneLabel.font = [UIFont textFontB2];
    oneLabel.textColor = [UIColor evTextColorH2];
    [oneLabel setText:title];
    return oneLabel;
}

- (void)tagsViewButtonAction:(EVTagListView *)tagsView button:(UIButton *)sender
{
    if (sender.selected == YES) {
        [self.selectIDArray addObject:@(sender.tag - 8000)];
        [self.selectTitleArray addObject:sender.titleLabel.text];
        
    }else {
        [self.selectIDArray removeObject:@(sender.tag - 8000)];
        [self.selectTitleArray removeObject:sender.titleLabel.text];
    }
    [self labelAddTextDataArray:self.selectTitleArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}
- (NSMutableArray *)selectIDArray
{
    if (!_selectIDArray) {
        _selectIDArray = [NSMutableArray array];
    }
    return _selectIDArray;
}

- (NSMutableArray *)allArray
{
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableArray *)selectTitleArray
{
    if (!_selectTitleArray) {
        _selectTitleArray = [NSMutableArray array];
    }
    return _selectTitleArray;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
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
