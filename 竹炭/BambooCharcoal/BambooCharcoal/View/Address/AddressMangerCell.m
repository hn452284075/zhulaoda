//
//  AddressMangerCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AddressMangerCell.h"

@implementation AddressMangerCell
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configData:(UserAddressModel *)model
{
    self.leftName.text = [model.name substringToIndex:1];
    self.ad_NameLabel.text = model.name;
    self.ad_PhoneLabel.text = model.phone;
    self.ad_AddressLabel.text = model.detail_district;
    if([model.isDefault intValue] == 0){
        
        self.ad_Defaultlabel.text=@"";
        self.nameLeft.constant=0;
    }else{
        self.nameLeft.constant=4.5;
        self.ad_Defaultlabel.text=@"  默认  ";
        self.ad_Defaultlabel.backgroundColor = [UIColor colorWithRed:0x46/255. green:0xc6/255. blue:0x7b/255. alpha:0.1];
        self.ad_Defaultlabel.layer.masksToBounds = YES;
        self.ad_Defaultlabel.layer.cornerRadius = 6.0;
        
    }
    self.ad_AddressLabel.text = [NSString stringWithFormat:@"%@ %@",model.district,model.detail_district];
     
}


- (IBAction)ad_deleteAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.delegate address_delete:(int)btn.superview.superview.tag];
}

- (IBAction)ad_editAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.delegate address_edit:(int)btn.superview.superview.tag];
}
@end
