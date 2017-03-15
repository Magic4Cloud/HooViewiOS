//
//  EVHVLiveShareView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/14.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVHVLiveShareView.h"
#import "EVEnums.h"

@interface EVHVLiveShareView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *shareCollectionView;


@property (nonatomic, strong) NSArray *shareTypeArr;

@property (nonatomic, strong) NSArray *imageArr;
@end


@implementation EVHVLiveShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpView];
    }
    return self;
}

- (void)addUpView
{
    self.shareTypeArr = @[@(EVLiveShareQQButton),@(EVLiveShareQQZoneButton),@(EVLiveShareWeiXinButton),@(EVLiveShareFriendCircleButton),@(EVLiveShareSinaWeiBoButton)];
    self.imageArr = @[@"btn_qq_n",@"btn_qzone_n",@"btn_wechat_n",@"btn_moments_n",@"btn_weibo_n"];
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 0, 120, ScreenWidth);
    [self addSubview:contentView];
    contentView.backgroundColor = [UIColor evTextColorH1];
    contentView.alpha = 0.8;
    
    
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(46, 46);
    flowLayout.minimumLineSpacing = 5;
    UICollectionView *shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    shareCollectionView.delegate = self;
    shareCollectionView.dataSource = self;
    [self addSubview:shareCollectionView];
    self.shareCollectionView = shareCollectionView;
    shareCollectionView.backgroundColor = [UIColor clearColor];
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    [self.shareCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"shareCell"];
    [self.shareCollectionView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.shareCollectionView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.shareCollectionView autoSetDimensionsToSize:CGSizeMake(46, 250)];
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shareTypeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *shareCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareCell" forIndexPath:indexPath];
    shareCell.backgroundColor = [UIColor clearColor];
    UIImageView *imageV = [[UIImageView alloc] init];
    [shareCell addSubview:imageV];
    imageV.frame = CGRectMake(12, 12, 22, 22);
    imageV.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    return shareCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVLiveShareButtonType type = [self.shareTypeArr[indexPath.row] integerValue];
    if (self.shareTypeBlock) {
        self.shareTypeBlock(type);
    }
}
@end
