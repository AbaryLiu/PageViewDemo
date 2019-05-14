//
//  PageViewController.m
//  PageViewDemo
//
//  Created by heyong on 2019/5/13.
//  Copyright © 2019年 liuxing. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = [NSString stringWithFormat:@"这个页面的标题是 %@",self.title];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}


@end
