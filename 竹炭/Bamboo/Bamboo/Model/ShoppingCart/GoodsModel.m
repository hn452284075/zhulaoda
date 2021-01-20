//
//  GoodsModel.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/29.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "GoodsModel.h"
#import "GlobeMaco.h"
#import "SupplyGDSpceModel.h"
@implementation GoodsModel
- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super initWithDefaultDataDic:dic];
    if (self) {
        self.delivery = dic[@"delivery"];
        self.storeId = dic[@"accid"];
        self.fare = dic[@"fare"];
        self.unit = dic[@"unit"];
        self.distance = dic[@"distance"];
        self.goodsName = dic[@"goodName"];
        self.name = dic[@"goodsName"];
        self.price =dic[@"goodsPrice"];
        self.goodsPrice = dic[@"unitPrice"];
        self.goodsThumb = dic[@"picUrl"];
        if (!isEmpty(dic[@"id"])) {
            self.goodsId = dic[@"id"];
        }else{
            self.goodsId = dic[@"goodsId"];
        }
        self.cartId=dic[@"goodsId"];
        self.shortDesc = dic[@"short_desc"];
        self.stockNum = dic[@"stock"];
        self.unitPrice = dic[@"unitPrice"];
        self.specificationList = dic[@"specificationList"];
        self.quantity = dic[@"quantity"];
        self.specificationId = dic[@"specificationId"];
        self.specName = dic[@"specification"];
        self.shipping_cost = dic[@"shipping_cost"];
        self.shipping_from = dic[@"shipping_from"];
        self.specialPrice = [NSString stringWithFormat:@"%@",dic[@"unitPrice"]];
        self.goodsOriginalPrice = dic[@"unitPrice"];
        self.goodsNumber = dic[@"actualQuantity"];
        self.oldNumber =dic[@"actualQuantity"];
        self.valid = @1;
        self.productId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.is_feedback = dic[@"is_feedback"];
        self.is_aftersale = dic[@"is_aftersale"];
        NSArray *arr = dic[@"specificationList"];
        NSMutableArray *spceArray = [[NSMutableArray alloc]init];
        for (int a=0;a<arr.count;a++) {
           SupplyGDSpceModel *spceModel = [[SupplyGDSpceModel alloc] init];
           NSDictionary *_dic = arr[a];
           spceModel.gs_name               = _dic[@"specification"];
           spceModel.gs_unit_price         = _dic[@"unit_price"];
           spceModel.gs_specificationId    = _dic[@"specificationId"];
           spceModel.gs_selected           = _dic[@"selected"];
           [spceArray addObject:spceModel];
        }
        self.specificationList = spceArray;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeShopCartGoodsEditState:) name:EditorGoodsCenter object:nil];
        
    }
    return self;
}

//- (CGFloat)leaseTextHeight{
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.leaseContent];
//    NSRange range =  NSMakeRange(0,[self.leaseContent length]);
//    [attributedString addAttribute:NSFontAttributeName value:kSystemFontSize(13) range:range];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
//
//    CGFloat textHeight  = [attributedString boundingRectWithSize:CGSizeMake(kScreenWidth-10, 9999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
//    JLog(@"leaseTextHeight%f",textHeight);
//    return textHeight;
//
//}

#pragma mark - EditorGoodsCenter
- (void)observeShopCartGoodsEditState:(NSNotification *)notification{
    BOOL isShopCartEditing = [(NSNumber *)notification.object integerValue];
    if (self.isValid) {
        return;
    }

    self.editing = isShopCartEditing;
    if (!isShopCartEditing) {
        self.selected = NO;
    }
   
}
@end

@implementation GoodsModel (objectGoodsModel)

+ (NSArray *)objectGoodsModelWithGoodsArr:(NSArray *)goodsArr
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:goodsArr.count];
    for (NSDictionary *dic in goodsArr) {
        GoodsModel *model = [[GoodsModel alloc] initWithDefaultDataDic:dic];
        [tempArr addObject:model];
    }
    
    return [tempArr copy];
}
@end
