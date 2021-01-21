//
//  AppDelegate.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"
#import "PayManager.h"
#import "ZYNetworkAccessibility.h"
#import <Bugly/Bugly.h>
#import <MOBFoundation/MobSDK+Privacy.h>
#import <MobPush/MobPush.h>
@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic, strong) OSSClient *client;
@end

/**
 * 获取sts信息的url,配置在业务方自己的搭建的服务器上。详情可见https://help.aliyun.com/document_detail/31920.html
 */
#define OSS_STS_URL                 @"oss_sts_url"


/**
 * bucket所在的region的endpoint,详情可见https://help.aliyun.com/document_detail/31837.html
 */
#define OSS_ENDPOINT                @"your bucket's endpoint"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //Bugly 记录闪退
    [Bugly startWithAppId:@"f473b5dc1f"];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.enableAutoToolbar = NO;
    
    
    [ZYNetworkAccessibility setAlertEnable:YES];
    
    [ZYNetworkAccessibility setStateDidUpdateNotifier:^(ZYNetworkAccessibleState state) {
        NSLog(@"setStateDidUpdateNotifier > %zd", state);
    }];
    
    [ZYNetworkAccessibility start];
    
    
    [self _configurationWXin];
    
    [self _entrance];
    // 启动图片延时:2秒
    [NSThread sleepForTimeInterval:1.5];
    
    //推送
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:^(BOOL success) {
    switch (success) {
        case 0:
             NSLog(@"提交失败");
            break;
        case 1:
            NSLog(@"提交成功");
            break;
        default:
            break;
    }
    }];
    
    
    #ifdef DEBUG
        [MobPush setAPNsForProduction:NO];
    #else
        [MobPush setAPNsForProduction:YES];
    #endif
    
    
    //MobPush推送设置（获得角标、声音、弹框提醒权限）
       MPushNotificationConfiguration *configuration = [[MPushNotificationConfiguration alloc] init];
       configuration.types = MPushAuthorizationOptionsBadge | MPushAuthorizationOptionsSound | MPushAuthorizationOptionsAlert;
       [MobPush setupNotification:configuration];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessage:) name:MobPushDidReceiveMessageNotification object:nil];
     [MobPush clearBadge];
     [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}
 
// 收到通知回调
- (void)didReceiveMessage:(NSNotification *)notification
{
    MPushMessage *message = notification.object;

         // 推送相关参数获取示例请在各场景回调中对参数进行处理
         //     NSString *body = message.notification.body;
     //     NSString *title = message.notification.title;
     //     NSString *subtitle = message.notification.subTitle;
     //     NSInteger badge = message.notification.badge;
     //     NSString *sound = message.notification.sound;
     //     NSLog(@"收到通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge:%ld,\nsound:%@,\n}",body, title, subtitle, (long)badge, sound);
    switch (message.messageType)
    {
        case MPushMessageTypeCustom:
        {// 自定义消息回调
        }
            break;
        case MPushMessageTypeAPNs:
        {// APNs回调
        }
            break;
        case MPushMessageTypeLocal:
        {// 本地通知回调

        }
            break;
        case MPushMessageTypeClicked:
        {// 点击通知回调

        }
        default:
            break;
    }
}


- (void)_entrance {

    
    self.mainVC = [[MainTabBarController alloc]init];
    self.window.rootViewController=self.mainVC;
    [self.window makeKeyAndVisible];
}
 

//: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    //网页调起app外面链接url type
      NSString *string =url.absoluteString;
      NSLog(@"string：：%@",string);
      
      [self handleAliCallBackUrl:url];
      
      return [WXApi handleOpenURL:url delegate:self];
}



- (void)handleAliCallBackUrl:(NSURL *)url {
    //跳转支付宝钱包进行支付，处理支付结果
    NSLog(@"平台 url %@",url.absoluteString);
     if ([url.host isEqualToString:@"safepay"]) {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"ali pay result = %@",resultDic);
        AliPayResponseModel *responseModel = [[AliPayResponseModel alloc] initWithDefaultDataDic:resultDic];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationAliPayResult object:responseModel];
    }];
    }
  
    
}

- (void)_configurationWXin {
    
    //在register之前打开log, 后续可以根据log排查问题
//    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
//        NSLog(@"WeChatSDK: %@", log);
//    }];


    [WXApi registerApp:WxAppid universalLink:@"https://www.taoyuan7.com/"];
        NSLog(@"%d",[WXApi registerApp:WxAppid universalLink:@"https://www.taoyuan7.com/"]);
    
    //调用自检函数
//       [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//           NSLog(@"%@, %u, %@, 问题:%@", @(step), result.success, result.errorInfo, result.suggestion);
//       }];
}

#pragma mark - BaseResp
// 微信终端SDK所有响应类的基类
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

-(void)onResp:(BaseResp *)resp{
    
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *wxResp = (PayResp *)resp;
        WXinPayResponseModel *wxResponseModel = [[WXinPayResponseModel alloc] init];
        wxResponseModel.weixinResp = wxResp;
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationWXPayResult object:wxResponseModel];
    }
    
        
        if ([resp isKindOfClass:[PayResp class]]) {
            PayResp *wxResp = (PayResp *)resp;
            WXinPayResponseModel *wxResponseModel = [[WXinPayResponseModel alloc] init];
            wxResponseModel.weixinResp = wxResp;
            [kNotification postNotificationName:KNotificationWXPayResult object:wxResponseModel];
        }
        if ([resp isKindOfClass:[SendMessageToWXResp class]]){
            
            if(resp.errCode == WXSuccess) {
//                [[BaseLoadingView sharedManager]showSuccessInfoWithStatus:@"分享成功"];

            }else{
                
                [[BaseLoadingView sharedManager]showMessage:@"取消分享"];
            }
            
        }
        
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *aresp = (SendAuthResp *)resp;
            if (aresp.errCode == 0) { // 用户同意
                NSLog(@"errCode = %d", aresp.errCode);
                NSLog(@"code = %@", aresp.code);
                
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WxAppid, APP_SECRET, aresp.code];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                           
                            
                            NSLog(@"dic = %@", dic);
                            [self getUserInfo:[dic objectForKey:@"access_token"] Andopenid:[dic objectForKey:@"openid"]]; // 获取用户信息
                        }
                    });
                });

            } else if (aresp.errCode == -2) {
                NSLog(@"用户取消");
            } else if (aresp.errCode == -4) {
                NSLog(@"用户拒绝");
            } else {
                NSLog(@"errCode = %d", aresp.errCode);
                NSLog(@"code = %@", aresp.code);
            }
            
        }
}


// 获取用户信息
- (void)getUserInfo:(NSString*)access_token Andopenid:(NSString *)openid {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", access_token, openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"openid = %@", [dic objectForKey:@"openid"]);
                NSLog(@"nickname = %@", [dic objectForKey:@"nickname"]);
                NSLog(@"sex = %@", [dic objectForKey:@"sex"]);
                NSLog(@"country = %@", [dic objectForKey:@"country"]);
                NSLog(@"province = %@", [dic objectForKey:@"province"]);
                NSLog(@"city = %@", [dic objectForKey:@"city"]);
                NSLog(@"headimgurl = %@", [dic objectForKey:@"headimgurl"]);
                NSLog(@"unionid = %@", [dic objectForKey:@"unionid"]);
                NSLog(@"privilege = %@", [dic objectForKey:@"privilege"]);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"wechatLogin" object:dic];
            }
        });
    });
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    if (self.enterBackgroundHandler) {
       self.enterBackgroundHandler();
    }
}

@end
