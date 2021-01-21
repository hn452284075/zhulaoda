//
//  ConfirmOrderHeaderView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *pushAddressView;
@property (weak, nonatomic) IBOutlet UIView *addressView;

@end

NS_ASSUME_NONNULL_END
