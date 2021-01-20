//
//  StoreModel.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/29.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel
- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super initWithDefaultDataDic:dic];
    if (self) {
       
        
        if (!isEmpty(dic[@"sellerShop"])) {
        self.storeTitle = dic[@"sellerShop"];
        }else{
        self.storeTitle = dic[@"shopName"];
        }
        
        
        if (!isEmpty(dic[@"cartGoodsVos"])) {
            self.listArr = [[GoodsModel objectGoodsModelWithGoodsArr:dic[@"cartGoodsVos"]] mutableCopy];
        }else{
            self.listArr = [[GoodsModel objectGoodsModelWithGoodsArr:dic[@"cartGoodsVoList"]] mutableCopy];
        }
        self.storeImage = dic[@"shopLogo"];
        
        if (!isEmpty(dic[@"accid"])) {
        self.storeId = dic[@"accid"];
        }else{
        self.storeId = dic[@"shopAccId"];
        }
        self.note = @"";
        self.subTotal = dic[@"subTotal"];
        
    }
    return self;
}
@end


@implementation StoreModel (objectStoreModel)

+ (NSMutableArray *)objectStoreModelWithStoreArr:(NSArray *)storeArr
{

    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:storeArr.count];
    for (NSDictionary *dic in storeArr) {
        StoreModel *model = [[StoreModel alloc] initWithDefaultDataDic:dic];
        [tempArr addObject:model];
    }
    
    return tempArr;
}

@end
