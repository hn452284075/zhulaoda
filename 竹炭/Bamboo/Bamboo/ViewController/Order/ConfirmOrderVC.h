//
//  ConfirmOrderVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderVC : BaseViewController
@property (nonatomic,strong)NSArray *seletecdArray;
@property (nonatomic,strong)NSMutableDictionary *goodsDic;
@property (nonatomic,strong)NSString *typeStr;
@end

NS_ASSUME_NONNULL_END
