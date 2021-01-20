//
//  WaitingPayTabCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "WaitingPayTabCell.h"

@implementation WaitingPayTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDic:(NSDictionary *)dic{
    [self.orderImage sd_SetImgWithUrlStr:dic[@"picUrl"] placeHolderImgName:@""];
    self.titleLabel.text = dic[@"goodName"];
    self.contentLabel.text = dic[@"specification"];
    self.orderPrice.text = [NSString stringWithFormat:@"￥%@",dic[@"unitPrice"]];
    
    self.actualQuantity.text = [NSString stringWithFormat:@"x%@",dic[@"actualQuantity"]];
    
    
}
@end
