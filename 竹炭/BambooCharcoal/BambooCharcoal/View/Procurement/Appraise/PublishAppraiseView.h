//
//  PublishAppraiseView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PublishAppraiseView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBGViewHeight;
@property (weak, nonatomic) IBOutlet UIView *photoBGView;
@property (weak, nonatomic) IBOutlet UIButton *gongkaiBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArr;//描述按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *huopinArr;//货品按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *maijiaArr;//卖家按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *wuliuArr;//物流按钮数组



@end

NS_ASSUME_NONNULL_END
