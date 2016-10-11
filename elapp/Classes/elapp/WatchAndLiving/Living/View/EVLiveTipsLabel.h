//
//  EVLiveTipsLabel.h
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVLiveTipsLabel : UILabel

- (void)showWithAnimationText:(NSString *)text;
- (void)hiddenWithAnimation;

- (void)showConnecting;

@end
