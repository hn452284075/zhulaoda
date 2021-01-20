//
//  PDBottumInfoView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDBottumInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *msImgview;
@property (weak, nonatomic) IBOutlet UIImageView *wpImgview;
@property (weak, nonatomic) IBOutlet UILabel *msLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;

- (void)configViewText1:(NSString *)str1 text2:(NSString *)str2;


@end

NS_ASSUME_NONNULL_END
