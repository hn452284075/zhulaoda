//
//  PersonalDataView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDataView : UIView
@property (weak, nonatomic) IBOutlet UIView *photoBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoBgViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UIButton *userImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *identityBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressField;//所在地
@property (weak, nonatomic) IBOutlet UITextField *identityField;//身份
@property (weak, nonatomic) IBOutlet UITextField *typeField;//主营类
@property (weak, nonatomic) IBOutlet UIButton *regioBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameFiled;


@end

NS_ASSUME_NONNULL_END
