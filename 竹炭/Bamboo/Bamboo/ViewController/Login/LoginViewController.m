//
//  LoginViewController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "LoginViewController.h"
#import "SelectIdentifyView.h"
#import "IdentifyCodeView.h"
#import "Util.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "JKCountDownButton.h"
#import "StoreGradeController.h"
#import "WXApi.h"
@interface LoginViewController ()<SelectIdentifyDelegate,CodeViewDelegate,WXApiDelegate>
{
    JKCountDownButton *getCodeBtn;
    NSDictionary *dic;
}
@property (nonatomic, strong) UITextField *phoneFiled;
@property (nonatomic, strong) UITextField *codeFiled;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic,strong)  NSString *phone;
@property (nonatomic,strong)  NSString *code;
@property (nonatomic, strong) SelectIdentifyView *identifyView;
@property (nonatomic, strong) IdentifyCodeView   *codeView;      //填写验证码弹出view
@property (nonatomic, strong) IdentifyCodeView   *contactView;   //填写联系手机弹出view

@end

@implementation LoginViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
     
    [self.navigationController setNavigationBarHidden:YES animated:animated];
 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wechatInfo:) name:@"wechatLogin" object:nil];
    
    
    int iphonex_height = 0;
    if(IS_Iphonex_Series)
        iphonex_height = 20;
  
    //返回按钮
    UIButton *closeBtn = [[UIButton alloc] init];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(17+iphonex_height);
        make.left.equalTo(self.view.mas_left).offset(17);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    [closeBtn setBackgroundImage:IMAGE(@"login_close") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backFrontController:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间logo
    UIImageView *logoImg = [[UIImageView alloc] init];
    [self.view addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(69+iphonex_height);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_equalTo(93);
        make.height.mas_equalTo(93);
    }];
    logoImg.image = IMAGE(@"login_logo");
    
    //输入手机号
    UIView *phonebackview = [[UIView alloc] init];
    [self.view addSubview:phonebackview];
    [phonebackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImg.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.height.mas_equalTo(45);
    }];
    phonebackview.backgroundColor = [UIColor whiteColor];
    phonebackview.layer.borderColor = kGetColor(0xeb, 0xeb, 0xeb).CGColor;
    phonebackview.layer.borderWidth = 1.;
    phonebackview.layer.cornerRadius = 22.;
    
    //---手机小图标
    UIImageView *phoneiconImg = [[UIImageView alloc] init];
    [self.view addSubview:phoneiconImg];
    [phoneiconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phonebackview.mas_left).offset(12);
        make.centerY.equalTo(phonebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    phoneiconImg.image = IMAGE(@"login_phoneicon");
    
    //---清除手机号码按钮，默认隐藏，有文字输入后显示
    self.clearBtn = [[UIButton alloc] init];
    [self.view addSubview:self.clearBtn];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phonebackview.mas_right).offset(-12);
        make.centerY.equalTo(phonebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    self.clearBtn.hidden = YES;
    [self.clearBtn setBackgroundImage:IMAGE(@"close-lv") forState:UIControlStateNormal];
    [self.clearBtn addTarget:self action:@selector(clearPhoneFiled:) forControlEvents:UIControlEventTouchUpInside];
    
    //---手机输入框
    self.phoneFiled = [[UITextField alloc] init];
    [self.view addSubview:self.phoneFiled];
    [self.phoneFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneiconImg.mas_right).offset(14);
        make.centerY.equalTo(phonebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    self.phoneFiled.textColor = UIColorFromRGB(0x222222);
    self.phoneFiled.font = CUSTOMFONT(14);
    self.phoneFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneFiled.placeholder = @"请输入手机号";
    [self.phoneFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    
    
    //输入验证码
    UIView *codebackview = [[UIView alloc] init];
    [self.view addSubview:codebackview];
    [codebackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phonebackview.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).offset(35);
        make.right.equalTo(self.view.mas_right).offset(-35);
        make.height.mas_equalTo(45);
    }];
    codebackview.backgroundColor = [UIColor whiteColor];
    codebackview.layer.borderColor = kGetColor(0xeb, 0xeb, 0xeb).CGColor;
    codebackview.layer.borderWidth = 1.;
    codebackview.layer.cornerRadius = 22.;
    
    //---验证码小图标
    UIImageView *codeiconImg = [[UIImageView alloc] init];
    [self.view addSubview:codeiconImg];
    [codeiconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codebackview.mas_left).offset(12);
        make.centerY.equalTo(codebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    codeiconImg.image = IMAGE(@"login_codeicon");
    
    //---验证码输入框
    self.codeFiled = [[UITextField alloc] init];
    [self.view addSubview:self.codeFiled];
    [self.codeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeiconImg.mas_right).offset(14);
        make.centerY.equalTo(codebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    
    self.codeFiled.textColor = UIColorFromRGB(0x222222);
    self.codeFiled.font = CUSTOMFONT(14);
    self.codeFiled.keyboardType = UIKeyboardTypeNumberPad;
    self.codeFiled.placeholder = @"请输入验证码";
    [self.codeFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //-------获取验证码按钮
     getCodeBtn = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:getCodeBtn];
    [getCodeBtn addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(codebackview.mas_right).offset(-14);
        make.centerY.equalTo(codebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(26);
    }];
    [self factory_btn:getCodeBtn
            backColor:[UIColor whiteColor]
            textColor:KCOLOR_Main
          borderColor:KCOLOR_Main
                title:@"获取验证码"
             fontsize:14
               corner:13
                  tag:1];
    
    
    self.codeFiled.text = @"";
    
    
    //登录按钮
    self.loginBtn = [[UIButton alloc] init];
    self.loginBtn.alpha = 0.5;
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codebackview.mas_bottom).offset(35);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.loginBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"登录"
            fontsize:18
              corner:22
                 tag:2];
    
    //其它方式登录
    UILabel *lab = [[UILabel alloc] init];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(115);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(15);
    }];
    lab.textColor = kGetColor(0xbb, 0xbb, 0xbb);
    lab.font = CUSTOMFONT(12);
    lab.text = @"———— 其它方式登录 ————";
    lab.hidden = YES;
    
    //微信图标
    UIButton *wechatlogoBtn = [[UIButton alloc] init];
    [self.view addSubview:wechatlogoBtn];
    [wechatlogoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    [wechatlogoBtn setBackgroundImage:IMAGE(@"login_wechatlogo") forState:UIControlStateNormal];
    [wechatlogoBtn addTarget:self action:@selector(wechatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    wechatlogoBtn.tag = 10;
    wechatlogoBtn.hidden = YES;
    if ([WXApi isWXAppInstalled]) {
    wechatlogoBtn.hidden = NO;
    }
    
    
    //隐私协议
    UIButton *privateBtn = [[UIButton alloc] init];
    [self.view addSubview:privateBtn];
    [privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wechatlogoBtn.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(300);
    }];
    
    NSString * aStr = @"登录即代表您已同意《用户协议/隐私政策》";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",aStr]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,aStr.length)];
    [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,9)];
    [str addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(9,aStr.length-9)];
    [privateBtn setAttributedTitle:str forState:UIControlStateNormal];
    [privateBtn addTarget:self action:@selector(privateBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
    
    //联系客服
    UIButton *connectBtn = [[UIButton alloc] init];
    [self.view addSubview:connectBtn];
    [connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(privateBtn.mas_bottom).offset(9);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(150);
    }];
    
    NSString * connectStr = @"如有问题点击联系客服";
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",connectStr]];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,connectStr.length)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,6)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(6,connectStr.length-6)];
    [connectBtn setAttributedTitle:tempstr forState:UIControlStateNormal];
    [connectBtn addTarget:self action:@selector(connectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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


- (void)_initSelectIdentifyView:(NSArray *)arr
{
    
    UIView *bv = [[UIView alloc] initWithFrame:self.view.frame];
    bv.alpha = 0.5;
    bv.tag = 112;
    bv.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bv];
    
    self.identifyView = [[SelectIdentifyView alloc] initWithFrame:CGRectMake(0, 0, 290, 414) identifyArr:arr];
    self.identifyView.backgroundColor = [UIColor whiteColor];
    self.identifyView.center = self.view.center;
    self.identifyView.delegate = self;
    [self.view addSubview:self.identifyView];
    self.identifyView.layer.cornerRadius = 10.;
}


#pragma mark ---微信授权后弹出手机框
- (void)_initCodeView:(NSString *)phone
{
    
    
    UIView *bv = [[UIView alloc] initWithFrame:self.view.frame];
    bv.alpha = 0.5;
    bv.tag = 112;
    bv.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bv];
    
    self.codeView = [[[NSBundle mainBundle] loadNibNamed:@"IdentifyCodeView" owner:self options:nil] lastObject];
    self.codeView.delegate = self;
    [self.codeView configViewTitle:[NSString stringWithFormat:@"向您的手机%@",phone]
                          subTitle:@"发送了验证码"
                        defaultstr:@"在这里填写验证码"
                          btnTitle:@"确定"
                          hideFlag:NO];
    [self.view addSubview:self.codeView];
    self.codeView.frame = CGRectMake(0, 0, 290, 250);
    self.codeView.backgroundColor = [UIColor whiteColor];
    self.codeView.center = self.view.center;
    self.codeView.layer.cornerRadius = 10.;
    
}


- (void)_initContactView{
    
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *bv = [[UIView alloc] initWithFrame:weak_self.view.frame];
           bv.alpha = 0.5;
           bv.tag = 112;
           bv.backgroundColor = [UIColor lightGrayColor];
           [weak_self.view addSubview:bv];
           
           weak_self.contactView = [[[NSBundle mainBundle] loadNibNamed:@"IdentifyCodeView" owner:weak_self options:nil] lastObject];
           weak_self.contactView.delegate = self;
           [weak_self.contactView configViewTitle:@"老板怎么联系到您呢？"
                                 subTitle:@"请提供一个常用的手机号"
                               defaultstr:@"在这里填写11位手机号码"
                                 btnTitle:@"验证手机"
                                 hideFlag:YES];
           [weak_self.view addSubview:weak_self.contactView];
           weak_self.contactView.frame = CGRectMake(0, 0, 290, 250);
           weak_self.contactView.backgroundColor = [UIColor whiteColor];
           weak_self.contactView.center = weak_self.view.center;
           
           weak_self.contactView.layer.cornerRadius = 10.;
        
    });
   
}

