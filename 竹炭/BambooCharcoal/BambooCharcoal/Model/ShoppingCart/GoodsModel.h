//
//  GoodsModel.h
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/29.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "BaseModel.h"

@interface GoodsModel : BaseModel

@property (nonatomic,copy)NSString * delivery;//物流
@property (nonatomic,copy)NSString *fare;//运费
@property (nonatomic,copy)NSString *storeId;//店铺id
@property (nonatomic,copy)NSString *distance;//距离
@property (nonatomic,copy)NSString *goodsName;//产品名
@property (nonatomic,copy)NSString *name;//产品名
@property (nonatomic,copy)NSString *unit;//单位
@property (nonatomic,copy)NSString *goodsPrice;//产品价格
@property (nonatomic,copy)NSString *price;//产品价格--数据没有统一接口不同参数也不同
@property (nonatomic,copy)NSString *specialPrice;//产品特价
@property (nonatomic,copy)NSString *unitPrice;
@property (nonatomic,copy)NSString *goodsThumb;//产品图片
@property (nonatomic,copy)NSString *goodsId;//产品id
@property (nonatomic,copy)NSString *cartId;//购物车产品id
@property (nonatomic,copy)NSString *specificationId;//规格id
@property (nonatomic,copy)NSString *specName;//规格名称
@property (nonatomic,copy)NSString *productId;//购物车产品id
@property (nonatomic,copy)NSString *shortDesc;//产品简述
@property (nonatomic,copy)NSString *stockNum;//产品库存
@property (nonatomic,copy)NSString *shipping_cost;//运费
@property (nonatomic,copy)NSString *shipping_from;//发货地
@property (nonatomic,copy)NSMutableArray *specificationList;//规格
@property (nonatomic,copy)NSString *quantity;//多少斤起批
@property (nonatomic,copy)NSNumber *goodsNumber;//产品数
@property (nonatomic,copy)NSNumber *oldNumber;//记录修改前的产品数
@property (nonatomic,copy)NSNumber *is_feedback;//是否评价
@property (nonatomic,copy)NSNumber *is_aftersale;//是否已经售后


 @property (nonatomic,assign)CGFloat leaseTextHeight;


#pragma mark - MODIFY
/**
 产品是否有效
 */
@property (nonatomic,getter=isValid)BOOL valid;
/**
 产品是否正在编辑
 */
@property (nonatomic,getter=isEditing)BOOL editing;


@property (nonatomic,copy)NSString *desc;
/**
// *  商品原价，没有经过任何打折和优惠的价格
// */
@property (nonatomic,strong)NSNumber *goodsOriginalPrice;

@end

@interface GoodsModel (objectGoodsModel)

+ (NSArray *)objectGoodsModelWithGoodsArr:(NSArray *)goodsArr;

@end
