//
//  WaitingPayInfoView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WaitingPayInfoView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payInfoHeight;
@property (weak, nonatomic) IBOutlet UIButton *courierBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courierViewBGHeight;
 
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UIView *payInfoView;
@property (weak, nonatomic) IBOutlet UILabel *courierLabel;
@property (weak, nonatomic) IBOutlet UILabel *courierNum;
@property (weak, nonatomic) IBOutlet UIView *courierView;
@property (nonatomic,strong)NSArray *arr;
@end

NS_ASSUME_NONNULL_END