#pragma mark ------------------------View Event---------------------------
//微信登录
-(void)wechatBtnClick{
    
 
    
     SendAuthReq *req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo"; 
    req.state = @"wx_oauth_authorization_state";
    [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {

    }];

}


-(void)getCodeClick:(JKCountDownButton *)sender {
    if (self.phoneFiled.text.length==0) {
        [self showMessage:@"请输入手机号"];
        return;
    }
    if (self.phoneFiled.text.length==11) {
            
        [self getSmsCode:_phoneFiled.text];
              
    }else{
        [self showMessage:@"手机号格式错误"];
        return;
    }
    
    [sender setTitleColor:KTextColor forState:UIControlStateNormal];
    sender.enabled = NO;
    //button type要 设置成custom 否则会闪动
    
    [sender startWithSecond:60];
    
    
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d重新获取",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        [sender setTitleColor:KCOLOR_Main forState:UIControlStateNormal];
        return @"重新获取";
        
    }];
}


#pragma mark ------------------------ 返回上级页面
- (void)backFrontController:(id)sender
{
   
    [self _jumpVC:10];
}

#pragma mark ------------------------ 隐私协议点击
- (void)privateBtnClicked:(id)sender event:(id)event
{
    UIButton *btn = (UIButton *)sender;
    
    UITouch *touch = [[event touchesForView:sender] anyObject];
    CGPoint point = [touch locationInView:btn];
    NSLog(@">>event:%f", point.x);
    if(point.x > 200)
    {
        StoreGradeController *vc = [[StoreGradeController alloc] init];
        vc.titlename = @"隐私政策";
        vc.urlstring = @"http://www.taoyuan7.com/thmh5/ysxy.html";
        [self navigatePushViewController:vc animate:YES];
    }
    else
    {
        StoreGradeController *vc = [[StoreGradeController alloc] init];
        vc.titlename = @"用户服务条款";
        vc.urlstring = @"http://www.taoyuan7.com/thmh5/yhfwxy.html";
        [self navigatePushViewController:vc animate:YES];
    }
}

