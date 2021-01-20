//
//  OSApplyViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OSApplyViewController.h"
#import "openStoreView.h"
#import "JWAddressPickerView.h"
#import "CheckFaceViewController.h"
#import "OSPayViewController.h"
#import "OSStoreInfoViewController.h"
#import "ManageStoreViewController.h"
#import "CertificationViewController.h"
@interface OSApplyViewController ()

@property (nonatomic, strong) openStoreView *osView;

@property (nonatomic, strong) UIButton *openBtn;

@end

@implementation OSApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self _initOpenView];
    
        
    if(self.smodel == nil)
    {
        self.pageTitle = @"开通竹商宝";
        self.openBtn = [[UIButton alloc] init];
        self.openBtn.alpha = 1.0;
        self.openBtn.userInteractionEnabled = YES;
        [self.view addSubview:self.openBtn];
        [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-35);
            make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
            make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
            make.height.mas_equalTo(45);
        }];

        [self factory_btn:self.openBtn
          backColor:KCOLOR_Main
          textColor:[UIColor whiteColor]
        borderColor:KCOLOR_Main
              title:@"申请开通"
           fontsize:16
             corner:22
                tag:2];
    }
    else
    {
        self.pageTitle = @"店铺信息";
        self.osView.nameFiled.text = self.smodel.shopName;
        self.osView.nameFiled.textColor = UIColorFromRGB(0x999999);
        
        self.osView.majorFiled.text = self.smodel.major;
        self.osView.majorFiled.textColor = UIColorFromRGB(0x999999);
        
        //self.smodel.addressMergeName
        [self.osView.addressBtn setTitle:self.smodel.detailedAddress forState:UIControlStateNormal];
        [self.osView.addressBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        
        self.osView.nameLab.textColor = UIColorFromRGB(0x999999);
        
        if(self.smodel.openPayState == 0)
        {
            self.osView.nameFiled.textColor = UIColorFromRGB(0x343434);
            self.osView.majorFiled.textColor = UIColorFromRGB(0x343434);
            [self.osView.addressBtn setTitleColor:UIColorFromRGB(0x343434) forState:UIControlStateNormal];
            self.osView.nameLab.textColor = UIColorFromRGB(0x343434);
            self.pageTitle = @"开通竹商宝";
            self.openBtn = [[UIButton alloc] init];
            self.openBtn.alpha = 1.0;
            self.openBtn.userInteractionEnabled = YES;
            [self.view addSubview:self.openBtn];
            [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-35);
                make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
                make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
                make.height.mas_equalTo(45);
            }];

            [self factory_btn:self.openBtn
              backColor:KCOLOR_Main
              textColor:[UIColor whiteColor]
            borderColor:KCOLOR_Main
                  title:@"申请开通"
               fontsize:16
                 corner:22
                    tag:2];
        }
        else
        {
            self.osView.userInteractionEnabled = NO;
        }
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([[UserModel sharedInstance].verifyStatus intValue] == 1)
        {
            self.osView.vertifyLab.text = @"  实名  ";
            self.osView.vertifyLab.textColor = KCOLOR_Main;
            self.osView.vertifyLab.layer.borderColor = KCOLOR_Main.CGColor;
            self.osView.vertifyLab.backgroundColor = [UIColor clearColor];
            
            self.osView.line3view.hidden = YES;
            self.osView.msgLab1.hidden = YES;
            self.osView.msgLab2.hidden = YES;
            self.osView.goVertifyBtn.hidden = YES;
        }
        else
        {
            self.osView.vertifyLab.text = @"  未实名  ";
            self.osView.vertifyLab.textColor = UIColorFromRGB(0x333333);
            self.osView.vertifyLab.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
            self.osView.vertifyLab.backgroundColor = [UIColor clearColor];
            [self.osView.goVertifyBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer)
            {
                CertificationViewController *vc = [[CertificationViewController alloc]init];
                [self navigatePushViewController:vc animate:YES];

    //            CheckFaceViewController *vc = [[CheckFaceViewController alloc] init];
    //            [self navigatePushViewController:vc animate:YES];
            }];
        }
    
    self.osView.nameLab.text = [UserModel sharedInstance].truename;
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------


