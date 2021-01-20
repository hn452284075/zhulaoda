//
//  ReturnGoodsHeaderView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReturnGoodsHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *gobackBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fwbLabel;

@end

NS_ASSUME_NONNULL_END
