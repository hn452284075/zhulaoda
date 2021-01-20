//
//  ShowAlertView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ShowAlertView.h"
#import "UIView+Frame.h"
static ShowAlertView *_showAlertView = nil;

@interface ShowAlertView ()
@end

@implementation ShowAlertView
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
       
       dispatch_once(&onceToken, ^{
           
           _showAlertView  = [[ShowAlertView alloc] init];;
           
       });
       
       return _showAlertView;
}

-(void)show:(NSString *)title{

    _viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _viewBG.tag=888;
    _viewBG.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
   
    [[UIApplication sharedApplication].delegate.window addSubview:_viewBG];
    
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-125, kScreenHeight/2-50, 250, 109)];
    _middleView.backgroundColor = [UIColor whiteColor];
    _middleView.layer.cornerRadius=5;
    [_viewBG addSubview:_middleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,_middleView.width, 66)];
    titleLabel.textColor = UIColorFromRGB(0x121212);
    titleLabel.textAlignment=1;
    titleLabel.text = title;
    titleLabel.font=CUSTOMFONT(14);
    [_middleView addSubview:titleLabel];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,titleLabel.bottom, _middleView.width, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_middleView addSubview:lineView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftBtn.frame = CGRectMake(0,lineView.bottom,124, 42.5);
    [leftBtn setTitle:@"我在想想" forState:UIControlStateNormal];
    leftBtn.titleLabel.font=CUSTOMFONT(16);
    [leftBtn setTitleColor:UIColorFromRGB(0x9a9a9a) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setBackgroundColor:[UIColor whiteColor]];
    leftBtn.layer.cornerRadius=5;
    [self.middleView addSubview:leftBtn];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(124,lineView.bottom, 0.5,42.5)];
    lineView2.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [_middleView addSubview:lineView2];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(124.5,lineView.bottom,124, 42.5);
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=CUSTOMFONT(16);
    [rightBtn setTitleColor:UIColorFromRGB(0xFF4807) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundColor:[UIColor whiteColor]];
    rightBtn.layer.cornerRadius=5;
    [self.middleView addSubview:rightBtn];
    
    [self showWithAlert:_middleView];
}

-(void)leftBtnClick{
    emptyBlock(self.seletecdBlock,0);
    [self dismissAlert];
}

-(void)rightBtnClick{
    emptyBlock(self.seletecdBlock,1);
    [self dismissAlert];
}

- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8f;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}

- (void)dismissAlert{
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
        weak_self.middleView.transform = CGAffineTransformMakeScale(.3f, .3f);
        self.middleView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [[[UIApplication sharedApplication].delegate.window viewWithTag:888]removeFromSuperview];
    } ];
    
}


@end
