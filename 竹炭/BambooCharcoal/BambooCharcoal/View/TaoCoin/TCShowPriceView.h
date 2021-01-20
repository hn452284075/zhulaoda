//
//  TCShowPriceView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAndSubtractButton.h"
typedef void(^PriceBlock)(NSString *price);

@interface TCShowPriceView : UIView
 
@property (nonatomic,strong)AddAndSubtractButton *btn;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,copy)PriceBlock priceBlock;
-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndTitle:(NSString *)title;
@end


