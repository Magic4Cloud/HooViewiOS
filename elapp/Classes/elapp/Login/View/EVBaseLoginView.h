//
//  EVBaseLoginView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^closeButtonClick)(id btn);
@interface EVBaseLoginView : UIView

@property (nonatomic, copy) closeButtonClick closeClick;

@end
