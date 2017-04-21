//
//  EVReadHistoryView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/21.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVNewsModel;
typedef void(^pushNewsDetailVC)(EVNewsModel *baseNewsModel);
@interface EVReadHistoryView : UIView
@property (nonatomic, copy) pushNewsDetailVC pushWatchBlock;
@end
