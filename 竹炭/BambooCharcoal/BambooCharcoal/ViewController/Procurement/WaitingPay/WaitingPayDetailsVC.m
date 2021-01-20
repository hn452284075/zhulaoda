//
//  WaitingPayDetailsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "WaitingPayDetailsVC.h"
#import "HomeAllCollectionCell.h"
#import "WaitingPayTabCell.h"
#import "WaitingPayAddressView.h"
#import "WaitingPayTotalView.h"
#import "WaitingPayTabCell.h"
#import "WaitingPayInfoView.h"
#import "HomeAllCollectionCell.h"
#import "CellCalculateModel.h"
#import "CancelPopView.h"
#import "DeliveryShowView.h"
#import "PublishAppraiseVC.h"
#import "LogisticModel.h"
#import "LogisticsShowView.h"
#import "GoodsInfoViewController.h"
#import "PayShowView.h"
#import "PayManager.h"
@interface WaitingPayDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    UIButton *goBackBtn;
    UILabel  *titleLabel;
}
@property (nonatomic,strong)UICollectionView *detailsCollecView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,strong)WaitingPayAddressView *addressHeaderView;//地址头部
@property (nonatomic,strong)WaitingPayInfoView *infoHeaderView;//支付信息头部
@property (nonatomic,strong)WaitingPayTotalView *totalFooterView;//商品下面的总价尾部
@property (nonatomic,strong)NSMutableArray *dataArray;//物流数组
@property (nonatomic,strong)UIView *topView;
@property(nonatomic ,assign) CGFloat oriOffsetY;
@property (nonatomic,strong)NSDictionary *storeDic;//总数据
@property (nonatomic,strong)NSArray *orderArr;//个人订单
@property (nonatomic,strong)NSArray *likeRecommendGoods;//底部推荐数组
@property (nonatomic,strong)PayShowView *payView;
@property (nonatomic,strong)PayManager *payManager;
@property (nonatomic,strong)NSString *priceStr;//支付金额
@property (nonatomic,assign)NSInteger payType;//支付方式
@end

@implementation WaitingPayDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initCollection];
    [self _initTopView];
    [self getOrderData];
}
 
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}





