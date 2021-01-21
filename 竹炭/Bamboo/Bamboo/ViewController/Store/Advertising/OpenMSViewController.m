//
//  OpenMSViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/20.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OpenMSViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "PayShowView.h"
#import "PayManager.h"
#import "AdvertisingGoodsVC.h"
@interface OpenMSViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic, strong)WKWebView *webView;
@property (nonatomic,strong)PayShowView *payView;
@property (nonatomic,strong)PayManager *payManager;
@property (nonatomic,strong)NSString *priceStr;//支付金额
@property (nonatomic,strong)NSString *orderNum;
@property (nonatomic,assign)NSInteger payType;//支付方式

@end

@implementation OpenMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initWeb];
    self.pageTitle=@"竹商";
}

- (void)_initWeb {
    if (_webView == nil) {
        // js配置
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        //需要JS调用iOS 原生的方法，都要添加到这里
        [userContentController addScriptMessageHandler:self name:@"getGoodsId"];
        // WKWebView的配置
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        // 显示WKWebView
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) configuration:configuration];
        _webView.UIDelegate = self; // 设置WKUIDelegate代理
        _webView.navigationDelegate = self;
        NSString *url = @"http://www.taoyuan7.com:8081/share/openHorseBusiness";
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
     if ([message.name isEqualToString:@"getGoodsId"]) {
         NSLog(@"%@",message.body);
         if (!isEmpty(message.body)) {
            
         NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
         NSString *index = [NSString stringWithFormat:@"%@",dic[@"index"]];
         NSString *edition = [NSString stringWithFormat:@"%@",dic[@"edition"]];
         NSLog(@"%@-%@",index,edition);
        [self   postOrderPay:edition AndIndex:index];
             
        }
     }
}

-(void)postOrderPay:(NSString *)edition AndIndex:(NSString *)index{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"edition":edition,@"index":index};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"UserApi/createOpenHorseBusinessOrder" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.orderNum = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"orderSn"]];
            weak_self.priceStr = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"totalAmount"]];
            [weak_self showPlayView:[NSString stringWithFormat:@"赠送%@桃币",resultDic[@"params"][@"taobiBonus"]]];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

#pragma mark ---- 显示支付弹窗---
-(void)showPlayView:(NSString *)taobiBonus{
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^(void) {

    weak_self.payView=[[PayShowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)withGoodsPrice:[NSString stringWithFormat:@"￥%@",weak_self.priceStr] AndGoodsNum:weak_self.orderNum ];
    [weak_self.view.window addSubview:weak_self.payView];
    
    weak_self.payView.seletecdTypeBlock = ^(NSInteger type) {
        NSLog(@"%ld",type);
        
        if (type!=0) {
        weak_self.payType = type;
        [weak_self submitPayRequest];
        }
        weak_self.payView=nil;
        [weak_self.payView removeFromSuperview];

    };

    });
    
}
#pragma mark ---- 提交支付---
-(void)submitPayRequest{
    NSString *payType;
     if (self.payType==1) {//支付宝支付
         payType = @"PayApi/aliPayOrder";
     }else{
         payType = @"PayApi/commonPayOrder";
     }
     
      
     WEAK_SELF
        dispatch_async(dispatch_get_main_queue(), ^{
        [weak_self showHub];
        [AFNHttpRequestOPManager postBodyParameters:@{@"orderSn":weak_self.orderNum,@"payType":[NSString stringWithFormat:@"%ld",weak_self.payType],@"totalAmount":self.priceStr,@"productType":@"1"} subUrl:payType block:^(NSDictionary *resultDic, NSError *error) {
                [weak_self dissmiss];
                NSLog(@"resultDic:%@",resultDic);
                if ([resultDic[@"code"] integerValue]==200) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weak_self.payType==1) {//支付宝支付
                            [weak_self.payManager startAlipayWithPaySignature:resultDic[@"params"] responseBlock:^(PayResponseBaseModel *payResponseModel) {
                            
                                 [weak_self _dealPayResultWithResponseModel:payResponseModel];
                            
                            }];
                        }else{
                           //微信支付
                            WXPayRequestModel *wxPayRequestModel = [[WXPayRequestModel alloc] initWithDefaultDataDic:resultDic[@"params"][@"prepareMap"]];
                             [weak_self.payManager startWXinpayWithWxinPreparePayModel:wxPayRequestModel responseBlock:^(PayResponseBaseModel *payResponseModel) {
                                 [weak_self _dealPayResultWithResponseModel:payResponseModel];
                             }];
                        }
                    

                        
                    });
                    
                }else{
                    [weak_self showMessage:resultDic[@"desc"]];
                }
                
            }];
        });
     
}

#pragma mark - 支付成功回调
- (void)_dealPayResultWithResponseModel:(PayResponseBaseModel *)payResponseModel{
    WEAK_SELF
    if (payResponseModel.payResult == PayResult_Success) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [weak_self showSuccessInfoWithStatus:@"支付成功" disappearTimer:0.5];
            AdvertisingGoodsVC *vc = [[AdvertisingGoodsVC alloc]init];
            [weak_self navigatePushViewController:vc animate:YES];
 
        });
        NSLog(@"支付成功");
        
    }else if(payResponseModel.payResult == PayResult_Canceled){
        
        
        NSLog(@"支付取消");
        [weak_self showMessage:@"取消支付"];
        
    }else {
        [weak_self showMessage:@"支付失败"];
        NSLog(@"支付失败");
    }
    
}

- (PayManager *)payManager {
    if (!_payManager) {
        _payManager = [PayManager sharedInstance];
    }
    return _payManager;
}
@end
