//
//  EVNativeNewsDetailViewController.m
//  elapp
//
//  Created by 唐超 on 5/8/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVNativeNewsDetailViewController.h"
#import "EVBaseToolManager+EVNewsAPI.h"
#import "EVBaseToolManager+EVStockMarketAPI.h"
#import "EVBaseToolManager+EVHomeAPI.h"

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
#import "EVNewsStockCell.h"
#import "EVWatchVideoInfo.h"
#import "EVVipCenterController.h"
#import "EVLoginInfo.h"
#import "EVMarketTextView.h"
#import "EVLoginViewController.h"
#import "EVNativeComentViewController.h"
#import "EVNormalPersonCenterController.h"

#import "EVShareManager.h"
@interface EVNativeNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UIWebViewDelegate,EVStockDetailBottomViewDelegate,EVWebViewShareViewDelegate,UITextFieldDelegate>
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
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIControl *touchLayer;
@property (nonatomic, weak) EVMarketTextView *marketTextView;

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) UIView *backView;

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addWindowView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self deallocView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    contentHeight = 40;
    tagCellHeight = 0;
    commentHeightArray = [@[@"44",@"47"] mutableCopy];
    [self.view addSubview:self.detailBottomView];
    [self.view addSubview:self.eVSharePartView];

    [self loadNewData];
//    [self initUI];
    [self.view addSubview:self.backView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 🖍 User Interface layout
- (void)initUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    [self.view insertSubview:self.tableView belowSubview:self.eVSharePartView];
    
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:49];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsTitleCell" bundle:nil] forCellReuseIdentifier:@"EVNewsTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVLikeOrNotCell" bundle:nil] forCellReuseIdentifier:@"EVLikeOrNotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsAuthorsCell" bundle:nil] forCellReuseIdentifier:@"EVNewsAuthorsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVNewsSectionTitleCell" bundle:nil] forCellReuseIdentifier:@"EVNewsSectionTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVAllCommentCell" bundle:nil] forCellReuseIdentifier:@"EVAllCommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EVRelatedNewsCell" bundle:nil] forCellReuseIdentifier:@"EVRelatedNewsCell"];
    

}

#pragma mark - 🌐Networks
- (void)loadNewData
{
    [EVProgressHUD showIndeterminateForView:self.backView];
    [commentHeightArray removeAllObjects];
    [commentHeightArray addObject:@"44"];
    
    [self.baseToolManager GETNewsDetailNewsID:self.newsID fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self.backView];
        self.backView.hidden = YES;
        [EVProgressHUD showError:@"请求失败！"];
    } success:^(NSDictionary *retinfo) {
        NSDictionary * dataDic = retinfo;
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            _newsDetailModel = [EVNewsDetailModel yy_modelWithDictionary:dataDic];
            
            NSArray *array = _newsDetailModel.posts;
            
            if (_newsDetailModel.posts.count == 0) {
                [commentHeightArray addObject:@"47"];
            } else if(_newsDetailModel.posts.count > 3) {
                for (int i =0; i < 3; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    
                    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
                    CGSize nameSize = [commentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
                    CGFloat cellHeight = nameSize.height+90;
                    CGFloat commentHeight = cellHeight < 90 ? 90 : cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            } else {
                for (int i =0; i < _newsDetailModel.posts.count; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
                    CGSize nameSize = [commentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
                    CGFloat cellHeight = nameSize.height+90;
                    NSInteger commentHeight = cellHeight < 90 ? 90 : cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            }
            [self initUI];
            self.detailBottomView.isCollec = [_newsDetailModel.favorite boolValue];
            self.isCollect = [_newsDetailModel.favorite boolValue];
            self.detailBottomView.commentCount = [_newsDetailModel.postCount integerValue];

            [self.tableView reloadData];
        }
    } sessionExpire:^{
        [EVProgressHUD showError:@"请求失败！"];
        [EVProgressHUD hideHUDForView:self.backView];
        self.backView.hidden = YES;
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
    
    self.urlStr = [self requestUrlID:self.newsID];
    NSString *shareUrlString = self.urlStr;
    if (self.urlStr == nil) {
        
        [EVProgressHUD showError:@"加载完成在分享"];
        
    }
    
    ShareType shareType = ShareTypeNewsWeb;
    UIImage *image = [UIImage imageNamed:@"icon_share"];
    [[EVShareManager shareInstance] shareContentWithPlatform:type shareType:shareType titleReplace:self.shareTitle descriptionReplaceName:@"#火眼财经#" descriptionReplaceId:nil URLString:shareUrlString image:image outImage:nil];
}

- (void)detailBottomClick:(EVBottomButtonType)type button:(UIButton *)btn
{
    switch (type) {
        case EVBottomButtonTypeAdd:
            EVLog(@"添加");
        {
            [self shareViewShowAction];
        }
            break;
        case EVBottomButtonTypeShare:
        {
            [self presentLoginVC];
            
            NSLog(@"---------%d",self.isCollect);
            int action = self.isCollect ? 0 : 1;
            
            [self.baseToolManager GETNewsCollectNewsid:_newsDetailModel.id action:action start:^{
                
            } fail:^(NSError *error) {
                [EVProgressHUD showMessage:@"失败"];
            } success:^(NSDictionary *retinfo) {
                [EVProgressHUD showMessage:@"成功"];
                self.isCollect = !self.isCollect;
                self.detailBottomView.isCollec = self.isCollect;
                if (self.refreshCollectBlock) {
                    self.refreshCollectBlock();
                }
            } sessionExpire:^{
            }];
        }
            break;
        
        case EVBottomButtonTypeRefresh:
        {
            [self pushCommentListVCID:_newsDetailModel.id];
        }
            break;
            
        case EVBottomButtonTypeComment:
        {
            EVLoginInfo *loginInfo = [EVLoginInfo localObject];
            if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
                [self hide];
                UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                [self presentViewController:navighaVC animated:YES completion:nil];
            }else {
                [self.marketTextView.inPutTextFiled becomeFirstResponder];
            }
            
        }
            break;
        default:
            break;
    }

}

#pragma mark -- webviewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{    

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
    
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        CGRect frame = webView.frame;
        frame.size.width = ScreenWidth;
        frame.size.height = 1;
        webView.frame = frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        
        contentHeight = CGRectGetMaxY(webView.frame);
        [self.tableView reloadData];
        [EVProgressHUD hideHUDForView:self.backView];
        self.backView.hidden = YES;

    });
}




