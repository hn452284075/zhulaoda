//
//  PublishGoodsHeaderView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishGoodsHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

NS_ASSUME_NONNULL_END