#pragma mark ------------------------ 联系客服
- (void)connectBtnClicked:(id)sender
{
    
   NSString *tellNumber = [NSString stringWithFormat:@"tel://0731-89902787"];
   [[UIApplication sharedApplication]openURL:[NSURL URLWithString:tellNumber] options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:^(BOOL success) {
          
   }];

 }

- (void)clearPhoneFiled:(id)sender
{
    self.phoneFiled.text = @"";
    self.loginBtn.alpha = 0.5;
}


#pragma mark ------------------------ 获取手机验证码
- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            NSLog(@"获取验证码");
//            if ([Util isValidateMobile:self.phoneFiled.text]) {
//                [self getSmsCode];
//            [self _initCodeView];
//            }else{
//                [self showErrorInfoWithStatus:@"手机号格式错误"];
//            }
            
        }
            break;
        case 2:
        {
            NSLog(@"登录");
            
            if (self.phoneFiled.text.length!=11) {
                
                [self showMessage:@"手机号格式错误"];
                return;
            }
            else
            {
                if(self.phoneFiled.text.length == 0){
                    [self showMessage:@"请输入手机号"];
                }else if (self.codeFiled.text.length==0){
                    [self showMessage:@"请输入验证码"];
                }else{
                
                    [self userLoginRequest];
                    
                }
            }
            
        }
            break;
        case 10:
        {
            NSLog(@"微信登录");
//            [self _initContactView];
        }
            break;
        default:
            break;
    }
}

