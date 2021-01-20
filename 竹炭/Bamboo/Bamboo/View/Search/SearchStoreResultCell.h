//
//  SearchStoreResultCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/29.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchStoreResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *address;

@end

NS_ASSUME_NONNULL_END
