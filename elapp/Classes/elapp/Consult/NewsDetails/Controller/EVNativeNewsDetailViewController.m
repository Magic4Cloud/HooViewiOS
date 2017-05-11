//
//  EVNativeNewsDetailViewController.m
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeNewsDetailViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"

#import "EVStockDetailBottomView.h"
#import "EVSharePartView.h"

#import "EVNewsDetailModel.h"

#import "EVNewsTitleCell.h"
#import "EVNewsAuthorsCell.h"
#import "EVNewsTagsCell.h"
#import "EVNewsContentCell.h"
#import "EVLikeOrNotCell.h"
#import "EVAllCommentCell.h"
#import "EVNewsSectionTitleCell.h"
#import "EVNewsCommentCell.h"
#import "EVRelatedNewsCell.h"

@interface EVNativeNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UIWebViewDelegate,EVStockDetailBottomViewDelegate,EVWebViewShareViewDelegate>
{
    CGFloat contentHeight;
    NSMutableArray *commentHeightArray;
    CGFloat tagCellHeight;
}
@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong) EVStockDetailBottomView *detailBottomView;

@property (nonatomic, strong) EVSharePartView *eVSharePartView;

@property (nonatomic, strong) EVBaseToolManager *baseToolManager;

@property (nonatomic, strong) EVNewsDetailModel * newsDetailModel;

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation EVNativeNewsDetailViewController

#pragma mark - ♻️Lifecycle
- (instancetype)init
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    contentHeight = 40;
    tagCellHeight = 0;
    commentHeightArray = [@[@"44",@"47"] mutableCopy];
    
    [self loadNewData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsTitleCell" bundle:nil] forCellReuseIdentifier:@"EVNewsTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVLikeOrNotCell" bundle:nil] forCellReuseIdentifier:@"EVLikeOrNotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsAuthorsCell" bundle:nil] forCellReuseIdentifier:@"EVNewsAuthorsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsSectionTitleCell" bundle:nil] forCellReuseIdentifier:@"EVNewsSectionTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVAllCommentCell" bundle:nil] forCellReuseIdentifier:@"EVAllCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVRelatedNewsCell" bundle:nil] forCellReuseIdentifier:@"EVRelatedNewsCell"];
    
    
    [self.view addSubview:self.detailBottomView];
    [self.view addSubview:self.eVSharePartView];
    
}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    [commentHeightArray removeAllObjects];
    [commentHeightArray addObject:@"44"];
    
    [self.baseToolManager GETNewsDetailNewsID:self.newsID fail:^(NSError *error) {
        
    } success:^(NSDictionary *retinfo) {
        NSDictionary * dataDic = retinfo[@"retinfo"][@"data"];
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            _newsDetailModel = [EVNewsDetailModel yy_modelWithDictionary:dataDic];
            
            NSArray *array = _newsDetailModel.posts;
            
            if (_newsDetailModel.posts.count == 0) {
                [commentHeightArray addObject:@"47"];
            } else if(_newsDetailModel.posts.count > 3) {
                for (int i =0; i < 3; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    NSInteger commentHeight = commentModel.cellHeight < 87 ? 87 : commentModel.cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            } else {
                for (int i =0; i < _newsDetailModel.posts.count; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    NSInteger commentHeight = commentModel.cellHeight < 87 ? 87 : commentModel.cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            }
            [self initUI];
            [self.tableView reloadData];
        }
    }];
}

- (NSString *)requestUrlID:(NSString *)ID
{
    NSMutableString *paramStr = [NSMutableString string];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setValue:ID forKey:@"newsid"];
    [params setValue:@"news" forKey:@"page"];
    NSInteger paramCount = params.count;
    __block NSInteger index = 0;
    [params enumerateKeysAndObjectsUsingBlock:^(id key, NSString *value, BOOL *stop) {
        NSString *param = [NSString stringWithFormat:@"%@=%@",key,value];
        [paramStr appendString:param];
        if ( index != paramCount - 1 ) {
            [paramStr appendString:@"&"];
        }
        index++;
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",webNewsUrl,paramStr];
    
    return urlStr;
}

#pragma mark -👣 Target actions

#pragma mark - delegate
- (void)shareType:(EVLiveShareButtonType)type
{
    
}

- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGRect frame = webView.frame;
    frame.size.width = ScreenWidth;
    frame.size.height = 1;
    webView.frame = frame;
    frame.size.height = webView.scrollView.contentSize.height;
    webView.frame = frame;

    contentHeight = CGRectGetMaxY(webView.frame);
    [self.tableView reloadData];
}



