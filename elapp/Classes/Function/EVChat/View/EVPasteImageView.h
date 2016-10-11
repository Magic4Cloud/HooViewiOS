//
//  EVPasteImageView.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendBtnBlock)(UIImage *image);

@interface EVPasteImageView : UIView

- (void)showPasteImageView:(SendBtnBlock)sendBlock;

@end
