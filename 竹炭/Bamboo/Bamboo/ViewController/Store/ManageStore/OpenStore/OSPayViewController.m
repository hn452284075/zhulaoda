//
//  OSPayViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OSPayViewController.h"
#import "PayShowView.h"
#import "PayManager.h"
#import "ManageStoreViewController.h"

@interface OSPayViewController ()

@property (nonatomic, retain) UIView    *backview;
@property (nonatomic, retain) UIButton  *openBtn;
@property (nonatomic, retain) UIButton  *cancelBtn;
@property (nonatomic,strong)PayShowView *payView;
@property (nonatomic,strong)PayManager *payManager;

@property (nonatomic,assign)NSInteger payType;//支付方式

@end

@implementation OSPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"开通竹商宝";
    self.payType   = 2;
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    [self _initViewInterface];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initViewInterface
{
    self.backview = [[UIView alloc] init];
    self.backview.layer.cornerRadius = 5.0;
    self.backview.layer.masksToBounds = YES;
    self.backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backview];
    
    [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(295);
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"竹商宝";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = UIColorFromRGB(0x343434);
    lab.font = CUSTOMFONT(16);
    [self.backview addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview).offset(38);
        make.left.equalTo(self.backview).offset(0);
        make.right.equalTo(self.backview).offset(0);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *pricelab = [[UILabel alloc] init];
    pricelab.textAlignment = NSTextAlignmentCenter;
    pricelab.textColor = UIColorFromRGB(0x343434);
    pricelab.font = CUSTOMFONT(18);
    [self.backview addSubview:pricelab];
    [pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(20);
        make.left.equalTo(self.backview).offset(15);
        make.right.equalTo(self.backview).offset(-15);
        make.height.mas_equalTo(26);
    }];
    NSString *priceStr = [NSString stringWithFormat:@"￥%@/年",self.totalAmount];
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:34] range:NSMakeRange(1,priceStr.length-3)];
    pricelab.attributedText = tempstr;
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self.backview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pricelab.mas_bottom).offset(40);
        make.left.equalTo(self.backview).offset(0);
        make.right.equalTo(self.backview).offset(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *nameLab = [self getCustomLabel:@"店铺名称" textcolor:0x9a9a9a];
    nameLab.textAlignment = NSTextAlignmentLeft;
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pricelab.mas_bottom).offset(66);
        make.left.equalTo(pricelab.mas_left);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];
    
    UILabel *namevalueLab = [self getCustomLabel:self.shopName textcolor:0x121212];
    namevalueLab.textAlignment = NSTextAlignmentRight;
    [namevalueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pricelab.mas_bottom).offset(66);
        make.right.equalTo(pricelab.mas_right);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];

    UILabel *cateLab = [self getCustomLabel:@"主营品类" textcolor:0x9a9a9a];
    cateLab.textAlignment = NSTextAlignmentLeft;
    [cateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(16);
        make.left.equalTo(pricelab.mas_left);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];

    UILabel *catevalueLab = [self getCustomLabel:self.cateName textcolor:0x121212];
    catevalueLab.textAlignment = NSTextAlignmentRight;
    [catevalueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLab.mas_bottom).offset(16);
        make.right.equalTo(pricelab.mas_right);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];

    UILabel *addrLab = [self getCustomLabel:@"联系地址" textcolor:0x9a9a9a];
    addrLab.textAlignment = NSTextAlignmentLeft;
    [addrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cateLab.mas_bottom).offset(16);
        make.left.equalTo(pricelab.mas_left);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];

    UILabel *addrvalueLab = [self getCustomLabel:self.address textcolor:0x121212];
    addrvalueLab.textAlignment = NSTextAlignmentRight;
    [addrvalueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cateLab.mas_bottom).offset(16);
        make.right.equalTo(pricelab.mas_right);
        make.width.mas_equalTo(kScreenWidth-30-90);
        make.height.mas_equalTo(13);
    }];

    UILabel *personLab = [self getCustomLabel:@"申请人" textcolor:0x9a9a9a];
    personLab.textAlignment = NSTextAlignmentLeft;
    [personLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrLab.mas_bottom).offset(16);
        make.left.equalTo(pricelab.mas_left);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];

    UILabel *personvalueLab = [self getCustomLabel:self.ownerName textcolor:0x121212];
    personvalueLab.textAlignment = NSTextAlignmentRight;
    [personvalueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrLab.mas_bottom).offset(16);
        make.right.equalTo(pricelab.mas_right);
        make.width.equalTo(self.backview.mas_width).dividedBy(2);
        make.height.mas_equalTo(13);
    }];
    
    
    self.openBtn = [[UIButton alloc] init];
    self.openBtn.alpha = 1.0;
    self.openBtn.userInteractionEnabled = YES;
    [self.view addSubview:self.openBtn];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap+2);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap-2);
        make.height.mas_equalTo(43);
    }];

    [self factory_btn:self.openBtn
      backColor:KCOLOR_Main
      textColor:[UIColor whiteColor]
    borderColor:KCOLOR_Main
          title:@"申请开通"
       fontsize:16
         corner:22
            tag:1];
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.alpha = 1.0;
    self.cancelBtn.userInteractionEnabled = YES;
    [self.view addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap+2);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap-2);
        make.height.mas_equalTo(43);
    }];

    [self factory_btn:self.cancelBtn
      backColor:[UIColor clearColor]
      textColor:UIColorFromRGB(0x222222)
    borderColor:kGetColor(0xde, 0xde, 0xde)
          title:@"我再想想"
       fontsize:16
         corner:22
            tag:2];
    
    
}