#pragma mark - 评论
- (void)addWindowView
{
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    
    self.touchLayer = [[UIControl alloc] initWithFrame:self.window.bounds];
    self.touchLayer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.window addSubview:self.touchLayer];
    [self.window makeKeyAndVisible];
    
    
    [self.touchLayer addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    EVMarketTextView *marketTextView = [[EVMarketTextView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenHeight, 49)];
    [self.window addSubview:marketTextView];
    self.marketTextView = marketTextView;
    marketTextView.hidden = NO;
    marketTextView.inPutTextFiled.delegate = self;
    marketTextView.backgroundColor = [UIColor whiteColor];
    marketTextView.commentBlock = ^ (NSString *content) {
        [self sendCommentStr:content];
    };
    self.window.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentStr:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)hide
{
    self.marketTextView.inPutTextFiled.text = nil;
    [self.marketTextView.inPutTextFiled resignFirstResponder];
    self.marketTextView.sendButton.selected = NO;
}



- (void)sendCommentStr:(NSString *)str
{
    if (str.length <= 0) {
        [EVProgressHUD showMessage:@"评论为空"];
        return;
    }
    //发送评论
        [self.baseToolManager POSTVideoCommentContent:str topicid:_newsDetailModel.id type:@"0" start:^{
    
        } fail:^(NSError *error) {
            NSString *errorMsg = @"评论失败";
            if (![EVLoginInfo localObject]) {
                errorMsg = [errorMsg stringByAppendingString:@"请先登录"];
            }
            [EVProgressHUD showError:errorMsg];
        } success:^(NSDictionary *info) {
            [EVProgressHUD showSuccess:@"评论成功"];
            [self reloadComment];
        } sessionExpired:^{
        }];
}

