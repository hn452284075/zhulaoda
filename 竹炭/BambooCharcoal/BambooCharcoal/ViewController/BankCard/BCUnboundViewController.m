//
//  BCUnboundViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BCUnboundViewController.h"

@interface BCUnboundViewController ()

@end

@implementation BCUnboundViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fd_prefersNavigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
       self.fd_prefersNavigationBarHidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initCarInfoView];
    
        
    UIView *v = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:v atIndex:0];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,kScreenWidth,kScreenHeight);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:109/255.0 blue:37/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:139/255.0 blue:82/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [v.layer addSublayer:gl];

    
    //返回箭头
    UIButton *backBtn = [[UIButton alloc] init];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(38);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
    }];
    [backBtn setBackgroundImage:IMAGE(@"supply_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backFrontController:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)_initCarInfoView
{
    UIImageView *logoimg = [[UIImageView alloc] init];
    [self.view addSubview:logoimg];
    [logoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.top.equalTo(self.view.mas_top).offset(78);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    logoimg.image = IMAGE(@"bc_ZSYH_logo");
    
    UILabel *bankname = [[UILabel alloc] init];
    [self.view addSubview:bankname];
    [bankname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.top.equalTo(logoimg.mas_bottom).offset(18);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(18);
    }];
    bankname.text = self.cardName;
    bankname.font = [UIFont boldSystemFontOfSize:18];
    bankname.textAlignment = NSTextAlignmentCenter;
    bankname.textColor = UIColorFromRGB(0xffffff);
    
    UILabel *carnumber = [[UILabel alloc] init];
    [self.view addSubview:carnumber];
    [carnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankname.mas_bottom).offset(10);
        make.left.equalTo(bankname.mas_left);
        make.right.equalTo(bankname.mas_right);
        make.height.mas_equalTo(15);
    }];
    carnumber.text = self.cardNo;
    carnumber.font = [UIFont boldSystemFontOfSize:20];
    carnumber.textAlignment = NSTextAlignmentCenter;
    carnumber.textColor = UIColorFromRGB(0xffffff);
    
    UIView *infoview = [[UIView alloc] init];
    [self.view addSubview:infoview];
    [infoview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carnumber.mas_bottom).offset(30);
        make.left.equalTo(bankname.mas_left).offset(15);
        make.right.equalTo(bankname.mas_right).offset(-15);
        make.height.mas_equalTo(111);
    }];
    infoview.backgroundColor = [UIColor whiteColor];
    infoview.layer.cornerRadius = 5.;
    
    
    UILabel *name_lab = [[UILabel alloc] init];
    [infoview addSubview:name_lab];
    [name_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoview.mas_top).offset(26);
        make.left.equalTo(infoview.mas_left).offset(18);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    name_lab.text = @"用户";
    name_lab.font = [UIFont boldSystemFontOfSize:14];
    name_lab.textAlignment = NSTextAlignmentLeft;
    name_lab.textColor = UIColorFromRGB(0x666666);
    
    
    UILabel *phone_lab = [[UILabel alloc] init];
    [infoview addSubview:phone_lab];
    [phone_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name_lab.mas_bottom).offset(35);
        make.left.equalTo(infoview.mas_left).offset(18);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    phone_lab.text = @"手机号";
    phone_lab.font = [UIFont boldSystemFontOfSize:14];
    phone_lab.textAlignment = NSTextAlignmentLeft;
    phone_lab.textColor = UIColorFromRGB(0x666666);
    
    
    UILabel *name_value_lab = [[UILabel alloc] init];
    [infoview addSubview:name_value_lab];
    [name_value_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoview.mas_top).offset(26);
        make.right.equalTo(infoview.mas_right).offset(-18);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    name_value_lab.text = self.ownerName;
    name_value_lab.font = [UIFont boldSystemFontOfSize:14];
    name_value_lab.textAlignment = NSTextAlignmentRight;
    name_value_lab.textColor = UIColorFromRGB(0x666666);
    
    UILabel *phone_value_lab = [[UILabel alloc] init];
    [infoview addSubview:phone_value_lab];
    [phone_value_lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(name_lab.mas_bottom).offset(35);
        make.right.equalTo(infoview.mas_right).offset(-18);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    phone_value_lab.text = self.ownerPhone;
    phone_value_lab.font = [UIFont boldSystemFontOfSize:14];
    phone_value_lab.textAlignment = NSTextAlignmentRight;
    phone_value_lab.textColor = UIColorFromRGB(0x666666);
    
    
    
    UIButton *unbundBtn = [[UIButton alloc] init];
    [self.view addSubview:unbundBtn];
    [unbundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-kStatusBarAndTabBarHeight);
        make.left.equalTo(bankname.mas_left).offset(100);
        make.right.equalTo(bankname.mas_right).offset(-100);
        make.height.mas_equalTo(40);
    }];
    unbundBtn.layer.cornerRadius = 20.;
    [unbundBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    [unbundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unbundBtn.titleLabel.font = CUSTOMFONT(16);
    unbundBtn.layer.borderWidth = 0.5;
    unbundBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [unbundBtn addTarget:self action:@selector(unbundBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)backFrontController:(id)sender
{
    [self goBack];
}


- (void)unbundBtnClicked:(id)sender
{
    [self unBoundBankCard];
}


#pragma mark ------------------------Api----------------------------------
- (void)unBoundBankCard
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/unbindBankCard" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue] == 200)
        {
            
            [self.delegate unboundSuccess];
            [self goBack];
        }
        else
        {
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}


@end
