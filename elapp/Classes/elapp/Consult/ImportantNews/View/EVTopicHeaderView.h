//
//  EVTopicHeaderView.h
//  elapp
//
//  Created by 唐超 on 4/11/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVTopicModel;
/**
 专题详情页头部view
 */
@interface EVTopicHeaderView : UIView
@property (nonatomic,strong)UIImageView * bgImageView;
@property (nonatomic, strong)UILabel * viewCountLabel;
@property (nonatomic, strong)UILabel * viewTitleLabel;
@property (nonatomic, strong)UILabel * viewContentLabel;
@property (nonatomic, strong)EVTopicModel * topicModel;
@end
