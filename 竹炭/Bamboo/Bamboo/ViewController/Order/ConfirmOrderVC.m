//
//  ConfirmOrderVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "ConfirmOderCell.h"
#import "ConfirmOrderFooterView.h"
#import "PayShowView.h"
#import "ConfirmOrderHeaderView.h"
#import "PayManager.h"
#import "ProcurementOrderVC.h"
#import "StoreModel.h"
#import "GoodsModel.h"
#import "AddressMangerController.h"
#import "UserAddressModel.h"
#import "ZZAddressController.h"
@interface ConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic,strong)UITableView *orderTable;
@property (nonatomic,strong)ConfirmOrderFooterView *footerV;
@property (nonatomic, strong)PayShowView *payView;//支付弹出视图
@property (nonatomic,strong)PayManager *payManager;
@property (nonatomic,strong)NSString *priceStr;//支付金额
@property (nonatomic,strong)NSString *orderNum;//订单号
@property (nonatomic,assign)NSInteger payType;//支付方式
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)NSDictionary *addressDic;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString *totalStr;//总金额
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)ConfirmOrderHeaderView *header;
@property (nonatomic,strong)NSString *addressId;//地址ID
@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KViewBgColor;
    self.addressId=@"";
    self.pageTitle=@"确认订单";
    self.dataArr = [[NSMutableArray alloc]init];
    if (!isEmpty(_goodsDic)) {
        self.typeStr = @"0";
        [self _buyNow];//立即购买进来
        
    }else{
        self.typeStr = @"1";
        [self _settlementOrder];//购物车进来
        
    }
}

#pragma mark ------------------------Init---------------------------------
 
- (void)initUI {
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^{
        
    if (weak_self.orderTable==nil) {
            
    weak_self.orderTable = [[UITableView alloc]initWithFrame:CGRectMake(14, 7, kScreenWidth-28, kScreenHeight-kStatusBarAndNavigationBarHeight-57-7) style:UITableViewStyleGrouped];
    weak_self.orderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [weak_self.view addSubview:weak_self.orderTable];
   weak_self.header  = BoundNibView(@"ConfirmOrderHeaderView", ConfirmOrderHeaderView);
    [weak_self.header addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self _jumpAddressManger];
    }];
    }else{
        [weak_self.orderTable reloadData];
    }
        
        //没有地址就去添加
    if (!isEmpty(self.addressDic[@"address"])) {
        weak_self.header.name.text = self.addressDic[@"name"];
           weak_self.header.phone.text = [NSString stringWithFormat:@"%@",self.addressDic[@"phone"]];
           weak_self.header.address.text = self.addressDic[@"address"];
        weak_self.addressId =self.addressDic[@"id"];
        weak_self.header.pushAddressView.hidden=YES;
        weak_self.header.addressView.hidden=NO;
        weak_self.header.frame =CGRectMake(0, 0, kScreenWidth-28, 100);
    }else{
        weak_self.header.addressView.hidden=YES;
        weak_self.header.frame =CGRectMake(0, 0, kScreenWidth-28, 54);
        weak_self.header.pushAddressView.hidden=NO;
        [weak_self.header addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self _jumpAddressManger];
        }];
    }
   
        
    weak_self.orderTable.tableHeaderView =weak_self.header;
    weak_self.orderTable.showsVerticalScrollIndicator = NO;
    weak_self.orderTable.backgroundColor = [UIColor clearColor];
    weak_self.orderTable.dataSource = weak_self;
    weak_self.orderTable.delegate = weak_self;
    weak_self.orderTable.rowHeight = 121.0f;
    [weak_self.orderTable registerNib:[UINib nibWithNibName:@"ConfirmOderCell" bundle:nil] forCellReuseIdentifier:@"ConfirmOderCell"];
   
    
   weak_self.bottomView  = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight-kStatusBarAndNavigationBarHeight-57, kScreenWidth, 57)];
    weak_self.bottomView.backgroundColor = [UIColor whiteColor];
    weak_self.bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    weak_self.bottomView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    weak_self.bottomView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    weak_self.bottomView.layer.masksToBounds = NO;
    [weak_self.view addSubview:weak_self.bottomView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(27, 19, 40, 17)];
    label.textColor = UIColorFromRGB(0x111111);
    label.textAlignment=1;
    label.text = @"合计:";
    label.font=CUSTOMFONT(16);
    [weak_self.bottomView addSubview:label];
    
    weak_self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 20, 300, 17)];
    weak_self.priceLabel.textColor = UIColorFromRGB(0xFF4807);
    weak_self.priceLabel.textAlignment=0;
    weak_self.priceLabel.font=CUSTOMFONT(16);
    weak_self.priceLabel.text =[NSString stringWithFormat:@"￥%@",weak_self.totalStr];
    [weak_self.bottomView addSubview:weak_self.priceLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(kScreenWidth-99-13, 7.5, 99, 42);
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    submitBtn.titleLabel.font=CUSTOMFONT(18);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setBackgroundColor:KCOLOR_Main];
    submitBtn.layer.cornerRadius=21;
    [weak_self.bottomView addSubview:submitBtn];
    });
        

}

