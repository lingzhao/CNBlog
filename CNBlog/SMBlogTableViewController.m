//
//  SMBlogTableViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/2/29.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBlogTableViewController.h"
#import "SMBlogTableViewCell.h"
#import "SMBlogModel.h"
#import "SMXMLParserTool.h"
#import "SMCoreDataTool.h"
#import "CNBlogCoreData+CoreDataProperties.h"
#import "SMBlogViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define kLOADNUM 10

@interface SMBlogTableViewController ()

@property (nonatomic, strong) NSMutableArray *blogArray;
@property (nonatomic, assign) NSInteger loadNum;
@property (nonatomic, strong) NSString *baseString;

@end

@implementation SMBlogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 取消滚动控件自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(108, 0, 0, 0);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.blogArray = [NSMutableArray array];
    
    // 提示加载中
//    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];

    [self setupHeaderFooter];
    
}

// 设置上拉刷新, 下拉刷新
- (void)setupHeaderFooter {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNews)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
}

- (void)loadNews {

    self.loadNum = kLOADNUM;
    
    [self loadXML];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
}

- (void)loadMore {
    self.loadNum += kLOADNUM;
    
    if (self.loadNum > self.blogArray.count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.loadNum = self.blogArray.count;
        return;
    }

    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
}

- (NSString *)baseString {
    return @"http://wcf.open.cnblogs.com/blog/sitehome/recent/";
}

// 异步请求xml
- (void)loadXML {
    // 异步请求服务器的xml文件
    NSString *urlString = [NSString stringWithFormat:@"%@%i", self.baseString, 100];
    NSString *nodeName = @"entry";
    
    __weak typeof(self) weakSelf = self;
    // 发送请求返回数据
    [SMXMLParserTool sm_toolWithURLString:urlString nodeName:nodeName completeHandler:^(NSArray *contentArray, NSError *error) {
        
        if (!error) {
            [weakSelf.blogArray removeAllObjects];
            
            for (NSDictionary *dictionary in contentArray) {
                SMBlogModel *blogModel = [SMBlogModel modelWithDictionary:dictionary];
                
                [weakSelf.blogArray addObject:blogModel];
            }
            
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//            });
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loadNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SMBlogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blog"];
    
    if (!cell) {
        cell = [[SMBlogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"blog"];
    }
        
    cell.blogModel = self.blogArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 传递参数, 跳转页面
    SMBlogViewController *blogVC = [[SMBlogViewController alloc] init];
    SMBlogModel *blogModel = self.blogArray[indexPath.row];
    blogVC.blogModel = blogModel;
    
    [self.navigationController pushViewController:blogVC animated:YES];
}

#pragma mark - TableView Editing

// 默认全部cell都可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 处理编辑情况
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 自定义编辑操作
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 收藏操作
    UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        // 异步实现保存操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SMBlogModel *blogModel = self.blogArray[indexPath.row];
//            [NSKeyedArchiver archiveRootObject:blogModel toFile:collectionFilePath];
            // 方法1
            /*
            // 存入coredata
            NSArray *attributeNames = @[@"postID", @"title", @"summary", @"published", @"name", @"uri", @"avatar"];
            NSArray *attributeValues = @[blogModel.postID, blogModel.title, blogModel.summary, blogModel.published, blogModel.name, blogModel.uri, blogModel.avatar];
            
            [SMCoreDataTool sm_toolAddDataWithEntity:@"CNBlogCoreData" attributeNames:attributeNames attributeValues:attributeValues];*/
            
            // 方法2
            // 加入前判断数据是否存在
            NSArray *resultArr = [SMCoreDataTool sm_toolSearchDataWithEntity:@"CNBlogCoreData" andPredicate:[NSString stringWithFormat:@"uri LIKE '%@' AND postID LIKE '%@'", blogModel.uri, blogModel.postID]];
            
            if (resultArr.count > 0) return;
            
            // 把published属性值改为updated属性值
            NSString *published = blogModel.published;
            blogModel.published = blogModel.updated;
            [SMCoreDataTool sm_toolAddDataWithEntity:@"CNBlogCoreData" attributeModel:blogModel];
            blogModel.published = published;
        });
        
        // 提示操作成功
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    collectRowAction.backgroundColor = [UIColor darkGrayColor];
    
    // 查看评论操作
    UITableViewRowAction *commonRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"评论" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        SMBlogModel *blogModel = [NSKeyedUnarchiver unarchiveObjectWithFile:collectionFilePath];
//        NSLog(@"%@ - %@", blogModel.name, blogModel.postID);
        
        // 读取coredata数据
        NSArray *arr = [SMCoreDataTool sm_toolSearchDataWithEntity:@"CNBlogCoreData" andPredicate:nil];
        for (CNBlogCoreData *obj in arr) {
            NSLog(@"%@ -%@", obj.name, obj.uri);
        }
        
    }];
    commonRowAction.backgroundColor = [UIColor orangeColor];
    
    return @[commonRowAction, collectRowAction];
}


@end
