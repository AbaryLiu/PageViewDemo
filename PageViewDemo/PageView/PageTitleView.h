//
//  PageTitleView.h
//  PageViewDemo
//
//  Created by heyong on 2019/5/13.
//  Copyright © 2019年 liuxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PageTitleView;
@protocol PageTitleViewDelegate <NSObject>

- (void)pageTitleView:(PageTitleView *)titleView selectedIndex:(NSInteger)index;

@end

@interface PageTitleView : UIView

@property (nonatomic,assign)id<PageTitleViewDelegate> delegate;

//其他设置
@property (nonatomic,assign)CGFloat lineHight;
@property (nonatomic,copy)UIColor *lineColor;
@property (nonatomic,copy)UIColor *titleNormalColor;
@property (nonatomic,copy)UIColor *titleSelectColor;
@property (nonatomic,assign)NSInteger titleNormalFont;
@property (nonatomic,assign)NSInteger titleSelectFont;


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@end


@class PageContentView;
@protocol PageContentViewDelegate <NSObject>

- (void)PageContentView:(PageContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@end


@interface PageContentView : UIView

@property (nonatomic,assign)id<PageContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame ChildVCs:(NSArray *)childVCs parentVc:(UIViewController *)parentVc;
- (void)setContentIndex:(NSInteger)currentIndex;
@end
NS_ASSUME_NONNULL_END
