//
//  TCTGCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/21.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TCTGCellDelegate <NSObject>

- (void)statusBtnChanged:(int)status;  //1--停止 2--重启

@end


@interface TCTGCell : UITableViewCell<TCTGCellDelegate>

@property (nonatomic, weak) id<TCTGCellDelegate> delegate;


- (void)configCellDataBy:(TCTGModel *)model;


@end

NS_ASSUME_NONNULL_END