- (void)reloadComment {
    [commentHeightArray removeAllObjects];
    [commentHeightArray addObject:@"44"];
    
    [self.baseToolManager GETNewsDetailNewsID:self.newsID fail:^(NSError *error) {
        [EVProgressHUD hideHUDForView:self.backView];
        self.backView.hidden = YES;
        [EVProgressHUD showError:@"请求失败！"];
    } success:^(NSDictionary *retinfo) {
        NSDictionary * dataDic = retinfo;
        if (dataDic && [dataDic isKindOfClass:[NSDictionary class]]) {
            _newsDetailModel = [EVNewsDetailModel yy_modelWithDictionary:dataDic];
            
            NSArray *array = _newsDetailModel.posts;
            
            if (_newsDetailModel.posts.count == 0) {
                [commentHeightArray addObject:@"47"];
            } else if(_newsDetailModel.posts.count > 3) {
                for (int i =0; i < 3; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    
                    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
                    CGSize nameSize = [commentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
                    CGFloat cellHeight = nameSize.height+90;
                    CGFloat commentHeight = cellHeight < 90 ? 90 : cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            } else {
                for (int i =0; i < _newsDetailModel.posts.count; i ++) {
                    //评论列表
                    EVHVVideoCommentModel *commentModel = array[i];
                    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.f]};
                    CGSize nameSize = [commentModel.content boundingRectWithSize:CGSizeMake(ScreenWidth - 81, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil].size;
                    CGFloat cellHeight = nameSize.height+90;
                    NSInteger commentHeight = cellHeight < 90 ? 90 : cellHeight;
                    [commentHeightArray addObject:[NSString stringWithFormat:@"%ld",(long)commentHeight]];
                }
                [commentHeightArray addObject:@"47"];
            }
            
            self.detailBottomView.isCollec = [_newsDetailModel.favorite boolValue];
            self.isCollect = [_newsDetailModel.favorite boolValue];
            self.detailBottomView.commentCount = [_newsDetailModel.postCount integerValue];
            
            [self.tableView reloadData];
        }
    } sessionExpire:^{
        [EVProgressHUD showError:@"请求失败！"];
        [EVProgressHUD hideHUDForView:self.backView];
        self.backView.hidden = YES;
    }];

}


- (void)keyboardWillShow:(NSNotification *)notification
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        return;
    }
    self.window.hidden = NO;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.3 animations:^{
        self.marketTextView.frame = CGRectMake(0, ScreenHeight - kbSize.height - 49, ScreenWidth, 49);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        return;
    }
    self.window.hidden = YES;
    //    NSDictionary* info = [notification userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    [UIView animateWithDuration:0.3 animations:^{
        self.marketTextView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 49);
    }];
    
}



//跳转评论列表
- (void)pushCommentListVCID:(NSString *)newsid
{
    EVNativeComentViewController * allCommentVC = [[EVNativeComentViewController alloc] init];
    allCommentVC.newsid = _newsDetailModel.id;
    [self.navigationController pushViewController:allCommentVC animated:YES];
}



