//
//  SIPageView.m
//  SIContainerTableView
//
//  Created by Silence on 2019/1/8.
//  Copyright © 2019年 Silence. All rights reserved.
//

#import "SIPageView.h"

static NSString *const kSIPageViewReuseIdentifier = @"SIPageViewReuseIdentifier";

@interface SIPageView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation SIPageView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    self.flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.collectionView reloadData];
}

#pragma mark - Public Method
- (void)scrollToIndex:(NSUInteger)index {
    NSInteger pageCount = [self collectionView:_collectionView numberOfItemsInSection:0];
    if (index >= pageCount) return;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - Getter & Setter
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        _flowLayout.minimumLineSpacing = 0 ;
        _flowLayout.minimumInteritemSpacing = 0;
        
        CGFloat itemWidth = CGRectGetWidth(self.frame);
        CGFloat itemHeight = CGRectGetHeight(self.frame);
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kSIPageViewReuseIdentifier];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(numberOfPageInPageView:)]) {
        return [self.dataSource numberOfPageInPageView:self];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSIPageViewReuseIdentifier forIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(pageView:pageAtIndex:)]) {
        UIView *page = [self.dataSource pageView:self pageAtIndex:indexPath.row];
        [cell.contentView addSubview:page];
        page.frame = cell.bounds;
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offSet = scrollView.contentOffset.x;
    NSInteger pageIndex = round(offSet / CGRectGetWidth(self.frame));
    
    if ([self.delegate respondsToSelector:@selector(pageView:didScrollToIndex:)]) {
        [self.delegate pageView:self didScrollToIndex:pageIndex];
    }
}

@end
