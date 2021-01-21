//
//  PublishGoodsFooterView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletecdIndex)(NSInteger index);

@interface PublishGoodsFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UITextField *originField;//产地
@property (weak, nonatomic) IBOutlet UIButton *originBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *priceBgView;
@property (weak, nonatomic) IBOutlet UILabel *logisticsLabel;//物流
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (nonatomic,copy)SeletecdIndex seletecdIndexBlock;
@end


