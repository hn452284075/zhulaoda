//
//  PDItemCellView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PDItemCellView.h"

@implementation PDItemCellView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.item_img_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.item_img_btn];
        [self.item_img_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.height.mas_equalTo(frame.size.width);
        }];
        self.item_img_btn.tag = 100;
        [self.item_img_btn addTarget:self action:@selector(itemBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.item_img_btn setBackgroundImage:IMAGE(@"supply_goodsimg") forState:UIControlStateNormal];
                
        
        self.item_msg_lab = [[UILabel alloc] init];
        [self addSubview:self.item_msg_lab];
        [self.item_msg_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.item_img_btn.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.mas_equalTo(35);
        }];
        self.item_msg_lab.numberOfLines = 0;
        self.item_msg_lab.lineBreakMode = NSLineBreakByWordWrapping;
        self.item_msg_lab.font = [UIFont boldSystemFontOfSize:14];
        self.item_msg_lab.textAlignment = NSTextAlignmentLeft;
        self.item_msg_lab.textColor = UIColorFromRGB(0x333333);
//        self.item_msg_lab.text = @"澳大利亚进口大西瓜，不甜不要钱";


        self.item_price_lab = [[UILabel alloc] init];
        [self addSubview:self.item_price_lab];
        [self.item_price_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.item_msg_lab.mas_bottom).offset(10);
            make.left.equalTo(self.item_msg_lab.mas_left).offset(0);
            make.width.mas_equalTo(frame.size.width/2);
            make.height.mas_equalTo(20);
        }];
//        self.item_price_lab.text = @"￥123/斤";
//        NSString *aStr = @"￥123/斤";
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",aStr]];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0,1)];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1,str.length-2)];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(str.length-2,2)];
//        [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0xFF, 0x47, 0x06) range:NSMakeRange(0,str.length)];
//        [self.item_price_lab setAttributedText:str];


        self.item_seen_lab = [[UILabel alloc] init];
        [self addSubview:self.item_seen_lab];
        [self.item_seen_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.item_price_lab.mas_centerY).offset(0);
            make.right.equalTo(self.item_img_btn.mas_right).offset(0);
            make.width.mas_equalTo(frame.size.width/2);
            make.height.mas_equalTo(20);
        }];
        self.item_seen_lab.font = [UIFont boldSystemFontOfSize:10];
        self.item_seen_lab.textAlignment = NSTextAlignmentCenter;
        self.item_seen_lab.textColor = UIColorFromRGB(0x999999);
//        self.item_seen_lab.text = @"8888人看过";
        
    }
    return self;
}


- (void)itemBtnClicked:(id)sender
{
    [self.delegate PDItemCellViewClicked:self];
}


@end
