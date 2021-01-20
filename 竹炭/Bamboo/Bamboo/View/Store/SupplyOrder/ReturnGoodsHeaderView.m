//
//  ReturnGoodsHeaderView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ReturnGoodsHeaderView.h"

@implementation ReturnGoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
        NSString *str = @"请在48小时内处理买家的退款请求，您可通过页面下方[联系买家]与买家进行沟通";
    
    // 创建Attributed
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
        // 改变颜色
        [noteStr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(25,6)];
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0X9A9A9A) range:NSMakeRange(0,0)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        paragraphStyle.lineSpacing = 15; // 调整行间距
        
        NSRange range = NSMakeRange(0, [str length]);
        [noteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
        
        _fwbLabel.numberOfLines=2;
        
        _fwbLabel.attributedText = noteStr;
}

@end
