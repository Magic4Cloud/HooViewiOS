//
//  EVWebViewShareView.m
//  elapp
//
//  Created by 杨尚彬 on 2017/1/3.
//  Copyright © 2017年 easyvaas. All rights reserved.
//

#import "EVWebViewShareView.h"
#import "EVShareViewCell.h"

static NSString *identifier = @"EVShareViewCell";

@interface EVWebViewShareView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *shareCollectionView;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation EVWebViewShareView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUpViewFrame:frame];
    }
    return self;
}

- (void)addUpViewFrame:(CGRect)frame
{
    self.titleArray = [NSMutableArray arrayWithObjects:@"QQ",@"新浪微博",@"朋友圈",@"微信",@"QQ空间", nil];
    self.imageArray = [NSMutableArray arrayWithObjects:@"btn_qq_s",@"btn_weibo_s",@"btn_moments_s",@"btn_wechat_s",@"btn_qzone_s", nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70, 110);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *shareCollectionView = [[UICollectionView alloc ]initWithFrame:CGRectMake(0, 0,ScreenWidth, 110) collectionViewLayout:flowLayout];
    shareCollectionView.delegate = self;
    shareCollectionView.dataSource = self;
    [self addSubview:shareCollectionView];
    self.shareCollectionView = shareCollectionView;
    shareCollectionView.showsVerticalScrollIndicator = NO;
    shareCollectionView.showsHorizontalScrollIndicator = NO;
    shareCollectionView.backgroundColor = [UIColor whiteColor];
    [shareCollectionView registerClass:[EVShareViewCell class] forCellWithReuseIdentifier:identifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath]
    ;
    
    [cell.shareWayBtn setImage:[UIImage imageNamed:self.imageArray[indexPath.row]] forState:(UIControlStateNormal)];
//    [cell.shareWayBtn setBackgroundImage:[UIImage imageNamed:self.imageArray[indexPath.row]] forState:(UIControlStateNormal)];
    [cell.shareWayNameLabel setText:self.titleArray[indexPath.row]];
    
    
    
    cell.shareBtnClickBlock = ^(UIButton *shareBtn) {
        shareBtn.tag = indexPath.row;
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareType:)]) {
            switch (indexPath.row) {
                case ShareWayQQ:
                    [self.delegate shareType:EVLiveShareQQButton];
                    break;
                case ShareWayWeiBo:
                    [self.delegate shareType:EVLiveShareSinaWeiBoButton];
                    break;
                case ShareWayFriends:
                    [self.delegate shareType:EVLiveShareFriendCircleButton];
                    break;
                case ShareWayWeiChat:
                    [self.delegate shareType:EVLiveShareWeiXinButton];
                    break;
                case ShareWayQZone:
                    [self.delegate shareType:EVLiveShareQQZoneButton];
                    break;
                default:
                    break;
            }
        }
       
        
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareType:)]) {
        switch (indexPath.row) {
            case ShareWayQQ:
                [self.delegate shareType:EVLiveShareQQButton];
                
                break;
            case ShareWayWeiBo:
                [self.delegate shareType:EVLiveShareSinaWeiBoButton];
                break;
            case ShareWayFriends:
                [self.delegate shareType:EVLiveShareFriendCircleButton];
                break;
            case ShareWayWeiChat:
                [self.delegate shareType:EVLiveShareWeiXinButton];
                break;
            case ShareWayQZone:
                [self.delegate shareType:EVLiveShareQQZoneButton];
                break;
            default:
                break;
        }
    }
    
    
    
}

@end