#pragma mark - 🌺 TableView Delegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 7;
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
                if ([_newsDetailModel.author.bind integerValue] == 1) {
                    return 64;
                } else {
                return 0;
                }
            }
            else if (indexPath.row ==2)
            {
                if (_newsDetailModel.stock.count == 0) {
                    return 0;
                } else {
                    //股票
                    return 38;
                }
            }
            else if (indexPath.row ==3)
            {
                //标签
//                return tagCellHeight;
                if (_newsDetailModel.tag.count == 0) {
                    return 0;
                } else {
                    return 42;
                }
            }
            else if (indexPath.row ==4)
            {
                return contentHeight;
            }
            else if (indexPath.row ==5)
            {
                //点赞&不喜欢
                return 70;
            }
            else if (indexPath.row ==6)
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
                titleCell.cellTitleLabel.text = _newsDetailModel.title;
                if ([_newsDetailModel.author.bind integerValue] == 0) {
                    titleCell.cellTimeLabel.text = [NSString stringWithFormat:@"%@  %@",_newsDetailModel.time,_newsDetailModel.author.name];
                } else {
                    titleCell.cellTimeLabel.text = _newsDetailModel.time;
                }
                return titleCell;
            }
            else if (indexPath.row == 1) {
                EVNewsAuthorsCell * authorCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsAuthorsCell"];
                authorCell.selectionStyle = NO;
                authorCell.authorImage.layer.cornerRadius = 22;
                authorCell.authorImage.layer.masksToBounds = YES;
                authorCell.backgroundColor = CCColor(250, 250, 250);
                authorCell.recommendPerson = _newsDetailModel.author;
                if ([_newsDetailModel.author.bind integerValue] == 0) {
                    authorCell.hidden = YES;
                }
                return authorCell;
            }
            else if (indexPath.row == 2) {
                EVNewsStockCell * stockCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsStockCell"];
                stockCell.selectionStyle = NO;
                if (!stockCell) {
                    stockCell = [[EVNewsStockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsStockCell"];
                }
                stockCell.stockModelArray = _newsDetailModel.stock;
                return stockCell;
            }
            else if (indexPath.row == 3)
            {
                EVNewsTagsCell * tagCell = [tableView dequeueReusableCellWithIdentifier:@"EVNewsTagsCell"];
                tagCell.selectionStyle = NO;
                if (!tagCell) {
                    tagCell = [[EVNewsTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EVNewsTagsCell"];
                    tagCell.tagsModelArray = _newsDetailModel.tag;
                    tagCell.tagCellHeightBlock = ^(CGFloat cellHeight) {
                        tagCellHeight = cellHeight;
                    };
                }
                
                return tagCell;
            }
            else if (indexPath.row == 4)
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
            else if (indexPath.row == 5)
            {
                EVLikeOrNotCell * likeOrNotCell = [tableView dequeueReusableCellWithIdentifier:@"EVLikeOrNotCell"];
                likeOrNotCell.selectionStyle = NO;
                likeOrNotCell.numberOfLike.text = _newsDetailModel.likeCount;
                likeOrNotCell.like = _newsDetailModel.like;
                likeOrNotCell.newsId = _newsDetailModel.id;
                likeOrNotCell.likeCount = _newsDetailModel.likeCount;
                return likeOrNotCell;
            }
            else if (indexPath.row == 6)
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
                allCell.allCommentLabel.text = [NSString stringWithFormat:@"全部评论(%ld)",[_newsDetailModel.postCount integerValue]];
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
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 1) {
                //作者
                EVWatchVideoInfo *watchVideoInfo = [EVWatchVideoInfo new];
                watchVideoInfo.name = _newsDetailModel.author.id;
                
                EVVipCenterController *vc = [[EVVipCenterController alloc] init];
                vc.watchVideoInfo = watchVideoInfo;
                [self.navigationController pushViewController:vc animated:YES];

            }
            else if (indexPath.row == 6)
            {
                //大V
                EVWatchVideoInfo *watchVideoInfo = [EVWatchVideoInfo new];
                watchVideoInfo.name = _newsDetailModel.recommendPerson.id;

                EVVipCenterController *vc = [[EVVipCenterController alloc] init];
                vc.watchVideoInfo = watchVideoInfo;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
            }
            else if(indexPath.row == commentHeightArray.count - 1) {
                
                if (![EVLoginInfo hasLogged]) {
                    UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
                    [self presentViewController:navighaVC animated:YES completion:nil];
                    return;
                }
                
                //全部评论
                EVNativeComentViewController * allCommentVC = [[EVNativeComentViewController alloc] init];
                allCommentVC.newsid = _newsDetailModel.id;
                [self.navigationController pushViewController:allCommentVC animated:YES];
            } else {
                EVHVVideoCommentModel *commentModel = _newsDetailModel.posts[indexPath.row - 1];
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
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
            } else {
                //相关新闻列表
                EVNewsModel *newsModel = _newsDetailModel.recommendNews[indexPath.row - 1];
                
                EVNativeNewsDetailViewController *newsWebVC = [[EVNativeNewsDetailViewController alloc] init];
                newsWebVC.newsID = newsModel.newsID;
                //newsWebVC.newsTitle = newsModel.title;
                if ([newsModel.newsID isEqualToString:@""] || newsModel.newsID == nil) {
                    return;
                }
                [self.navigationController pushViewController:newsWebVC animated:YES];
            }
        }
            break;
        default:
            break;
    }

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight - 10) style:(UITableViewStyleGrouped)];
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

- (void)deallocView
{
    if (self.touchLayer) {
        [self.touchLayer removeFromSuperview];
        self.touchLayer = nil;
    }
    
    if (self.window) {
        [self.window resignKeyWindow];
        self.window = nil;
    }
    
}

- (void)shareViewShowAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.eVSharePartView.frame = CGRectMake(0, 0, ScreenWidth,  ScreenHeight - 49);
    }];
}

- (void)presentLoginVC
{
    
    EVLoginInfo *loginInfo = [EVLoginInfo localObject];
    if (loginInfo.sessionid == nil || [loginInfo.sessionid isEqualToString:@""]) {
        UINavigationController *navighaVC = [EVLoginViewController loginViewControllerWithNavigationController];
        [self presentViewController:navighaVC animated:YES completion:nil];
    }
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 49)];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

@end
