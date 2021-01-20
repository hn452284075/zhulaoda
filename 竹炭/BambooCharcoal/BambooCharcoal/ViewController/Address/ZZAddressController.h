//
//  ZZAddressController.h
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 2017/7/20.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"
#import "UserAddressModel.h"

@protocol ZZAddressDelegate <NSObject>

- (void)addNewUserAddress;

@end

typedef void(^OrderPageBlock)(UserAddressModel *model);//下单页面进去添加第一个地址然后回调

typedef void(^AddressBlock)(NSDictionary *dic);//下单页面无token用户扫一扫进来

@interface ZZAddressController : BaseViewController <ZZAddressDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;

@property (weak, nonatomic) IBOutlet UITextField *detailsAddress;
@property (weak, nonatomic) IBOutlet UISwitch *isDefault;
@property (nonatomic,strong)NSDictionary *dic;
@property (nonatomic,copy)OrderPageBlock orderPageBlock;
@property (nonatomic,copy)AddressBlock   addressBlock;

@property (nonatomic, weak) id<ZZAddressDelegate> delegate;
@property (nonatomic, strong) UserAddressModel *uModel;

@end
