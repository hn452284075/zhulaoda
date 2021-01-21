//
//  OSMainViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OSMainViewController.h"
#import "OSApplyViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface OSMainViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIButton      *goBtn;
@property (nonatomic, strong)WKWebView *webView;
@end

@implementation OSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageTitle = @"开通竹商宝";
    
    [self _initWeb];
}

- (void)_initWeb {
    if (_webView == nil) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        //需要JS调用iOS 原生的方法，都要添加到这里
        [userContentController addScriptMessageHandler:self name:@"openStore"];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        // 显示WKWebView
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) configuration:configuration];
        _webView.UIDelegate = self; // 设置WKUIDelegate代理
        _webView.navigationDelegate = self;
        NSString *url = @"http://www.taoyuan7.com:8081/share/openStore";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
    }
}

#pragma mark - WKScriptMessageHandler
//实现js注入方法的协议方法--oc调js
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    //找到对应js端的方法名,获取messge.body
     if ([message.name isEqualToString:@"openStore"]) {
         NSLog(@"%@",message.body);
         [self openShop];
     }
}

 
#pragma mark ------------------------Private------------------------------
- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}


#pragma mark ------------------------View Event---------------------------

#pragma mark --------------- 开始认证
- (void)btnClicked:(id)sender
{
//    OSApplyViewController *vc = [[OSApplyViewController alloc] init];
//    [self navigatePushViewController:vc animate:YES];
    
    
    [self openShop];
    
}



#pragma mark ------------------------Api----------------------------------
-(void)openShop{    
    OSApplyViewController *vc = [[OSApplyViewController alloc] init];
    vc.smodel = self.smodel;
    [self navigatePushViewController:vc animate:YES];
}




@end
