//
//  ClassGoodsVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassGoodsVC : BaseViewController
@property (assign, nonatomic) BOOL isHaveShadow;
@property (assign, nonatomic) BOOL isHaveBGColor;
@property (assign, nonatomic) BOOL isHaveHeaderFooterView;
@property (assign, nonatomic) BOOL isRoundWithHeaerView;

@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, assign) int currentCategoryId;
@property (nonatomic, strong) NSString  *currentCateName;

@property (nonatomic, assign) int jumpFlagValue; //点击具体品类跳转到商品结果页 = 1 或者跳转到采购结果页 = 2


@end

NS_ASSUME_NONNULL_END
