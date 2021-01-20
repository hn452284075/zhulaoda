//
//  ShopCartCell.h
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 2017/7/25.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAndSubtractButton.h"

typedef void(^SeletedBlock)(UITableViewCell *cell);
typedef void(^GoodsNumBlock)(UITableViewCell *cell,NSNumber *num);

@class GoodsModel;
@interface ShopCartCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet AddAndSubtractButton *addSubtractButton;
@property (weak, nonatomic) IBOutlet UIButton *seletecdBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UIButton *specBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addSubViewWidth;//加减框宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgviewRight;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic,strong)GoodsModel *model;
@property (nonatomic,copy)SeletedBlock seletedBlock;
@property (nonatomic,copy)GoodsNumBlock goodsNumBlock;//加减数量

@property (nonatomic,assign)BOOL isCart;//是否是购物车
@end
