//
//  GoodsCategoryModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/16.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCategoryModel : NSObject


@property (nonatomic, assign)   int cateGoryId;
@property (nonatomic, assign)   int parentId;
@property (nonatomic, assign)   int level;
@property (nonatomic, assign)   int hotState;
@property (nonatomic, strong)   NSString *cateGoryName;
@property (nonatomic, strong)   NSString *iconUrl;
@property (nonatomic, assign)   int hasSubCategory;
@property (nonatomic, assign)   int hasTopCategories;
@property (nonatomic, strong)   NSArray<GoodsCategoryModel*> *topCategories;
@property (nonatomic, strong)   NSArray<GoodsCategoryModel*> *subCateGory;


@end

NS_ASSUME_NONNULL_END
