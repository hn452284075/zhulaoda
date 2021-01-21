//
//  CheckStatusViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CheckStatusViewController.h"
#import "ManageStoreViewController.h"
#import "OSApplyViewController.h"

@interface CheckStatusViewController ()

@property (nonatomic, strong) UIButton *goBtn;
@property (nonatomic, strong) UIImageView *statusView;
@property (nonatomic, strong) UILabel *lab;

@end

@implementation CheckStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"实名认证";
    
    self.statusView = [[UIImageView alloc] init];
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    self.statusView.image = IMAGE(@"ver_checkok");
    
    self.lab = [[UILabel alloc] init];
    [self.view addSubview:self.lab];
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusView.mas_bottom).offset(27);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(44);
    }];
    self.lab.text = @"实名认证成功";
    self.lab.font = CUSTOMFONT(22);
    self.lab.textColor = UIColorFromRGB(0x343434);
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.numberOfLines = 2;
    
    
    //开始认证
    self.goBtn = [[UIButton alloc] init];
    [self.view addSubview:self.goBtn];
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.goBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"返回"
            fontsize:18
              corner:22
                 tag:2];
    
    [self requstDetectInfo];
    
}

- (void)showDetectResult:(int)result
{
    if(result == 1) //成功
    {
        [self showHub];
        
        self.statusView.image = IMAGE(@"ver_checkok");
        self.lab.text = @"实名认证成功";
        [self.goBtn setTitle:@"返回" forState:UIControlStateNormal];
        
        
        [[UserModel sharedInstance].userInfo setValue:@"1" forKey:@"verifyStatus"];
        [[UserModel sharedInstance].userInfo setValue:self.detect_name forKey:@"truename"];
        [[UserModel sharedInstance] saveUserInfo:[UserModel sharedInstance].userInfo];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dissmiss];
            for(UIViewController*temp in self.navigationController.viewControllers) {
                if([temp isKindOfClass:[ManageStoreViewController class]])
                {
                    [self.navigationController popToViewController:temp animated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IDCardVertifyOK" object:nil];
                    break;
                }
                if ([temp isKindOfClass:[OSApplyViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    
                    break;
                }
               
            }
 
        });
        
    }
    else        //取消
    {
        [[UserModel sharedInstance].userInfo setValue:@"0" forKey:@"verifyStatus"];
        [[UserModel sharedInstance].userInfo setValue:@"" forKey:@"truename"];
        [[UserModel sharedInstance] saveUserInfo:[UserModel sharedInstance].userInfo];
        
        self.statusView.image = IMAGE(@"ver_checkfailed");
        self.lab.text = @"实名认证失败";
        [self.goBtn setTitle:@"再次验证" forState:UIControlStateNormal];
    }
    self.checkResult = result;
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
#pragma mark ------------ 开始认证
- (void)btnClicked:(id)sender
{
    if (_isStorePush) {
    [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self goBack];
    }
    
//    [self.delegate checkStatusFinish:self.checkResult];
}


#pragma mark ------------------------Delegate-----------------------------
- (void)requstDetectInfo
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        
        @"cardNo":self.detect_card,
        @"name"  :self.detect_name,
//        @"token" :self.detect_token
        
    } subUrl:@"UserApi/faceCore" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            [weak_self showDetectResult:1];
            
        }else{
            [weak_self showDetectResult:0];
        }
    }];
}

@end
