//
//  AddressCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/18.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DeleteBlock)(void);
@interface AddressCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *delBtn;
@property (nonatomic,copy)DeleteBlock deleteBlock;
@end

NS_ASSUME_NONNULL_END
