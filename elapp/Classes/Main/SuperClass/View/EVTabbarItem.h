//
//  EVTabbarItem.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/16.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EVTabbarItemDelegate;

@interface EVTabbarItem : UIView

@property (nonatomic, weak) id <EVTabbarItemDelegate> delegate;

- (instancetype)initWithSelectImg:(UIImage *)selectImg normalImg:(UIImage *)normalImg title:(NSString *)title;
- (void)selectItem:(BOOL)YorN;
- (void)showRedPoint:(BOOL)YorN;

@end


@protocol EVTabbarItemDelegate <NSObject>
@required
- (void)didClickedTabbarItem:(EVTabbarItem *)item;

@end
