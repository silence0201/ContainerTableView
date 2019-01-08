//
//  SISegmentView.m
//  SIContainerTableView
//
//  Created by Silence on 2019/1/8.
//  Copyright © 2019年 Silence. All rights reserved.
//

#import "SISegmentView.h"

static NSInteger kSISegmentViewCellBottomLineHeight = 2;
static NSString *const kSISegmentViewReuseIdentifier = @"SISegmentViewReuseIdentifier";

@implementation SISegmentViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kSISegmentViewCellBottomLineHeight, 0, kSISegmentViewCellBottomLineHeight)];
        _bottomLine.clipsToBounds = YES;
        _bottomLine.backgroundColor = [UIColor redColor];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = self.bounds;
    
    CGRect bottomLineFrame = _bottomLine.frame;
    bottomLineFrame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(bottomLineFrame)) / 2;
    bottomLineFrame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(bottomLineFrame);
    _bottomLine.frame = bottomLineFrame;
}

@end

@interface SISegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation SISegmentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 调整所有item的尺寸，保证item高度和segmentView高度相等
    _collectionView.frame = self.bounds;
    _flowLayout.itemSize = CGSizeMake(_itemWidth, CGRectGetHeight(self.frame));
    
    [_collectionView reloadData];
}

#pragma mark - Public Method
- (void)scrollToIndex:(NSUInteger)index {
    if (_currentIndex == index) return;
    if (index >= _itemList.count) return;
    [self selectIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Private Method
- (void)selectIndex:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didScrollToIndex:)]) {
        [self.delegate segmentView:self didScrollToIndex:indexPath.row];
    }
}

#pragma mark - Getter & Setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[self bounds] collectionViewLayout:self.flowLayout];
        [self addSubview:_collectionView];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[SISegmentViewCell class] forCellWithReuseIdentifier:kSISegmentViewReuseIdentifier];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //设置间距
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        
        //设置item尺寸
        CGFloat itemW = _itemWidth;
        CGFloat itemH = CGRectGetHeight(self.frame);
        _flowLayout.itemSize = CGSizeMake(itemW, itemH);
        
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        // 设置水平滚动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (void)setItemList:(NSArray<NSString *> *)itemList {
    _itemList = itemList;
    [_collectionView reloadData];
}

- (void)setItemFont:(UIFont *)itemFont {
    _itemFont = itemFont;
    [_collectionView reloadData];
}

- (void)setItemWidth:(CGFloat)itemWidth {
    _itemWidth = itemWidth;
    [_collectionView reloadData];
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    _itemNormalColor = itemNormalColor;
    [_collectionView reloadData];
}

- (void)setItemSelectColor:(UIColor *)itemSelectColor {
    _itemSelectColor = itemSelectColor;
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SISegmentViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSISegmentViewReuseIdentifier forIndexPath:indexPath];
    
    UILabel *label = cell.titleLabel;
    label.text = _itemList[indexPath.row];
    label.font = _itemFont;
    label.textColor = _currentIndex == indexPath.row ? _itemSelectColor : _itemNormalColor;
    
    UIView *bottomLine = cell.bottomLine;
    if (_currentIndex == indexPath.row) {
        bottomLine.hidden = NO;
        bottomLine.backgroundColor = _itemSelectColor;
        
        CGRect frame = bottomLine.frame;
        frame.size.width = _bottomLineWidth ? _bottomLineWidth : _itemWidth;
        frame.size.height = _bottomLineHeight ? _bottomLineHeight : CGRectGetHeight(frame);
        bottomLine.frame = frame;
        bottomLine.layer.cornerRadius = CGRectGetHeight(frame) / 2;
    } else {
        bottomLine.hidden = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self selectIndex:indexPath];
}

@end
