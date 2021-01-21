//
//  SupplyGoodsCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupplyGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_weight;
@property (weak, nonatomic) IBOutlet UILabel *goods_price;
@property (weak, nonatomic) IBOutlet UILabel *goods_unit;
@property (weak, nonatomic) IBOutlet UILabel *goods_total;
@property (weak, nonatomic) IBOutlet UILabel *goods_name;
@property (weak, nonatomic) IBOutlet UILabel *goods_adress;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeft;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn3;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn4;


@end

NS_ASSUME_NONNULL_END
