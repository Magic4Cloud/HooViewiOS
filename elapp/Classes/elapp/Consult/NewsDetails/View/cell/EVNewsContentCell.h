//
//  EVNewsConrentCell.h
//  elapp
//
//  Created by 唐超 on 5/9/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
/**
 新闻详情contentcell  webview
 */
@interface EVNewsContentCell : UITableViewCell<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * cellWebView;

@end
