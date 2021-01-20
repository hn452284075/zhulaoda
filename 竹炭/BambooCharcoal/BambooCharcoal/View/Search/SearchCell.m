//
//  SearchCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/18.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic{
    [_goodsImage sd_SetImgWithUrlStr:dic[@"picUrl"] placeHolderImgName:nil];
    _goodsName.text = dic[@"goodsName"];
    _quantityLabel.text = [NSString stringWithFormat:@"%@%@起售 %@",dic[@"quantity"],dic[@"unit"],dic[@"updateTime"]];
    _priceLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsPrice"]];
    _unit.text =[NSString stringWithFormat:@"/%@",dic[@"unit"]];
    _addressLabel.text=dic[@"place"];
    if ([dic[@"shopTurnover"] floatValue]>0) {
       _chenjiaoLabel.text = [NSString stringWithFormat:@"成交%.2f元",[dic[@"shopTurnover"]floatValue]];
      }else{
       _chenjiaoLabel.text = @"";
      }
   
    _levelLabel.text = [NSString stringWithFormat:@"    %@级",dic[@"shopLevel"]];
    
}
@end
