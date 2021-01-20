//
//  BuyHallCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallCell.h"

@implementation BuyHallCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDic:(NSDictionary *)dic{
    
    NSString *picurl = dic[@"picsStr"];
    if([dic[@"picsStr"] rangeOfString:@","].location != NSNotFound)
    {
        picurl = [dic[@"picsStr"] componentsSeparatedByString:@","][0];
    }
    
    if (isEmpty(picurl)) {
        self.goodsNameWidth.constant=kScreenWidth-76;
    }else{
        self.goodsNameWidth.constant=154;
    }
    [self.goodsImage sd_SetImgWithUrlStr:picurl placeHolderImgName:@""];
    self.frequency.text = [NSString stringWithFormat:@" %@   ",dic[@"frequency"]];
    self.goodsName.text = dic[@"title"];
    self.addressName.text = dic[@"purchaseAreaName"];
    self.requirements.text = dic[@"requirements"];
    self.destinationAreaName.text = [dic[@"destinationAreaName"]stringByReplacingOccurrencesOfString:@" - " withString:@""];
    self.userName.text = dic[@"purchaseUsername"];
    NSString *str = dic[@"updateTime"];
    if (str.length>16) {
    self.updateTime.text = [str substringToIndex:16];
    }else{
        self.updateTime.text =str;
    }
    
}

@end
