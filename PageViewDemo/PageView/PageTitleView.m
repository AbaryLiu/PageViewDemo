//
//  PageTitleView.m
//  PageViewDemo
//
//  Created by heyong on 2019/5/13.
//  Copyright © 2019年 liuxing. All rights reserved.
//

#import "PageTitleView.h"

@implementation PageTitleViewConfigure

- (UIColor *)lineColor {
    if (!_lineColor) {
        _lineColor = [UIColor orangeColor];
    }
    return _lineColor;
}

- (CGFloat)lineHight {
    if (_lineHight <= 0) {
        _lineHight = 2.f;
    }
    return _lineHight;
}

- (NSInteger)titleFont {
    if (_titleFont <= 0) {
        _titleFont = 12;
    }
    return _titleFont;
}


- (UIColor *)titleNormalColor {
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor blackColor];
    }
    return _titleNormalColor;
}

- (UIColor *)titleSelectColor {
    if (!_titleSelectColor) {
        _titleSelectColor = [UIColor orangeColor];
    }
    return _titleSelectColor;
}

@end



@interface PageTitleView ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *scrollLine;
@property (nonatomic,strong)NSMutableArray <UILabel *>*titleLabels;
@property (nonatomic,strong)PageTitleViewConfigure *configure;
@property (nonatomic,copy)NSArray * titles;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic, strong) NSArray<NSNumber *> *titleSelectColorGRBAArray;
@property (nonatomic, strong) NSArray<NSNumber *> *titleNormalColorRGBAArray;
@property (nonatomic,assign)id<PageTitleViewDelegate> delegate;

@end


@implementation PageTitleView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PageTitleViewDelegate>)delegate titles:(NSArray *)titles configure:(PageTitleViewConfigure *)configure {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        self.configure = configure;
        self.delegate = delegate;
        [self initDefault];
        [self setUpUI];
    }
    return self;
}

+ (instancetype)pageTitleViewWithframe:(CGRect)frame delegate:(id<PageTitleViewDelegate>)delegate titles:(NSArray *)titles configure:(PageTitleViewConfigure *)configure {
    
    return [[self alloc] initWithFrame:frame delegate:delegate titles:titles configure:configure];
}


- (void)initDefault {
    _isGradientEffect = YES;
    _isTextZoom = NO;
    _titleTextScaling = 0.1;
}


- (void)setUpUI {
    
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    [self setUpTitleLabels];
    [self setUpBottomMenuAndScrollLine];
}

- (void)setUpTitleLabels {
    
    CGFloat labelW = self.frame.size.width/self.titles.count;
    CGFloat labelH = self.frame.size.height - self.configure.lineHight;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titles.count; i ++) {
        UILabel * label = [UILabel new];
        label.text = self.titles[i];
        label.tag = i;
        label.font = [UIFont systemFontOfSize:self.configure.titleFont];
        label.textColor = self.configure.titleNormalColor;
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelX = labelW * i;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        [self.scrollView addSubview:label];
        [self.titleLabels addObject:label];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
    }
}

- (void)setUpBottomMenuAndScrollLine {
    
    UIView * bottomLine = [UIView new];
    CGFloat lineH = 0.5;
    bottomLine.frame = CGRectMake(0, self.frame.size.height-lineH, self.frame.size.width, lineH);
    [self addSubview:bottomLine];
    
    if (self.titleLabels.count > 0) {
        UILabel * firstLabel = self.titleLabels.firstObject;
        firstLabel.textColor = self.configure.titleSelectColor;
        
        [self.scrollView addSubview:self.scrollLine];
        self.scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - self.configure.lineHight, firstLabel.frame.size.width, self.configure.lineHight);
    }
}

#pragma mark - events

- (void)titleClick:(UITapGestureRecognizer *)tap {
    
    if (tap.view) {
        UILabel * currentLabel = (UILabel *)tap.view;
        if (currentLabel.tag == _currentIndex) {
            return;
        }
        UILabel * oldLabel = self.titleLabels[_currentIndex];
        [self setupLabelStatus:oldLabel targetLabel:currentLabel];
        
        _currentIndex = currentLabel.tag;
        
        CGFloat scrollLinePosition = currentLabel.tag * self.scrollLine.frame.size.width;
        [UIView animateWithDuration:0.15 animations:^{
            CGRect frame = self.scrollLine.frame;
            frame.origin.x = scrollLinePosition;
            self.scrollLine.frame = frame;
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pageTitleView:selectedIndex:)]) {
            [self.delegate pageTitleView:self selectedIndex:_currentIndex];
        }
    }
}


- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
 
    UILabel * sourceLabel = self.titleLabels[sourceIndex];
    UILabel * targetLabel = self.titleLabels[targetIndex];
    
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    CGRect frame = self.scrollLine.frame;
    frame.origin.x = sourceLabel.frame.origin.x + moveX;
    self.scrollLine.frame = frame;
    
    [self setupLabelStatus:sourceLabel targetLabel:targetLabel];
    //是否开启文字渐变
    if (self.isGradientEffect) {
        
        _titleSelectColorGRBAArray = [self getRGBAComponentsWithColor:self.configure.titleSelectColor];
        _titleNormalColorRGBAArray = [self getRGBAComponentsWithColor:self.configure.titleNormalColor];
        
        if (!(self.titleSelectColorGRBAArray.count < 4 || self.titleNormalColorRGBAArray.count < 4)) {
            if (progress != 0) {
                CGFloat titleHighlightedColorR = [self.titleSelectColorGRBAArray[0] floatValue];
                CGFloat titleHighlightedColorG = [self.titleSelectColorGRBAArray[1] floatValue];
                CGFloat titleHighlightedColorB = [self.titleSelectColorGRBAArray[2] floatValue];
                CGFloat titleHighlightedColorA = [self.titleSelectColorGRBAArray[3] floatValue];
                CGFloat titleNormalColorR = [self.titleNormalColorRGBAArray[0] floatValue];
                CGFloat titleNormalColorG = [self.titleNormalColorRGBAArray[1] floatValue];
                CGFloat titleNormalColorB = [self.titleNormalColorRGBAArray[2] floatValue];
                CGFloat titleNormalColorA = [self.titleNormalColorRGBAArray[3] floatValue];
                CGFloat RDistance = titleHighlightedColorR - titleNormalColorR;
                CGFloat GDistance = titleHighlightedColorG - titleNormalColorG;
                CGFloat BDistance = titleHighlightedColorB - titleNormalColorB;
                CGFloat ADistance = titleHighlightedColorA - titleNormalColorA;
                
                sourceLabel.textColor = [UIColor colorWithRed:(titleNormalColorR+(RDistance*(1.0-progress)))/255.
                                                        green:(titleNormalColorG+(GDistance*(1.0-progress)))/255.
                                                         blue:(titleNormalColorB+(BDistance*(1.0-progress)))/255.
                                                        alpha:titleNormalColorA+(ADistance*(1.0-progress))];
                targetLabel.textColor = [UIColor colorWithRed:(titleNormalColorR+(RDistance*progress))/255.
                                                        green:(titleNormalColorG+(GDistance*progress))/255.
                                                         blue:(titleNormalColorB+(BDistance*progress))/255.
                                                        alpha:titleNormalColorA+(ADistance*progress)];
            }
        }
    }
    
    
    _currentIndex = targetIndex;
  
}

- (void)setupLabelStatus:(UILabel *)sourceLabel targetLabel:(UILabel *)targetLabel  {

    sourceLabel.textColor = self.configure.titleNormalColor;
    targetLabel.textColor = self.configure.titleSelectColor;
    CGRect frame = self.scrollLine.frame;
    frame.size.height = self.configure.lineHight;
    self.scrollLine.frame = frame;
    
    //是否开启字体缩放
    if (self.isTextZoom) {
        [self.titleLabels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *btn = obj;
            btn.transform = CGAffineTransformMakeScale(1, 1);
        }];
        targetLabel.transform = CGAffineTransformMakeScale(1 + self.titleTextScaling, 1 + self.titleTextScaling);
    }

}

#pragma mark - setter/gettter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (NSMutableArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (UIView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [UIView new];
        _scrollLine.backgroundColor = self.configure.lineColor;
    }
    return _scrollLine;
}


// 渐变颜色
- (NSArray<NSNumber *> *)getRGBAComponentsWithColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    NSNumber * r = [NSNumber numberWithFloat:resultingPixel[0]];
    NSNumber * g = [NSNumber numberWithFloat:resultingPixel[1]];
    NSNumber * b = [NSNumber numberWithFloat:resultingPixel[2]];
    NSNumber * a = [NSNumber numberWithFloat:resultingPixel[3]/255.];
    return @[r,g,b,a];
    
}
@end



@interface PageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)NSArray *childVCs;
@property (nonatomic,weak) UIViewController * parentViewController;
@property (nonatomic,assign)CGFloat startOffsetX;
@property (nonatomic,assign)BOOL isForbidScrollDelegate;
@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)  CGFloat progress;
@property(nonatomic,assign) NSInteger  currentIndex;
@property(nonatomic,assign) CGFloat  directionLength;
@end

static NSString * const contentCellID = @"conentCellID";
@implementation PageContentView

- (instancetype)initWithFrame:(CGRect)frame ChildVCs:(NSArray *)childVCs parentVc:(UIViewController *)parentVc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCs = childVCs;
        self.parentViewController = parentVc;
        [self setUpUI];
        self.currentIndex = 0;
    }
    return self;
}

- (void)setUpUI {
    
    for (UIViewController * childVC in self.childVCs) {
        [self.parentViewController addChildViewController:childVC];
    }
    
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource/UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:contentCellID forIndexPath:indexPath];
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController * childVC = self.childVCs[indexPath.row];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _isForbidScrollDelegate = NO;
    _startOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    self.currentIndex =  currentOffsetX/ scrollViewW;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isForbidScrollDelegate) {
        return;
    }
    
    self.progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.frame.size.width;
    if (currentOffsetX > _startOffsetX) {//左滑
        self.progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        sourceIndex = currentOffsetX/ scrollViewW;
        targetIndex = sourceIndex + 1;
        
        
        
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
        }
        
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            self.progress = 1;
            targetIndex = sourceIndex;
        }
    } else {
        self.progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        targetIndex = currentOffsetX / scrollViewW;
        if (self.currentIndex == targetIndex) {
            if (self.directionLength < scrollView.contentOffset.x) {
                sourceIndex = targetIndex - 1;
            }else{
                sourceIndex = targetIndex+1;
            }
            
        }else{
            
            sourceIndex = targetIndex + 1;
        }
        
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(PageContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate PageContentView:self progress:self.progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    self.directionLength = scrollView.contentOffset.x;
}
- (void)setContentIndex:(NSInteger)currentIndex {
    
    _isForbidScrollDelegate = YES;
    CGFloat offsetX = currentIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

#pragma mark - setter/getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:contentCellID];
    }
    return _collectionView;
}

@end
