//
//  CheckFaceViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CheckFaceViewController.h"
#import "CheckStatusViewController.h"

@interface CheckFaceViewController ()

@property (nonatomic, strong) UIButton *goBtn;
@property (nonatomic, assign) BOOL      isCheck;

@end

@implementation CheckFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"刷脸";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.isCheck = NO;
    
    UILabel *lab = [[UILabel alloc] init];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(58);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(44);
    }];
    lab.text = @"请将脸正对屏幕 \n 点击开始后，做出提示的动作";
    lab.textColor = UIColorFromRGB(0x343434);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    
    
    //开始认证
    self.goBtn = [[UIButton alloc] init];
    self.goBtn.alpha = 0.5;
    self.goBtn.userInteractionEnabled = NO;
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
               title:@"开始"
            fontsize:18
              corner:22
                 tag:2];
    
    //用户协议
    UIButton *docBtn = [[UIButton alloc] init];
    [self.view addSubview:docBtn];
    [docBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(150);
    }];
    
    NSString * connectStr = @"已阅读并同意《用户协议》";
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",connectStr]];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,connectStr.length)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,6)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(6,connectStr.length-6)];
    [docBtn setAttributedTitle:tempstr forState:UIControlStateNormal];
    [docBtn addTarget:self action:@selector(docBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //勾选用户协议
    UIButton *checkBtn = [[UIButton alloc] init];
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(docBtn.mas_left).offset(0);
        make.centerY.equalTo(docBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    [checkBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    [checkBtn addTarget:self
                 action:@selector(checkBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark ------------------------Init---------------------------------
 
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

#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
#pragma mark ------------ 开始认证
- (void)btnClicked:(id)sender
{
    CheckStatusViewController *vc = [[CheckStatusViewController alloc] init];
    vc.checkResult = 1;
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ------------ 用户协议
- (void)docBtnClicked:(id)sender
{
    
}

#pragma mark ------------ 勾选用户协议
- (void)checkBtnClicked:(UIButton *)sender
{
    if(self.isCheck)
    {
        self.goBtn.userInteractionEnabled = NO;
        self.goBtn.alpha = 0.5;
        [sender setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    }
    else
    {
        self.goBtn.userInteractionEnabled = YES;
        self.goBtn.alpha = 1;
        [sender setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
    }
    self.isCheck = !self.isCheck;
}

#pragma mark ------------------------Delegate-----------------------------


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------



@end