#pragma mark ------------------------Private------------------------------
- (UILabel *)getCustomLabel:(NSString *)text textcolor:(int)rgb
{
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = UIColorFromRGB(rgb);
    lab.font = CUSTOMFONT(14);
    lab.text = text;
    [self.backview addSubview:lab];
    return lab;
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


#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            [self showPlayView];
        }
            break;
        case 2:
        {
            [self goBack];
        }
            break;
            
        default:
            break;
    }        
}


#pragma mark ------------------------Api----------------------------------
-(void)requstOpenStore{
    
}

#pragma mark ---- 显示支付弹窗---
-(void)showPlayView{
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^(void) {

    weak_self.payView=[[PayShowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)withGoodsPrice:[NSString stringWithFormat:@"￥%@",weak_self.totalAmount] AndGoodsNum:weak_self.orderSn];
    [weak_self.view.window addSubview:weak_self.payView];
    
    weak_self.payView.seletecdTypeBlock = ^(NSInteger type) {
        NSLog(@"%ld",type);
        
        if (type!=0) {
        weak_self.payType = type;
        [weak_self submitPayRequest];
        }
        weak_self.payView=nil;
        [weak_self.payView removeFromSuperview];

    };

    });
    
}

#pragma mark ---- 提交支付---
-(void)submitPayRequest{
 
    
     
   NSString *payType;
       if (self.payType==1) {//支付宝支付
           payType = @"PayApi/aliPayOrder";
       }else{
           payType = @"PayApi/commonPayOrder";
       }
       
        
       WEAK_SELF
          dispatch_async(dispatch_get_main_queue(), ^{
          [weak_self showHub];
          [AFNHttpRequestOPManager postBodyParameters:@{@"orderSn":weak_self.orderSn,@"payType":[NSString stringWithFormat:@"%ld",weak_self.payType],@"totalAmount":weak_self.totalAmount,@"productType":@"1"} subUrl:payType block:^(NSDictionary *resultDic, NSError *error) {
                  [weak_self dissmiss];
                  NSLog(@"resultDic:%@",resultDic);
                  if ([resultDic[@"code"] integerValue]==200) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if (weak_self.payType==1) {//支付宝支付
                              [weak_self.payManager startAlipayWithPaySignature:resultDic[@"params"] responseBlock:^(PayResponseBaseModel *payResponseModel) {
                              
                                   [weak_self _dealPayResultWithResponseModel:payResponseModel];
                              
                              }];
                          }else{
                             //微信支付
                              WXPayRequestModel *wxPayRequestModel = [[WXPayRequestModel alloc] initWithDefaultDataDic:resultDic[@"params"][@"prepareMap"]];
                               [weak_self.payManager startWXinpayWithWxinPreparePayModel:wxPayRequestModel responseBlock:^(PayResponseBaseModel *payResponseModel) {
                                   [weak_self _dealPayResultWithResponseModel:payResponseModel];
                               }];
                          }
                      

                          
                      });
                      
                  }else{
                      [weak_self showMessage:resultDic[@"desc"]];
                  }
                  
              }];
          });
       
    
}

#pragma mark - 支付成功回调
- (void)_dealPayResultWithResponseModel:(PayResponseBaseModel *)payResponseModel{
    WEAK_SELF
    if (payResponseModel.payResult == PayResult_Success) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [weak_self showSuccessInfoWithStatus:@"支付成功" disappearTimer:0.5];
            
//
            for(UIViewController*temp in self.navigationController.viewControllers) {
                if([temp isKindOfClass:[ManageStoreViewController class]])
                {
                    [weak_self.navigationController popToViewController:temp animated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenStoreOk" object:nil];
                    break;
                }else{
                    [weak_self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                }
            }
 
        });
        NSLog(@"支付成功");
        
    }else if(payResponseModel.payResult == PayResult_Canceled){
        
        
        NSLog(@"支付取消");
        [weak_self showMessage:@"取消支付"];
        
    }else {
        [weak_self showMessage:@"支付失败"];
        NSLog(@"支付失败");
    }
    
}

#pragma mark ------------------------Getter / Setter----------------------
- (PayManager *)payManager {
    if (!_payManager) {
        _payManager = [PayManager sharedInstance];
    }
    return _payManager;
}

@end
