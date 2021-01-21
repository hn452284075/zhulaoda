//
//  BuyHallInfoModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyHallInfoModel : NSObject

@property (nonatomic, strong) NSString  *info_id;           //ID
@property (nonatomic, strong) NSString  *info_title;        //发布的标题
@property (nonatomic, strong) NSString  *info_period;       //求购周期--每月
@property (nonatomic, strong) NSString  *info_addr_get;     //采购地区
@property (nonatomic, strong) NSString  *info_addr_go;      //送货地区
@property (nonatomic, strong) NSString  *info_msg;          //求购的详细信息
@property (nonatomic, strong) NSArray   *info_imageArray;   //求购的图片列表
@property (nonatomic, strong) NSString  *info_publisher;    //发布人
@property (nonatomic, strong) NSString  *info_publishTime;  //发布时间
@property (nonatomic, strong) NSString  *info_seenCount;    //看过人数
@property (nonatomic, strong) NSString  *info_priceCount;   //报价人数
@property (nonatomic, strong) NSString  *info_unit;         //单位

@end

NS_ASSUME_NONNULL_END
