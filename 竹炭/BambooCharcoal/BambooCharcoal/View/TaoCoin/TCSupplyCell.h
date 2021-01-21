//
//  TCSupplyCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/22.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCSupplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCSupplyCell : UITableViewCell

- (void)configCellData:(TCSupplyModel *)model;

@end

NS_ASSUME_NONNULL_END