#pragma mark ------------------------Private-------------------------

#pragma mark ------------------------Api----------------------------------
#pragma mark - 立即购买
-(void)_buyNow{
    
    
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:self.goodsDic subUrl:@"orderCart/buyNow" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
       if ([resultDic[@"code"] integerValue]==200) {
            weak_self.addressDic = resultDic[@"params"][@"addressVo"];
            weak_self.dataArr=[StoreModel objectStoreModelWithStoreArr:resultDic[@"params"][@"cartSettleVos"]];
            dispatch_async(dispatch_get_main_queue(), ^{
            weak_self.totalStr = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"total"]];
            });
            [weak_self initUI];
            
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weak_self goBack];
             });
            
        }
        
    }];
    
}
#pragma mark - 结算订单
-(void)_settlementOrder{
    WEAK_SELF
    [self showHub];
    
    [AFNHttpRequestOPManager postBodyParameters:@{@"createOrderShopItemVoList":self.seletecdArray,@"memberAddressId":self.addressId} subUrl:@"orderCart/checkoutCart" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.addressDic = resultDic[@"params"][@"addressVo"];
            weak_self.addressId = [NSString stringWithFormat:@"%@",weak_self.addressDic[@"id"]];
            weak_self.dataArr=[StoreModel objectStoreModelWithStoreArr:resultDic[@"params"][@"cartSettleVos"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            weak_self.totalStr = [NSString stringWithFormat:@"%@",[weak_self reviseString:resultDic[@"params"][@"total"]]];
            });
            [weak_self initUI];
            
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weak_self goBack];
             });
            
        }
        
    }];
}

