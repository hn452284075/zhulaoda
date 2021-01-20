//
//  SupplyStoreModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/14.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupplyStoreModel : NSObject

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *accid;
@property (nonatomic, strong) NSString *shopLevel;
@property (nonatomic, strong) NSArray  *shopTagArray;
@property (nonatomic, strong) NSString *logisticsServices;
@property (nonatomic, strong) NSString *sellerServices;
@property (nonatomic, strong) NSString *upToStandard;
@property (nonatomic, strong) NSString *shopIcon;


@end

NS_ASSUME_NONNULL_END
