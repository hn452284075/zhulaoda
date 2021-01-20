//
//  BuyHallOfferPriceModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyHallOfferPriceModel : NSObject

@property (nonatomic, strong) NSString  *op_accid;          //ccid
@property (nonatomic, strong) NSString  *op_headImg;        //头像
@property (nonatomic, strong) NSString  *op_name;           //名字
@property (nonatomic, strong) NSString  *op_tag;            //采
@property (nonatomic, strong) NSString  *op_adress;         //地区
@property (nonatomic, strong) NSString  *op_time;           //时间
@property (nonatomic, strong) NSString  *op_price;          //价格
@property (nonatomic, strong) NSString  *op_msg;            //详细信息
@property (nonatomic, strong) NSArray   *op_imageArray;     //图片数组


@end

NS_ASSUME_NONNULL_END
