//
//  EVTextLiveStockTableView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/23.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class EVStockBaseModel;
@protocol EVTextLiveStockDelegate <NSObject>

- (void)stockViewDidScroll:(UIScrollView *)scrollView;

@end


typedef void(^didCellSelectBlock)(EVStockBaseModel *stockBaseModel);

@interface EVTextLiveStockTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) id<EVTextLiveStockDelegate> tDelegate;

@property (nonatomic, copy) didCellSelectBlock cellSelectBlock;
@property (nonatomic, strong) WKWebView *stockWebView;
- (void)removeAllAry;

@end
