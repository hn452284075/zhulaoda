//
//  ChatOnceCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatOnceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *lable_2;
@property (weak, nonatomic) IBOutlet UILabel *label_3;
@property (weak, nonatomic) IBOutlet UILabel *label_4;
@property (weak, nonatomic) IBOutlet UILabel *label_5;
@property (weak, nonatomic) IBOutlet UILabel *label_6;
@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIView *lineview;



- (IBAction)chatBtnClicked:(id)sender;
- (IBAction)callBtnClicked:(id)sender;


@end

NS_ASSUME_NONNULL_END
