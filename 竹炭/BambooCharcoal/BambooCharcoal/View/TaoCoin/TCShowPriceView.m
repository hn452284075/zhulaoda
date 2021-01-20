//
//  TCShowPriceView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCShowPriceView.h"
#import "UIView+Frame.h"
#import "UIView+BlockGesture.h"
@implementation TCShowPriceView
-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndTitle:(NSString *)title{
     self = [super initWithFrame:frame];
      if (self) {
        
          [self initUI:price AndTitle:title];
          
             
        }
        
        return self;
    
}

-(void)initUI:(NSString*)price AndTitle:(NSString *)title{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
    WEAK_SELF
    [_bgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self cancelBtnClick];
    }];
    [self addSubview:_bgView];

    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 226)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:_bottomView];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    titleLabel.textColor = UIColorFromRGB(0x111111);
    titleLabel.textAlignment=1;
    titleLabel.text = title;
    titleLabel.font=CUSTOMFONT(16);
    [self.bottomView addSubview:titleLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,titleLabel.bottom+14, kScreenWidth, 13)];
    contentLabel.textColor = UIColorFromRGB(0x111111);
    contentLabel.textAlignment=1;
    contentLabel.text = @"系统建议出价";
    contentLabel.font=CUSTOMFONT(12);
    [self.bottomView addSubview:contentLabel];
    
    _btn = [[AddAndSubtractButton alloc] initWithFrame:CGRectMake(kScreenWidth/2-177/2, contentLabel.bottom+15, 177, 33)];
    _btn.smallResult=100;
    _btn.currentNum=price;
    _btn.callBack = ^(NSInteger currentNum) {
        NSLog(@"%ld",currentNum);
    };
    [self.bottomView addSubview:_btn];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-150/2, _btn.bottom+10, 150, 13)];
    label.textColor = UIColorFromRGB(0x999999);
    label.textAlignment=1;
    label.text = @"桃币/点击";
    label.font=CUSTOMFONT(12);
    [self.bottomView addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 173, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.bottomView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-0.5,173.5, 0.5,51)];
    lineView2.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.bottomView addSubview:lineView2];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0,lineView.bottom,kScreenWidth/2-0.5, 51);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"不推广" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=CUSTOMFONT(16);
    [cancelBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [_bottomView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(kScreenWidth/2,lineView.bottom,kScreenWidth/2, 51);
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=CUSTOMFONT(16);
    [confirmBtn setTitleColor:UIColorFromRGB(0xFF4706) forState:UIControlStateNormal];
    [_bottomView addSubview:confirmBtn];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
                 
       weak_self.bottomView.frame = CGRectMake(0,kScreenHeight-226, kScreenWidth, 226);
                 
                 
    }completion:^(BOOL finished) {
             
        
        
    }];

}

-(void)cancelBtnClick{
    
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
       weak_self.bottomView.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    } completion:^(BOOL finished) {
       
       [self removeFromSuperview];
    }];
}

-(void)confirmBtnClick{
 
    emptyBlock(self.priceBlock,_btn.currentNum);
    WEAK_SELF
     [UIView animateWithDuration:0.3 animations:^{
           weak_self.bottomView.frame  = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
       } completion:^(BOOL finished) {
           [self removeFromSuperview];
           
    }];
}
@end
