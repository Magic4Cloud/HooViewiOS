//
//  EVMineTableViewCell.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/26.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVMineTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView * cellNewMessageImageView;
- (void)setCellImage:(NSString *)image name:(NSString *)name;
@end
