//
//  EVUserTagsView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/2/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVUserTagsView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;


/**
 当标签居中显示

 @param frame
 @return 
 */
- (instancetype)initWithCenterFrame:(CGRect)frame;



@end
