//
//  SMNewsViewController.m
//  CNBlog
//
//  Created by zzZgHhui on 16/3/7.
//  Copyright © 2016年 zzZgHhui. All rights reserved.
//

#import "SMNewsViewController.h"
#import "SMXMLParserTool.h"
#import "SMNewsModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define kPadding 8

@interface SMNewsViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation SMNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupVC];
    
    [self setupWebView];
    
    [self loadHTML];
    
}

- (void)setupVC {
    // 设置背景颜色
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // 设置标题
    self.title = @"新闻资讯";
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
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.webView.delegate = self;
    self.webView.frame = self.view.frame;
    self.webView.allowsLinkPreview = YES;
    [self.view addSubview:self.webView];
//    self.webView.scrollView.showsVerticalScrollIndicator = NO;
}

// 发送请求解析html
- (void)loadHTML {
    NSString *urlString = [NSString stringWithFormat:@"http://wcf.open.cnblogs.com/news/item/%@", self.newsModel.postID];
    NSString *nodeName = @"NewsBody";
    
    __weak typeof(self) weakSelf = self;
    [SMXMLParserTool sm_toolWithURLString:urlString nodeName:nodeName completeHandler:^(NSArray *contentArray, NSError *error) {
        
        weakSelf.newsModel = [SMNewsModel modelWithDictionary:contentArray[0]];
        
        // 加入标题,时间和来源
        NSString *title = [NSString stringWithFormat:@"<h2>%@</h2>", weakSelf.newsModel.title];
        NSString *publish = [NSString stringWithFormat:@"<h7>%@   %@</h7><hr/>", weakSelf.newsModel.SubmitDate, weakSelf.newsModel.sourceName];
        NSString *htmlContent = [NSString stringWithFormat:@"%@%@%@", title, publish, weakSelf.newsModel.Content];
        [weakSelf.webView loadHTMLString:htmlContent baseURL:nil];
        
    }];
}

// 返回按钮点击事件
- (void)backClick {
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlString = [[request URL] absoluteString];
//    NSLog(@"%@", urlString);
    
    return YES;
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
                                       document.location = 'imageClick:'+this.src;}}}"];
    [webView stringByEvaluatingJavaScriptFromString:setImageOnclickString];
    [webView stringByEvaluatingJavaScriptFromString:@"setImageOnclick()"];
    
    // 加载完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
