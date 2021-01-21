//
//  WaitingPayDetailsVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailsVC : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomX;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIView *lineV;
@property (nonatomic,assign)BOOL isSupplyOrderPush;
@property (nonatomic,strong)NSString *storeOrderSn;
@end

NS_ASSUME_NONNULL_END
