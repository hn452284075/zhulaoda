//
//  ConfirmOrderFooterView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConfirmOrderFooterView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *noteField;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong)StoreModel *model;
@end

NS_ASSUME_NONNULL_END
