//
//  EVNotOpenView.h
//  elapp
//
//  Created by 杨尚彬 on 2017/1/11.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVNotOpenView : UIView

@property (nonatomic, weak) UIImageView *topBackImageView;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, weak) UILabel *textLabel;

@property (nonatomic, copy) NSString *titleStr;

@end
