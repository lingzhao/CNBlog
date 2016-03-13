//
//  SMSettingMainTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMSettingMainTableViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SMSettingMainTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *clearCacheLabel;

@end

@implementation SMSettingMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.contentOffset = CGPointZero;
    self.tableView.scrollEnabled = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 15;
    
    [self setupClearCacheLabel];
}

// 设置清除缓存信息
- (void)setupClearCacheLabel {
    // 获得缓存
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSUInteger fileSize = [SDImageCache sharedImageCache].getSize;
        
        // 设置文字
        NSString *text = nil;
        
        if (fileSize >= 1000 * 1000 * 1000) { // fileSize >= 1GB
            text = [NSString stringWithFormat:@"清除缓存(%.1fGB)", fileSize/(1000.0 * 1000.0 * 1000.0)];
        } else if (fileSize >= 1000 * 1000) { // 1GB > fileSize >= 1MB
            text = [NSString stringWithFormat:@"清除缓存(%.1fMB)", fileSize/(1000.0 * 1000.0)];
        } else if (fileSize >= 1000) { // 1MB > fileSize >= 1KB
            text = [NSString stringWithFormat:@"清除缓存(%.1fKB)", fileSize/ 1000.0];
        } else { // 1KB > fileSize
            text = [NSString stringWithFormat:@"清除缓存(%zdB)", fileSize];
        }
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置文字
            self.clearCacheLabel.text = text;
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    if (indexPath.section == 3) {
        if ([SDImageCache sharedImageCache].getSize != 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            [[SDImageCache sharedImageCache] clearDisk];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self setupClearCacheLabel];
            });
        } else {
            [SVProgressHUD showSuccessWithStatus:@"没有缓存,不需要清除"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"未开发" maskType:SVProgressHUDMaskTypeClear];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

@end
