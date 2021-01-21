//
//  PayShowView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PayShowView.h"
#import "UIView+Frame.h"
@implementation PayShowView

-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndGoodsNum:(NSString *)num{
     self = [super initWithFrame:frame];
      if (self) {
        
          [self initUI:price AndNum:num];
          [self initPayTypeView];
             
        }
        
        return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndGoodsNum:(NSString *)num WithDetails:(NSString *)detail{
      self = [super initWithFrame:frame];
      if (self) {
          self.details=detail;
          [self initUI:price AndNum:num];
          [self initPayTypeView];
             
        }
        
        return self;
    
}

-(void)initUI:(NSString*)price AndNum:(NSString *)num{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
    [self addSubview:_bgView];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 398)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_bottomView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,0,51, 51);
    [cancelBtn setImage:IMAGE(@"dissImage") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-70, 0, 140, 51)];
    titleLabel.textColor = UIColorFromRGB(0x111111);
    titleLabel.textAlignment=1;
    titleLabel.text = @"确认付款";
    titleLabel.font=CUSTOMFONT(14);
    [_bottomView addSubview:titleLabel];
 
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, kScreenWidth, 0.5)];
    lineView.backgroundColor = KLineColor;
    [_bottomView addSubview:lineView];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, lineView.bottom+57, kScreenWidth, 37)];
      priceLabel.textColor = UIColorFromRGB(0x111111);
      priceLabel.textAlignment=1;
    //富文本
    if (!isEmpty(self.details)) {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",price,_details];
     NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",str]];
     [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36] range:NSMakeRange(0,str.length)];
     [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(price.length,_details.length)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(price.length,_details.length)];
     [priceLabel setAttributedText:tempstr];
    }else{
    priceLabel.text = price;
    priceLabel.font=CUSTOMFONT(36);
    }

    [_bottomView addSubview:priceLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(14.5, 178, 60, 14)];
    numLabel.textColor = UIColorFromRGB(0x9a9a9a);
    numLabel.textAlignment=1;
    numLabel.text = @"订单编号";
    numLabel.font=CUSTOMFONT(14);
    [_bottomView addSubview:numLabel];
    
    UILabel *orderNum = [[UILabel alloc]initWithFrame:CGRectMake(90, 178, kScreenWidth-14-90, 14)];
    orderNum.textColor = UIColorFromRGB(0x121212);
    orderNum.textAlignment=2;
    orderNum.text = num;
    orderNum.font=CUSTOMFONT(14);
    [_bottomView addSubview:orderNum];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, orderNum.bottom+17.5, kScreenWidth, 0.5)];
    lineView2.backgroundColor = KLineColor;
    [_bottomView addSubview:lineView2];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(14.5,lineView2.bottom+17, 60, 14)];
    typeLabel.textColor = UIColorFromRGB(0x9a9a9a);
    typeLabel.textAlignment=1;
    typeLabel.text = @"付款方式";
    typeLabel.font=CUSTOMFONT(14);
    [_bottomView addSubview:typeLabel];
    
    _currentPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _currentPayBtn.frame = CGRectMake(kScreenWidth-110,lineView2.bottom, 80, 47);
    [_currentPayBtn setTitle:@"微信" forState:UIControlStateNormal];
    [_currentPayBtn setImage:IMAGE(@"wechatPay") forState:UIControlStateNormal];
    _currentPayBtn.titleLabel.font=CUSTOMFONT(14);
    [_currentPayBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    [_currentPayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_bottomView addSubview:_currentPayBtn];
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, _currentPayBtn.bottom, kScreenWidth, 0.5)];
    lineView3.backgroundColor = KLineColor;
    [_bottomView addSubview:lineView3];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0,lineView2.bottom, kScreenWidth-10, 47);
    [rightBtn setImage:IMAGE(@"rightArrow") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [self.bottomView addSubview:rightBtn];
    
    //用户协议
//     UIButton *docBtn = [[UIButton alloc] initWithFrame:CGRectMake(41, self.bottomView.height-105, 180, 13)];
//     [self.bottomView addSubview:docBtn];
//      
//     NSString * connectStr = @"请阅读并同意《用户协议》";
//     NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",connectStr]];
//     [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,connectStr.length)];
//     [tempstr addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,6)];
//     [tempstr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(6,connectStr.length-6)];
//     [docBtn setAttributedTitle:tempstr forState:UIControlStateNormal];
//     [docBtn addTarget:self action:@selector(docBtnClicked) forControlEvents:UIControlEventTouchUpInside];

//     //勾选用户协议
//      checkBtn= [[UIButton alloc] initWithFrame:CGRectMake(15, self.bottomView.height-116, 35, 35)];
//     [self.bottomView addSubview:checkBtn];
//
//     [checkBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
//     [checkBtn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateSelected];
//     [checkBtn addTarget:self
//                  action:@selector(checkBtnClicked:)
//        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.frame = CGRectMake(15, 345.5, kScreenWidth-30, 42);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=CUSTOMFONT(16);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundColor:KCOLOR_Main];
    confirmBtn.layer.cornerRadius=21;
    [self.bottomView addSubview:confirmBtn];
    
   
    WEAK_SELF
     [UIView animateWithDuration:0.3 animations:^{
                  
        weak_self.bottomView.frame = CGRectMake(0,kScreenHeight-398, kScreenWidth, 398);
                  
                  
     }completion:^(BOOL finished) {
              
         
         
     }];
 

}

