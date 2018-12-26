//
//  SIContainerTableView.h
//  SIContainerTableView
//
//  Created by Silence on 2018/12/26.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class SIContainerTableView;

@protocol SIContainerTableViewDelegate <NSObject>

@required
- (void)tableViewContentScroll:(SIContainerTableView *)tableView;
- (void)tableViewContainerScroll:(SIContainerTableView *)tableView;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

@optional
- (CGFloat)tableViewContentInsetTop:(SIContainerTableView *)tableView;
- (CGFloat)tableViewContentInsetBottom:(SIContainerTableView *)nestTableView;

@end

@interface SIContainerTableView : UIView

/// 头部
@property (nonatomic, strong) UIView *headerView;
/// 分类导航
@property (nonatomic, strong) UIView *segmentView;
/// 内容
@property (nonatomic, strong) UIView *contentView;
/// 底部
@property (nonatomic, strong) UIView *footerView;

/// 设置容器是否可以滚动
@property (nonatomic, assign) BOOL canScroll;

/// 设置可以传递手势的列表
@property (nonatomic, copy) NSArray *gesturePassViews;

/// 容器代理
@property (nonatomic, weak) id<SIContainerTableViewDelegate> delegate;

/// 返回容器可以滑动的高度,超过这个高度会调用tableViewContentScroll方法实现Content的滑动
- (CGFloat)heightForContainerCanScroll;

- (void)setFooterViewHidden:(BOOL)hidden;

- (void)setHeaderViewHeight:(CGFloat)height;
- (void)setSegmentViewHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
