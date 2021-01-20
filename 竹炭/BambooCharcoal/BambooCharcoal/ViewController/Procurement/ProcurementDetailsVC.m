//
//  ProcurementDetailsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ProcurementDetailsVC.h"
#import "ProcurementCell.h"
#import "MycommonTableView.h"
#import "WaitingPayDetailsVC.h"
#import "CancelPopView.h"
#import "PayShowView.h"
#import "PayManager.h"
@interface ProcurementDetailsVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)NSString *orderNum;
@property (nonatomic,strong)NSString *parentOrderSn;
@property (nonatomic,strong)PayShowView *payView;
@property (nonatomic,strong)NSString *priceStr;//支付金额
@property (nonatomic,assign)NSInteger payType;//支付方式
@property (nonatomic,strong)PayManager *payManager;
@end

@implementation ProcurementDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.view addSubview:self.listTableView];
    
    
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
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/list" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                NSLog(@"%@",[UserModel sharedInstance].phone);
//                if ([[UserModel sharedInstance].phone isEqualToString:@"18670770713"]) {
//                    [weak_self.listTableView configureTableAfterRequestPagingData:@[]];
//                }else{
                 [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"userOrderVoIPage"][@"records"]];
//                }
                 
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    
    
}

#pragma mark ---确认收货
-(void)confirmGoods{
    
        WEAK_SELF
        [self showHub];
        NSDictionary *param = @{@"orderSn":self.parentOrderSn};
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/confirmReceipt" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                                      
                    [weak_self showMessage:@"收货成功"];
               });
               [weak_self againRefreshData];
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    
}

#pragma mark ---取消订单
-(void)cancelOrder{
    WEAK_SELF
     [[CancelPopView sharedInstance]show:^(NSString *type) {
        [weak_self showHub];
         NSDictionary *param = @{@"orderSn":weak_self.parentOrderSn,@"cancelRemark":type};
           [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/cancel" block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [weak_self showMessage:@"取消订单成功"];
                   });
                   [weak_self againRefreshData];
                  
                   
                   
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
    }];
    
 
}



#pragma mark ------------------------Page Navigate------------------------
-(void)jumpWaitingPayDetailsVC:(NSString *)num{//待付款
    WaitingPayDetailsVC *vc = [[WaitingPayDetailsVC alloc]init];
    vc.orderNum = num;
    [self navigatePushViewController:vc animate:YES];

}

 
#pragma mark ------------------------Private-------------------------
-(void)againRefreshData{
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self _requestOrderData];
}



#pragma mark ------------------------View Event---------------------------
- (void)buttonclick:(NSString *)str{
    WEAK_SELF
    if ([str isEqualToString:@"付款"]) {
        [self showPlayView];
    }else if ([str isEqualToString:@"取消订单"]){
        
        [self showSimplyAlertWithTitle:@"提示" message:@"确定取消订单吗?" sureAction:^(UIAlertAction *action) {
        [weak_self cancelOrder];
        } cancelAction:^(UIAlertAction *action) {
            
        }];
        
        
    }else if ([str isEqualToString:@"查看物流"]){
        
    }else if ([str isEqualToString:@"提醒发货"]){
        [self showMessage:@"提醒成功"];
    }else if ([str isEqualToString:@"确认收货"]){
        
        [self showSimplyAlertWithTitle:@"提示" message:@"是否确认收货？" sureAction:^(UIAlertAction *action) {
            [weak_self confirmGoods];
        } cancelAction:^(UIAlertAction *action) {
            
        }];
    }
    
}

#pragma mark ---- 显示支付弹窗---
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
#pragma mark ---- 提交支付---
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
            [weak_self againRefreshData];
 
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


#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 273.0f;
        WEAK_SELF
//       _listTableView.cellHeightBlock = ^CGFloat(UITableView *tableView, id cellModel) {
//           NSDictionary *dic=(NSDictionary *)cellModel;
//           if([dic[@"orderStatus"]intValue]==1){
//               return  218.0f;
//           }else{
//              return  273.0f;
//           }
//       };
        
       _listTableView.noDataLogicModule.nodataAlertTitle=@"您还没有相关的订单";
        
        
        [_listTableView configurecellNibName:@"ProcurementCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            ProcurementCell *orderCell =(ProcurementCell *)cell;
            orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dic=(NSDictionary *)cellModel;
            [orderCell setMeOrderDic:dic];
               
           
            //点击每个cell下的按钮操作
            orderCell.buttonTitleBlock = ^(NSString * _Nullable str) {
                 weak_self.orderNum = dic[@"parentOrderSn"];
                weak_self.parentOrderSn=dic[@"orderSn"];
                 weak_self.priceStr = [NSString stringWithFormat:@"%@",dic[@"orderPrice"]];
                 [weak_self buttonclick:str];
                     
            };
            
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
             NSDictionary *dic=(NSDictionary *)cellModel;
            [weak_self jumpWaitingPayDetailsVC:dic[@"orderSn"]];
            
          
            
            
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


- (PayManager *)payManager {
    if (!_payManager) {
        _payManager = [PayManager sharedInstance];
    }
    return _payManager;
}
@end
