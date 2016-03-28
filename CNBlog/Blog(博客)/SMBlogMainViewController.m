//
//  SMBlogMainViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBlogMainViewController.h"
#import "SMTagMenuView.h"
#import "SMBlogTableViewController.h"
#import "SMBlog10DayTableViewController.h"
#import "SMBlog48HourTableViewController.h"
#import "SMBLogMoreTableViewController.h"

@interface SMBlogMainViewController () <SMTagMenuViewDelegate>

@property (nonatomic, strong) SMTagMenuView *tagMenuView;

@end

@implementation SMBlogMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
}

- (void)viewDidLayoutSubviews {
    
    [self setupTagMenu];

}
// 创建tagMenu
- (void)setupTagMenu {
    // 只创建一次
    if (self.tagMenuView)  return;
    
    // tag名称
    NSArray *tagNames = @[@"首页博客", @"十日推荐", @"48小时阅读", @"推荐博客"];
    SMTagMenuView *tagMenu = [[SMTagMenuView alloc] initWithFrame:CGRectMake(0, self.topLayoutGuide.length, self.view.width, 44)];
    tagMenu.tagNames = tagNames;
    tagMenu.delegate = self;
    self.tagMenuView = tagMenu;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 加入子页面显示
    [self.view addSubview:tagMenu];
}

// 创建子控制器
- (void)setupViewController {
    SMBlogTableViewController *mainBlogVC = [[SMBlogTableViewController alloc] init];
    [self addChildViewController:mainBlogVC];
    
    SMBlog10DayTableViewController *tenDayBlogVC = [[SMBlog10DayTableViewController alloc] init];
    [self addChildViewController:tenDayBlogVC];
    
    SMBlog48HourTableViewController *fourEHourBlogVC = [[SMBlog48HourTableViewController alloc] init];
    [self addChildViewController:fourEHourBlogVC];
    
    SMBLogMoreTableViewController *blogVC4 = [[SMBLogMoreTableViewController alloc] init];
    [self addChildViewController:blogVC4];
}

#pragma mark - SMTagMenuViewDelegate

- (void)smTagMenu:(UIView *)tagMenu didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

- (void)smTagMenu:(UIView *)tagMenu didDoubleClickButtonFrom:(NSInteger)from to:(NSInteger)to {
    UITableViewController *selectedVC = self.selectedViewController;
    [selectedVC.tableView setContentOffset:CGPointMake(0, -108) animated:YES];
}

@end
