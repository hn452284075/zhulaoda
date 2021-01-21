//
//  HomeAllCollectionCell.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/20.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "HomeAllCollectionCell.h"
#import "UIImageView+sd_SetImg.h"
@implementation HomeAllCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.layer.cornerRadius=5;

    self.layer.shadowColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:0.05].CGColor;
    self.layer.shadowOffset = CGSizeMake(1,3);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 2;
    self.layer.cornerRadius = 5;
    
}

- (void)setDic:(NSDictionary *)dic{
    //设置UIImageView的填充属性
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;
    [self.goodsImage sd_SetImgWithUrlStr:dic[@"picUrl"] placeHolderImgName:@""];
   self.goodsName.text  = dic[@"goodsName"];
   self.priceLabel.text = [NSString stringWithFormat:@"%@",dic[@"goodsPrice"]];
    self.unit.text = [NSString stringWithFormat:@"/%@",dic[@"unit"]];
    self.totalLabel.text = [NSString stringWithFormat:@"%@人看过",dic[@"viewersCount"]];
}


- (void)configCellData:(SupplyGoodsModel *)model
{
    //设置UIImageView的填充属性
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;
    
    [self.goodsImage sd_SetImgWithUrlStr:model.imgurl placeHolderImgName:nil];
    self.goodsName.text  = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
   
    if([model.adress rangeOfString:@"-"].location !=NSNotFound){
        self.distance.text   = [model.adress stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }else{
        self.distance.text   = model.adress;
    }
    self.totalLabel.text = model.total;
    
}


@end
