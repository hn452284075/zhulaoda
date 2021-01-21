//
//  CollectStoreCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectStoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImg;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;
@property (weak, nonatomic) IBOutlet UILabel *businessCategory;

@end

NS_ASSUME_NONNULL_END
