//
//  ViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/2/29.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "ViewController.h"
#import "SMBlogMainViewController.h"
#import "SMNewsMainViewController.h"
#import "SMSettingMainTableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加所有子控制器
    [self setupChildViewController];

}

// 添加所有子控制器
- (void)setupChildViewController {
    
    // 设置BlogVC
    [self setupChildViewControllerWithVC:[[SMBlogMainViewController alloc] init] title:@"博客"  image:[UIImage imageNamed:@"tabBar_essence_icon"] selectedImage:[[UIImage imageNamed:@"tabBar_essence_click_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    // 设置NewsVC
    [self setupChildViewControllerWithVC:[[SMNewsMainViewController alloc] init] title:@"新闻"  image:[UIImage imageNamed:@"tabBar_new_icon"] selectedImage:[[UIImage imageNamed:@"tabBar_new_click_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    // 设置SettingVC
    SMSettingMainTableViewController *settingVC = [[UIStoryboard storyboardWithName:NSStringFromClass([SMSettingMainTableViewController class]) bundle:nil] instantiateInitialViewController];
    [self setupChildViewControllerWithVC:settingVC title:@"我的"  image:[UIImage imageNamed:@"tabBar_me_icon"] selectedImage:[[UIImage imageNamed:@"tabBar_me_click_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

// 添加子控制器
- (void)setupChildViewControllerWithVC:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    // 设置tabBarItem
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    [vc.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    // 设置tabBarItem文字属性
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]} forState:UIControlStateSelected];
    
//    self.tabBar.barStyle = UIBarStyleBlack;
    
    // 添加子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBar.barStyle = UIBarStyleBlack;
    
    [self addChildViewController:nav];
}


@end