-(void)initPayTypeView{
    self.typeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth,kScreenHeight-270, kScreenWidth, 270)];
    self.typeView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.typeView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-70, 0, 140, 51)];
    titleLabel.textColor = UIColorFromRGB(0x111111);
    titleLabel.textAlignment=1;
    titleLabel.text = @"选择付款方式";
    titleLabel.font=CUSTOMFONT(14);
    [self.typeView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,0,51, 51);
    [backBtn setImage:IMAGE(@"leftBack") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius=3;
    [self.typeView addSubview:backBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backBtn.bottom, kScreenWidth, 0.5)];
    lineView.backgroundColor = KLineColor;
    [self.typeView addSubview:lineView];
    
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(16,lineView.bottom, 90, 48);
    [payBtn setTitle:@"微信" forState:UIControlStateNormal];
    [payBtn setImage:IMAGE(@"wechatPay") forState:UIControlStateNormal];
    payBtn.titleLabel.font=CUSTOMFONT(14);
    [payBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    [payBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    
    [self.typeView addSubview:payBtn];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, payBtn.bottom, kScreenWidth, 0.5)];
    lineView2.backgroundColor = KLineColor;
    [self.typeView addSubview:lineView2];
    
    
    UIButton *alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBtn.frame = CGRectMake(16,lineView2.bottom, 100, 48);
    [alipayBtn setTitle:@"支付宝" forState:UIControlStateNormal];
    [alipayBtn setImage:IMAGE(@"alipay") forState:UIControlStateNormal];
    alipayBtn.titleLabel.font=CUSTOMFONT(14);
    [alipayBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    [alipayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    
    [self.typeView addSubview:alipayBtn];
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, alipayBtn.bottom, kScreenWidth, 0.5)];
    lineView3.backgroundColor = KLineColor;
    [self.typeView addSubview:lineView3];
    
    
    _wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wxBtn.frame = CGRectMake(0,lineView.bottom, kScreenWidth-10, 48);
    [_wxBtn setImage:IMAGE(@"paySeletecd") forState:UIControlStateSelected];
    [_wxBtn addTarget:self action:@selector(typeBtnClick:)
     forControlEvents:UIControlEventTouchUpInside];
    _wxBtn.selected=YES;
    _wxBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [self.typeView addSubview:_wxBtn];
    
    _zfbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _zfbBtn.frame = CGRectMake(0,lineView2.bottom, kScreenWidth-10, 48);
    [_zfbBtn setImage:IMAGE(@"paySeletecd") forState:UIControlStateSelected];
    [_zfbBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _zfbBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [self.typeView addSubview:_zfbBtn];
    
    
    UIButton *confirmTypeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmTypeBtn.frame = CGRectMake(15, 216.5, kScreenWidth-30, 42);
    [confirmTypeBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmTypeBtn.titleLabel.font=CUSTOMFONT(16);
    [confirmTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmTypeBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmTypeBtn setBackgroundColor:KCOLOR_Main];
    confirmTypeBtn.layer.cornerRadius=21;
    [self.typeView addSubview:confirmTypeBtn];
    
}


-(void)typeBtnClick:(UIButton *)btn{
    
    if (btn==_wxBtn) {
        _wxBtn.selected=YES;
        _zfbBtn.selected=NO;
    }else{
        _wxBtn.selected=NO;
        _zfbBtn.selected=YES;
    }
    
}

 


-(void)initAgreement{
    
}

-(void)confirmBtnClick{
    
//    if (!checkBtn.selected) {
//        [[BaseLoadingView sharedManager]showErrorWithStatus:@"请阅读并勾选协议"];
//        return;
//    }
    
    NSInteger type;
    if (_wxBtn.selected) {
        type=2;
    }else{
        type=1;
        
    }
    emptyBlock(self.seletecdTypeBlock,type);
    WEAK_SELF
     [UIView animateWithDuration:0.3 animations:^{
           weak_self.bottomView.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
       } completion:^(BOOL finished) {
           [self removeFromSuperview];
           
    }];
    
}

-(void)docBtnClicked{
    
}
-(void)checkBtnClicked:(UIButton *)btn{
    btn.selected=!btn.selected;
}

-(void)cancelBtnClick{
    __block int a=0;
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.bottomView.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        emptyBlock(self.seletecdTypeBlock,a);
        [self removeFromSuperview];
    }];
    
}

-(void)backBtnClick{
    WEAK_SELF
    
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.typeView.frame  = CGRectMake(kScreenWidth, kScreenHeight-270, kScreenWidth, 270);
    } completion:^(BOOL finished) {
        weak_self.bottomView.hidden=NO;
        if (weak_self.zfbBtn.selected) {
            [weak_self.currentPayBtn setImage:IMAGE(@"alipay") forState:UIControlStateNormal];
            [weak_self.currentPayBtn setTitle:@"支付宝" forState:UIControlStateNormal];
             [weak_self.currentPayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
        }else{
             [weak_self.currentPayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [weak_self.currentPayBtn setImage:IMAGE(@"wechatPay") forState:UIControlStateNormal];
            [weak_self.currentPayBtn setTitle:@"微信" forState:UIControlStateNormal];

        }
    }];
}

-(void)rightBtnClick{
    WEAK_SELF

       [UIView animateWithDuration:0.3 animations:^{
           weak_self.typeView.frame  = CGRectMake(0, kScreenHeight-270, kScreenWidth, 270);
       } completion:^(BOOL finished) {
           
           [UIView animateWithDuration:0.1 animations:^{
                weak_self.bottomView.hidden=YES;
           } completion:^(BOOL finished) {
               
               
               
           }];
           
       }];
}
@end