#pragma mark ------------------------Init---------------------------------
-(void)_initTopView{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:0];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75,kStatusBarAndNavigationBarHeight/2, 150,20)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment=1;
    titleLabel.text = @"订单详情";
    titleLabel.font=CUSTOMFONT(17);
    titleLabel.alpha=0;
    [_topView addSubview:titleLabel];
    
    goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goBackBtn.frame = CGRectMake(10,kStatusBarAndNavigationBarHeight/2, 40, 20);
    [goBackBtn setImage:IMAGE(@"supply_back") forState:UIControlStateNormal];
    [goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:goBackBtn];
    
    [self.view addSubview:_topView];
}
- (void)_initCollection {
    
    [self.view addSubview:self.detailsCollecView];
    
    
    if (@available(iOS 11.0, *)) {
        self.detailsCollecView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    
}
#pragma mark ------------------------Private------------------------------
- (void)setButtonArr:(NSArray *)buttonArr{//后面有时间再去封装

    
        
    // 保存前一个button的宽以及前一个button距离屏幕边缘的距
       CGFloat edge =10;
       //设置button 距离父视图的高
       
       self.bottomX.constant = kScreenWidth-buttonArr.count*87-30-((buttonArr.count-1)*edge);
    
       for (int i =0; i< buttonArr.count; i++) {
           UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
           button.tag =200+i;
           button.backgroundColor =[UIColor whiteColor];
           [button addTarget:self action:@selector(selectClick:) forControlEvents:(UIControlEventTouchUpInside)];
           button.layer.cornerRadius = 15;
          
           //确定文字的字号
           button.titleLabel.font = [UIFont systemFontOfSize:14];

           CGFloat length = 87;
           //为button赋值
           [button setTitle:buttonArr[i] forState:(UIControlStateNormal)];
           if ([button.titleLabel.text isEqualToString:@"付款"]||[button.titleLabel.text isEqualToString:@"确认收货"]||[button.titleLabel.text isEqualToString:@"评价"]){
                [button setTitleColor:[UIColor whiteColor]  forState:(UIControlStateNormal)];
               [button setBackgroundColor:UIColorFromRGB(0x4BC77E)];
           }else{

               button.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
               button.layer.borderWidth = 0.5f;

               [button setTitleColor:UIColorFromRGB(0x666666) forState:(UIControlStateNormal)];
           }
           //设置button的frame
           button.frame =CGRectMake(edge, 13, length, 30);
           
    
           //获取前一个button的尾部位置位置
           edge = button.frame.size.width +button.frame.origin.x+edge;
           
           [self.bottomView addSubview:button];
           
           
       }

        


}


-(void)selectClick:(UIButton *)btn{
    WEAK_SELF
    if ([btn.titleLabel.text isEqualToString:@"评价"]) {
//        PublishAppraiseVC *vc = [[PublishAppraiseVC alloc]init];
//        [self navigatePushViewController:vc animate:YES];

    }else if ([btn.titleLabel.text isEqualToString:@"提醒发货"]){
        [self showMessage:@"提醒成功"];
    }else if ([btn.titleLabel.text isEqualToString:@"取消订单"]){
        
        
       [self showSimplyAlertWithTitle:@"提示" message:@"确定取消订单吗?" sureAction:^(UIAlertAction *action) {
       [weak_self cancelOrder];
       } cancelAction:^(UIAlertAction *action) {
           
       }];
        
    }else if ([btn.titleLabel.text isEqualToString:@"付款"]){
        
        [self showPlayView];
    }else if ([btn.titleLabel.text isEqualToString:@"确认收货"]){
    
        [self showSimplyAlertWithTitle:@"提示" message:@"是否确认收货？" sureAction:^(UIAlertAction *action) {
                   [weak_self confirmGoods];
               } cancelAction:^(UIAlertAction *action) {
                   
        }];
        
    }else{
       
    }
    
}

 

//发货视图
-(void)showDelivery{
    DeliveryShowView *showView=[[DeliveryShowView alloc]initWithDeliveryFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
   showView.deliveryBlock = ^(NSString *company, NSString *num) {
       NSLog(@"%@,%@",company,num);
   };
   [self.view addSubview:showView];
}


 
#pragma mark ------------------------Api----------------------------------
-(void)getOrderData{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"orderSn":self.orderNum};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/detail" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
           weak_self.storeDic=resultDic[@"params"];
            weak_self.likeRecommendGoods = resultDic[@"params"][@"likeRecommendGoods"];
           weak_self.orderArr = resultDic[@"params"][@"orderGoodsVoList"];
           weak_self.priceStr = [NSString stringWithFormat:@"%@",weak_self.storeDic[@"orderPrice"]];

           [weak_self.addressHeaderView setDic:resultDic[@"params"]];
           [weak_self.detailsCollecView reloadData];
            
              
            //orderStatus订单状态:0：正常，1：已失效
            if ([resultDic[@"params"][@"orderStatus"]intValue]==1) {
                weak_self.bottomView.hidden=YES;
                weak_self.detailsCollecView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            }else{
                //payStatus付款状态:0:待付款，1：已付款
                if ([resultDic[@"params"][@"payStatus"]intValue]==1) {
                    
                    //receiptStatus收货状态:0：待发货，1：已发货 ， 2 已收货
                    if ([resultDic[@"params"][@"receiptStatus"]intValue]==1) {
                        [self setButtonArr:@[@"查看物流",@"确认收货"]];
                    }else if ([resultDic[@"params"][@"receiptStatus"]intValue]==2) {
                        [self setButtonArr:@[@"查看物流",@"评价"]];
                    }else{
                        
                        [self setButtonArr:@[@"提醒发货"]];
                    }
                    
                }else{
                    [self setButtonArr:@[@"取消订单",@"付款"]];
                }
                
            }
            
            
            
           //付款状态:0:待付款，1：已付款
           if ([resultDic[@"params"][@"payStatus"]intValue]==0) {
               weak_self.addressHeaderView.deliveryBtn.hidden=YES;
               return;
           }
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}


#pragma mark ---确认收货
-(void)confirmGoods{
    
        WEAK_SELF
        [self showHub];
        NSDictionary *param = @{@"orderSn":self.orderNum};
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/confirmReceipt" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                [weak_self showSuccessInfoWithStatus:@"收货成功"];
                [weak_self.navigationController popToRootViewControllerAnimated:YES];
                
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
         NSDictionary *param = @{@"orderSn":weak_self.orderNum,@"cancelRemark":type};
           [AFNHttpRequestOPManager postWithParameters:param subUrl:@"user/orders/cancel" block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   [weak_self showSuccessInfoWithStatus:@"取消订单成功"];
                   [weak_self.navigationController popToRootViewControllerAnimated:YES];
                   
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
    }];
    
 
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
            [weak_self.navigationController popToRootViewControllerAnimated:YES];
 
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



#pragma mark ------------------------Delegate-----------------------------
#pragma mark 计算滚动的便宜量 scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY=scrollView.contentOffset.y;
    if (offsetY <= 0) {
            _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:0];
            titleLabel.alpha=0;
        } else if (offsetY > 0 && offsetY < kStatusBarAndNavigationBarHeight) {
            
             _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent: offsetY / kStatusBarAndNavigationBarHeight];
    
            titleLabel.alpha= offsetY / kStatusBarAndNavigationBarHeight;

        } else if (offsetY >= kStatusBarAndNavigationBarHeight ) {
            _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:1];
            titleLabel.alpha=1;

        }
}



