//
//  WaitingPayTotalView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitingPayTotalView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBGTop;

@end

NS_ASSUME_NONNULL_END
