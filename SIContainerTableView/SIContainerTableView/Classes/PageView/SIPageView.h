//
//  SIPageView.h
//  SIContainerTableView
//
//  Created by Silence on 2019/1/8.
//  Copyright © 2019年 Silence. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SIPageView;

@protocol SIPageViewDelegate <NSObject>

- (void)pageView:(SIPageView *)pageView didScrollToIndex:(NSUInteger)index;

@end

@protocol SIPageViewDataSource <NSObject>

- (NSUInteger)numberOfPageInPageView:(SIPageView *)pageView;
- (UIView *)pageView:(SIPageView *)pageView pageAtIndex:(NSUInteger)index;

@end

@interface SIPageView : UIView

@property (nonatomic, weak) id<SIPageViewDataSource> dataSource;
@property (nonatomic, weak) id<SIPageViewDelegate> delegate;

- (void)scrollToIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