- (void)changedTextField:(UITextField *)sender
{
    if(self.phoneFiled.text.length > 0)
        self.clearBtn.hidden = NO;
    else
        self.clearBtn.hidden = YES;
    
    if(self.phoneFiled.text.length > 0 && self.codeFiled.text.length > 0)
        self.loginBtn.alpha = 1.;
    else
        self.loginBtn.alpha = 0.5;
}

#pragma mark ------------------------Api----------------------------------
//获取验证码
-(void)getSmsCode:(NSString *)phone{
    
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"userName":phone} subUrl:@"UserApi/getSmsCode" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            [weak_self showSuccessInfoWithStatus:@"发送成功"];
            if (!isEmpty(weak_self.phone)) {
            [weak_self bingdingWX:weak_self.code];
            }
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
    
}
#pragma mark --用户登录
-(void)userLoginRequest{
    
      WEAK_SELF
      [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"installId":[Util appVersionStr],@"loginSource":@"2",@"loginType":@"1",@"userName":self.phoneFiled.text,@"smsCode":self.codeFiled.text} subUrl:@"UserApi/acountLogin" block:^(NSDictionary *resultDic, NSError *error) {
          NSLog(@"%@",resultDic);
          [self dissmiss];
          if ([resultDic[@"code"] integerValue]==200) {
              [[UserModel sharedInstance]saveUserInfo:@{
                  @"token":resultDic[@"params"][@"token"],
                  @"accid":resultDic[@"params"][@"accid"],
                  @"username":resultDic[@"params"][@"nickName"],
                  @"phone":weak_self.phoneFiled.text,@"getTime":[NSString getNow13Time],
              }.mutableCopy];

              //0用户未选择用户身份
              if ([resultDic[@"params"][@"existCapacity"]intValue]==0) {
                  [weak_self getCapacity];
              }else{
                  [weak_self _jumpVC:10];
              }

              
              [weak_self getUserInfo];
              

           }else{
              [weak_self showMessage:resultDic[@"desc"]];
          }

      }];
}

