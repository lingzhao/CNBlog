//
//  SMCollectionTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMCollectionTableViewController.h"
#import "SMCollectionTableViewCell.h"
#import "SMCoreDataTool.h"
#import "CNBlogCoreData.h"
#import "SMCollectionViewController.h"

@interface SMCollectionTableViewController ()

@property (nonatomic, strong) NSArray *coreDataArray;

@end

@implementation SMCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"收藏";
    self.tableView.estimatedRowHeight = 82;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 5;
    
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupData];
    self.navigationController.navigationBar.hidden = NO;
}

// 初始化navigationBar
- (void)setupNavigationBar {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    backItem.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 初始化数据
- (void)setupData {
    self.coreDataArray = [SMCoreDataTool sm_toolSearchDataWithEntity:@"CNBlogCoreData" andPredicate:nil];
    // 按加入先后倒序数组
    self.coreDataArray = [[self.coreDataArray reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.coreDataArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SMCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coreDataCell"];
    
    if (!cell) {
        cell = [[SMCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"coreDataCell"];
    }
    cell.coreDataModel = self.coreDataArray[indexPath.section];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section > 0) return nil;
    
    return @"我的收藏";
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 传递参数, 跳转页面
    SMCollectionViewController *collectionVC = [[SMCollectionViewController alloc] init];
    SMBlogModel *blogModel = self.coreDataArray[indexPath.section];
    collectionVC.blogModel = blogModel;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

#pragma mark - UITableView EditingDelegate 

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// 自定义编辑状态
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 删除指定数据
        CNBlogCoreData *coreData = self.coreDataArray[indexPath.row];
        [SMCoreDataTool sm_toolDeleteDataWithEntity:@"CNBlogCoreData" andPredicate:[NSString stringWithFormat:@"postID == '%@' AND uri == '%@'", coreData.postID, coreData.uri]];
        
        
    }];
    
    return @[deleteAction];
}*/

// 处理编辑操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CNBlogCoreData *coreData = self.coreDataArray[indexPath.section];
    [SMCoreDataTool sm_toolDeleteDataWithEntity:@"CNBlogCoreData" andPredicate:[NSString stringWithFormat:@"postID == '%@' AND uri == '%@'", coreData.postID, coreData.uri]];
    [self setupData];
}

// 全部cell编辑状态都为删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

@end
