//
//  SMAttentionTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/27.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMAttentionTableViewController.h"
#import "SMAttentionTableViewCell.h"
#import "SMNewsModel.h"
#import "SMCoreDataTool.h"
#import "SMAttentionViewController.h"
#import "CNNewsCoreData.h"

@interface SMAttentionTableViewController ()

@property(nonatomic, strong) NSArray *coreDataArray;

@end

@implementation SMAttentionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关注";
}

- (void)setupData {
    self.coreDataArray = [SMCoreDataTool sm_toolSearchDataWithEntity:@"CNNewsCoreData" andPredicate:nil];
    // 按加入先后倒序数组
    self.coreDataArray = [[self.coreDataArray reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coreDataCell"];
    
    if (!cell) {
        cell = [[SMAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"coreDataCell"];
    }
    cell.coreDataModel = self.coreDataArray[indexPath.section];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section > 0) return nil;
    
    return @"我的关注";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 传递参数, 跳转页面
    SMAttentionViewController *attentionVC = [[SMAttentionViewController alloc] init];
    SMNewsModel *newsModel = self.coreDataArray[indexPath.section];
    attentionVC.newsModel = newsModel;
    
    [self.navigationController pushViewController:attentionVC animated:YES];
}

// 处理编辑操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CNNewsCoreData *coreData = self.coreDataArray[indexPath.section];
    [SMCoreDataTool sm_toolDeleteDataWithEntity:@"CNNewsCoreData" andPredicate:[NSString stringWithFormat:@"postID == '%@'", coreData.postID]];
    [self setupData];
}

@end
