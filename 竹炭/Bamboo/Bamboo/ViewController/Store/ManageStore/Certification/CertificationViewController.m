//
//  CertificationViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CertificationViewController.h"
#import "CheckFaceViewController.h"
#import "StoreGradeController.h"
#import "MYLabel.h"
#import "Util.h"
#import "CheckStatusViewController.h"

@interface CertificationViewController ()

@property (nonatomic, strong) UITextField   *nameFiled;
@property (nonatomic, strong) UITextField   *codeIdFiled;
@property (nonatomic, strong) UIButton      *goBtn;
@property (nonatomic, assign) BOOL      isCheck;

@end

@implementation CertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pageTitle = @"实名认证";
    
    UIImageView *bannerView = [[UIImageView alloc] init];
    [self.view addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(132);
    }];
    bannerView.image = IMAGE(@"ver_banner");
    
    UIImageView *lab1view = [[UIImageView alloc] init];
    [self.view addSubview:lab1view];
    [lab1view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bannerView.mas_bottom).offset(32);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(269);
        make.height.mas_equalTo(15.5);
    }];
    lab1view.image = IMAGE(@"ver_lab1");
    
    
    NSArray *imagearr = [[NSArray alloc] initWithObjects:@"ver_icon1",@"ver_icon2",@"ver_icon3",@"ver_icon4", nil];
    NSArray *titlearr = [[NSArray alloc] initWithObjects:@"发布货品",@"提高账号诚信值",@"优先参加平台活动",@"实名认证标签", nil];
    NSMutableArray *viewarr = [[NSMutableArray alloc] init];
    for(int i=0;i<imagearr.count;i++)
    {
        UIView *v = [self getCustomClassView:IMAGE(imagearr[i]) tag:i title:titlearr[i]];
        [viewarr addObject:v];
        [self.view addSubview:v];
    }
    int space = (kScreenWidth-32*2-51*4)/3;
    [viewarr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:space leadSpacing:32 tailSpacing:32];
    [viewarr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1view.mas_bottom).offset(25);
        make.height.equalTo(@95);
    }];
        
    UIImageView *lab2view = [[UIImageView alloc] init];
    [self.view addSubview:lab2view];
    [lab2view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1view.mas_bottom).offset(156);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(224);
        make.height.mas_equalTo(15.5);
    }];
    lab2view.image = IMAGE(@"ver_lab2");
    
    
    //输入姓名
    UIView *namebackview = [[UIView alloc] init];
    [self.view addSubview:namebackview];
    [namebackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2view.mas_bottom).offset(22);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(305);
    }];
    namebackview.backgroundColor = [UIColor whiteColor];
    namebackview.layer.borderColor = kGetColor(0xeb, 0xeb, 0xeb).CGColor;
    namebackview.layer.borderWidth = 1.;
    namebackview.layer.cornerRadius = 22.;
                    
    self.nameFiled = [[UITextField alloc] init];
    [self.view addSubview:self.nameFiled];
    [self.nameFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.centerY.equalTo(namebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(35);
    }];
    self.nameFiled.textColor = kGetColor(0x22, 0x2, 0x22);
    self.nameFiled.font = CUSTOMFONT(14);
    self.nameFiled.textAlignment = NSTextAlignmentCenter;
    self.nameFiled.placeholder = @"请输入您的名字";
    [self.nameFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //输入身份证号
    UIView *codebackview = [[UIView alloc] init];
    [self.view addSubview:codebackview];
    [codebackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namebackview.mas_bottom).offset(18);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(305);
    }];
    codebackview.backgroundColor = [UIColor whiteColor];
    codebackview.layer.borderColor = kGetColor(0xeb, 0xeb, 0xeb).CGColor;
    codebackview.layer.borderWidth = 1.;
    codebackview.layer.cornerRadius = 22.;
                    
    self.codeIdFiled = [[UITextField alloc] init];
    [self.view addSubview:self.codeIdFiled];
    [self.codeIdFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
        make.centerY.equalTo(codebackview.mas_centerY).offset(0);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(35);
    }];
    self.codeIdFiled.textColor = kGetColor(0x22, 0x22, 0x22);
    self.codeIdFiled.font = CUSTOMFONT(14);
    self.codeIdFiled.textAlignment = NSTextAlignmentCenter;
    self.codeIdFiled.placeholder = @"请输入您的身份证号";
    [self.codeIdFiled addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    //开始认证
    int b_height = -85;
    if(!IS_Iphonex_Series)
        b_height = -65;
    self.goBtn = [[UIButton alloc] init];
    self.goBtn.alpha = 0.5;
    self.goBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.goBtn];
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(b_height);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.goBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"开始认证"
            fontsize:18
              corner:22
                 tag:2];
    
    
    //用户协议
    UIButton *docBtn = [[UIButton alloc] init];
    [self.view addSubview:docBtn];
    [docBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX).offset(0).offset(15);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(150);
    }];
    
    NSString * connectStr = @"同意《认证服务协议》";
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",connectStr]];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,connectStr.length)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,2)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(2,connectStr.length-2)];
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

