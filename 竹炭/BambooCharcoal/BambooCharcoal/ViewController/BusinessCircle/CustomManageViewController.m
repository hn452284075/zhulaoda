//
//  CustomManageViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CustomManageViewController.h"
#import "VisitorRecordViewController.h"
#import "ChatOnceViewController.h"

@interface CustomManageViewController ()

@property (nonatomic, strong) UILabel  *countLabel;
@property (nonatomic, strong) UIButton *yesterdayBtn;


@end

@implementation CustomManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.pageTitle = @"客户管理";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
 
    [self _initTopview];
    [self _initChatview];
}


#pragma mark ------------------------Init---------------------------------
- (void)_initTopview
{
    UIView *bv = [[UIView alloc] init];
    [self.view addSubview:bv];
    [bv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(165);
    }];
    bv.backgroundColor = UIColorFromRGB(0x46C67B);
    
    self.countLabel = [[UILabel alloc] init];
    [bv addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bv.mas_centerX);
        make.top.equalTo(bv.mas_top).offset(40);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    self.countLabel.text = @"8888";
    self.countLabel.font = [UIFont boldSystemFontOfSize:34];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    [bv addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bv.mas_centerX);
        make.top.equalTo(self.countLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    lab.text = @"客户总数";
    lab.font = CUSTOMFONT(14);
    lab.textAlignment = NSTextAlignmentRight;
    lab.textColor = [UIColor whiteColor];
    
    self.yesterdayBtn = [[UIButton alloc] init];
    [bv addSubview:self.yesterdayBtn];
    [self.yesterdayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bv.mas_centerX).offset(10);
        make.centerY.equalTo(lab.mas_centerY);
        make.height.mas_equalTo(10);
    }];
    self.yesterdayBtn.titleLabel.font = CUSTOMFONT(10);
    [self.yesterdayBtn setTitle:@"昨日+100" forState:UIControlStateNormal];
    self.yesterdayBtn.layer.cornerRadius = 5.;
    self.yesterdayBtn.backgroundColor = UIColorFromRGB(0x46C67B);
    [self.yesterdayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
}

- (void)_initChatview
{
    UIView *bv = [[UIView alloc] init];
    [self.view addSubview:bv];
    [bv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(165+16);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(130);
    }];
    bv.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIView *v1 = [self getCustomClassView:@"1000" tag:1 title:@"聊过一次"];
    UIView *v2 = [self getCustomClassView:@"2000" tag:2 title:@"聊过多次"];
    UIView *v3 = [self getCustomClassView:@"3000" tag:3 title:@"成交过的"];

    [bv addSubview:v1];
    [bv addSubview:v2];
    [bv addSubview:v3];
    
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bv.mas_centerX).dividedBy(3.);
        make.centerY.equalTo(bv.mas_centerY);
        make.width.mas_equalTo(v1.frame.size.width);
        make.height.mas_equalTo(v1.frame.size.height);
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bv.mas_centerX);
        make.centerY.equalTo(bv.mas_centerY);
        make.width.mas_equalTo(v1.frame.size.width);
        make.height.mas_equalTo(v1.frame.size.height);
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bv.mas_centerX).multipliedBy(1.68);
        make.centerY.equalTo(bv.mas_centerY);
        make.width.mas_equalTo(v1.frame.size.width);
        make.height.mas_equalTo(v1.frame.size.height);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 0.5, 100)];
        line1.center = CGPointMake(bv.frame.size.width/3, line1.center.y);
        line1.backgroundColor = [UIColor lightGrayColor];
        line1.alpha = 0.3;
        [bv addSubview:line1];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 15, 0.5, 100)];
        line2.center = CGPointMake(bv.frame.size.width/3*2, line2.center.y);
        line2.backgroundColor = [UIColor lightGrayColor];
        line2.alpha = 0.3;
        [bv addSubview:line2];
    });
    
}
 
#pragma mark ------------------------Private------------------------------
- (UIView *)getCustomClassView:(NSString *)title tag:(int)tag title:(NSString *)string
{
    int w = 100;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, w, w-30)];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    btn.titleLabel.font = CUSTOMFONT(22);
    [view addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, w-35, w, 14)];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = UIColorFromRGB(0x666666);
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    return view;
}
 
#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:
        {
            ChatOnceViewController *vc = [[ChatOnceViewController alloc] init];
            [self navigatePushViewController:vc animate:YES];
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            VisitorRecordViewController *vc = [[VisitorRecordViewController alloc] init];
            [self navigatePushViewController:vc animate:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ------------------------Delegate-----------------------------


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------





@end