-(NSString *)reviseString:(NSString *)str
{
 //直接传入精度丢失有问题的Double类型
 double conversionValue = [str doubleValue];
 NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
 NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
 return [decNumber stringValue];
}
#pragma mark - 提交订单
-(void)submitBtnClick{
  
    if (isEmpty(self.header.name.text)) {
        [self showMessage:@"请选择地址"];
        return;
    }
     
        WEAK_SELF
        [self showHub];
    NSString *urlStr= @"user/orders/createOrder";
    
    NSMutableArray *shopNoteVoList = [[NSMutableArray alloc]init];
    NSMutableArray *cartIdsList = [[NSMutableArray alloc]init];
    
    for (int i=0;i<self.dataArr.count;i++) {
        StoreModel *storeModel = self.dataArr[i];
        for (int j=0; j<storeModel.listArr.count; j++) {
            GoodsModel *model =storeModel.listArr[j];
            [cartIdsList addObject:model.goodsId];
        }
        if (i==self.dataArr.count-1) {
            [shopNoteVoList addObject:@{@"shopAccid":storeModel.storeId,@"shopOrderRemark":storeModel.note,@"cartIds":cartIdsList}];
        }
        
    }
    NSLog(@"%@",shopNoteVoList);
    [AFNHttpRequestOPManager postBodyParameters:@{@"memberAddressId":self.addressId,@"createOrderShopItemVoList":shopNoteVoList} subUrl:urlStr block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                weak_self.priceStr= resultDic[@"params"][@"totalAmount"];
                weak_self.orderNum=resultDic[@"params"][@"orderSn"];
                [weak_self showPlayView];
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
  
        

    
    
}

-(void)submitPayRequest{
    NSString *payType;
    if (self.payType==1) {//支付宝支付
        payType = @"PayApi/aliPayOrder";
    }else{
        payType = @"PayApi/commonPayOrder";
    }
    
     
    WEAK_SELF
       dispatch_async(dispatch_get_main_queue(), ^{
       [weak_self showHub];
       [AFNHttpRequestOPManager postBodyParameters:@{@"orderSn":weak_self.orderNum,@"payType":[NSString stringWithFormat:@"%ld",weak_self.payType],@"totalAmount":self.priceStr,@"productType":@"1"} subUrl:payType block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (weak_self.payType==1) {//支付宝支付
                           [weak_self.payManager startAlipayWithPaySignature:resultDic[@"params"] responseBlock:^(PayResponseBaseModel *payResponseModel) {
                           
                                [weak_self _dealPayResultWithResponseModel:payResponseModel];
                           
                           }];
                       }else{
                          //微信支付
                           WXPayRequestModel *wxPayRequestModel = [[WXPayRequestModel alloc] initWithDefaultDataDic:resultDic[@"params"][@"prepareMap"]];
                            [weak_self.payManager startWXinpayWithWxinPreparePayModel:wxPayRequestModel responseBlock:^(PayResponseBaseModel *payResponseModel) {
                                [weak_self _dealPayResultWithResponseModel:payResponseModel];
                            }];
                       }
                   

                       
                   });
                   
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
       });
    
}

#pragma mark - 支付成功回调
- (void)_dealPayResultWithResponseModel:(PayResponseBaseModel *)payResponseModel{
    WEAK_SELF
    if (payResponseModel.payResult == PayResult_Success) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [weak_self showSuccessInfoWithStatus:@"支付成功" disappearTimer:0.5];
            
            ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
            [weak_self navigatePushViewController:vc animate:YES];
                      
        });
        NSLog(@"支付成功");
        
    }else if(payResponseModel.payResult == PayResult_Canceled){
        
        
        NSLog(@"支付取消");
        [weak_self showMessage:@"取消支付"];
        
    }else {
        [weak_self showMessage:@"支付失败"];
        NSLog(@"支付失败");
    }
    
}


