//
//  openStoreView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/21.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface openStoreView : UIView


@property (weak, nonatomic) IBOutlet UITextField *nameFiled;
@property (weak, nonatomic) IBOutlet UITextField *majorFiled;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *vertifyLab;


@property (weak, nonatomic) IBOutlet UIView *backView1;
@property (weak, nonatomic) IBOutlet UIView *backView2;

@property (weak, nonatomic) IBOutlet UIView *line3view;
@property (weak, nonatomic) IBOutlet UILabel *msgLab1;
@property (weak, nonatomic) IBOutlet UILabel *msgLab2;
@property (weak, nonatomic) IBOutlet UIButton *goVertifyBtn;




@end

NS_ASSUME_NONNULL_END
