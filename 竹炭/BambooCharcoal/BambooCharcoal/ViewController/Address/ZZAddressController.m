//
//  ZZAddressController.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 2017/7/20.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "ZZAddressController.h"
#import "Util.h"
#import "IQKeyboardManager.h"
#import "JWAddressPickerView.h"
@interface ZZAddressController ()
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *region;
@property (nonatomic,strong)NSString *detailAddress;
@property (nonatomic, strong) UIButton *goBtn;

@end

@implementation ZZAddressController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KViewBgColor;
    self.pageTitle=@"创建收货地址";
//    if (!isEmpty(self.dic)) {//地址编辑进来
//        self.province = _dic[@"province"];
//        self.city = _dic[@"city"];
//        self.region = _dic[@"region"];
//        self.phone.text = _dic[@"phone"];
//        self.userName.text = _dic[@"name"];
//        self.address.text = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.region];
//        self.detailsAddress.text = [NSString isEmptyForString:_dic[@"detailAddress"]];
//        self.isDefault.on= [_dic[@"receiveStatus"] intValue];
//    }
    
    [self _init];
    
    if(self.uModel != nil)
    {
        self.userName.text = self.uModel.name;
        self.phone.text = self.uModel.phone;
        self.address.text = self.uModel.district;
        if([self.uModel.detail_district rangeOfString:@";"].location != NSNotFound)
            self.detailsAddress.text = [self.uModel.detail_district componentsSeparatedByString:@";"][1];
        else
            self.detailsAddress.text = self.uModel.detail_district;
        if([self.uModel.isDefault intValue] == 0)
        {
            [self.isDefault setOn:NO];
        }
        else{
            [self.isDefault setOn:YES];
        }
    }
    
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
               title:@"确定"
            fontsize:16
              corner:22
                 tag:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}



#pragma mark ------------------------Init---------------------------------
- (void)_init{
    WEAK_SELF
    [self.addressBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        
        [self.view endEditing:YES];
        
        JWAddressPickerView *tmppick = [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {
               
            weak_self.address.text =[NSString stringWithFormat:@"%@ - %@ - %@",province,city,area];
        }];
        if([weak_self.address.text rangeOfString:@" - "].location != NSNotFound)
        {
            NSArray *tmpArray = [weak_self.address.text componentsSeparatedByString:@" - "];
            [tmppick setDefaultPro:tmpArray[0] city:tmpArray[1] town:tmpArray[2]];
        }

    }];
    
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kStatusBarAndNavigationBarHeight-61, kScreenWidth, 61)];
//      bottomView.backgroundColor = [UIColor whiteColor];
//      [self.view addSubview:bottomView];
//
//      UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//      submitBtn.frame = CGRectMake(15, 10.5, kScreenWidth-30, 40);
//      [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
//      submitBtn.titleLabel.font=CUSTOMFONT(14);
//      submitBtn.layer.cornerRadius=3;
//      [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//      [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
//      [submitBtn setBackgroundColor:KCOLOR_Main];
//      [bottomView addSubview:submitBtn];

     _isDefault.transform = CGAffineTransformMakeScale(0.8, 0.8);
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
    [btn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}


- (void)_textFieldDidChange:(UITextField *)textField
{
    
    
    if (textField == self.phone) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}

#pragma mark ------------------------Api----------------------------------
- (void)addAddressInfo:(NSString *)name phone:(NSString *)phone countyId:(NSString *)cid detailStr:(NSString *)dstr isDefault:(int)isdefault
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        
        @"addressDetail"    : dstr,
        @"countyId"         : cid,
        @"mobile"           : phone,
        @"receiverName"     : name,
        @"isDefault"        : [NSNumber numberWithInt:isdefault]
        
    } subUrl:@"userAddress/saveOrUpdate" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue] == 200) {
            [weak_self.delegate addNewUserAddress];
            //确认订单进来回调地址model
            UserAddressModel *model = [[UserAddressModel alloc]init];
            model.ad_id=[resultDic[@"params"][@"id"]intValue];
            model.phone=[NSString stringWithFormat:@"%@",resultDic[@"params"][@"mobile"]];
            model.name=[NSString stringWithFormat:@"%@",resultDic[@"params"][@"receiverName"]];
            model.district=[NSString stringWithFormat:@"%@",resultDic[@"params"][@"addressPrefix"]];
            model.detail_district=[NSString stringWithFormat:@"%@",resultDic[@"params"][@"addressSuffix"]];
            
            emptyBlock(weak_self.orderPageBlock,model);
            [weak_self goBack];
        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}

- (void)editAdressInfo:(NSString *)name phone:(NSString *)phone countyId:(NSString *)cid detailStr:(NSString *)dstr isDefault:(int)isdefault u_id:(int)u_id
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        
        @"id"               : [NSNumber numberWithInt:u_id],
        @"addressDetail"    : dstr,
        @"countyId"         : cid,
        @"mobile"           : phone,
        @"receiverName"     : name,
        @"isDefault"        : [NSNumber numberWithInt:isdefault]
        
    } subUrl:@"userAddress/saveOrUpdate" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue] == 200) {
            [weak_self.delegate addNewUserAddress];
            [weak_self goBack];
        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}



#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
 
    
- (void)submitBtnClick {
    [self.view endEditing:YES];
    
    int isDefaulsStr = -1;
         
         if (self.userName.text.length==0) {
            
             [self showSimplyAlertWithTitle:@"提示" message:@"请输入姓名" sureAction:^(UIAlertAction *action) {
                 
             }];
             
         }else if (self.phone.text.length==0) {
             [self showSimplyAlertWithTitle:@"提示" message:@"请输入手机号" sureAction:^(UIAlertAction *action) {
                            
             }];
             
          
             
         }else if (self.address.text.length==0) {
             [self showSimplyAlertWithTitle:@"提示" message:@"请选择地区" sureAction:^(UIAlertAction *action) {
             }];
           
          }else if(self.detailsAddress.text.length==0){
             [self showSimplyAlertWithTitle:@"提示" message:@"请输入详细地址" sureAction:^(UIAlertAction *action) {
                                       
             }];
            
          }else{
              
              if (![Util isValidateMobile:self.phone.text]) {
                  
                  [self showSimplyAlertWithTitle:@"提示" message:@"手机号格式错误！" sureAction:^(UIAlertAction *action) {
                                                        
                  }];
                  return;
              }
              
           
                              
                 if (_isDefault.isOn) {
                     isDefaulsStr = 1;
                 }else{
                     isDefaulsStr = 0;
                 }
      
             
          }
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProData" ofType:@"plist"];
    NSDictionary *prodic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if(prodic != nil)
    {
        //根据地址查找id
        NSString *idstr = [NSString stringWithFormat:@"%d",[[prodic valueForKey:self.address.text] intValue]];
        
        if([idstr isEqualToString:@"0"])
            idstr = @"1271";
        
        if(self.uModel.name.length > 0)
        {
            [self editAdressInfo:self.userName.text
                           phone:self.phone.text
                        countyId:idstr
                       detailStr:self.detailsAddress.text
                       isDefault:isDefaulsStr u_id:self.uModel.ad_id];
        }
        else
        {
            [self addAddressInfo:self.userName.text
                           phone:self.phone.text
                        countyId:idstr
                       detailStr:self.detailsAddress.text
                       isDefault:isDefaulsStr];
        }
    }
}

@end