#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 6;
        }
            break;
        case 1:
        {
            return commentHeightArray.count;
        }
            break;
        case 2:
        {
            return _newsDetailModel.recommendNews.count + 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //三个区   标题加详情一个   评论一个    推荐新闻一个
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row ==0)
            {
                return UITableViewAutomaticDimension;
            }
            else if (indexPath.row ==1)
            {
                //作者信息
                if ([_newsDetailModel.Author.bind integerValue] == 1) {
                    return 64;
                } else {
                return 64;
                }
            }
            else if (indexPath.row ==2)
            {
                //标签
                return 0;
                
            }
            else if (indexPath.row ==3)
            {
                return contentHeight;
            }
            else if (indexPath.row ==4)
            {
                //点赞&不喜欢
                return 70;
            }
            else if (indexPath.row ==5)
            {
                //大V
                return 80;
            }
        }
            break;
        case 1:
        {
            return [commentHeightArray[indexPath.row] integerValue];
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                //相关视频
                return 44;
            } else {
                return 68;
            }
        }
            break;
            
        default:
            break;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2) {
        return 20 ;
    } else {
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 20 ;
    } else {
        return 0.01;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0) {
                EVNewsTitleCell * titleCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTitleCell"];
                titleCell.selectionStyle = NO;
                return titleCell;
            }
            else if (indexPath.row == 1) {
                EVNewsAuthorsCell * authorCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsAuthorsCell"];
                authorCell.selectionStyle = NO;
                authorCell.authorImage.layer.cornerRadius = 22;
                authorCell.authorImage.layer.masksToBounds = YES;
                authorCell.backgroundColor = CCColor(250, 250, 250);
                authorCell.recommendPerson = _newsDetailModel.Author;
                return authorCell;
            }
            else if (indexPath.row == 2)
            {
                EVNewsTagsCell * tagCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTagsCell"];
                tagCell.selectionStyle = NO;
                if (!tagCell) {
                    tagCell = [[EVNewsTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsTagsCell"];
                    tagCell.tagsModelArray = _newsDetailModel.tag;
                }
                tagCell.tagCellHeight = ^(CGFloat cellHeight) {
                    tagCellHeight = cellHeight;
                };

                
//                tagCell.stockModelArray = _newsDetailModel.stock;
                return tagCell;
            }
            else if (indexPath.row == 3)
            {
                EVNewsContentCell * contentCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsContentCell"];
                contentCell.selectionStyle = NO;
                if (!contentCell) {
                    contentCell = [[EVNewsContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsContentCell"];
                    contentCell.webView.delegate = self;
                    
                }
                contentCell.htmlString = _newsDetailModel.content;
                return contentCell;
            }
            else if (indexPath.row == 4)
            {
                EVLikeOrNotCell * likeOrNotCell = [tableView dequeueReusableCellWithIdentifier:@"EVLikeOrNotCell"];
                likeOrNotCell.selectionStyle = NO;
                return likeOrNotCell;
            }
            else if (indexPath.row == 5)
            {
                EVNewsAuthorsCell * authorCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsAuthorsCell"];
                authorCell.selectionStyle = NO;
                authorCell.authorImage.layer.cornerRadius = 30;
                authorCell.authorImage.layer.masksToBounds = YES;
                authorCell.recommendPerson = _newsDetailModel.recommendPerson;
                return authorCell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                EVNewsSectionTitleCell * titleCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsSectionTitleCell"];
                titleCell.sectionTitle.text = @"热门评论";
                titleCell.selectionStyle = NO;
                return titleCell;
            }
            else if(indexPath.row == commentHeightArray.count - 1) {
                EVAllCommentCell * allCell = [tableView dequeueReusableCellWithIdentifier:@"EVAllCommentCell"];
                allCell.selectionStyle = NO;
                return allCell;
            }
            else {
                EVNewsCommentCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
                if (!Cell) {
                    Cell = [[EVNewsCommentCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"commentCell"];
                }
                Cell.videoCommentModel = _newsDetailModel.posts[indexPath.row - 1];
                Cell.selectionStyle = NO;
                return Cell;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                EVNewsSectionTitleCell * titleCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsSectionTitleCell"];
                titleCell.sectionTitle.text = @"相关新闻";
                titleCell.selectionStyle = NO;
                return titleCell;
            } else {
                EVRelatedNewsCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"relatedNewsCell"];
                if (!Cell) {
                    Cell = [[EVRelatedNewsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"relatedNewsCell"];
                }
                Cell.newsModel = _newsDetailModel.recommendNews[indexPath.row - 1];
                Cell.selectionStyle = NO;
                return Cell;

            }

        }
            break;
            
        default:
            break;
    }
    static NSString * identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//加圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        if ([cell respondsToSelector:@selector(tintColor)]) {
            CGFloat cornerRadius = 10.f;
            cell.backgroundColor = [UIColor whiteColor];
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            
            if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            }
            else if (indexPath.row == (indexPath.section == 1 ? commentHeightArray.count : _newsDetailModel.recommendNews.count)) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }
            else {
                CGPathAddRect(pathRef, nil, bounds);
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            //颜色修改
            layer.fillColor = CCColor(250, 250, 250).CGColor;
            layer.strokeColor=[UIColor clearColor].CGColor;
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
    

}



#pragma mark - ✍️ Setters & Getters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}

- (EVSharePartView *)eVSharePartView {
    if (!_eVSharePartView) {
        _eVSharePartView = [[EVSharePartView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 49)];
        _eVSharePartView.backgroundColor = [UIColor colorWithHexString:@"#303030" alpha:0.7];
        _eVSharePartView.eVWebViewShareView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _eVSharePartView.cancelShareBlock = ^() {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.eVSharePartView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-49);
            }];
        };

    }
    return _eVSharePartView;
}

- (EVStockDetailBottomView *)detailBottomView
{
    if (!_detailBottomView) {
        _detailBottomView = [[EVStockDetailBottomView alloc] initWithFrame: CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49) isBottomBack:YES];
        NSArray *titleArray = @[@"分享",@"收藏",@"评论"];
        NSArray *seleteTitleArr = @[@"分享",@"已收藏",@"评论"];
        NSArray *imageArray = @[@"btn_share_n",@"btn_news_collect_n",@"btn_news_comment_n"];
        NSArray *seleteImageArr = @[@"btn_share_n",@"btn_news_collecte_s",@"btn_news_comment_n"];
        [_detailBottomView addButtonTitleArray:titleArray seleteTitleArr:seleteTitleArr imageArray:imageArray seleteImage:seleteImageArr];
        _detailBottomView.backgroundColor = [UIColor whiteColor];
        _detailBottomView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _detailBottomView.backButtonClickBlock = ^()
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _detailBottomView;
}

- (EVBaseToolManager *)baseToolManager
{
    if (!_baseToolManager) {
        _baseToolManager = [[EVBaseToolManager alloc] init];
    }
    return _baseToolManager;
}

@end
