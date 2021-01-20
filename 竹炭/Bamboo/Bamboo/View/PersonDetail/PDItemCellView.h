//
//  PDItemCellView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/11.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDItemCellViewDelegate <NSObject>

- (void)PDItemCellViewClicked:(id)sender;

@end


@interface PDItemCellView : UIView<PDItemCellViewDelegate>

@property (nonatomic, strong) id<PDItemCellViewDelegate> delegate;

@property (nonatomic, retain) UIButton  *item_img_btn;
@property (nonatomic, retain) UILabel   *item_msg_lab;
@property (nonatomic, retain) UILabel   *item_price_lab;
@property (nonatomic, retain) UILabel   *item_seen_lab;

@end

NS_ASSUME_NONNULL_END
