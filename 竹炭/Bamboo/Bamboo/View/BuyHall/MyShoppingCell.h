//
//  MyShoppingCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyShoppingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *purchaseArea;
@property (weak, nonatomic) IBOutlet UILabel *requirements;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *quotedCount;
@property (nonatomic,strong)NSDictionary *dic;
@end

NS_ASSUME_NONNULL_END