//设置容器中有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
    return 2;
}
//设置每个组有多少个方块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.orderArr.count;
    }
        return self.likeRecommendGoods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        WaitingPayTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaitingPayTabCell" forIndexPath:indexPath];
         [cell setDic:self.orderArr[indexPath.row]];
          return cell;
    }
    HomeAllCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAllCollectionCell" forIndexPath:indexPath];
    [cell setDic:self.likeRecommendGoods[indexPath.row]];
      return cell;
  
   
}
//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    

    if (kind == UICollectionElementKindSectionHeader) {
            if (indexPath.section==0) {
                self.addressHeaderView  = (WaitingPayAddressView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayAddressView" forIndexPath:indexPath];
                
                
                WEAK_SELF
                
                [self.addressHeaderView.deliveryBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                    NSLog(@"sss");
                    [weak_self showDelivery];
                   
               }];
                
                
                return self.addressHeaderView;
            }else{
                self.infoHeaderView  = (WaitingPayInfoView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayInfoView" forIndexPath:indexPath];
                if (!isEmpty(self.storeDic[@"orderInformations"])) {
                    //失效不显示
//                     if ([self.storeDic[@"orderStatus"]intValue]==0) {
                       NSArray *arr=self.storeDic[@"orderInformations"];
                      [self.infoHeaderView setArr:arr];
                   }
    
                   //待付款 还没有快递物流信息
                   if (!isEmpty(self.storeDic)) {
                       if ([self.storeDic[@"payStatus"]intValue]==0) {
                           self.infoHeaderView.courierViewBGHeight.constant=0;
                           self.infoHeaderView.likeImage.hidden=NO;
                           //订单状态:0：正常，1：已失效
                        if ([self.storeDic[@"orderStatus"]intValue]==1) {
                              self.infoHeaderView.likeImage.hidden=NO;
                              self.infoHeaderView.payInfoHeight=0;
                            self.infoHeaderView.payInfoView.hidden=YES;
                        }
                           
                    }else{
                        //receiptStatus收货状态:0：待发货，1：已发货 ， 2 已收货
                        if ([self.storeDic[@"receiptStatus"]intValue]==0) {
                           self.infoHeaderView.courierViewBGHeight.constant=0;
                           self.infoHeaderView.likeImage.hidden=NO;
                        }else{
                            self.infoHeaderView.courierViewBGHeight.constant=49;
                            self.infoHeaderView.likeImage.hidden=NO;
                            self.infoHeaderView.courierView.hidden=NO;
                            if (!isEmpty(self.storeDic[@"orderShipment"])) {
                                
                            
                            if (!isEmpty(self.storeDic[@"orderShipment"][@"shipCompanyName"])) {
                            self.infoHeaderView.courierLabel.text = [NSString stringWithFormat:@"%@",self.storeDic[@"orderShipment"][@"shipCompanyName"]];
                            }
                            if (!isEmpty(self.storeDic[@"orderShipment"][@"shipTrackingNumber"])) {
                                self.infoHeaderView.courierNum.text =[NSString stringWithFormat:@"%@",self.storeDic[@"orderShipment"][@"shipTrackingNumber"]];;
                            }
                            }
                            
                        }
                   }
                   
               }
                
                //物流
                [self.infoHeaderView.courierBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                    self.dataArray=[[NSMutableArray alloc]init];
                    NSArray *arr = @[@"北包裹正在等待揽收",@"[太原市]百世快递 阳曲收件员 已揽件",@"[太原市]阳曲 已发出[太原市]阳曲 已发出[太原市]阳曲 已发出[太原市]阳曲 已发出[太原市]阳曲 已发出[太原市]阳曲 已发出[太原市]阳曲 已发出",@"[太原市]快件已到达 太原转运中心",@"[太原市]太原转运中心 已发出",@"到济南市【济南转运中心】",@"[济南市]快件已到达 济南转运中心", @"[济南市]【已签收，签收人是拍照签收】，感谢使用百世快递，期待再次为您服务"];
                    
                    NSArray *dateArray=@[@"6-5",@"6-7",@"6-8",@"6-9",@"6-10",@"6-11",@"6-12",@"6-13"];
                    
                     NSArray *statusArray=@[@"已下单",@"已揽件",@"",@"运输中",@"配送中",@"代取件",@"已签收",@""];
                    for (int i=0;i<arr.count; i++) {
                        LogisticModel *model = [[LogisticModel alloc]init];
                        model.dsc = [arr objectAtIndex:i];
                        model.date = [dateArray objectAtIndex:i];
                        model.status = [statusArray objectAtIndex:i];
                        [self.dataArray addObject:model];
                        
                        
                        
                    }
                    //快递视图
//                    LogisticsShowView *logis = [[LogisticsShowView alloc]initWithDatas:self.dataArray];
//                    logis.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//
//                    [self.view addSubview:logis];
                }];
                         
                return self.infoHeaderView;
            }
        
        
    }else{
        
        if (kind == UICollectionElementKindSectionFooter) {
            if (indexPath.section==0) {
               self.totalFooterView  = (WaitingPayTotalView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WaitingPayTotalView" forIndexPath:indexPath];
            if (!isEmpty(self.storeDic)) {
               self.totalFooterView.priceLabel.text=[NSString stringWithFormat:@"￥%@",self.storeDic[@"goodsPrice"]];
               self.totalFooterView.freightLabel.text=[NSString stringWithFormat:@"￥%@",self.storeDic[@"freightPrice"]];
               self.totalFooterView.orderPriceLabel.text=[NSString stringWithFormat:@"￥%@",self.storeDic[@"orderPrice"]];
               self.totalFooterView.totalLabel.text=[NSString stringWithFormat:@"合计:%@元",self.storeDic[@"actualPrice"]];
               }

        //售后状态，0是可申请，1是用户已申请，2是管理员审核通过，3是管理员退款成功，4是管理员审核拒绝，5是用户已取消
           if (!isEmpty(self.storeDic)) {//没有退款按钮
                if ([self.storeDic[@"afterSaleStatus"]intValue]!=1)
                {
                    self.totalFooterView.viewBGTop.constant=23;
                }
           }
                           
                       
             return self.totalFooterView;
            
            }else{
                return 0;
            }
        
        }
    
    }
        
 
    return 0;
    
}

