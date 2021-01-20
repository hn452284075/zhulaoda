//
//  PublishAppraiseView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PublishAppraiseView.h"

@implementation PublishAppraiseView
-(void)awakeFromNib{
    [super awakeFromNib];
   
}
//描述评分
- (IBAction)describeClick:(UIButton *)sender {
    for (UIButton *btn in _buttonArr) {
         if (btn == sender) {
             btn.selected = YES;
         }else{
             btn.selected = NO;
         }
       }
    NSLog(@"%ld",sender.tag);
}

//货品评分
- (IBAction)huopinClick:(UIButton *)sender {
    for (UIButton *btn in _huopinArr) {
         if (btn == sender) {
             btn.selected = YES;
         }else{
             btn.selected = NO;
         }
       }
    NSLog(@"%ld",sender.tag);
}

//卖家评分
- (IBAction)maijiaClick:(UIButton *)sender {
    for (UIButton *btn in _maijiaArr) {
         if (btn == sender) {
             btn.selected = YES;
         }else{
             btn.selected = NO;
         }
       }
    NSLog(@"%ld",sender.tag);
}
//物流评分
- (IBAction)wuliuClick:(UIButton *)sender {
    for (UIButton *btn in _wuliuArr) {
         if (btn == sender) {
             btn.selected = YES;
         }else{
             btn.selected = NO;
         }
       }
    NSLog(@"%ld",sender.tag);
}

- (IBAction)gongkaiClick:(UIButton *)sender {
    sender.selected=!sender.selected;
}

@end
