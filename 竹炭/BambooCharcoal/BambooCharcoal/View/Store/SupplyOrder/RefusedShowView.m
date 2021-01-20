//
//  RefusedShowView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "RefusedShowView.h"
#import "UIView+Frame.h"
#import "UIView+BlockGesture.h"
@implementation RefusedShowView
-(instancetype)initWithRefusedFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
      if (self) {
        
          [self initUI];
             
        }
        
        return self;
    
}

-(void)initUI{
        
       _viewBG = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.width, self.height)];
       _viewBG.tag=222;
       _viewBG.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
        WEAK_SELF
        [_viewBG addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self colse];
        }];
       [self addSubview:_viewBG];
        
    
        self.bottomView = [[UIView alloc] init];
        self.bottomView.frame = CGRectMake(0,self.height,self.width,226);
        [_viewBG addSubview:self.bottomView];
    
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(14, 50, kScreenWidth-28, 154)];
        _textView.layer.borderWidth=0.5;
        _textView.layer.borderColor=KLineColor.CGColor;
        _textView.layer.cornerRadius=5;
        [_bottomView addSubview:_textView];
    
        self.bottomView.backgroundColor=[UIColor whiteColor];
          UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(13,17, 100, 16)];
          titleLabel.textColor = UIColorFromRGB(0x111111);
          titleLabel.textAlignment=0;
          titleLabel.text = @"拒绝原因";
          titleLabel.font=CUSTOMFONT(16);
          [_bottomView addSubview:titleLabel];
      
          UIButton *determineBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
          determineBtn.frame = CGRectMake(kScreenWidth-13-50, 17, 50, 16);
          [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
          determineBtn.titleLabel.font=CUSTOMFONT(14);
          [determineBtn setTitleColor:KCOLOR_Main forState:UIControlStateNormal];
          [determineBtn addTarget:self action:@selector(determineBtnClick) forControlEvents:UIControlEventTouchUpInside];
          [_bottomView addSubview:determineBtn];
          [UIView animateWithDuration:0.2 animations:^{
               
          weak_self.bottomView.frame = CGRectMake(0,kScreenHeight-226, kScreenWidth, 226);
          
               
           } completion:^(BOOL finished) {
               
           }];

}

- (void)colse{
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
            
           weak_self.bottomView.frame = CGRectMake(0, weak_self.height, kScreenWidth, 0);
            

        } completion:^(BOOL finished) {
             [self removeFromSuperview];
        }];
}

-(void)determineBtnClick{
    if (isEmpty(self.textView.text)) {
        [[BaseLoadingView sharedManager]showMessage:@"请填写拒绝原因"];
        return;
    }
    
    
    emptyBlock(self.deliveryBlock,self.textView.text);
    [self colse];
}
@end
