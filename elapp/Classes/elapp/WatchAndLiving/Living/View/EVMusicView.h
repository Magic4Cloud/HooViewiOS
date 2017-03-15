//
//  EVMusicView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/11/14.
//  Copyright © 2016年 easyvaas. All rights reserved.
//
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MusicButtonType) {
    MusicButtonTypePlay,
    MusicButtonTypePause,
    MusicButtonTypeResume,
    MusicButtonTypeStop,
    
};

@protocol EVMusicViewDelegate <NSObject>

- (void)touchMusicButton:(MusicButtonType)musicType button:(UIButton *)btn;


@end

@interface EVMusicView : UIView

@property (nonatomic, weak) id <EVMusicViewDelegate> delegate;


- (void)showCover;
@end
