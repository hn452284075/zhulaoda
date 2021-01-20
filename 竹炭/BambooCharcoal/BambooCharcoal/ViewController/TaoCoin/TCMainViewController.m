//
//  TCMainViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/17.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCMainViewController.h"
#import "TCDetailViewController.h"
#import "TCTGViewController.h"

@interface TCMainViewController ()

@property (nonatomic, strong) UIView   *topview;
@property (nonatomic, strong) UIButton *buyBtn;  //购买
@property (nonatomic, strong) UIButton *adBtn;   //推广

@end

@implementation TCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageTitle = @"我的淘币";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self _initTopview];
    [self _initTowBtn];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initTopview
{
    self.topview = [[UIView alloc] init];
    self.topview.backgroundColor = UIColorFromRGB(0x46c67c);
    [self.view addSubview:self.topview];
    [self.topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.equalTo(@137);
    }];
    
    UILabel *moneyLab = [[UILabel alloc] init];
    [self.topview addSubview:moneyLab];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topview).offset(37);
        make.left.equalTo(self.topview).offset(0);
        make.right.equalTo(self.topview).offset(0);
        make.height.equalTo(@25);
    }];
    [self customLabel:moneyLab text:@"2000.00" color:UIColorFromRGB(0xFFFFFF) fsize:30];
    
    UILabel *msgLab = [[UILabel alloc] init];
    [self.topview addSubview:msgLab];
    [msgLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLab.mas_bottom).offset(20);
        make.left.equalTo(self.topview).offset(0);
        make.right.equalTo(self.topview).offset(0);
        make.height.equalTo(@25);
    }];
    [self customLabel:msgLab text:@"可用田币数" color:UIColorFromRGB(0x80F3B0) fsize:14];
    
    UIButton *detailBtn = [[UIButton alloc] init];
    [self.topview addSubview:detailBtn];
    [detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topview.mas_top).offset(15);
        make.right.equalTo(self.topview.mas_right).offset(-15);
        make.height.equalTo(@14);
        make.width.equalTo(@70);
    }];
    detailBtn.layer.cornerRadius = 9.;
    detailBtn.layer.masksToBounds = YES;
    detailBtn.backgroundColor = kGetColorWithAlpha(0xff, 0xff, 0xff, 0.2);
    [detailBtn setTitle:@"查看明细 >" forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailBtn.titleLabel.font = CUSTOMFONT(10);
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_initTowBtn
{
    self.buyBtn = [[UIButton alloc] init];
    [self.buyBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buyBtn];
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topview.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@72);
    }];
    [self customBtn:self.buyBtn
                img:@"tb_icon"
              title:@"购买桃币卡"
           subtitle:@"多种面值可选，面值越大越优惠"];
    
    
    self.adBtn = [[UIButton alloc] init];
    [self.adBtn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.adBtn];
    [self.adBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buyBtn.mas_bottom).offset(9);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@72);
    }];
    [self customBtn:self.adBtn
                img:@"tb_icon"
              title:@"花淘币做推广"
           subtitle:@"精准推广帮您赚钱"];
}


#pragma mark ------------------------Private------------------------------
- (void)customBtn:(UIButton *)btn img:(NSString *)img title:(NSString *)title subtitle:(NSString *)subtitle
{
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5.0;
    btn.layer.masksToBounds = YES;
    
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.image = IMAGE(img);
    [btn addSubview:imgview];
    [imgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_left).offset(15);
        make.centerY.equalTo(btn.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];

    UILabel *tLab = [[UILabel alloc] init];
    tLab.text = title;
    tLab.textColor = UIColorFromRGB(0x222222);
    tLab.font = CUSTOMFONT(16);
    [btn addSubview:tLab];
    [tLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgview.mas_right).offset(11);
        make.top.equalTo(imgview.mas_top);
        make.width.equalTo(@240);
        make.height.equalTo(@16);
    }];

    UILabel *stLab = [[UILabel alloc] init];
    stLab.text = title;
    stLab.textColor = UIColorFromRGB(0x9a9a9a);
    stLab.font = CUSTOMFONT(12);
    [btn addSubview:stLab];
    [stLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgview.mas_right).offset(11);
        make.bottom.equalTo(imgview.mas_bottom);
        make.width.equalTo(@240);
        make.height.equalTo(@12);
    }];


    UIImageView *arrowimg = [[UIImageView alloc] init];
    arrowimg.image = IMAGE(@"rightArrow");
    [btn addSubview:arrowimg];
    [arrowimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn.mas_right).offset(-15);
        make.centerY.equalTo(btn.mas_centerY);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}


- (void)customLabel:(UILabel *)lab text:(NSString *)text color:(UIColor *)color fsize:(int)size
{
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = CUSTOMFONT(size);
    lab.textColor = color;
    lab.text = text;
}


#pragma mark ------------------------View Event---------------------------
//详情
- (void)detailBtnClicked
{
    TCDetailViewController *vc = [[TCDetailViewController alloc] init];
    [self navigatePushViewController:vc animate:YES];
}

//购买淘币   做推广
- (void)itemBtnClicked:(UIButton *)sender
{
    if([sender isEqual:self.buyBtn])
    {
        
    }
    else
    {
        TCTGViewController *vc = [[TCTGViewController alloc] init];
        [self navigatePushViewController:vc animate:YES];
    }
}


 

#pragma mark ------------------------Api----------------------------------





@end
