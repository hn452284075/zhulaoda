//
//  DLHttpRequestManager.m
//  YilidiSeller
//
//  Created by yld on 16/3/23.
//  Copyright © 2016年 Dellidc. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"
#import "AFNHttpRequestOPManager+checkNetworkStatus.h"
#import "AFNHttpRequestOPManager+ExternParams.h"
#import "AFNHttpRequestOPManager+errorHandle.h"
//#import "AFNHttpRequestOPManager+setCookes.h"
#import "AFNHttpRequestOPManager+log.h"
#import "NSString+Add.h"
#import "LoginViewController.h"
#import "ZZBaseNavController.h"
#import "Util.h"
#import "AlertViewManager.h"
static AFNHttpRequestOPManager *_shareAFNHttpRequestOPManager = nil;


@implementation AFNHttpRequestOPManager

+ (instancetype)sharedManager{
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareAFNHttpRequestOPManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    
        _shareAFNHttpRequestOPManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/png",@"image/jpeg", nil];
 
        _shareAFNHttpRequestOPManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _shareAFNHttpRequestOPManager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
        _shareAFNHttpRequestOPManager.securityPolicy.validatesDomainName = NO;//是否验证域名
        // 设置超时时间
        [_shareAFNHttpRequestOPManager.requestSerializer setTimeoutInterval:60];
 
    });
    return _shareAFNHttpRequestOPManager;
}

#pragma mark -- post method
+ (void )postWithParameters:(NSDictionary *)Parameters
                     subUrl:(NSString *)suburl
                      block:(void (^)(NSDictionary *resultDic, NSError *error))block
{
    
//    [[self class] setSessionIdCookie];
    [[self class] checkNetWorkStatus];
//    [[self class] logWithRequestParam:Parameters requestUrl:suburl];
    
    // 请求头参数
    NSString *token=[NSString stringWithFormat:@"Token %@",[UserModel sharedInstance].token];
    NSString *accid = [UserModel sharedInstance].userId;
    
    NSString *timeStr;
    if (isEmpty([UserModel sharedInstance].userInfo)) {
        timeStr=[NSString getNow13Time];
    }else{
        timeStr=[UserModel sharedInstance].getTime;
    }
    NSString *secret=@"fuckyou#$*xkg12x4iuYxigq*gsSkems358";
    NSString *signature = [[self class] dealMd5:[NSString stringWithFormat:@"%@%@%@ios",[UserModel sharedInstance].token,secret,timeStr]];
    NSString *headerStr = [NSString stringWithFormat:@"%@,%@,%@,%@,ios",token,accid,timeStr,signature];
    NSLog(@"headerStr:%@",headerStr);
    
    [[[self class] sharedManager] POST:[NSString stringWithFormat:@"%@%@",BASEURL,suburl] parameters:Parameters headers:@{@"Authorization":headerStr} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSError *responseError = nil;
              [[self class] handError:&responseError withResponse:responseObject ofRequestUlr:suburl];

               NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

               [[self class] logWithResponseObject:responseObject htppResponse:response responseErrorInfo:responseError requestUrl:suburl requestParam:Parameters];
        
        NSDictionary *dic=(NSDictionary *)responseObject;
        if ([dic[@"code"] intValue]==403) {
        AlertViewManager *alertManager = [[AlertViewManager alloc]init];
        [alertManager showAlertViewWithControllerTitle:@"提示" message:@"授权认证过期,请重新登录" controllerStyle:UIAlertControllerStyleAlert isHaveTextField:NO actionTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertViewAction:^(UIAlertAction *action) {
             LoginViewController *loginVC = [[LoginViewController alloc] init];
             ZZBaseNavController *loginNav = [[ZZBaseNavController alloc] initWithRootViewController:loginVC];
             loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
             [[Util currentViewController] presentViewController:loginNav animated:YES completion:^{
                 
             }];
            
        }];
            
        }
               if (block && responseObject) {
                   block(responseObject,responseError);
               }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[self class] handError:&error withResponse:nil ofRequestUlr:suburl];
           NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
           NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
           error = [NSError errorWithDomain:@"请求服务器出错" code:-1 userInfo:errorUserInfo];
           [[self class] logWithResponseObject:nil htppResponse:response responseErrorInfo:error requestUrl:suburl requestParam:Parameters];
           if (block) {
               block(@{@"desc":@"数据加载失败"},error);
           }
    }];
    
}

