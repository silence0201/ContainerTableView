//
//  SIContainerTableView.m
//  SIContainerTableView
//
//  Created by Silence on 2018/12/26.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "SIContainerTableView.h"

#define IS_IPHONE_X (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) == 44)

@interface SIGesturePassViewsTableView : UITableView
@property (copy, nonatomic) NSArray *gesturePassViews;
@end

@implementation SIGesturePassViewsTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.panGestureRecognizer.cancelsTouchesInView = NO;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIView *view  = otherGestureRecognizer.view;
    
    if ([[view superview] isKindOfClass:[UIWebView class]]) {
        view = [view superview];
    }
    
    if (_gesturePassViews && [_gesturePassViews containsObject:view]) {
        return YES;
    }else {
        return NO;
    }
    
    
}

@end

@interface SIContainerTableView ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL _hiddenFooterView;
}

@property (nonatomic, strong) SIGesturePassViewsTableView *tableView;

@end

@implementation SIContainerTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.canScroll = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - Public Method
- (CGFloat)heightForContainerCanScroll {
    if (_tableView && _tableView.tableHeaderView) {
        return CGRectGetHeight(_tableView.tableHeaderView.bounds) - [self contentInsetTop];
    }
    return 0;
}

- (void)setFooterViewHidden:(BOOL)hidden {
    if (_hiddenFooterView == hidden) return;
    _hiddenFooterView = hidden;
    [self resizeContentHeight];
    [_tableView reloadData];
}

- (void)setHeaderViewHeight:(CGFloat)height {
    if (!_tableView.tableHeaderView) return;
    UIView *headerView = _tableView.tableHeaderView;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    _tableView.tableHeaderView = headerView;
    [self resizeContentHeight];
    [_tableView reloadData];
}

-(void)setSegmentViewHeight:(CGFloat)height {
    if (!_segmentView) return;
    CGRect frame = _segmentView.frame ;
    frame.size.height = height;
    [self resizeContentHeight];
    [_tableView reloadData];
}


#pragma mark - Getter/Setter
- (SIGesturePassViewsTableView *)tableView {
    if (!_tableView) {
        _tableView = [[SIGesturePassViewsTableView alloc]initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView == headerView) return;
    _headerView = headerView;
    _tableView.tableHeaderView = headerView;
    [self resizeContentHeight];
    [_tableView reloadData];
}

- (void)setSegmentView:(UIView *)segmentView {
    if (_segmentView == segmentView) return;
    _segmentView = segmentView;
    _segmentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(_segmentView.frame));
    [_tableView reloadData];
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView == contentView) return;
    _contentView = contentView;
    [self resizeContentHeight];
    [_tableView reloadData];
}

- (void)setFooterView:(UIView *)footerView {
    if (_footerView == footerView) return;
    _footerView = footerView;
    [self resizeContentHeight];
    [_tableView reloadData];
}

- (void)setGesturePassViews:(NSArray *)gesturePassViews {
    _gesturePassViews = gesturePassViews;
    _tableView.gesturePassViews = gesturePassViews;
}

- (void)setCanScroll:(BOOL)canScroll {
    if (_canScroll == canScroll) return;
    _canScroll = canScroll;
    if (canScroll && self.delegate && [self.delegate respondsToSelector:@selector(tableViewContainerScroll:)]) {
        [self.delegate tableViewContainerScroll:self];
    }
}
#pragma mark - Private

- (CGFloat)contentInsetTop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentInsetTop:)]) {
        return [self.delegate tableViewContentInsetTop:self];
    }
    return 0;
}

- (CGFloat)contentInsetBottom {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentInsetBottom:)]) {
        return [self.delegate tableViewContentInsetBottom:self];
    }
    if (IS_IPHONE_X) {
        return 34;
    } else {
        return 0;
    }
}

- (CGFloat)footerViewHeight {
    return (_footerView && !_hiddenFooterView) ? CGRectGetHeight(_footerView.bounds) : 0;
}

- (void)resizeContentHeight {
    if (!_contentView) return;
    CGFloat contentHeight = CGRectGetHeight(self.bounds) - CGRectGetHeight(self.headerView.bounds) - CGRectGetHeight(self.segmentView.bounds) - [self contentInsetBottom] - [self contentInsetTop] - [self footerViewHeight];
    _contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), contentHeight);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (_contentView) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:_contentView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_contentView) {
        return CGRectGetHeight(_contentView.bounds);
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_segmentView) {
        return CGRectGetHeight(_segmentView.bounds);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_segmentView) {
        return _segmentView;
    }
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_footerView) {
        return  CGRectGetHeight(_footerView.bounds);
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_hiddenFooterView && _footerView) {
        return _footerView;
    }
    return [UIView new];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffSet = [self heightForContainerCanScroll];
    if (!_canScroll) {
        // 固定contentOffSet,来实现固定
        scrollView.contentOffset = CGPointMake(0, contentOffSet);
    }else if (scrollView.contentOffset.y >= contentOffSet) {
        scrollView.contentOffset = CGPointMake(0, contentOffSet);
        
        self.canScroll = NO;
        // 通知content开始滚动
        if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewContentScroll:)]) {
            [self.delegate tableViewContentScroll:self];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewDidScroll:)]) {
        [self.delegate tableViewDidScroll:_tableView];
    }
}

@end
