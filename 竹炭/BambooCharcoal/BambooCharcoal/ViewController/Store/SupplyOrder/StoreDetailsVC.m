//
//  WaitingPayDetailsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "StoreDetailsVC.h"
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
#import "LogisticsShowView.h"//快递view
#import "Util.h"
@interface StoreDetailsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
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
@property (nonatomic,strong)NSArray *storeOrderArr;//店铺订单
@property (nonatomic,strong)UIView *topView;
@property(nonatomic ,assign)CGFloat oriOffsetY;
@property (nonatomic,strong)NSDictionary *storeDic;//总数据
@end

@implementation StoreDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _initCollection];
    [self _initTopView];
    self.view.backgroundColor=KViewBgColor;
    if (_isSupplyOrderPush) {
    [self requestStoreOrderData];
    }
    
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
    if (_isSupplyOrderPush) {
        self.lineV.hidden=NO;
        self.phoneBtn.hidden=NO;
        self.chatBtn.hidden=NO;
    }
     
    WEAK_SELF
    [self.detailsCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.width.left.mas_equalTo(weak_self.view);
        make.bottom.mas_equalTo(weak_self.view.mas_bottom).offset(-52);
        
    }];
    if (@available(iOS 11.0, *)) {
        self.detailsCollecView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
//     [self setButtonArr:@[@"pay",@"feedback"]];
    
}
#pragma mark ------------------------Private------------------------------
- (void)setButtonArr:(NSArray *)buttonArr{//后面有时间再去封装

    if (!self.isSupplyOrderPush) {
        
    // 保存前一个button的宽以及前一个button距离屏幕边缘的距
    CGFloat edge =10;
    //设置button 距离父视图的高
    
    self.bottomX.constant = kScreenWidth-buttonArr.count*83-30-((buttonArr.count-1)*edge);
 
    for (int i =0; i< buttonArr.count; i++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeSystem];
        button.tag =200+i;
        
        [button addTarget:self action:@selector(selectClick:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = 15;
        
       
        //确定文字的字号
        button.titleLabel.font = [UIFont systemFontOfSize:15];

        CGFloat length = 83;
        //为button赋值
        [button setTitle:[self findStatusKey:buttonArr[i]] forState:(UIControlStateNormal)];
        if ([button.titleLabel.text isEqualToString:@"支付"]) {
            button.backgroundColor =KCOLOR_Main;
            [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        }else{
            button.backgroundColor =[UIColor whiteColor];
            button.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
            button.layer.borderWidth = 0.5f;
            [button setTitleColor:UIColorFromRGB(0x222222) forState:(UIControlStateNormal)];
        }
        //设置button的frame
        button.frame =CGRectMake(edge, 13, length, 30);
        
 
        //获取前一个button的尾部位置位置
        edge = button.frame.size.width +button.frame.origin.x+edge;
        
        [self.bottomView addSubview:button];
       }
        
    }

}

-(void)selectClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"评价"]) {
//        PublishAppraiseVC *vc = [[PublishAppraiseVC alloc]init];
//        [self navigatePushViewController:vc animate:YES];

    }else{
        [[CancelPopView sharedInstance]show:^(NSString *type) {
        NSLog(@"%@",type);
        }];
    }
    
}

- (NSString *)findStatusKey:(NSString *)key{

    NSDictionary *dic = @{@"confirm":@"确认收货",@"pay":@"支付",@"details":@"查看详情",@"cancel_order":@"取消订单",@"delete":@"删除订单",@"delivery":@"待发货",@"again":@"再次购买",@"feedback":@"评价",@"logistics":@"物流",@"remindDelivery":@"提醒发货"};

    return dic[key];
    
}