+ (void )postBodyParameters:(id)Parameters
                     subUrl:(NSString *)suburl
                      block:(void (^)(NSDictionary *resultDic, NSError *error))block{
    
    [[self class] checkNetWorkStatus];
    NSString *token=[NSString stringWithFormat:@"Token %@",[UserModel sharedInstance].token];
    NSString *accid = [UserModel sharedInstance].userId;
    NSString *timeStr;
    if (isEmpty([UserModel sharedInstance].getTime)) {
        timeStr=[NSString getNow13Time];
    }else{
        timeStr=[UserModel sharedInstance].getTime;
    }
    
    NSString *secret=@"fuckyou#$*xkg12x4iuYxigq*gsSkems358";
    NSString *signature = [[self class] dealMd5:[NSString stringWithFormat:@"%@%@%@ios",[UserModel sharedInstance].token,secret,timeStr]];
    NSString *headerStr = [NSString stringWithFormat:@"%@,%@,%@,%@,ios",token,accid,timeStr,signature];
    NSLog(@"headerStr:%@",headerStr);
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Parameters options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",BASEURL,suburl] parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:headerStr forHTTPHeaderField:@"Authorization"];
//    [req setValue:accid forHTTPHeaderField:@"Accid"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session =  [NSURLSession sharedSession];
    [[session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
 
          //打印返回数据
          //json解析根字典
          NSDictionary* dicRoot = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
           NSError *responseError = nil;
            NSLog(@"dicRoot==%@",dicRoot);
            //授权失败重新登录
          if ([dicRoot[@"code"] intValue]==403) {
              dispatch_async(dispatch_get_main_queue(), ^{
                 
                  AlertViewManager *alertManager = [[AlertViewManager alloc]init];
                  [alertManager showAlertViewWithControllerTitle:@"提示" message:@"授权认证过期,请重新登录" controllerStyle:UIAlertControllerStyleAlert isHaveTextField:NO actionTitle:@"确定" actionStyle:UIAlertActionStyleDefault alertViewAction:^(UIAlertAction *action) {
                       LoginViewController *loginVC = [[LoginViewController alloc] init];
                       ZZBaseNavController *loginNav = [[ZZBaseNavController alloc] initWithRootViewController:loginVC];
                       loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                       [[Util currentViewController] presentViewController:loginNav animated:YES completion:^{
                           
                       }];
                      
                  }];
                  
              });
              
           }
            
            if (block && response) {
                if (isEmpty(dicRoot[@"params"])) {
                block(@{@"code":dicRoot[@"code"],@"desc":dicRoot[@"desc"],@"params":@""},responseError);
                }else{
                    block(dicRoot,responseError);
                }
            }
 
          } else {

              [[self class] handError:&error withResponse:nil ofRequestUlr:suburl];
              NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
              error = [NSError errorWithDomain:@"请求服务器出错" code:-1 userInfo:errorUserInfo];
              if (block) {
                  block(@{@"desc":@"数据加载失败"},error);
              }
        
              NSLog(@"Error: %@, %@, %@", error, response, response);

          }
    }]resume];
    
 

    
}


+ (NSString  *)dealMd5:(NSString *)entryParam {
    
   NSString *str=  [[self class]_MD5Encryption:entryParam];
    return str;
    
}

#pragma mark 取消网络请求
+ (void)cancelRequest{
    NSLog(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}


@end

