//
//  EVRecommendCell.m
//  elapp
//
//  Created by 唐超 on 4/6/17.
//  Copyright © 2017 easyvaas. All rights reserved.
//

#import "EVRecommendCell.h"
#import "EVAvatarCell.h"
#import "EVRecommendModel.h"
@implementation EVRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor evLineColor];
    UIView * lineView = [UIView new];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor hvPurpleColor];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:12];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12];
    [lineView autoSetDimensionsToSize:CGSizeMake(2, 14)];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"牛人推荐";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithHexString:@"#303030"];
    [self.contentView addSubview:label];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView withOffset:6];
    [label autoAlignAxis:ALAxisHorizontal toSameAxisOfView:lineView];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:12];
    [self.collectionView autoSetDimension:ALDimensionHeight toSize:162];
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _recommentArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"EVAvatarCell";
    EVAvatarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    EVRecommendModel * model = _recommentArray[indexPath.item];
    cell.recommendModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didselectedIndexIWithModelBlock) {
        EVRecommendModel * model = _recommentArray[indexPath.item];
        self.didselectedIndexIWithModelBlock(model);
    }
}
#pragma mark - ✍️ Setters & Getters
- (void)setRecommentArray:(NSMutableArray *)recommentArray
{
    if (!recommentArray) {
        return;
    }
    _recommentArray = recommentArray;
    [_collectionView reloadData];
    
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(128, 162);
        layout.minimumLineSpacing = 20;//滑动方向的距离
        layout.minimumInteritemSpacing = 0;//与滑动方向垂直的距离
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"EVAvatarCell" bundle:nil] forCellWithReuseIdentifier:@"EVAvatarCell"];
    }
    return _collectionView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
