# 这个简单的列表滚动页面，头部使用scrollView，内容使用collectionView
# 使用简单，主题内容在PageTitleView（标题文件）、PageContentView（内容文件）
## 头部标题简单使用
```
 CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSArray * titles = @[@"推荐",@"游戏",@"娱乐",@"音频",@"视频"];
    _titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, statusBarH, self.view.frame.size.width, 50) titles:titles];
    _titleView.delegate = self;
    [self.view addSubview:_titleView];
```
## 设置标题样式
```
    _titleView.titleNormalFont = 12;
    _titleView.titleSelectFont = 15;
    _titleView.titleNormalColor = [UIColor grayColor];
    _titleView.titleSelectColor = [UIColor redColor];
    _titleView.lineColor = [UIColor redColor];
    _titleView.lineHight = 2;
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
