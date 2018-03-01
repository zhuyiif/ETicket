//
//  DSWebViewController.m
//  ETicket
//
//  Created by chunjian wang on 2017/12/13.
//  Copyright © 2017年 chunjian wang. All rights reserved.
//

#import "DSWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define HIDE_NETWORKING \
[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
#define SHOW_NETWORKING \
[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

@interface DSWebViewController ()

@property (nonatomic, strong) NSString *loadDatas;
@property (nonatomic, assign) BOOL showRightButton;
@property (nonatomic, strong) NSString *webURL;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic) JSContext *context;

@end

@implementation DSWebViewController
- (id)initWithURL:(NSString *)url title:(NSString *)viewTitle {
    if ((self = [super init])) {
        self.navigationItem.title = viewTitle;
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
        if (htmlFile.length > 0) {
            self.webURL = htmlFile;
        } else {
            self.webURL = url;
        }
        self.webURL = [self.webURL trim];
    }
    return self;
}

- (id)initWithData:(NSString *)content title:(NSString *)viewTitle {
    if (self = [super init]) {
        self.navigationItem.title = viewTitle;
        self.loadDatas = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.frame = CGRectMake(0, 0, 0, 0);
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.allowsInlineMediaPlayback = NO;
    self.webView.mediaPlaybackRequiresUserAction = YES;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    if (self.showRightButton) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonPress:)];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    
    NSURLRequest *request = nil;
    NSString *url = [self.webURL lowercaseString];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    if (self.loadDatas) {
        NSData *data = [self.loadDatas dataUsingEncoding:NSUTF8StringEncoding];
        [self.webView loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8"
                       baseURL:[NSURL URLWithString:@"https://www.baidu.com"]];
        self.webView.scalesPageToFit = YES;
    } else {
        if ([url hasPrefix:@"www"]) {
            self.webURL = [@"http://" stringByAppendingString:self.webURL];
        }
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.webURL]];
        [self.webView loadRequest:request];
    }
}

- (void)confirmButtonPress:(UIButton *)button {
    [self popController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.webURL containsString:@"help"]) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [DSPopover showLoading:YES];
    [self injectJavaScript];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [DSPopover showLoading:NO];
    [self injectJavaScript];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [DSPopover showFailureWithContent:NSLocalizedString(@"加载失败", nil)];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)injectJavaScript {
    
    _context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        con.exception = exception;
    };
    @weakify(self);
    _context[@"host"] = @{};
    _context[@"host"][@"naviBack"] = ^{
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popController];
        });
    };
}

@end
