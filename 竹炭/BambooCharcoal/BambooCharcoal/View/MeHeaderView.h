//
//  MeHeaderView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/25.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIView *goodsBtn;
@property (weak, nonatomic) IBOutlet UIView *storeBtn;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIView *certificationView;

@property (weak, nonatomic) IBOutlet UIButton *certificationBtn;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;
@property (weak, nonatomic) IBOutlet UILabel *storeNum;
@property (weak, nonatomic) IBOutlet UILabel *recordsNum;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UIButton *loginoutBtn;

@property (weak, nonatomic) IBOutlet UIButton *vertifyStatusBtn;







@end

NS_ASSUME_NONNULL_END
