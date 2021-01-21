//
//  GoodsInfoViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoodsInfoViewController : BaseViewController
@property (nonatomic,assign)BOOL isStoreMangerPush;//店铺管理跳转
@property (nonatomic, assign) int goodsID;
@property (nonatomic,strong)NSString *goodsImgUrl;
@end

NS_ASSUME_NONNULL_END
