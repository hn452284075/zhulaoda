//
//  visitorRecordCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface visitorRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eysImg;
@property (weak, nonatomic) IBOutlet UILabel *eysInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel_2;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel_3;

@property (weak, nonatomic) IBOutlet UIView *bgview;





@end

NS_ASSUME_NONNULL_END
