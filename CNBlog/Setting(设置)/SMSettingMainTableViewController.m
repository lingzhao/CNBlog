//
//  SMSettingMainTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMSettingMainTableViewController.h"
#import "SMCollectionTableViewController.h"
#import "SMAttentionTableViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define iconPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"icon.png"]

@interface SMSettingMainTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *clearCacheLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@end

@implementation SMSettingMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.contentOffset = CGPointZero;
    self.tableView.scrollEnabled = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 15;
    
    // 从本地获取图片
    UIImage *image = [UIImage imageWithContentsOfFile:iconPath];
    if (image) {
        [self.iconButton setBackgroundImage:image forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

    // 每次进入页面前刷新缓存大小
    [self setupClearCacheLabel];
}

// 更改头像
- (IBAction)iconClick:(UIButton *)sender {
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *defaultActionTakePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                
                [self presentViewController:imagePicker animated:YES completion:nil];
            }];
            
            [alertController addAction:defaultActionTakePhoto];
        }
        
        UIAlertAction *defaultActionFromPhotoGraf = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:defaultActionFromPhotoGraf];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIActionSheet *sheet;

        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"从相册选择", nil];
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        
        [sheet showInView:self.view];
    }
}

// 设置清除缓存信息
- (void)setupClearCacheLabel {
    // 获得缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    if (indexPath.section == 2) {
        // 关注vc
        if (indexPath.row ==0) {
            SMAttentionTableViewController *attentionVC = [[SMAttentionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            //        [self.navigationController pushViewController:collecionVC animated:YES];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:attentionVC];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        // 收藏vc
        if (indexPath.row ==1) {
            SMCollectionTableViewController *collecionVC = [[SMCollectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            //        [self.navigationController pushViewController:collecionVC animated:YES];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:collecionVC];
            nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:nav animated:YES completion:nil];
        }
        
    } else if (indexPath.section == 3) {
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 把选择的图片保存到本地
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.iconButton setImage:selectedImage forState:UIControlStateNormal];
    
    [UIImagePNGRepresentation(selectedImage) writeToFile:iconPath atomically:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = 0;
    switch (buttonIndex) {
        case 1:
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 2:
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        default:
            break;
    }
    // 跳转到相机或者相册
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}

@end
