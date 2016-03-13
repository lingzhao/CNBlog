//
//  SMBLogMoreTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/13.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBLogMoreTableViewController.h"
#import "SMMoreBlogModel.h"
#import "SMMoreBlogTableViewCell.h"
#import "SMXMLParserTool.h"
#import "SMBlogLinkViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface SMBLogMoreTableViewController ()

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger loadNum;
@property (nonatomic, strong) NSMutableArray *blogArray;

@end

@implementation SMBLogMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 取消滚动控件自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0);
    
    // 取消分割线
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.blogArray = [NSMutableArray array];
    
    // 创建上下拉控件
    [self setupHeaderFooter];
}

// 异步请求XML
- (void)loadXML {
    // 异步请求服务器的xml文件
    NSString *urlString = [NSString stringWithFormat:@"http://wcf.open.cnblogs.com/blog/bloggers/recommend/%ld/%ld", self.pageIndex, self.pageSize];
    NSString *nodeName = @"entry";
    
    __weak typeof(self) weakSelf = self;
    // 发送请求返回数据
    [SMXMLParserTool sm_toolWithURLString:urlString nodeName:nodeName completeHandler:^(NSArray *contentArray, NSError *error) {
        
        if (!error) {
            [weakSelf.blogArray removeAllObjects];
            
            self.pageSize = contentArray.count;
            for (NSDictionary *dictionary in contentArray) {
                SMMoreBlogModel *blogModel = [SMMoreBlogModel modelWithDictionary:dictionary];
                
                [weakSelf.blogArray addObject:blogModel];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    }];
}

// 设置上拉刷新, 下拉刷新
- (void)setupHeaderFooter {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNews)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)loadNews {
    self.pageSize = 100;
    self.pageIndex = 1;
    self.loadNum = 10;
    
    [self loadXML];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
}

- (void)loadMore {
    self.loadNum += 10;
    
    if (self.loadNum > self.pageIndex * self.pageSize) {
        if (self.pageSize != 100) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        self.pageIndex ++;
        [self loadXML];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loadNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMoreBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"more"];
    if (!cell) {
        cell = [[SMMoreBlogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"more"];
    }
    cell.blogModel = self.blogArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SMMoreBlogModel *blogModel = self.blogArray[indexPath.row];
    SMBlogLinkViewController *linkVC = [[SMBlogLinkViewController alloc] initWithURL:[NSURL URLWithString:blogModel.postID] entersReaderIfAvailable:YES];
    [self presentViewController:linkVC animated:YES completion:nil];
}

@end