#pragma mark ------------------------Page Navigate---------------------------
-(void)_jumpAddressManger{
    
    if (isEmpty(self.addressDic[@"address"])) {
        ZZAddressController *vc = [[ZZAddressController alloc]init];
        WEAK_SELF
        vc.orderPageBlock = ^(UserAddressModel *model) {
            weak_self.header.pushAddressView.hidden=YES;
            weak_self.header.address.hidden=NO;
            weak_self.header.frame =CGRectMake(0, 0, kScreenWidth-28, 100);
            weak_self.header.name.text = model.name;
            weak_self.header.phone.text = model.phone;
            weak_self.header.address.text =[NSString stringWithFormat:@"%@%@",model.district,model.detail_district];
            weak_self.addressId = [NSString stringWithFormat:@"%d",model.ad_id];
            [weak_self.goodsDic setValue:weak_self.addressId forKey:@"memberAddressId"];
            weak_self.dataArr = [[NSMutableArray alloc]init];
            
               if (!isEmpty(weak_self.goodsDic)) {
                 [self _buyNow];//立即购买进来
             }else{
                 [self _settlementOrder];//购物车进来
             }
        };
        [self navigatePushViewController:vc animate:YES];

        
    }else{
    AddressMangerController *vc = [[AddressMangerController alloc]init];
    WEAK_SELF
    vc.addressBlock = ^(UserAddressModel * _Nullable model) {
        weak_self.header.pushAddressView.hidden=YES;
        weak_self.header.address.hidden=NO;
        weak_self.header.frame =CGRectMake(0, 0, kScreenWidth-28, 123);
        weak_self.header.name.text = model.name;
        weak_self.header.phone.text = model.phone;
        weak_self.header.address.text =[NSString stringWithFormat:@"%@%@",model.district,model.detail_district];
        weak_self.addressId = [NSString stringWithFormat:@"%d",model.ad_id];
        [weak_self.goodsDic setValue:weak_self.addressId forKey:@"memberAddressId"];
        weak_self.dataArr = [[NSMutableArray alloc]init];
        
           if (!isEmpty(weak_self.goodsDic)) {
             [self _buyNow];//立即购买进来
         }else{
             [self _settlementOrder];//购物车进来
         }
    };
    [self navigatePushViewController:vc animate:YES];
    
    }

}
#pragma mark ------------------------View Event---------------------------
#pragma mark - 显示支付弹窗
-(void)showPlayView{
    WEAK_SELF
    dispatch_async(dispatch_get_main_queue(), ^(void) {

    weak_self.payView=[[PayShowView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)withGoodsPrice:[NSString stringWithFormat:@"￥%@",weak_self.priceStr] AndGoodsNum:weak_self.orderNum];
    [weak_self.view.window addSubview:weak_self.payView];
    
    weak_self.payView.seletecdTypeBlock = ^(NSInteger type) {
        NSLog(@"%ld",type);
        
        if (type!=0) {
        weak_self.payType = type;
        [weak_self submitPayRequest];
        }
        weak_self.payView=nil;
        [weak_self.payView removeFromSuperview];

    };
 
    });
    
}

 

#pragma mark ------------------------Delegate-----------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, kScreenWidth-28, 42)];
   
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-28, 7)];
    subView.backgroundColor = KViewBgColor;
    [headerView addSubview:subView];
    UIView *whileView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, kScreenWidth-28, 35)];
    whileView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whileView];
    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      maskLayer.frame = whileView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = whileView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
    maskLayer.frame = whileView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    whileView.layer.mask = maskLayer;
    
    StoreModel *model = [self.dataArr objectAtIndex:section];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, 17, 19, 19)];
    [imgView setImage:IMAGE(@"car_hg")];
    [whileView addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 17, kScreenWidth/2, 17)];
    titleLabel.textColor = UIColorFromRGB(0x111111);
    titleLabel.textAlignment=0;
    titleLabel.text =model.storeTitle;
    titleLabel.font=CUSTOMFONT(17);
    [whileView addSubview:titleLabel];
    
    return headerView;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    _footerV = BoundNibView(@"ConfirmOrderFooterView", ConfirmOrderFooterView);
    StoreModel *model = [self.dataArr objectAtIndex:section];
    [_footerV setModel:model];
    return self.footerV;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 104;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    StoreModel *model = [self.dataArr objectAtIndex:section];
    return [model.listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConfirmOderCell *cell = [self.orderTable dequeueReusableCellWithIdentifier:@"ConfirmOderCell" forIndexPath:indexPath];
    StoreModel *model = [self.dataArr objectAtIndex:indexPath.section];
    GoodsModel *goodsModel = model.listArr[indexPath.row];
    [cell setModel:goodsModel];


    return cell;
    
    
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------
 
- (PayManager *)payManager {
    if (!_payManager) {
        _payManager = [PayManager sharedInstance];
    }
    return _payManager;
}

@end
