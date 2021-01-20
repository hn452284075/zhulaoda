//
//  ConfirmOderCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *courierLabel;
@property (weak, nonatomic) IBOutlet UILabel *courierPrice;

@property (nonatomic,strong)GoodsModel *model;
@end

NS_ASSUME_NONNULL_END
