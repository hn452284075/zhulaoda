//
//  SupplyOrderDetailsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SupplyOrderDetailsVC.h"
#import "ProcurementCell.h"
#import "MycommonTableView.h"
#import "StoreDetailsVC.h"
#import "ReturnGoodsVC.h"
#import "DeliveryShowView.h"
@interface SupplyOrderDetailsVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)NSString *orderNum;
@end

@implementation SupplyOrderDetailsVC

-(void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.listTableView];
    [self removeLine];

    [self _requestOrderData];
    if ([self.orderType isEqualToString:@"0"]) {
        
        [self setIsPushPage:YES];
    }else{
        
        for (UISwipeGestureRecognizer *recognizer in [[self view] gestureRecognizers]) {
            [[self view] removeGestureRecognizer:recognizer];
        }
    }
}
#pragma mark ------------------------Api----------------------------------
-(void)_requestOrderData{
 
    
    
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"displayTabIndex":self.orderType};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"supplier/orders/list" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            if ([[UserModel sharedInstance].phone isEqualToString:@"18670770713"]) {
                [weak_self.listTableView configureTableAfterRequestPagingData:@[]];
            }else{
                 [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"supplierOrderVoIPage"][@"records"]];
            }
            
           
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
     
    
}


#pragma mark ------------------------Page Navigate------------------------
-(void)jumpOrderDetails:(NSString *)orderSn{
    StoreDetailsVC *vc = [[StoreDetailsVC alloc]init];
    vc.isSupplyOrderPush=YES;
    vc.storeOrderSn = orderSn;
    [self navigatePushViewController:vc animate:YES];
}

-(void)jumpStoreDetailsVC{
    StoreDetailsVC *vc = [[StoreDetailsVC alloc]init];
    vc.isSupplyOrderPush=YES;
    [self navigatePushViewController:vc animate:YES];

}
-(void)jumpReturnGoodsVC{
    ReturnGoodsVC *vc = [[ReturnGoodsVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}

#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-39-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.noDataLogicModule.nodataAlertTitle=@"您还没有相关的订单";
        WEAK_SELF
        _listTableView.cellHeightBlock = ^CGFloat(UITableView *tableView, id cellModel) {
            NSDictionary *dic=(NSDictionary *)cellModel;
            if([dic[@"payStatus"]intValue]==0){
                return  218.0f;
            }else{
                //收货状态:0：待发货，1：已发货 ， 2 已收货
               if ([dic[@"receiptStatus"]intValue]==0) {
                   return  273.0f;
               }else{
                   return  218.0f;
               }
                               
               
            }
        };
     
        
        [_listTableView configurecellNibName:@"ProcurementCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            NSDictionary *dic=(NSDictionary *)cellModel;
            ProcurementCell *orderCell =(ProcurementCell *)cell;
            orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [orderCell setStoreDic:dic];
            //付款状态:0:待付款，1：已付款
            if ([dic[@"payStatus"]intValue]==0) {
                orderCell.bottomHeight.constant=0;
            }else{
                //收货状态:0：待发货，1：已发货 ， 2 已收货
                if ([dic[@"receiptStatus"]intValue]==0) {
                    orderCell.bottomHeight.constant=55;
                }else{
                    orderCell.bottomHeight.constant=0;
                }
                
                
            }
            
            //点击每个cell下的按钮操作
            orderCell.buttonTitleBlock = ^(NSString * _Nullable str) {
                weak_self.orderNum = dic[@"orderSn"];
//                weak_self.priceStr = [NSString stringWithFormat:@"%@",dic[@"orderPrice"]];
//                [weak_self buttonclick:str];
                NSDictionary *dic=(NSDictionary *)cellModel;
                           
                [weak_self jumpOrderDetails:dic[@"orderSn"]];
                           
            };
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            NSDictionary *dic=(NSDictionary *)cellModel;
            
            [weak_self jumpOrderDetails:dic[@"orderSn"]];
            

        }];
        
        
        [_listTableView headerRreshRequestBlock:^{
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
            [weak_self _requestOrderData];
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
            [weak_self _requestOrderData];
            
        }];
        
        
        
    }
    
    return _listTableView;
}

#pragma mark ------------------------View Event---------------------------
//- (void)buttonclick:(NSString *)str{
//     if ([str isEqualToString:@"去发货"]) {
//         [self showDelivery];
//     }
//
//}
//
////发货视图
//-(void)showDelivery{
//
//    DeliveryShowView *showView=[[DeliveryShowView alloc]initWithDeliveryFrame:CGRectMake(0, -kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight)];
//    WEAK_SELF
//   showView.deliveryBlock = ^(NSString *company, NSString *num) {
//       NSLog(@"%@,%@",company,num);
//       [weak_self postCompany:company AndNum:num];
//   };
//   [self.view addSubview:showView];
//}
 
#pragma mark ------------------------Api----------------------------------
-(void)postCompany:(NSString *)company AndNum:(NSString *)num{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"shipChannelName":company,@"shipSn":num,@"orderSn":self.orderNum};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"supplier/orders/shipOrder" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
        
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}
 

@end
