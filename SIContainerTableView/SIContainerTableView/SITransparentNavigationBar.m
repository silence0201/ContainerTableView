//
//  SITransparentNavigationBar.m
//  SIContainerTableView
//
//  Created by Silence on 2019/1/8.
//  Copyright © 2019年 Silence. All rights reserved.
//

#import "SITransparentNavigationBar.h"

@interface SITransparentNavigationBar ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation SITransparentNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    // 将原来的背景设置透明
    UIImage *transparentImage = [[UIImage alloc] init];
    [self setBackgroundImage:transparentImage forBarMetrics:UIBarMetricsDefault];
    
    // 去除分割线
    UIImage *shadowImage = [[UIImage alloc] init];
    [self setShadowImage:shadowImage];
}

#pragma mark - public methods
- (void)setBackgroundAlpha:(CGFloat)alpha{
    alpha = alpha > 1 ? 1 : alpha;
    alpha = alpha < 0 ? 0 : alpha;
    
    if (!_bgView) {
        UIView *backgroundView = [[self subviews] firstObject];
        UIView *view = [[UIView alloc] initWithFrame:backgroundView.bounds];
        self.bgView = view;view.backgroundColor = [UIColor redColor];
        self.bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [backgroundView insertSubview:_bgView atIndex:0];
    }
    _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
}

@end
