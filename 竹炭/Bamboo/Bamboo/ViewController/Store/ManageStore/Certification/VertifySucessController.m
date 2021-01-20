//
//  VertifySucessController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "VertifySucessController.h"

@interface VertifySucessController ()

@end

@implementation VertifySucessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.infoBackView.backgroundColor = [UIColor whiteColor];
    self.infoBackView.layer.cornerRadius = 5.0;
    
    self.nameLab.textColor = UIColorFromRGB(0x9a9a9a);
    self.cardLab.textColor = UIColorFromRGB(0x9a9a9a);
    
    
    [self getUserInfo];
}

#pragma mark ------------------------Api----------------------------------
-(void)getUserInfo{
    WEAK_SELF
   [self showHub];
   [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/userDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
       NSLog(@"resultDic:%@",resultDic);
       [weak_self dissmiss];
       if ([resultDic[@"code"] integerValue]==200) {
                      
           weak_self.nameValueLab.text = resultDic[@"params"][@"truename"];
           weak_self.cardValueLab.text = resultDic[@"params"][@"idCardNumber"];
           
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"realNameVerifyState"] forKey:@"verifyStatus"];
           
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"truename"] forKey:@"truename"];
           
           [[UserModel sharedInstance] saveUserInfo:[UserModel sharedInstance].userInfo];
           
        }else{
           [weak_self showMessage:resultDic[@"desc"]];
       }
   }];
}





@end
