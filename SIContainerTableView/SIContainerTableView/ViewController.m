//
//  ViewController.m
//  SIContainerTableView
//
//  Created by Silence on 2018/12/26.
//  Copyright © 2018年 Silence. All rights reserved.
//

#import "ViewController.h"
#import "SISegmentView.h"
#import "SIContainerTableView.h"
#import "SIPageView.h"
#import "SITransparentNavigationBar.h"

#define IS_IPHONE_X (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) == 44)

@interface ViewController ()<SISegmentViewDelegate,SIPageViewDelegate,SIPageViewDataSource,SIContainerTableViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SIContainerTableView *containerTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) SISegmentView *segmentView;
@property (nonatomic, strong) SIPageView *contentView;

@property (nonatomic, strong) NSMutableArray <NSArray *> *dataSource;
@property (nonatomic, strong) NSMutableArray <UIView *> *viewList;
@property (nonatomic, assign) BOOL canContentScroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self.view addSubview:self.containerTableView];
}

- (void)initDataSource {
    _viewList = [[NSMutableArray alloc] init];
    _dataSource = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 30; ++i) {
        [array addObject:[NSString stringWithFormat:@"Hello row - %d", i]];
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_dataSource addObject:array];
    
    [_viewList addObject:tableView];
    
    // 添加ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"img1"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * image.size.height / image.size.width);
    scrollView.contentSize = imageView.frame.size;
    scrollView.alwaysBounceVertical = YES; // 设置为YES，当contentSize小于frame.size也可以滚动
    [scrollView addSubview:imageView];
    scrollView.delegate = self;  // 主要是为了在 scrollViewDidScroll: 中处理是否可以滚动
    [_viewList addObject:scrollView];
    
    // 添加webview
    UIWebView *webview = [[UIWebView alloc] init];
    webview.backgroundColor = [UIColor whiteColor];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/silence0201"]]];
    webview.scrollView.delegate = self;  // 主要是为了在 scrollViewDidScroll: 中处理是否可以滚动
    [_viewList addObject:webview];
}


- (UIView *)headerView {
    if (!_headerView) {
        CGFloat offsetTop = [self heightHeaderHeight];
        UIImage *image = [UIImage imageNamed:@"img2"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, -offsetTop, CGRectGetWidth(self.view.frame), self.view.frame.size.width * image.size.height / image.size.width);
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame) - offsetTop)];
        [_headerView addSubview:imageView];
    }
    return _headerView;
}

- (SISegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[SISegmentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
        _segmentView.delegate = self;
        _segmentView.itemWidth = CGRectGetWidth(self.view.bounds) / 3;
        _segmentView.itemFont = [UIFont systemFontOfSize:15];
        _segmentView.itemNormalColor = [UIColor colorWithRed:155.0 / 255 green:155.0 / 255 blue:155.0 / 255 alpha:1];
        _segmentView.itemSelectColor = [UIColor colorWithRed:244.0 / 255 green:67.0 / 255 blue:54.0 / 255 alpha:1];
        _segmentView.bottomLineWidth = 60;
        _segmentView.bottomLineHeight = 2;
        _segmentView.itemList = @[ @"列表", @"图片", @"网页"];
    }
    return _segmentView;
}

- (SIPageView *)contentView {
    if (!_contentView) {
        _contentView = [[SIPageView alloc] initWithFrame:self.view.bounds];
        _contentView.delegate = self;
        _contentView.dataSource = self;
    }
    return _contentView;
}

- (SIContainerTableView *)containerTableView {
    if (!_containerTableView) {
        _containerTableView = [[SIContainerTableView alloc] initWithFrame:self.view.bounds];
        _containerTableView.delegate = self;
        _containerTableView.headerView = self.headerView;
        _containerTableView.segmentView = self.segmentView;
        _containerTableView.contentView = self.contentView;
        _containerTableView.gesturePassViews = _viewList;
    }
    return _containerTableView;
}

- (CGFloat)heightHeaderHeight {
    if (IS_IPHONE_X) {
        return 88;
    } else {
        return 64;
    }
}

- (void)segmentView:(SISegmentView *)segmentView didScrollToIndex:(NSUInteger)index {
    [_contentView scrollToIndex:index];
}

- (NSUInteger)numberOfPageInPageView:(SIPageView *)pageView {
    return [_viewList count];
}

- (UIView *)pageView:(SIPageView *)pageView pageAtIndex:(NSUInteger)index {
    return _viewList[index];
}

- (void)pageView:(SIPageView *)pageView didScrollToIndex:(NSUInteger)index {
    [_segmentView scrollToIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger pageIndex = tableView.tag;
    return [_dataSource[pageIndex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSUInteger pageIndex = tableView.tag;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _dataSource[pageIndex][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

// 3个tableView，scrollView，webView滑动时都会响应这个方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_canContentScroll) {
        // 这里通过固定contentOffset，来实现不滚动
        scrollView.contentOffset = CGPointZero;
    } else if (scrollView.contentOffset.y <= 0) {
        _canContentScroll = NO;
        // 通知容器可以开始滚动
        _containerTableView.canScroll = YES;
    }
    scrollView.showsVerticalScrollIndicator = _canContentScroll;
}


- (void)tableViewDidScroll:(UIScrollView *)scrollView {
    // 监听容器的滚动，来设置NavigationBar的透明度
    if (_headerView) {
        CGFloat offset = scrollView.contentOffset.y;
        CGFloat canScrollHeight = [_containerTableView heightForContainerCanScroll];
        SITransparentNavigationBar *bar = (SITransparentNavigationBar *)self.navigationController.navigationBar;
        if ([bar isKindOfClass:[SITransparentNavigationBar class]]) {
            [bar setBackgroundAlpha:offset / canScrollHeight];
        }
    }
}

- (CGFloat)tableViewContentInsetTop:(SIContainerTableView *)containerView {
    return [self heightHeaderHeight];
}


- (void)tableViewContainerScroll:(SIContainerTableView *)tableView {
    // 当容器开始可以滚动时，将所有内容设置回到顶部
    for (id view in self.viewList) {
        UIScrollView *scrollView;
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = view;
        } else if ([view isKindOfClass:[UIWebView class]]) {
            scrollView = ((UIWebView *)view).scrollView;
        }
        if (scrollView) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)tableViewContentScroll:(SIContainerTableView *)tableView {
    self.canContentScroll = YES;
}


@end
