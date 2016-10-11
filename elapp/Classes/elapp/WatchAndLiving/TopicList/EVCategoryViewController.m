//
//  EVCategoryViewController.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVCategoryViewController.h"
#import "EVStartResourceTool.h"

@interface EVCategoryButton ()

@end

@implementation EVCategoryButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.layer.cornerRadius = ScreenWidth/375*5;
    self.layer.borderColor = [UIColor colorWithHexString:@"#FB6655" alpha:0.5].CGColor;
    self.layer.borderWidth = 0.5f;
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:ScreenWidth/375*15];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if ( selected )
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#FB6655"];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end

@interface EVCategoryViewController ()

@property (nonatomic, strong)NSMutableArray *categoryArray;

@property (nonatomic, strong)NSMutableArray *buttonArray;

@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic, strong)EVCategoryButton *selectedButton;

@end


@implementation EVCategoryViewController

- (NSMutableArray *)categoryArray
{
    if (!_categoryArray) {
        _categoryArray = [NSMutableArray arrayWithArray:[EVStartResourceTool shareInstance].allTopicArray];
        EVVideoTopicItem *hotItem = [[EVVideoTopicItem alloc]init];
        hotItem.title = @"热门";
        hotItem.topic_id = @"0";
        [_categoryArray addObject:hotItem];
        
    }
    return _categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"分类";
    [self createScorllView];
    [self createButtons];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveCategoryViewDidSelectItem:)]) {
        [self.delegate liveCategoryViewDidSelectItem:self.categoryArray[self.buttonArray.count-[self.buttonArray indexOfObject:self.selectedButton]-1]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createScorllView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-64)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
}

- (void)createButtons
{
    self.buttonArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.categoryArray.count; i++)
    {
        EVVideoTopicItem * item = self.categoryArray[(NSInteger)self.categoryArray.count-i-1];
        CGFloat width = ScreenWidth/320*128;
        CGFloat height = ScreenWidth/320*30;
        CGFloat x = ScreenWidth/320*17.5+i%2*(width+ScreenWidth/320*29);
        CGFloat y = ScreenWidth/320*19+i/2*(height+ScreenWidth/320*13);
        EVCategoryButton * button = [[EVCategoryButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [button setTitle:[NSString stringWithFormat:@"#%@#",item.title] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(categoryButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [self.buttonArray addObject:button];
        
        if ( !self.nowItem ) {
            if ( i == 0 ) {
                button.selected = YES;
                self.selectedButton = button;
            }
        }
        else
        {
            if ([item.topic_id isEqualToString:self.nowItem.Id]) {
                button.selected = YES;
                self.selectedButton = button;
            }
        }
        
        
    }
    
    EVCategoryButton * lastButton = [self.buttonArray lastObject];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, lastButton.frame.origin.y+lastButton.frame.size.height+ScreenWidth/320*30);
    
}

- (void)categoryButtonDidClick:(EVCategoryButton *)sender
{
    for (EVCategoryButton * button in self.buttonArray) {
        button.selected = NO;
    }
    sender.selected = YES;
    self.selectedButton = sender;
    [self popBack];
}

- (EVTopicItem *)nowItem
{
    if ( !_nowItem ) {
        // 设置默认的分类
        NSString *defaultTopicID = [CCUserDefault objectForKey:@"topic_id"];
        for (EVVideoTopicItem *item in self.categoryArray) {
            if ( [item.topic_id isEqualToString:defaultTopicID] )
            {
                EVTopicItem * nowItem = [[EVTopicItem alloc] init];
                nowItem.title = [item.title mutableCopy];
                nowItem.Id = [item.topic_id mutableCopy];
                nowItem.descriptions = [item.topic_description mutableCopy];
                _nowItem = nowItem;
            }
        }
    }
    return _nowItem;
}

@end
