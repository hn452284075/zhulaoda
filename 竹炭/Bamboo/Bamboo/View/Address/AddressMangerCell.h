//
//  AddressMangerCell.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MannageAddressDelegate <NSObject>

- (void)address_delete:(int)index;
- (void)address_edit:(int)index;

@end


@interface AddressMangerCell : UITableViewCell<MannageAddressDelegate>

@property (nonatomic, weak) id<MannageAddressDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *leftName;
@property (weak, nonatomic) IBOutlet UILabel *ad_Defaultlabel;
@property (weak, nonatomic) IBOutlet UILabel *ad_NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ad_PhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *ad_AddressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

- (IBAction)ad_deleteAction:(id)sender;
- (IBAction)ad_editAction:(id)sender;

- (void)configData:(UserAddressModel *)model;



@end

NS_ASSUME_NONNULL_END
