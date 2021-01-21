//
//  SetExpressDetailModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetExpressDetailModel : NSObject

@property (nonatomic, strong) NSMutableArray *areaArray;    //地区数组

@property (nonatomic, strong) NSString *default_weight;     //首重
@property (nonatomic, strong) NSString *default_price;      //首重运费

@property (nonatomic, strong) NSString *add_weight;     //增重
@property (nonatomic, strong) NSString *add_price;      //增重运费

@end

NS_ASSUME_NONNULL_END