#pragma mark ------------------------Init---------------------------------
- (void)_initOpenView
{
    self.osView = [[[NSBundle mainBundle] loadNibNamed:@"openStoreView" owner:self options:nil] lastObject];
    [self.view addSubview:self.osView];
    [self.osView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_offset(500);
    }];
    self.osView.userInteractionEnabled = YES;
    self.osView.backgroundColor = KViewBgColor;
    
    self.osView.backView1.layer.cornerRadius = 5.0;
    self.osView.backView1.backgroundColor = [UIColor whiteColor];
    self.osView.backView2.layer.cornerRadius = 5.0;
    self.osView.backView2.backgroundColor = [UIColor whiteColor];

    self.osView.nameFiled.placeholder = @"请输入店铺名称，最多12个字";
    self.osView.majorFiled.placeholder = @"输入您的主营品类";
    [self.osView.nameFiled setBorderStyle:UITextBorderStyleNone];
    [self.osView.majorFiled setBorderStyle:UITextBorderStyleNone];

    self.osView.nameLab.textColor = UIColorFromRGB(0x333333);
    

    
    self.osView.vertifyLab.layer.cornerRadius = 10.0;
    self.osView.vertifyLab.layer.borderWidth = 0.5;
    

    self.osView.addressBtn.titleLabel.font = CUSTOMFONT(14);
    [self.osView.addressBtn setTitle:@"请输入地址" forState:UIControlStateNormal];
    [self.osView.addressBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    self.osView.addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    WEAK_SELF
    [self.osView.addressBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [weak_self.view endEditing:YES];
        
        JWAddressPickerView *tmppick = [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {

            NSString *addr = [NSString stringWithFormat:@"%@ - %@ - %@",province,city,area];
            [weak_self.osView.addressBtn setTitle:addr forState:UIControlStateNormal];
            [weak_self.osView.addressBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }];
        if([weak_self.osView.addressBtn.titleLabel.text rangeOfString:@"-"].location != NSNotFound)
        {
            NSArray *tmpArray = [weak_self.osView.addressBtn.titleLabel.text componentsSeparatedByString:@" - "];
            [tmppick setDefaultPro:tmpArray[0] city:tmpArray[1] town:tmpArray[2]];
        }
    }];
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



#pragma mark ------------------------Api----------------------------------
- (void)requestOfOpenStore:(NSString *)name major:(NSString *)major address:(NSString *)address
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProData" ofType:@"plist"];
       NSDictionary *prodic = [[NSDictionary alloc] initWithContentsOfFile:path];
       //根据地址查找id
    NSString *idstr;
       if(prodic != nil)
       {
        
           idstr = [NSString stringWithFormat:@"%d",[[prodic valueForKey:address] intValue]];
           
           if([idstr isEqualToString:@"0"]){
               idstr = @"1271";
           }
    
           self.smodel.areaId=idstr;
       }
    NSLog(@"%@",idstr);
    
    
    WEAK_SELF
    [self showHub];
    NSDictionary *dic;
    if (isEmpty(self.smodel.areaId)) {
        dic =@{
        @"address":idstr,
        @"major":major,
        @"shopname":name};
    }else{
        dic =@{
        @"address":self.smodel.areaId,
        @"major":major,
        @"shopname":name};
    }
    
    [AFNHttpRequestOPManager postBodyParameters:dic subUrl:@"ShopApi/openingShop" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {

//            NSLog(@"开通开通成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if([resultDic objectForKey:@"params"] && [[resultDic objectForKey:@"params"] isKindOfClass:[NSDictionary class]])
                {
                    OSPayViewController *vc = [[OSPayViewController alloc] init];
                    vc.shopName     = weak_self.osView.nameFiled.text;
                    vc.cateName     = weak_self.osView.majorFiled.text;
                    vc.address      = weak_self.osView.addressBtn.titleLabel.text;
                    vc.ownerName    = [UserModel sharedInstance].truename;
                    if([resultDic[@"params"] objectForKey:@"orderSn"])
                    {
                        vc.orderSn      = resultDic[@"params"][@"orderSn"];
                    }
                    if([resultDic[@"params"] objectForKey:@"totalAmount"])
                    {
                        vc.totalAmount  = resultDic[@"params"][@"totalAmount"];
                    }
                    [weak_self navigatePushViewController:vc animate:YES];
                }
                else
                {
                    
                    for(UIViewController*temp in self.navigationController.viewControllers) {
                        if([temp isKindOfClass:[ManageStoreViewController class]])
                        {
                            [self.navigationController popToViewController:temp animated:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenStoreOk" object:nil];
                            break;
                        }
                    }
                     
                }
                
            });
            
            

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}

#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
#pragma mark ---- 立即开通
- (void)btnClicked:(UIButton *)sender
{
    if(self.osView.nameFiled.text.length == 0 ||
       self.osView.majorFiled.text.length == 0 ||
       [self.osView.addressBtn.titleLabel.text rangeOfString:@"输入"].location != NSNotFound)
    {
        [self showMessage:@"所有选项不能为空"];
    }
    else
    {
        [self requestOfOpenStore:self.osView.nameFiled.text
                           major:self.osView.majorFiled.text
                         address:self.osView.addressBtn.titleLabel.text];
        
    }
}

#pragma mark ------------------------Delegate-----------------------------


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------




@end
