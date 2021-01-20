//
//  StoreGradeController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/23.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "StoreGradeController.h"
#import <WebKit/WebKit.h>

@interface StoreGradeController ()

@end

@implementation StoreGradeController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = self.titlename; //@"等级规则";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

    config.selectionGranularity = WKSelectionGranularityDynamic;

    config.allowsInlineMediaPlayback = YES;

    WKPreferences *preferences = [WKPreferences new];

    //是否支持JavaScript

    preferences.javaScriptEnabled = YES;

    //不通过用户交互，是否可以打开窗口

    preferences.javaScriptCanOpenWindowsAutomatically = YES;

    config.preferences = preferences;

    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth - 64) configuration:config];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.bottom.mas_equalTo(self.view);
    }];
    
    /* 加载服务器url的方法*/

    NSString *url = self.urlstring; //@"http://www.taoyuan7.com/thmh5/3.html";

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    [webview loadRequest:request];

    webview.navigationDelegate = self;

    webview.UIDelegate = self;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
