//
//  ShopCartManger+request.h
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/29.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "ShopCartManger.h"
#import "StoreModel.h"
#import "GoodsModel.h"
typedef void(^JoinShopCartBlock)(BOOL isSuccess ,NSString *statusStr);

typedef void(^RequestShopCartBlock)(BOOL isSuccess);

typedef void(^ClearShopCartBlock)(BOOL isClear);

typedef void(^DeleteShopCartBlock)(BOOL isDelete);

typedef void(^AdjustShopCartBlock)(BOOL isAdjust,NSString *statusStr);

typedef void(^ShopCartNumBlock)(NSString *numStr);
@interface ShopCartManger (request)

/**
 *  详情添加购物车数据
 */
- (void)requestJoinShopCartData:(NSString *)goodsId
                     AndisLease:(BOOL)lease
           requestShopCartBlock:(JoinShopCartBlock)requestShopCartBlock;

/**
 *  添加购物车数据
 */
- (void)requestJoinShopCartData:(NSString *)goodsId
           requestShopCartBlock:(JoinShopCartBlock)requestShopCartBlock;

/**
 *  请求购物车数据
 */
- (void)requestShopCartAllData:(RequestShopCartBlock)requestShopCartBlock;

/**
 *  清除服务器购物车
 */
- (void)requestClearShopCartData:(ClearShopCartBlock)clearShopCartBlock;

/**
 *  删除购物车商品
 */
- (void)requestDeleteShopCartGoodsForGoodsIds:(NSMutableArray *)goodsArrIds
deleteShopCartBlock:(DeleteShopCartBlock)deleteShopCartBlock;

/**
 * 购物车总数量
 */
- (void)getCartGoodsAllNumBlock:(ShopCartNumBlock)numBlock;

/**
 *  调整购物车数量
 */
- (void)requestAdjustShopCartGoodsData:(GoodsModel *)model AndGoodsNum:(NSNumber *)num adjustShopCartBlock:(AdjustShopCartBlock)adjustShopCartBlock;


@end
