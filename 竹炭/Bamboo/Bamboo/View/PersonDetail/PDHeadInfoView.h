//
//  PDHeadInfoView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDHeadInfoView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headimg;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImg;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel_3;


- (void)configViewData:(PersonDetailModel *)model;


@end

NS_ASSUME_NONNULL_END
