//
//  PublishGoodsVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^GoBackBlock)(void);

@interface PublishGoodsVC : BaseViewController
@property (nonatomic,strong)NSString *goodsId;//修改页面进来
@property (nonatomic,copy)GoBackBlock goBackBlock;
@end


