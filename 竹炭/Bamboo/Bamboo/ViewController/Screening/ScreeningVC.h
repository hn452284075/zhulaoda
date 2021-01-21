//
//  ScreeningVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/29.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ScreeningDataBlock)(NSString * _Nullable lowStr,NSString * _Nullable highStr,NSString * _Nullable dayStr);
NS_ASSUME_NONNULL_BEGIN

@interface ScreeningVC : BaseViewController
@property (nonatomic,copy)ScreeningDataBlock screeningDataBlock;
@property (nonatomic,strong)NSString *dayStr;
@end

NS_ASSUME_NONNULL_END