#pragma mark ------vx登录返回
- (void)wechatInfo:(NSNotification *)cation{

     dic = cation.object;
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"requestEntity":@{@"city":dic[@"city"],@"headimgurl":dic[@"headimgurl"],@"province":dic[@"province"],@"country":dic[@"country"],@"nickname":dic[@"nickname"],@"openid":dic[@"openid"],@"unionid":dic[@"unionid"],@"language":@"中文",@"sex":dic[@"sex"],@"installId":[Util appVersionStr],@"loginSource":@"2",@"loginType":@"2",},@"unionid":dic[@"unionid"],@"openid":dic[@"openid"]};
//      NSDictionary *param = @{@"requestEntity":@{@"city":dic[@"city"],@"headimgurl":dic[@"headimgurl"],@"province":dic[@"province"],@"country":dic[@"country"],@"nickname":dic[@"nickname"],@"openid":@"oLg7a6giNMN82QaFHPWgChLWIDJWI",@"unionid":@"oZKBs6PdP_gS30Wp5DgHxwwwwww",@"language":@"中文",@"sex":dic[@"sex"]},@"unionid":@"oZKBs6PdP_gS30Wp5DgHxwwwwww",@"openid":@"oLg7a6giNMN82QaFHPWgChLWIDJWI"};
    
        [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"UserApi/checkWxLogin" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                
                if ([resultDic[@"params"][@"isBindMobile"]intValue]==0) {
                    [weak_self _initContactView];
                }else{
                   
                    [[UserModel sharedInstance]saveUserInfo:@{
                               @"token":resultDic[@"params"][@"token"],
                               @"accid":resultDic[@"params"][@"accid"],
                               @"username":resultDic[@"params"][@"nickName"],@"getTime":[NSString getNow13Time]
                                }.mutableCopy];

                           //0用户未选择用户身份
                        dispatch_async(dispatch_get_main_queue(), ^{
                           if ([resultDic[@"params"][@"existCapacity"]intValue]==0) {
                               
                               [weak_self getCapacity];
                                   
                               
                               
                           }else{
                               [weak_self _jumpVC:10];
                           }

                        });
                           [weak_self getUserInfo];
                        
                    
                }
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    
}


#pragma mark --vx绑定手机
-(void)bingdingWX:(NSString *)code{
    NSDictionary *param = @{@"city":dic[@"city"],@"headimgurl":dic[@"headimgurl"],@"province":dic[@"province"],@"country":dic[@"country"],@"nickname":dic[@"nickname"],@"openid":dic[@"openid"],@"language":@"中文",@"smsCode":code,@"mobile":_phone,@"unionid":dic[@"unionid"],@"sex":dic[@"sex"],@"installId":[Util appVersionStr],@"loginSource":@"2",@"loginType":@"2"};
    
//     NSDictionary *param = @{@"city":dic[@"city"],@"headimgurl":dic[@"headimgurl"],@"province":dic[@"province"],@"country":dic[@"country"],@"nickname":dic[@"nickname"],@"language":@"中文",@"smsCode":_code,@"mobile":_phone,@"sex":dic[@"sex"],@"unionid":@"oZKBs6PdP_gS30Wp5DgHxwwwwww",@"openid":@"oLg7a6giNMN82QaFHPWgChLWIDJWI"};
    
    
    WEAK_SELF
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"UserApi/wxLoginAndBindMobile" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            [[UserModel sharedInstance]saveUserInfo:@{
             @"token":resultDic[@"params"][@"token"],
             @"accid":resultDic[@"params"][@"accid"],
             @"username":resultDic[@"params"][@"nickName"],
             @"phone":weak_self.phone
         }.mutableCopy];

         //0用户未选择用户身份
         if ([resultDic[@"params"][@"existCapacity"]intValue]==0) {
             [weak_self getCapacity];
         }else{
             [weak_self _jumpVC:10];
         }

         
         [weak_self getUserInfo];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

-(void)getUserInfo{
    WEAK_SELF
//   [self showHub];
   [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/userDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
       NSLog(@"resultDic:%@",resultDic);
       [weak_self dissmiss];
       if ([resultDic[@"code"] integerValue]==200) {
                      
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"realNameVerifyState"] forKey:@"verifyStatus"];
           
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"truename"] forKey:@"truename"];
                      
           [[UserModel sharedInstance] saveUserInfo:[UserModel sharedInstance].userInfo];
        }else{
           [weak_self showMessage:resultDic[@"desc"]];
       }
   }];
}


