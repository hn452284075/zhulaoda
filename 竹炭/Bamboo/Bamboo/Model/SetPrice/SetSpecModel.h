//
//  SetSpecModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/5.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetSpecModel : NSObject

@property (nonatomic, strong) NSString *cateGoryId;
@property (nonatomic, strong) NSString *cateGoryName;
@property (nonatomic, strong) NSMutableArray    *subCateGory;

@end

NS_ASSUME_NONNULL_END
