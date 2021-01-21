//
//  SetExpressModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetExpressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetExpressModel : NSObject

@property (nonatomic, strong) NSString *templateName;  //模板名称
@property (nonatomic, strong) NSString *unitPrice;     //计量单位
@property (nonatomic, assign) int tId;     //模板id

@property (nonatomic, strong) NSMutableArray *expressDetailArray; //模板数据


@end

NS_ASSUME_NONNULL_END
