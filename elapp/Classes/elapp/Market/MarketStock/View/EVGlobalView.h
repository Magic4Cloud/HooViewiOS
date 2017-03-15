//
//  EVGlobalView.h
//  elapp
//
//  Created by 杨尚彬 on 2016/12/29.
//  Copyright © 2016年 easyvaas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVGlobalView;
@protocol EVGlobalViewDelegate <NSObject>

-(void)tagView:(EVGlobalView *)tagView editState:(BOOL)state;

-(void)tagView:(EVGlobalView *)tagView selectedTag:(NSInteger)row;

- (void)editButtonWithSelectedStocks:(NSArray *)stocks;

- (void)refreshButton;

@end
@interface EVGlobalView : UIView
@property(nonatomic,strong)UICollectionView                *collectionView;
@property(nonatomic,strong)NSString *unSelectItemTitle;
@property(nonatomic,assign)BOOL      editState;


@property(nonatomic,assign)id<EVGlobalViewDelegate>delegate;


- (void)loadData;
- (void)updateDataArray:(NSMutableArray *)dataArray;
- (void)removeALL;
@end
