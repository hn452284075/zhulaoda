//
//  WaitingPayAddressView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "WaitingPayAddressView.h"
#import "UIButton+WebCache.h"
@implementation WaitingPayAddressView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDic:(NSDictionary *)dic{
    self.statusLabel.text=dic[@"orderStateTitle"];
    
    if (isEmpty(dic[@"memberAddress"])) {
        if (!isEmpty(dic[@"orderShipment"])) {
            self.userName.text =dic[@"orderShipment"][@"receiverName"];
            self.addressLabel.text =dic[@"orderShipment"][@"receiverAddress"];
            self.phoneLabel.text = dic[@"orderShipment"][@"receiverMobile"];
        }
        
    }else{
        self.userName.text =dic[@"memberAddress"][@"receiverName"];
        self.addressLabel.text =dic[@"memberAddress"][@"addressDetail"];
        self.phoneLabel.text = dic[@"memberAddress"][@"mobile"];
    }
    
    
    [self.storeImage sd_setImageWithURL:[NSURL URLWithString:dic[@"shopLogo"]] forState:UIControlStateNormal placeholderImage:IMAGE(@"login_logo")];
    self.storeName.text = dic[@"shopName"];
}
@end
