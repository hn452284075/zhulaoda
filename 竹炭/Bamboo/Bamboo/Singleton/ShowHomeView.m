//
//  ShowHomeView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ShowHomeView.h"
#import "UIView+Frame.h"
#import "UIView+BlockGesture.h"
static ShowHomeView *_showHomeView = nil;
@implementation ShowHomeView

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
       
       dispatch_once(&onceToken, ^{
           
           _showHomeView = [[ShowHomeView alloc] init];
           
       });
       
       return _showHomeView;
}

-(void)showLeftTile:(NSString *)letf withRight:(NSString *)right AndBlock:(SeletecdIndexBlock)block{
    
     _viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
       _viewBG.tag=111;
    WEAK_SELF
    [_viewBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self  closeBtnClick];
    }];
       _viewBG.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
       [[UIApplication sharedApplication].delegate.window addSubview:_viewBG];
       
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 235)];
     self.bottomView.backgroundColor = [UIColor whiteColor];
     self.bottomView.tag=999;
        //UIView设置阴影UIColorFromRGB(0xacacac).CGColor;
     self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
     self.bottomView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
     self.bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
     self.bottomView.layer.shadowRadius = 5;//阴影半径，默认3
     self.bottomView.layer.masksToBounds = NO;
     [_viewBG addSubview:self.bottomView];
    
      //图片在上 文字在下
      UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      leftBtn.frame = CGRectMake(0,39,kScreenWidth/2, 95);
      leftBtn.titleLabel.font = [UIFont systemFontOfSize:18];
      [leftBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
      [leftBtn setImage:IMAGE(letf) forState:UIControlStateNormal];
      [leftBtn setTitle:letf forState:UIControlStateNormal];
      [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
      CGFloat offset = 15.0f;
      leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -leftBtn.imageView.frame.size.width, -leftBtn.imageView.frame.size.height-offset, 0);
      leftBtn.imageEdgeInsets = UIEdgeInsetsMake(-leftBtn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -leftBtn.titleLabel.intrinsicContentSize.width);
      
      [_bottomView addSubview:leftBtn];
      
    
      
      UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      rightBtn.frame = CGRectMake(kScreenWidth/2,39,kScreenWidth/2, 95);
      rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
      [rightBtn setTitle:right forState:UIControlStateNormal];
      [rightBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
      [rightBtn setImage:IMAGE(right) forState:UIControlStateNormal];
      [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
      rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -rightBtn.imageView.frame.size.width, -rightBtn.imageView.frame.size.height-offset, 0);
      rightBtn.imageEdgeInsets = UIEdgeInsetsMake(-rightBtn.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -rightBtn.titleLabel.intrinsicContentSize.width);
      [_bottomView addSubview:rightBtn];

//    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,leftBtn.bottom+15, rightBtn.width, 13)];
//    leftLabel.textColor = UIColorFromRGB(0x999999);
//    leftLabel.textAlignment=1;
//    leftLabel.text = @"让百万供应商为你报价";
//    leftLabel.font=CUSTOMFONT(12);
//    [_bottomView addSubview:leftLabel];
//    
//    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightBtn.left,rightBtn.bottom+15, rightBtn.width, 13)];
//    rightLabel.textColor = UIColorFromRGB(0x999999);
//    rightLabel.textAlignment=1;
//    rightLabel.text = @"让千万采购商找到你";
//    rightLabel.font=CUSTOMFONT(12);
//    [_bottomView addSubview:rightLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 182, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    [_bottomView addSubview:lineView];
    
    
  
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 182.5, kScreenWidth, 53);
    if ([right isEqualToString:@"朋友圈"]) {
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    }else{
         [closeBtn setImage:IMAGE(@"closebtn") forState:UIControlStateNormal];
    }
    
    closeBtn.titleLabel.font = CUSTOMFONT(15);
    [closeBtn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setBackgroundColor:[UIColor whiteColor]];
    
    [_bottomView addSubview:closeBtn];
    
    [UIView animateWithDuration:0.3 animations:^{
             
        weak_self.bottomView.frame = CGRectMake(0, kScreenHeight-235, kScreenWidth, 235);
             
             
    } completion:^(BOOL finished) {
         
         
    }];
     self.seletecdIndexBlock =block;
}

-(void)leftBtnClick{
    emptyBlock(self.seletecdIndexBlock,2);
    [self colse];
}
-(void)rightBtnClick{
    emptyBlock(self.seletecdIndexBlock,1);
    [self colse];
}

-(void)closeBtnClick{
    emptyBlock(self.seletecdIndexBlock,0);
    [self colse];
}

- (void)colse{
    WEAK_SELF
 [UIView animateWithDuration:0.3 animations:^{
     
     weak_self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 235);
     

 } completion:^(BOOL finished) {
      [[[UIApplication sharedApplication].keyWindow viewWithTag:111] removeFromSuperview];
 }];
     
}
@end
