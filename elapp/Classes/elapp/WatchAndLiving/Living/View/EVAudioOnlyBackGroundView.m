//
//  EVAudioOnlyBackGroundView.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//


#import "EVAudioOnlyBackGroundView.h"
#import <PureLayout.h>
#import "EVAudioOnlyCollectionViewCell.h"
#import "EVAudioOnlyCollectionViewCellItem.h"

#define TOPBAR_HEIGHT 64

#define ANIMATION_TIME 0.2

@interface EVAudioOnlyBackGroundView ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *items;

@end

@implementation EVAudioOnlyBackGroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    UIView *topBar = [[UIView alloc] init];
    [self addSubview:topBar];
    topBar.backgroundColor = CCAppMainColor;
    [topBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [topBar autoSetDimension:ALDimensionHeight toSize:TOPBAR_HEIGHT];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kE_GlobalZH(@"default_background");
    [topBar addSubview:titleLabel];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    NSLayoutConstraint *constraint = [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    constraint.constant = 10;
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [topBar addSubview:cancelButton];
    [cancelButton setTitle:kCancel forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
    [cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *comfirmButton = [[UIButton alloc] init];
    [topBar addSubview:comfirmButton];
    [comfirmButton setTitle:kOK forState:UIControlStateNormal];
    comfirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [comfirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLabel];
    [comfirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [comfirmButton addTarget:self action:@selector(comfirm) forControlEvents:UIControlEventTouchUpInside];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(0.8 * ScreenWidth, 0.8 * ScreenHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(layout.sectionInset.top, 20, layout.sectionInset.bottom, 20);
    layout.minimumInteritemSpacing = 15;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    [collectionView registerClass:[EVAudioOnlyCollectionViewCell class] forCellWithReuseIdentifier:[EVAudioOnlyCollectionViewCell cellID]];
    [collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topBar];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    EVAudioOnlyCollectionViewCellItem *item = self.items[0];
    self.selectedItem = item;
    item.selected = YES;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EVAudioOnlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EVAudioOnlyCollectionViewCell cellID] forIndexPath:indexPath];
    
    EVAudioOnlyCollectionViewCellItem *item = self.items[indexPath.item];
    cell.item = item;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    for ( EVAudioOnlyCollectionViewCellItem *item in self.items )
    {
        item.selected = NO;
    }
    EVAudioOnlyCollectionViewCellItem *item = self.items[indexPath.item];
    item.selected = YES;
    [collectionView reloadData];
}

- (void)show
{
    self.hidden = NO;
//    self.marginSuperViewTop.constant = 0;

    CGRect frame = self.frame;
    
    self.frame = CGRectMake(0, ScreenHeight, frame.size.width, frame.size.height);
    
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
//        [self layoutIfNeeded];
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }];
}

- (void)dismiss
{
    if ( [UIDevice currentDevice].systemVersion.floatValue >= 8.0 )
    {
        CGRect frame = self.frame;
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.frame = CGRectMake(0, ScreenHeight, frame.size.width, frame.size.height);
            //        [self layoutIfNeeded];
        }];
    }
//    self.marginSuperViewTop.constant = ScreenHeight;
//    [self setNeedsLayout];
     self.hidden = YES;
}

- (void)comfirm
{
    for ( EVAudioOnlyCollectionViewCellItem *item in self.items )
    {
        if ( item.selected )
        {
            self.selectedItem = item;
            break;
        }
    }
    
    [self dismiss];
    
    if ( [self.delegate respondsToSelector:@selector(audioOnlyBackGroundViewDidClickComfirm:)] )
    {
        [self.delegate audioOnlyBackGroundViewDidClickComfirm:self];
    }
}

@end
