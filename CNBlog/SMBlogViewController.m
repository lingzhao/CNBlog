//
//  SMBlogViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/5.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMBlogViewController.h"
#import "SMXMLParserTool.h"
#import "SMBlogModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SMBlogLinkViewController.h"
#import "NSString+SMDateStringFormatter.h"

#define kPadding 4

@interface SMBlogViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SMBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置控制器
    [self setupVC];
    // 设置webView
    [self setupWebView];
    // 发送请求解析html
    [self loadHTML];
}

// push后隐藏tabBar
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)setupVC {
    // 设置背景颜色
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 设置标题
    self.title = @"热门博客";
    // 设置返回按钮样式
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]} forState:UIControlStateNormal];
    // 手势返回
    [self.navigationController.interactivePopGestureRecognizer setValue:self forKey:@"delegate"];
    // 提示加载中
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeBlack];
}

// 设置webView
- (void)setupWebView {
    self.webView = [[UIWebView alloc] init];
//    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
//    [self.webView sizeToFit];
//    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.webView.frame = CGRectMake(kPadding, kPadding, kScreenW - 2*kPadding, kScreenH - kPadding);
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
    // 去除多余滚动空间
    for (id v in self.webView.subviews) {
        if ([v isKindOfClass:[UIScrollView class]]) {
            [v setBounces:NO];
        }
    }
    
    [self.view addSubview:self.webView];
//    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

// 发送请求解析html
- (void)loadHTML {
    NSString *urlString = [NSString stringWithFormat:@"http://wcf.open.cnblogs.com/blog/post/body/%@", self.blogModel.postID];
    NSString *nodeName = @"string";

    __weak typeof(self) weakSelf = self;
    [SMXMLParserTool sm_toolWithURLString:urlString nodeName:nodeName completeHandler:^(NSArray *contentArray, NSError *error) {
        // 如果解析页面有错误
        if (error) {
            // 加载完成
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            self.webView.hidden = YES;
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"页面加载有错误, 跳转到博文首页" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"跳转" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self jumpClick];
            }];
            UIAlertAction* cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self backClick];
            }];
            
            [alert addAction:cancleAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            return;
        }
        
        NSString *htmlContent = [contentArray firstObject][@"string"];
//        NSLog(@"%@", htmlContent);
        // 加入标题,时间和来源
        NSString *title = [NSString stringWithFormat:@"<h3>%@</h3>", weakSelf.blogModel.title];
        NSString *publish = [NSString stringWithFormat:@"<h7>%@ <a href='%@'>%@</a></h7>", [weakSelf.blogModel.published sm_stringFromUTCString], weakSelf.blogModel.uri, weakSelf.blogModel.name];
        htmlContent = [NSString stringWithFormat:@"%@%@%@", title, publish, htmlContent];
        
        [weakSelf.webView loadHTMLString:htmlContent baseURL:nil];
        
        
    }];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpClick {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.blogModel.uri]]];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr=request.URL.absoluteString;
    
//    NSLog(@"url: %@",urlStr);
    
    //为空，第一次加载本页面
    if ([urlStr isEqualToString:@"about:blank"]) {
        return YES;
    }
    //设置点击后的视图控制器
    SMBlogLinkViewController *linkVC = [[SMBlogLinkViewController alloc] initWithURL:[NSURL URLWithString:urlStr] entersReaderIfAvailable:YES];

    //跳转到点击后的控制器并加载webview
    [self presentViewController:linkVC animated:YES completion:nil];
    
    return  NO;
}

// 页面图片大小适应
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 设置图片的宽高适应屏幕
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                     @"var script = document.createElement('script');"
                                                     "script.type = 'text/javascript';"
                                                     "script.text = \"function ResizeImages() { "
                                                     "var myImg,oldWidth,oldHeight;"
                                                     "var maxWidth=%f;"// 图片宽度
                                                     "for(i=0;i <document.images.length;i++){"
                                                     "myImg = document.images[i];"
                                                     "oldWidth = myImg.width;oldHeight = myImg.height;"
                                                     "var scale = oldWidth/oldHeight;"
                                                     "if(myImg.width > maxWidth){"
                                                     "myImg.width = maxWidth;myImg.height = maxWidth/scale;"
                                                     "}"
                                                     "}"
                                                     "}\";"
                                                     "document.getElementsByTagName('head')[0].appendChild(script);", kScreenW-20]];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    // 添加图片的onclick方法
    NSString *setImageOnclickString = [NSString stringWithFormat:
                                       @"function setImageOnclick() {\
                                       var imgs = document.getElementsByTagName('img');\
                                       for(var i=0; i<imgs.length; i++) {\
                                       imgs[i].onclick = function(){\
                                       document.location = this.src;}}}"];
    [webView stringByEvaluatingJavaScriptFromString:setImageOnclickString];
    [webView stringByEvaluatingJavaScriptFromString:@"setImageOnclick()"];

    // 加载完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
