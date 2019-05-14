//
//  ViewController.m
//  PageViewDemo
//
//  Created by heyong on 2019/5/13.
//  Copyright © 2019年 liuxing. All rights reserved.
//

#import "ViewController.h"
#import "PageViewController.h"
#import "PageView/PageTitleView.h"


@interface ViewController ()<PageTitleViewDelegate,PageContentViewDelegate>

@property (nonatomic,strong)PageContentView *contentView;
@property (nonatomic,strong)PageTitleView *titleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSArray * titles = @[@"推荐",@"游戏",@"娱乐",@"音频",@"视频"];
    _titleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, statusBarH, self.view.frame.size.width, 50) titles:titles];
    _titleView.delegate = self;
    _titleView.titleNormalFont = 12;
    _titleView.titleSelectFont = 15;
    _titleView.titleNormalColor = [UIColor grayColor];
    _titleView.titleSelectColor = [UIColor redColor];
    _titleView.lineColor = [UIColor redColor];
    _titleView.lineHight = 2;
    [self.view addSubview:_titleView];
    
    NSMutableArray * VCs = [NSMutableArray array];
    for (NSString * title in titles) {
        PageViewController * vc = [PageViewController new];
        vc.title = title;
        [VCs addObject:vc];
    }
    _contentView = [[PageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_titleView.frame)) ChildVCs:VCs parentVc:self];
    _contentView.delegate =self;
    [self.view addSubview:_contentView];
}

#pragma mark - PageTitleViewDelegate,PageContentViewDelegate

- (void)pageTitleView:(PageTitleView *)titleView selectedIndex:(NSInteger)index {
    [_contentView setContentIndex:index];
}

- (void)PageContentView:(PageContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    [_titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

@end
