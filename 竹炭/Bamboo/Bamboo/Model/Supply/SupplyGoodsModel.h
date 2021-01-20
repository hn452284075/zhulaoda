//
//  SupplyGoodsModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupplyGoodsModel : NSObject

@property (nonatomic, assign) int goodsID;     //商品ID
@property (nonatomic, strong) NSString *imgurl;     //图片地址
@property (nonatomic, strong) NSString *title;      //产品文本
@property (nonatomic, strong) NSString *weight;     //起批量  刚刚更新
@property (nonatomic, strong) NSString *price;      //价格
@property (nonatomic, strong) NSString *unit;       //规格 斤、颗
@property (nonatomic, strong) NSString *updateTime;      //更新时间
@property (nonatomic, strong) NSString *total;      //成交总量
@property (nonatomic, strong) NSString *name;       //店铺名
@property (nonatomic, strong) NSString *adress;     //店铺地址
@property (nonatomic, strong) NSMutableArray  *tagArray;   //店铺标签数组

@end

NS_ASSUME_NONNULL_END
