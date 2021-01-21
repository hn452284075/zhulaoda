//
//  BanKCardViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BanKCardViewController.h"
#import "AddBCardViewController.h"

@interface BanKCardViewController ()

@property (nonatomic, strong) UILabel   *noCarMsgLabel;
@property (nonatomic, strong) UIView    *noCarBackView;
@property (nonatomic, strong) UIButton  *addCarBtn;

@end

@implementation BanKCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"银行账户";
    
    
    [self _initNoCarTopView];
}


#pragma mark ------------------------Init---------------------------------
- (void)_initNoCarTopView
{
    self.noCarMsgLabel = [[UILabel alloc] init];
    [self.view addSubview:self.noCarMsgLabel];
    self.noCarMsgLabel.text = @"您还没有绑定银行账户";
    self.noCarMsgLabel.font = CUSTOMFONT(14);
    self.noCarMsgLabel.textColor = UIColorFromRGB(0x121212);
    [self.noCarMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(33);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.height.mas_equalTo(13);
    }];
    
    self.noCarBackView = [[UIView alloc] init];
    [self.view addSubview:self.noCarBackView];
    [self.noCarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noCarMsgLabel.mas_bottom).offset(18);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(122);
    }];
    self.noCarBackView.layer.cornerRadius = 5.;
    self.noCarBackView.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAShapeLayer *border = [CAShapeLayer layer];
        //虚线的颜色
        border.strokeColor = [UIColor lightGrayColor].CGColor;
        //填充的颜色
        border.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.noCarBackView.bounds cornerRadius:5];
        //设置路径
        border.path = path.CGPath;
        border.frame = self.noCarBackView.bounds;
        //虚线的宽度
        border.lineWidth = 1.f;
        //设置线条的样式
        //    border.lineCap = @"square";
        //虚线的间隔
        border.lineDashPattern = @[@4, @2];
        self.noCarBackView.layer.cornerRadius = 5.f;
        self.noCarBackView.layer.masksToBounds = YES;
        [self.noCarBackView.layer addSublayer:border];
    });
    
    
    self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addCarBtn setImage:IMAGE(@"bc_addicon") forState:UIControlStateNormal];
    [self.addCarBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
    [self.addCarBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [self.addCarBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    self.addCarBtn.titleLabel.font= CUSTOMFONT(16);
    [self.view addSubview:self.addCarBtn];
    [self.addCarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.noCarBackView.mas_centerX);
        make.centerY.equalTo(self.noCarBackView.mas_centerY);
        make.width.mas_equalTo(170);
        make.height.mas_equalTo(40);
    }];
    [self.addCarBtn setAdjustsImageWhenHighlighted:NO];
    [self.addCarBtn setBackgroundColor:UIColorFromRGB(0x46c67c)];
    [self.addCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addCarBtn.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.addCarBtn.layer.cornerRadius = 20.;
    [self.addCarBtn addTarget:self action:@selector(addCarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark ------------------------Private------------------------------
 


#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)addCarBtnClicked:(id)sender
{
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    AddBCardViewController *vc = [[AddBCardViewController alloc] init];
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ------------------------Delegate-----------------------------


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------


@end
