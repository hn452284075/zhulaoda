//
//  CircleChatCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleChatCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *headImgview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIButton *countLabel;




@end

NS_ASSUME_NONNULL_END
