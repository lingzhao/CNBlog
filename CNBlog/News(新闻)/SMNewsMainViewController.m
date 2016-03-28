//
//  SMNewsMainViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMNewsMainViewController.h"
#import "SMNewsTableViewController.h"
#import "SMHotNewsTableViewController.h"

@interface SMNewsMainViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation SMNewsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupScrollView];
    
    [self setupViewController];

    [self setupTitleView];
    
    //默认显示第0个控制器view
    [self scrollViewDidEndScrollingAnimation:self.scrollView];

}

- (void)setupViewController {
    SMHotNewsTableViewController *hotNews = [[SMHotNewsTableViewController alloc] init];
    SMNewsTableViewController *recentNews = [[SMNewsTableViewController alloc] init];
    
    [self addChildViewController:recentNews];
    [self addChildViewController:hotNews];
    
    [self.scrollView setContentSize:CGSizeMake(self.childViewControllers.count*self.view.width, 0)];

}

- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
}

- (void)setupTitleView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    
    NSArray *btnTitleArray = @[@"最新", @"热门"];
    self.btnArray = [NSMutableArray array];
    
    CGFloat btnW = titleView.width / btnTitleArray.count;
    CGFloat btnH = titleView.height;
    for (int i =0; i<btnTitleArray.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(i*btnW, 0, btnW, btnH);
        button.clipsToBounds = YES;
        button.layer.cornerRadius = btnH/2;
        button.tag = i;
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button setBackgroundImage:[self createPureColorImageWithColor:[UIColor whiteColor] alpha:1 size:button.frame.size] forState:UIControlStateNormal];
        [button setBackgroundImage:[self createPureColorImageWithColor:[UIColor darkGrayColor] alpha:1 size:button.frame.size] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        [titleView addSubview:button];
        [self.btnArray addObject:button];
        
        if (i == 0) {
            [self btnClick:button];
        }
    }
    self.navigationItem.titleView = titleView;
    
}

- (void)btnClick: (UIButton *)btn {
    // 修改按钮状态
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    CGPoint offset = CGPointMake(self.view.width * btn.tag, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
}

// 生成纯色背景图
- (UIImage *)createPureColorImageWithColor:(UIColor *)color alpha:(CGFloat)alpha size:(CGSize)size
{
    // 纯色的UIView
    UIView *pureColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    pureColorView.backgroundColor = color;
    pureColorView.alpha = alpha;
    
    // 由上下文获取UIImage
    UIGraphicsBeginImageContext(size);
    [pureColorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *pureColorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return pureColorImage;
}

#pragma mark - UIScrollViewDelegate

// 需要主动调用才触发
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    
    // 如果添加过就返回
    if (vc.isViewLoaded) return;
    
    vc.view.frame = scrollView.bounds;
    [scrollView addSubview:vc.view];
}

// 人为滑动就触发
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self btnClick:self.btnArray[index]];
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end
