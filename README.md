# 这个简单的列表滚动页面，头部使用scrollView，内容使用collectionView
# 使用简单，主题内容在PageTitleView（标题文件）、PageContentView（内容文件）
![image](https://github.com/AbaryLiu/PageViewDemo/blob/master/2019-05-14%2014-23-59.2019-05-14%2014_24_56.gif)
## 头部标题简单使用
```
 CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSArray * titles = @[@"推荐",@"游戏",@"娱乐",@"音频",@"视频"];
    //设置标题属性
    PageTitleViewConfigure * configure = [PageTitleViewConfigure new];
    configure.titleFont = 12;
    configure.titleNormalColor = [UIColor grayColor];
    configure.titleSelectColor = [UIColor redColor];
    configure.lineColor = [UIColor redColor];
    configure.lineHight = 2;
    
    _titleView = [PageTitleView pageTitleViewWithframe:CGRectMake(0, statusBarH, self.view.frame.size.width, 50) delegate:self titles:titles configure:configure];
    // 字体缩放
    _titleView.isTextZoom = YES;
    // 字体颜色渐变
    _titleView.isGradientEffect = YES;
    [self.view addSubview:_titleView];
```
## 内容初始化
```
    NSMutableArray * VCs = [NSMutableArray array];
    for (NSString * title in titles) {
        PageViewController * vc = [PageViewController new];
        vc.title = title;
        [VCs addObject:vc];
    }
    _contentView = [[PageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_titleView.frame)) ChildVCs:VCs parentVc:self];
    _contentView.delegate =self;
    [self.view addSubview:_contentView];
```
## 代理方法
```
#pragma mark - PageTitleViewDelegate,PageContentViewDelegate

- (void)pageTitleView:(PageTitleView *)titleView selectedIndex:(NSInteger)index {
    [_contentView setContentIndex:index];
}

- (void)PageContentView:(PageContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    [_titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
```
