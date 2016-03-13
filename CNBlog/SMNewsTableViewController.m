//
//  SMNewsTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/2/29.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMNewsTableViewController.h"
#import "SMNewsViewController.h"
#import "SMNewsTableViewCell.h"
#import "SMNewsModel.h"
#import "SMXMLParserTool.h"
#import <MJRefresh/MJRefresh.h>

@interface SMNewsTableViewController ()

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, assign) NSInteger loadNum;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, strong) NSString *baseString;

@end

@implementation SMNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取消滚动控件自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // 取消分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 初始化数组
    self.newsArray = [NSMutableArray array];
    
    // 设置上下拉刷新
    [self setupHeaderAndFooter];
}

// 设置上下拉控件
- (void)setupHeaderAndFooter {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    
    [self.tableView.mj_header beginRefreshing];
}

// 下拉刷新
- (void)loadNew {
    // 接收的数据数目
    self.maxNum = 50;
    // 显示的数据数目
    self.loadNum = 10;
    
    [self loadXML];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
}

// 上拉更多
- (void)loadMore {
    
    self.loadNum += 10;

    if (self.loadNum > self.newsArray.count) {
        if (self.maxNum == self.newsArray.count) {
            self.maxNum += 50;
            [self loadXML];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.loadNum = self.newsArray.count;
        return;
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
}

- (NSString *)baseString {
    return @"http://wcf.open.cnblogs.com/news/recent/";
}

// 异步加载xml数据
- (void)loadXML {
    
    // URL地址
    NSString *urlString = [NSString stringWithFormat:@"%@%ld", self.baseString,self.maxNum];
    
    __weak typeof(self) weakSelf = self;
    [SMXMLParserTool sm_toolWithURLString:urlString nodeName:@"entry" completeHandler:^(NSArray *contentArray, NSError *error) {
        [weakSelf.newsArray removeAllObjects];

        for (NSDictionary *newsDict in contentArray) {
            SMNewsModel *newsModel = [SMNewsModel modelWithDictionary:newsDict];
            [weakSelf.newsArray addObject:newsModel];
        }
        
        // 防止读取数据越界
        weakSelf.loadNum = MIN(weakSelf.loadNum, contentArray.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loadNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SMNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"news"];
    
    if (!cell) {
        cell = [[SMNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"news"];
    }
    
    cell.newsModel = self.newsArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMNewsViewController *newsVC = [[SMNewsViewController alloc] init];
    newsVC.newsModel = self.newsArray[indexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