//单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {//购买产品cell大小
        
        return CGSizeMake(kScreenWidth, 100);
    }
    //底部推荐cell大小
   CellCalculateNeedModel *cellCaculateNeedModel = [[CellCalculateNeedModel alloc] initWithHorizontalDisplayCount:2 horizontalDisplayAreaWidth:kScreenWidth cellImgToSideEdge:0 cellImgWidthToHeightScale:1.0 cellOterPartHeightBesideImg:90 edgeBetweenCellAndCell:16 edgeBetweenCellAndSide:16];
   CellCalculateModel *cellCaculateModel = [[CellCalculateModel alloc] initWithCalculateNeedModel:cellCaculateNeedModel];
  
   return CGSizeMake(cellCaculateModel.cellWidth, cellCaculateModel.cellHeight);

    
}

//设置单元格的边距。单元格Cell的边距设置，即Cell整体相对于Header、Footer以及屏幕左右两侧的距离，优先级较高；
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section==1) {
           UIEdgeInsets insets = UIEdgeInsetsMake(10, 16, 12,16);
           return insets;
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0,0,0);
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section==1) {
        return 16;
    }
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section==1) {
        return 16;
    }
    return 0;
}
 
// 设置header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0){
//        if (self.isSupplyOrderPush) {
//            return CGSizeMake(kScreenWidth, 257);
//        }else{
            return CGSizeMake(kScreenWidth,313);