//获取用户身份列表
-(void)getCapacity{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/getCapacity" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200) {
             [weak_self _initSelectIdentifyView:resultDic[@"params"]];
         }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

//确认用户身份
-(void)submitUserCapacit:(NSString *)capacity AndUserName:(NSString *)name{
    
    WEAK_SELF
    [self showHub];
    NSString *iphone;
    if (!isEmpty(_phone)) {
        iphone=_phone;
    }else{
        iphone=_phoneFiled.text;
    }
    
    [AFNHttpRequestOPManager postWithParameters:@{@"capacity":capacity,@"nickName":name,@"userName":iphone} subUrl:@"UserApi/updateCapacit" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200) {
            [weak_self removeIdView];
            [weak_self _jumpVC:10];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
    
}
-(void)removeIdView{
    UIView *view = [self.view viewWithTag:112];
     [view removeFromSuperview];
     self.identifyView.delegate = nil;
     [self.identifyView removeFromSuperview];
}
#pragma mark ------------------------Page Navigate------------------------
- (void)_jumpVC:(NSInteger)index {
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
   
    MainTabBarController* mainTabbarVC = appDelegate.mainVC;
    [mainTabbarVC didSelectItemWithIndex:index];
 
}
#pragma mark ------------------------Delegate-----------------------------

#pragma mark --------------- 关闭身份选择view
- (void)disMissIdentifyView
{
    UIView *bv = [self.view viewWithTag:112];
    [bv removeFromSuperview];
    self.identifyView.delegate = nil;
    [self.identifyView removeFromSuperview];
}
 

#pragma mark --------------- 确定身份选择
- (void)confirmInfoIdentifyName:(NSString *)name identify:(NSString *)capacit
{
    if (isEmpty(name)) {
        [self showMessage:@"请输入姓名"];
        return;
    }
    if (isEmpty(capacit)) {
        [self showMessage:@"请选择类别"];
        return;
    }
    [self submitUserCapacit:capacit AndUserName:name];
 
}


- (void)disMissCodeView
{
    if(self.codeView)
    {
        UIView *bv = [self.view viewWithTag:112];
        [bv removeFromSuperview];
      
        [self.codeView removeFromSuperview];
        self.codeView.delegate = nil;
        self.codeView=nil;
       
    }
    
    if(self.contactView)
    {
        UIView *bv = [self.view viewWithTag:112];
        [bv removeFromSuperview];
        
        [self.contactView removeFromSuperview];
        self.contactView.delegate = nil;
        self.contactView=nil;
    }
}

- (void)getCodeAgin
{
    [self _initCodeView:_phone];
}

- (void)confirmCodeInfo:(NSString *)code
{
    if(self.codeView)
    {
        UIView *bv = [self.view viewWithTag:112];
        [bv removeFromSuperview];
        [self.codeView removeFromSuperview];
        self.codeView.delegate = nil;
        self.codeView=nil;
        _code=code;
         [self getSmsCode:_phone];
        
    }
    
    if(self.contactView)
    {
        if (code.length!=11) {
            [self showMessage:@"手机号格式错误"];
            return;
        }
        UIView *bv = [self.view viewWithTag:112];
        [bv removeFromSuperview];
        
        [self.contactView removeFromSuperview];
        self.contactView.delegate = nil;
        self.contactView=nil;
        _phone=code;
        [self _initCodeView:_phone];
        
    }
}


@end
