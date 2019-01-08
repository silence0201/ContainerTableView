//
//  SISegmentView.h
//  SIContainerTableView
//
//  Created by Silence on 2019/1/8.
//  Copyright © 2019年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SISegmentViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@class SISegmentView;

@protocol SISegmentViewDelegate <NSObject>

- (void)segmentView:(SISegmentView *)segmentView didScrollToIndex:(NSUInteger)index;

@end

@interface SISegmentView : UIView

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIFont  *itemFont;
@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, assign) CGFloat bottomLineWidth;
@property (nonatomic, assign) CGFloat bottomLineHeight;

@property (nonatomic, strong) NSArray <NSString *> *itemList;

@property (nonatomic, weak) id<SISegmentViewDelegate> delegate;

- (void)scrollToIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
