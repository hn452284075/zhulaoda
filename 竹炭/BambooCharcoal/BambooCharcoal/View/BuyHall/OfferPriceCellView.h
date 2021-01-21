//
//  OfferPriceCellView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyHallOfferPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OfferPriceCellDelegate <NSObject>

- (void)offerPriceCellChatAction:(UIButton *)btn event:(id)event;

@end

@interface OfferPriceCellView : UIView<OfferPriceCellDelegate>

@property (nonatomic, weak) id<OfferPriceCellDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame offerModel:(BuyHallOfferPriceModel *)model;

@end

NS_ASSUME_NONNULL_END
