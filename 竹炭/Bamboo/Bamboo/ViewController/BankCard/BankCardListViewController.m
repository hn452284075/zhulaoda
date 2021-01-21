//
//  BankCardListViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BankCardListViewController.h"
#import "BCUnboundViewController.h"

@interface BankCardListViewController ()<UNBoundDelegate>

@property (nonatomic, strong) UILabel   *msgLabel;

@property (nonatomic, strong) NSString  *bankName;
@property (nonatomic, strong) NSString  *cardNo;
@property (nonatomic, strong) NSString  *userName;
@property (nonatomic, strong) NSString  *userPhone;

@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"银行账户";
    
    //获取银行卡信息
    [self getBankCardInfo];
    
}





#pragma mark ------------------------Init---------------------------------
- (void)_initBankCardView
{
    for(UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    
    self.msgLabel = [[UILabel alloc] init];
    [self.view addSubview:self.msgLabel];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(33);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(20);
    }];
    self.msgLabel.text = @"以下银行卡用于收取买家确认收货后的订单金额";
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    self.msgLabel.textAlignment = NSTextAlignmentLeft;
    self.msgLabel.textColor = UIColorFromRGB(0x111111);
    
    UIButton *view = [[UIButton alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(62);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(120);
    }];
    [view addTarget:self action:@selector(enterUnbundController:) forControlEvents:UIControlEventTouchUpInside];
        
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,kScreenWidth-30,120);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:109/255.0 blue:37/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:139/255.0 blue:82/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 5.;
    [view.layer addSublayer:gl];
    
    UIImageView *logoimg = [[UIImageView alloc] init];
    [view addSubview:logoimg];
    [logoimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(18);
        make.left.equalTo(view.mas_left).offset(18);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    logoimg.image = IMAGE(@"bc_ZSYH_logo");
    
    UIImageView *logoimg_1 = [[UIImageView alloc] init];
    [view addSubview:logoimg_1];
    [logoimg_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(-10);
        make.right.equalTo(view.mas_right).offset(-10);
        make.width.mas_equalTo(117);
        make.height.mas_equalTo(117);
    }];
    logoimg_1.image = IMAGE(@"bc_ZSYH_logo_1");
    
    UILabel *bankname = [[UILabel alloc] init];
    [view addSubview:bankname];
    [bankname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(23);
        make.left.equalTo(view.mas_left).offset(66);
        make.right.equalTo(view.mas_right);
        make.height.mas_equalTo(15);
    }];
    bankname.text = self.bankName;
    bankname.font = [UIFont boldSystemFontOfSize:15];
    bankname.textAlignment = NSTextAlignmentLeft;
    bankname.textColor = UIColorFromRGB(0xffffff);
    
    UILabel *ownername = [[UILabel alloc] init];
    [self.view addSubview:ownername];
    [ownername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankname.mas_bottom).offset(8);
        make.left.equalTo(bankname.mas_left);
        make.right.equalTo(bankname.mas_right);
        make.height.mas_equalTo(12);
    }];
    ownername.text = self.userName;
    ownername.font = [UIFont systemFontOfSize:11];
    ownername.textAlignment = NSTextAlignmentLeft;
    ownername.textColor = UIColorFromRGB(0xffffff);
    
    UILabel *carnumber = [[UILabel alloc] init];
    [self.view addSubview:carnumber];
    [carnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ownername.mas_bottom).offset(32);
        make.left.equalTo(bankname.mas_left);
        make.right.equalTo(bankname.mas_right);
        make.height.mas_equalTo(16);
    }];
    carnumber.text = self.cardNo;
    carnumber.font = [UIFont boldSystemFontOfSize:20];
    carnumber.textAlignment = NSTextAlignmentLeft;
    carnumber.textColor = UIColorFromRGB(0xffffff);
    

}

 
#pragma mark ------------------------Private------------------------------
 
#pragma mark ------------------------Api----------------------------------
-(void)getBankCardInfo{
    WEAK_SELF
   [self showHub];
   [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/getBankCardInfo" block:^(NSDictionary *resultDic, NSError *error) {
       NSLog(@"resultDic:%@",resultDic);
       [weak_self dissmiss];
       if ([resultDic[@"code"] integerValue]== 200) {
           
           NSString *namestr = [NSString stringWithFormat:@"%@%@",resultDic[@"params"][@"bankName"],resultDic[@"params"][@"bankType"]];
           weak_self.bankName = [NSString stringWithFormat:@"中国%@",namestr];
           weak_self.cardNo   = resultDic[@"params"][@"cardNo"];
           weak_self.userPhone= resultDic[@"params"][@"mobile"];
           weak_self.userName = resultDic[@"params"][@"userName"];
           
           [self _initBankCardView];
       }
       else if ([resultDic[@"code"] integerValue] == -200) {
           for(UIView *v in self.view.subviews)
           {
               [v removeFromSuperview];
           }
           
           self.msgLabel = [[UILabel alloc] init];
           [self.view addSubview:self.msgLabel];
           [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.view.mas_top).offset(33);
               make.left.equalTo(self.view.mas_left).offset(15);
               make.right.equalTo(self.view.mas_right);
               make.height.mas_equalTo(20);
           }];
           self.msgLabel.text = @"以下银行卡用于收取买家确认收货后的订单金额";
           self.msgLabel.font = [UIFont systemFontOfSize:14];
           self.msgLabel.textAlignment = NSTextAlignmentLeft;
           self.msgLabel.textColor = UIColorFromRGB(0x111111);
       }
       else
       {
           [weak_self showMessage:resultDic[@"desc"]];
       }
   }];
}
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)enterUnbundController:(id)sender
{
    BCUnboundViewController *vc = [[BCUnboundViewController alloc] init];
    vc.cardName   = self.bankName;
    vc.cardNo     = self.cardNo;
    vc.ownerName  = self.userName;
    vc.ownerPhone = self.userPhone;
    vc.delegate = self;
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ------------------------Delegate-----------------------------
- (void)unboundSuccess
{
    for(UIView *v in self.view.subviews)
    {
        [v removeFromSuperview];
    }
    //获取银行卡信息
    [self getBankCardInfo];
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------


@end
