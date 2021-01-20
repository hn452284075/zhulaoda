//
//  LogisticsCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogisticModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LogisticsCell : UITableViewCell

@property (strong, nonatomic)UILabel *infoLabel;
@property (strong, nonatomic)UILabel *statusLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UILabel *timeLabel2;
@property (assign, nonatomic) BOOL hasDownLine;
@property (assign, nonatomic) BOOL currented;
@property (nonatomic,assign)NSInteger index;
- (void)reloadDataWithModel:(LogisticModel*)model;
@end

NS_ASSUME_NONNULL_END
