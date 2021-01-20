//
//  AdvertisingGoodsCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertisingGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

NS_ASSUME_NONNULL_END
