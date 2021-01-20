//
//  TCSupplyModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/22.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCSupplyModel : NSObject

@property (nonatomic, assign) int       supply_goodsID;
@property (nonatomic, strong) NSString *supply_imgurl;
@property (nonatomic, strong) NSString *supply_title;
@property (nonatomic, strong) NSString *supply_price;
@property (nonatomic, strong) NSString *supply_unit;

@end

NS_ASSUME_NONNULL_END