//发货视图
-(void)showDelivery{
    DeliveryShowView *showView=[[DeliveryShowView alloc]initWithDeliveryFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    WEAK_SELF
   showView.deliveryBlock = ^(NSString *company, NSString *num) {
       NSLog(@"%@,%@",company,num);
       [weak_self postCompany:company AndNum:num];
   };
   [self.view addSubview:showView];
}


 
#pragma mark ------------------------Api----------------------------------
#pragma mark ---发货
-(void)postCompany:(NSString *)company AndNum:(NSString *)num{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"shipChannelName":company,@"shipSn":num,@"orderSn":self.storeOrderSn};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"supplier/orders/shipOrder" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            [weak_self showSuccessInfoWithStatus:@"发货成功"];
            [weak_self goBack];
        
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

#pragma mark ---店铺订单详情
-(void)requestStoreOrderData{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"orderSn":_storeOrderSn};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"supplier/orders/detail" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.storeDic=resultDic[@"params"];
            
            weak_self.storeOrderArr = resultDic[@"params"][@"orderGoodsVoList"];
            [weak_self.addressHeaderView setDic:resultDic[@"params"]];
            
            [weak_self.detailsCollecView reloadData];
            //付款状态:0:待付款，1：已付款
            if ([resultDic[@"params"][@"payStatus"]intValue]==0) {
                weak_self.addressHeaderView.deliveryBtn.hidden=YES;
                return;
            }
            
            //收货状态:0：待发货，1：已发货 ， 2 已收货
            if ([resultDic[@"params"][@"receiptStatus"]intValue]==0) {
                
                if ([resultDic[@"params"][@"payStatus"]intValue]==1) {
                    weak_self.addressHeaderView.deliveryBtn.hidden=NO;
                    weak_self.addressHeaderView.timeLabel.hidden=YES;
                    weak_self.addressHeaderView.deliveryTop.constant=90;
                }
                
            }else if ([resultDic[@"params"][@"receiptStatus"]intValue]==1){
                
                
                
            }else{
                
            }
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

 
#pragma mark ------------------------View Event---------------------------

- (IBAction)phoneClick:(id)sender {
    if (!isEmpty(self.storeDic[@"memberAddress"][@"mobile"])) {
        
    [Util dialWithPhoneNumber:[NSString stringWithFormat:@"%@",self.storeDic[@"memberAddress"][@"mobile"]]];
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
   
//    if (_isSupplyOrderPush) {
//        return 1;
//    }
    return 2;
}
//设置每个组有多少个方块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.storeOrderArr.count;
    }
        return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        WaitingPayTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaitingPayTabCell" forIndexPath:indexPath];
        [cell setDic:self.storeOrderArr[indexPath.row]];
          return cell;
    }
    HomeAllCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAllCollectionCell" forIndexPath:indexPath];
    cell.totalLabel.hidden=YES;
    
      return cell;
  
   
}
//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    

    if (kind == UICollectionElementKindSectionHeader) {
            if (indexPath.section==0) {
                self.addressHeaderView  = (WaitingPayAddressView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayAddressView" forIndexPath:indexPath];
                if (self.isSupplyOrderPush) {
                    self.addressHeaderView.storeViewHeight=0;
                    
                }
                
                WEAK_SELF
                
                [self.addressHeaderView.deliveryBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                    NSLog(@"sss");
                    [weak_self showDelivery];
                   
               }];
                
                
                return self.addressHeaderView;
            }else{
                self.infoHeaderView  = (WaitingPayInfoView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WaitingPayInfoView" forIndexPath:indexPath];
                
                if (!isEmpty(self.storeDic[@"orderInformations"])) {
                    NSArray *arr=self.storeDic[@"orderInformations"];
                    [self.infoHeaderView setArr:arr];
                }
 
                //待付款 还没有快递物流信息
                if (!isEmpty(self.storeDic)) {
                    if ([self.storeDic[@"payStatus"]intValue]==0) {
                self.infoHeaderView.courierViewBGHeight.constant=0;
                    }else{
                if ([self.storeDic[@"receiptStatus"]intValue]==0) {
                        
                    self.infoHeaderView.courierViewBGHeight.constant=0;
                         
                }else{
                      self.infoHeaderView.courierViewBGHeight.constant=49;
                      self.infoHeaderView.courierView.hidden=NO;
                      if (!isEmpty(self.storeDic[@"orderShipment"][@"shipCompanyName"])) {
                      self.infoHeaderView.courierLabel.text = [NSString stringWithFormat:@"%@",self.storeDic[@"orderShipment"][@"shipCompanyName"]];
                      }
                      if (!isEmpty(self.storeDic[@"orderShipment"][@"shipTrackingNumber"])) {
                          self.infoHeaderView.courierNum.text =[NSString stringWithFormat:@"%@",self.storeDic[@"orderShipment"][@"shipTrackingNumber"]];;
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
        if (self.isSupplyOrderPush) {
            return CGSizeMake(kScreenWidth, 257);
        }else{
            return CGSizeMake(kScreenWidth,313);
        }
    }
    
    //待付款 还没有快递物流信息 payStatus 付款状态:0:待付款，1：已付款
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
               return CGSizeMake(kScreenWidth,(arr.count-1)*30+40+h);
             }
         }
       
     
    
    return CGSizeMake(0,0);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
     if(section == 0){
         if (!isEmpty(self.storeDic)) {//没有退款按钮
             if ([self.storeDic[@"afterSaleStatus"]intValue]!=1)
             {
                  return CGSizeMake(kScreenWidth, 148);
             }
        }
 
     }
        return CGSizeMake(0, 0);
    
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
@end
