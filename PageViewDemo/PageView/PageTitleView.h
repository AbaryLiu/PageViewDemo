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


@interface PageTitleViewConfigure : NSObject

/** 底部分割线，默认为 2.f */
@property (nonatomic,assign)CGFloat lineHight;
/** 底部分割线颜色，默认为 orangeColor */
@property (nonatomic,copy)UIColor *lineColor;
/** 标题普通状态颜色，默认为 blackColor */
@property (nonatomic,copy)UIColor *titleNormalColor;
/** 标题选中状态颜色，默认为 orangeColor */
@property (nonatomic,copy)UIColor *titleSelectColor;
/** 标题字体大小，默认为 12 */
@property (nonatomic,assign)NSInteger titleFont;

@end


@interface PageTitleView : UIView

/** 是否让标题按钮文字有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL isGradientEffect;
/** 是否开启标题按钮文字缩放效果，默认为 NO */
@property (nonatomic, assign) BOOL isTextZoom;
/** 标题文字缩放比，默认为 0.1f，取值范围 0 ～ 0.3f */
@property (nonatomic, assign) CGFloat titleTextScaling;


/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PageTitleViewDelegate>)delegate titles:(NSArray *)titles configure:(PageTitleViewConfigure *)configure;

/** 类方法，推荐使用 */
+ (instancetype)pageTitleViewWithframe:(CGRect)frame delegate:(id<PageTitleViewDelegate>)delegate titles:(NSArray *)titles configure:(PageTitleViewConfigure *)configure;

/** 外部方法 */
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
