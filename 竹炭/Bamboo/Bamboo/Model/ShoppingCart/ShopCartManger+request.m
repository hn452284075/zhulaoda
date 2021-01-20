//
//  ShopCartManger+request.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/29.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "ShopCartManger+request.h"
#import "GlobeMaco.h"
#import "AFNHttpRequestOPManager.h"
@implementation ShopCartManger (request)
/**
 *  详情添加购物车数据
 */
- (void)requestJoinShopCartData:(NSString *)goodsId
                     AndisLease:(BOOL)lease
           requestShopCartBlock:(JoinShopCartBlock)requestShopCartBlock{
    
    NSString *is_rented;
    if (lease) {
        is_rented = @"0";
    }else{
        is_rented = @"1";
        
    }
    
  
    
    NSDictionary  *requestParam  = @{@"module":@"cart",@"act":@"addtocart",@"goods_id":goodsId,@"num":@"1",@"buyer_id":@"",@"is_rented":@""};
    
    
    [AFNHttpRequestOPManager postWithParameters:requestParam subUrl:nil block:^(NSDictionary *resultDic, NSError *error) {
        
        if ([resultDic[@"code"] integerValue]==200) {
            
            requestShopCartBlock(YES,resultDic[@"desc"]);
            
        }else{
            requestShopCartBlock(NO,resultDic[@"desc"]);
        }
        
    }];
    
}

/**
 *  添加购物车数据
 */
- (void)requestJoinShopCartData:(NSString *)goodsId
           requestShopCartBlock:(JoinShopCartBlock)requestShopCartBlock{

 
    
     NSDictionary  *requestParam  = @{@"module":@"cart",@"act":@"addtocart",@"goods_id":goodsId,@"num":@"1",@"buyer_id":@"",@"is_rented":@"0"};
    
    
    [AFNHttpRequestOPManager postWithParameters:requestParam subUrl:nil block:^(NSDictionary *resultDic, NSError *error) {
        
        if ([resultDic[@"code"] integerValue]==200) {
            
            requestShopCartBlock(YES,resultDic[@"desc"]);

        }else{
            requestShopCartBlock(NO,resultDic[@"desc"]);
        }
        
    }];

}
/**
 *  请求购物车数据
 */
- (void)requestShopCartAllData:(RequestShopCartBlock)requestShopCartBlock{
    
   self.goodsShopCartArray = [NSMutableArray array];
    WEAK_SELF
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"orderCart/list" block:^(NSDictionary *resultDic, NSError *error) {

        if ([resultDic[@"code"] integerValue]==200) {

            NSLog(@"%@",resultDic);
            weak_self.goodsShopCartArray = [StoreModel objectStoreModelWithStoreArr:resultDic[@"params"]];
            
            requestShopCartBlock(YES);
        }else{
            requestShopCartBlock(NO);
        }

    }];


}

/**
 *  清除服务器购物车
 */
- (void)requestClearShopCartData:(ClearShopCartBlock)clearShopCartBlock{

 
 
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"orderCart/clearCart" block:^(NSDictionary *resultDic, NSError *error) {
        
        if ([resultDic[@"code"] integerValue]==200) {
            
            NSLog(@"%@",resultDic);
          
            clearShopCartBlock(YES);
        }else{
            clearShopCartBlock(NO);
        }
        
    }];
    


}

/**
 *  删除购物车商品
 */
- (void)requestDeleteShopCartGoodsForGoodsIds:(NSMutableArray *)goodsArrIds
                          deleteShopCartBlock:(DeleteShopCartBlock)deleteShopCartBlock{

//    NSDictionary  *requestParam  = @{@"module":@"cart",@"act":@"dropcart",@"buyer_id":@"",@"goods_ids":goodsIds};
    
    
    [AFNHttpRequestOPManager postBodyParameters:goodsArrIds subUrl:@"orderCart/deleteCart" block:^(NSDictionary *resultDic, NSError *error) {
        
        if ([resultDic[@"code"] integerValue]==200) {
            
            deleteShopCartBlock(YES);
        }else{
            deleteShopCartBlock(NO);
        }
        
    }];


}
/**
 * 购物车总数量
 */
- (void)getCartGoodsAllNumBlock:(ShopCartNumBlock)numBlock{
    
    
    
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"orderCart/userCartCount" block:^(NSDictionary *resultDic, NSError *error) {
        
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            numBlock([NSString stringWithFormat:@"%@",resultDic[@"params"]]);
            
        }else{
            numBlock(@"0");
        }
        
    }];
    
}


/**
 *  调整购物车数量
 */
- (void)requestAdjustShopCartGoodsData:(GoodsModel *)model AndGoodsNum:(NSNumber *)num adjustShopCartBlock:(AdjustShopCartBlock)adjustShopCartBlock{
    
    
    NSDictionary  *requestParam  = @{@"cartId":model.goodsId,@"number":num,@"specificationId":model.specificationId};
    
    
    [AFNHttpRequestOPManager postWithParameters:requestParam subUrl:@"orderCart/updateCartNumber" block:^(NSDictionary *resultDic, NSError *error) {
        
        NSLog(@"%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
 
            adjustShopCartBlock(YES,resultDic[@"desc"]);
        }else{
            adjustShopCartBlock(NO,resultDic[@"desc"]);
        }
        
    }];

    
}
@end
