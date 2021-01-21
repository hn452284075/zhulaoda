//
//  ShopModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject
@property (nonatomic,strong)NSString *areaId;
@property (nonatomic, strong) NSString *accid;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressMergeName;
@property (nonatomic, strong) NSString *detailedAddress;
@property (nonatomic, assign) int grade;
@property (nonatomic, assign) int ownerRealNameVerifyState;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *ownerRealName;
@property (nonatomic, strong) NSString *shopName;

@property (nonatomic, assign) int openPayState;


@end

NS_ASSUME_NONNULL_END
