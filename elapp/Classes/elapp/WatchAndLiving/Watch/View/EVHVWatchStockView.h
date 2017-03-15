//
//  EVHVWatchStockView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class EVStockBaseModel;
typedef void(^didSeletedStcokBlock)(EVStockBaseModel *stockBaseModel);

@interface EVHVWatchStockView : UIView

@property (nonatomic, weak) UITableView *searchTableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) WKWebView *stockWebView;


@end
