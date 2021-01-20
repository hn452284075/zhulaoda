//
//  SupplyGoodsDetailModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/14.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupplyStoreModel.h"
#import "SupplyGEvaluModel.h"
#import "SupplyGDSpceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupplyGoodsDetailModel : NSObject

@property (nonatomic, assign) int goodsID;
@property (nonatomic, strong) NSMutableArray *goodsImgArray;
@property (nonatomic, strong) NSString *goodName;
@property (nonatomic, strong) NSString *accid;
@property (nonatomic, strong) NSString *goodPrice;
@property (nonatomic, strong) NSString *goodUnit;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *viewCount;
@property (nonatomic, strong) NSMutableArray *goodsSpecArray;  //产品规格
@property (nonatomic, strong) NSString *materials;  //物流
@property (nonatomic, strong) NSString *mobile;  
@property (nonatomic, strong) NSMutableArray *evaluateVosArray;  //评价数组
@property (nonatomic, strong) SupplyStoreModel  *storeInfo;   //店铺信息
@property (nonatomic, assign)int collectionState;//是否收藏
@end   

NS_ASSUME_NONNULL_END
