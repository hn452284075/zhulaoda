//
//  ConfirmOderCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ConfirmOderCell.h"

@implementation ConfirmOderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsModel *)model{
    if ([model.goodsThumb containsString:@"mp4"]) {
        _goodsImage.image=[UIImage thumbnailImageForVideo:[NSURL URLWithString:model.goodsThumb] atTime:1];
    }else{
        [_goodsImage sd_SetImgWithUrlStr:model.goodsThumb placeHolderImgName:@""];
    }
    _goodsImage.contentMode =UIViewContentModeScaleToFill;
      _goodsName.text = model.goodsName;
      _numLabel.text = [NSString stringWithFormat:@"x%d%@",[model.goodsNumber intValue],model.unit];
//      _price.text  = [NSString stringWithFormat:@"￥%@/%@",model.specialPrice,model.unit];
    _courierLabel.text = model.delivery;
    _courierPrice.text = [NSString stringWithFormat:@"%@",model.fare];
    
    NSString *priceStr = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"￥%@/%@",model.specialPrice,model.unit]];
     NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:priceStr];
     [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,model.specialPrice.length)];
    _price.attributedText = tempstr;
    
}

@end
