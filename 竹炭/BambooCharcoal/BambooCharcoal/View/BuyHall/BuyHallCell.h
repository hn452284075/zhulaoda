//
//  BuyHallCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BuyHallCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *frequency;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UILabel *requirements;
@property (weak, nonatomic) IBOutlet UILabel *destinationAreaName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (nonatomic,strong)NSDictionary *dic;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameWidth;

@end

NS_ASSUME_NONNULL_END
