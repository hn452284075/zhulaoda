//
//  UserAddressModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserAddressModel : NSObject

@property (nonatomic,assign) int ad_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,strong) NSString *detail_district;
@property (nonatomic,strong) NSString *isDefault;

@end

NS_ASSUME_NONNULL_END