- (void)docBtnClicked:(id)sender
{
    StoreGradeController *vc = [[StoreGradeController alloc] init];
    vc.titlename = @"认证服务协议";
    vc.urlstring = @"http://www.taoyuan7.com/thmh5/htrzxy.html";
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ---- 勾选图标
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


#pragma mark ------------------------Init---------------------------------
 
#pragma mark ------------------------Private------------------------------
- (UIView *)getCustomClassView:(UIImage *)img tag:(int)tag title:(NSString *)string
{
    int w = 51;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, w+30+15)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    [btn setImage:img forState:UIControlStateNormal];
    btn.tag = tag;
    [view addSubview:btn];
    
    MYLabel *lab = [[MYLabel alloc] initWithFrame:CGRectMake(0, w+8, w, 30)];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:12];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    [lab setVerticalAlignment:VerticalAlignmentTop];
    [view addSubview:lab];
    
    return view;
}


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
- (void)changedTextField:(UITextField *)filed
{
    if(self.nameFiled.text.length > 0 && [Util cly_verifyIDCardString:self.codeIdFiled.text])
    {
//        self.goBtn.alpha = 1.;
//        self.goBtn.userInteractionEnabled = YES;
    }
    else{
//        self.goBtn.alpha = 0.5;
//        self.goBtn.userInteractionEnabled = NO;
    }
}

#pragma mark --------------- 开始认证
- (void)btnClicked:(id)sender
{
//    CheckFaceViewController *vc = [[CheckFaceViewController alloc] init];
//    [self navigatePushViewController:vc animate:YES];
    
    if((isEmpty(self.nameFiled.text) || isEmpty(self.codeIdFiled.text)) ||
       ![Util cly_verifyIDCardString:self.codeIdFiled.text] || self.codeIdFiled.text.length != 18)
    {
        [self showMessage:@"请先填写信息并确保格式正确"];
    }
    else if(self.isCheck == NO)
    {
        [self showMessage:@"请先勾选认证服务协议"];
    }
    else
    {//网易人脸识别
//        NTESLDMainViewController *vc = [[NTESLDMainViewController alloc] init];
//        vc.nameString = self.nameFiled.text;
//        vc.cardString = self.codeIdFiled.text;
//        vc.delegate = self;
//        [self.navigationController pushViewController:vc animated:YES];
        
        
        CheckStatusViewController *vc = [[CheckStatusViewController alloc] init];
        vc.detect_name  = self.nameFiled.text;
        vc.detect_card  = self.codeIdFiled.text;
        vc.isStorePush=self.isStorePush;
        [self navigatePushViewController:vc animate:YES];
        
        
        NSLog(@"开始认证");
    }
}

#pragma mark ------------------------Delegate-----------------------------
- (void)NTESDetectResult:(int)flag
{
    if(flag == 0)
    {
        [self showMessage:@"认证不通过！请确保是本人在操作并核对所填信息"];
    }
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------






@end
