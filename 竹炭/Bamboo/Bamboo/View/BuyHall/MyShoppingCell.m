//
//  MyShoppingCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "MyShoppingCell.h"

@implementation MyShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic{
    self.name.text = dic[@"title"];
    self.purchaseArea.text = [NSString stringWithFormat:@"%@|%@",dic[@"frequency"],dic[@"purchaseArea"]];
    self.time.text=dic[@"updateTime"];
    self.quotedCount.text=[NSString stringWithFormat:@"%@",dic[@"quotedCount"]];
}
@end