//        }
    }else{
    
    //订单状态:0：正常，1：已失效
     if ([self.storeDic[@"orderStatus"]intValue]==1) {
        
         return CGSizeMake(kScreenWidth,90);
     }else{
 
         int h =0;
         if ([self.storeDic[@"receiptStatus"]intValue]==1||[self.storeDic[@"receiptStatus"]intValue]==2) {
  
             h=57;
          }
          NSArray *arr=self.storeDic[@"orderInformations"];
          if (arr.count>0) {
//              self.infoHeaderView.payInfoHeight.constant= (arr.count-1)*30+40;
            return CGSizeMake(kScreenWidth,(arr.count-1)*30+40+70+h);
          }
      }
    }
    return CGSizeMake(kScreenWidth,313);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
     if(section == 0){
        
         if (!isEmpty(self.storeDic)) {//没有退款按钮
              if ([self.storeDic[@"afterSaleStatus"]intValue]!=1)
              {
                   return CGSizeMake(kScreenWidth, 148);
              }else{
                  return CGSizeMake(kScreenWidth, 188.5);
              }
         }
     }
        return CGSizeMake(0, 0);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        NSDictionary *dic = [self.likeRecommendGoods objectAtIndex:indexPath.row];
        GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
        vc.goodsID = [dic[@"goodsId"]intValue];
        vc.goodsImgUrl= dic[@"picUrl"];
        [self navigatePushViewController:vc animate:YES];
    }
    

}

#pragma mark ------------------------Getter / Setter----------------------

- (UICollectionView *)detailsCollecView
{
    if (!_detailsCollecView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _detailsCollecView.alwaysBounceVertical = YES;
        _detailsCollecView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _detailsCollecView.delegate = self;
        _detailsCollecView.dataSource = self;
        _detailsCollecView.showsVerticalScrollIndicator = NO;
        _detailsCollecView.showsHorizontalScrollIndicator = NO;
        _detailsCollecView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-52);
        [_detailsCollecView setBackgroundColor:KViewBgColor];
        //注册cell
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"HomeAllCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HomeAllCollectionCell"];
     
        //注册cell
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"WaitingPayTabCell" bundle:nil] forCellWithReuseIdentifier:@"WaitingPayTabCell"];
        
        //注册头
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"WaitingPayAddressView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayAddressView"];
        //注册头
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"WaitingPayInfoView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayInfoView"];
        //注册尾部
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"WaitingPayTotalView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"WaitingPayTotalView"];
    }
    return _detailsCollecView;
}

- (PayManager *)payManager {
    if (!_payManager) {
        _payManager = [PayManager sharedInstance];
    }
    return _payManager;
}
@end
