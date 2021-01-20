//
//  PublishProcurementView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletecdIndexBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface PublishProcurementView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *photoBgView;
@property (nonatomic,copy)SeletecdIndexBlock seletecdIndexBlock;//采购商品，数量，地区，频次回调
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//品类
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;//单位
@property (weak, nonatomic) IBOutlet UITextField *numField;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;//地区
@property (weak, nonatomic) IBOutlet UILabel *countLabel;//采购频次
@property (weak, nonatomic) IBOutlet UITextField *regionField;//送货地区
@property (weak, nonatomic) IBOutlet UITextView *requireTextView;//采购要求
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;//发布
@property (weak, nonatomic) IBOutlet UIButton *regionBtn;

@end

NS_ASSUME_NONNULL_END
