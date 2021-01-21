//
//  ShopCartViewController.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 17/7/18.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "ShopCartViewController.h"
#import "ShopCartCell.h"
#import "ShopCartHeaderView.h"
#import "ShopCartManger.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "GoodsModel.h"
#import "ShopCartManger+request.h"
#import "GlobleErrorView.h"
#import "ConfirmOrderVC.h"
#import "AddToCartView.h"
#import "GoodsInfoViewController.h"
#import "PersonDetailViewController.h"
#import "ShowAlertView.h"
@interface ShopCartViewController ()<UITableViewDelegate,UITableViewDataSource,AddToCartDelegate>
@property(nonatomic,strong)NSMutableArray *shopCartArray;
@property (nonatomic,strong)ShopCartHeaderView *shopCartHeaderView;
@property (nonatomic,strong)AddToCartView *addCartView;
@property (weak, nonatomic) IBOutlet UITableView *shopCartTableView;
@property (nonatomic,strong)NSString *oldSpecId;//新选择的规格id
@property (nonatomic,strong)NSString *goodsId;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)ShowAlertView *showAlertView;

@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle = @"购物车";
    [self _init];
    [self _initShopCartTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self toRefresh];
  
}

-(void)toRefresh{
    [ShopCartManger sharedManager].seletedCount=0;
       [ShopCartManger sharedManager].isSelecteAll=NO;
       _allSeletedBtn.selected = NO;
       self.totalMoney.text = @"￥0.00";
       [self.settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
       WEAK_SELF
       [ self _checkNetWork:^(BOOL isNetWork){
           if (isNetWork) {
              [weak_self _requestData];
           }
           
       }];
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
     NSLog(@"%@",NSStringFromCGRect(self.bottomView.frame));
}


#pragma mark ------------------------Init---------------------------------
- (void)_init{

   _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
   _bottomView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
   _bottomView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
   _bottomView.layer.masksToBounds = NO;
    
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    self.rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.rightBtn setTitleColor:KCOLOR_MAIN_TEXT forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)_initShopCartTableView{
    
    self.shopCartTableView.rowHeight = 114;
    self.shopCartTableView.delegate = self;
    self.shopCartTableView.dataSource = self;
    [self.shopCartTableView registerNib:[UINib nibWithNibName:@"ShopCartCell" bundle:nil] forCellReuseIdentifier:@"ShopCartCell"];
    
    
}
#pragma mark ------------------------Private------------------------------
//店铺选中即店铺中的商品都选中
- (void)clickedWhichHeaderViewIsSeleted:(BOOL)isSeleted AndSectionIndex:(NSInteger)index{

    [[ShopCartManger sharedManager]selectStoreAllShopCartGoods:isSeleted AndSectionIndex:index];
    
    [self refreshBottomUI];
    
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:index-2000];
    
    [self.shopCartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}


//刷新当前选中的cell
- (void)clickedSeletedLeftBtn:(UITableViewCell *)cell{
    NSIndexPath * indexpath = [self.shopCartTableView indexPathForCell:cell];
    [[ShopCartManger sharedManager]clickSeletedGoods:indexpath];
    
    [self refreshBottomUI];
    
}

//刷新底部UI
- (void)refreshBottomUI{
    WEAK_SELF//x主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.shopCartTableView reloadData];
    //空数据显示view
    if ([ShopCartManger sharedManager].goodsShopCartArray.count == 0) {
        [GlobleErrorView showInContentView:self.shopCartTableView withReloadBlock:^{
            
        } alertTitle:@"您还未添加任何商品" alertImageName:nil];
        
    }else{
        [GlobleErrorView showLoadingInView:self.shopCartTableView];
    }
    
         weak_self.allSeletedBtn.selected = [ShopCartManger sharedManager].isSelecteAll;
           weak_self.totalMoney.text = [NSString stringWithFormat:@"￥%.2f",[ShopCartManger sharedManager].totalPrice];
    
   
    if ([ShopCartManger sharedManager].seletedCount ==0) {
        
        [self.settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
    }else{
         [self.settlementBtn setTitle:[NSString stringWithFormat:@"结算(%ld)",[ShopCartManger sharedManager].seletedCount] forState:UIControlStateNormal];
    }
    });
}

#pragma mark---修改数量
- (void)changeTheShopCount:(UITableViewCell *)cell count:(NSNumber *)count{
    NSIndexPath * indexpath = [self.shopCartTableView indexPathForCell:cell];
    WEAK_SELF
    [self showHub];
    [[ShopCartManger sharedManager]changeTheShopIndexPath:indexpath AndModify:count AddIsSuccess:^{
        [weak_self dissmiss];
        [weak_self refreshBottomUI];
    }];

   
}

#pragma mark ------------------------Api----------------------------------
- (void)_requestData {
    WEAK_SELF
    [self showHub];
    self.shopCartArray = [NSMutableArray array];
    [[ShopCartManger sharedManager]ShopCartAllDataBlock:^(BOOL isSuccess, NSMutableArray *array) {
       [weak_self dissmiss];
        if (isSuccess) {
            weak_self.shopCartArray = array;
            if (weak_self.shopCartArray.count==0) {
 
            [GlobleErrorView showInContentView:weak_self.shopCartTableView withReloadBlock:^{
                
            } alertTitle:@"您还未添加任何商品" alertImageName:nil];
                
            }else{
            [GlobleErrorView showLoadingInView:weak_self.shopCartTableView];
            [weak_self.shopCartTableView reloadData];
            weak_self.allSeletedBtn.selected = NO;
            [weak_self.settlementBtn setTitle:@"结算" forState:UIControlStateNormal];
            }
        }else{
        
            [weak_self showMessage:@"请求失败"];
        }
        
    }];
    

}

//购物车修改规格
-(void)_modifySpecGoodsNewSpec:(NSString *)new{        
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"cartId":self.goodsId,@"oldSpecificationId":self.oldSpecId,@"newSpecificationId":new} subUrl:@"orderCart/updateCartGoodsSpecification" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            [weak_self toRefresh];
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
    
}

//订单结算
- (void)_settlementOrder{
 
    
    [ShopCartManger sharedManager].seletedCount=0;
    [ShopCartManger sharedManager].isSelecteAll = NO;
    [self _jumpSurePage:[ShopCartManger sharedManager].goodsShopCartArray];

}
#pragma mark ------------------------Page Navigate------------------------
- (void)_jumpSurePage:(NSArray *)array{
    
    NSMutableArray *shopNoteVoList = [[NSMutableArray alloc]init];
    
    BOOL flag=NO;
       for (int i=0;i<array.count;i++) {
           StoreModel *storeModel = array[i];
           NSMutableArray *cartIdsList = [[NSMutableArray alloc]init];
           for (int j=0; j<storeModel.listArr.count; j++) {
               GoodsModel *model =storeModel.listArr[j];
               if (model.selected) {
                   [cartIdsList addObject:model.goodsId];
                   flag=YES;
               }
           }
           
           if (flag==YES) {
               [shopNoteVoList addObject:@{@"shopAccid":storeModel.storeId,@"cartIds":cartIdsList}];
                  flag=NO;
               }
           
           
            
        
       }
    
  
    NSLog(@"%@",shopNoteVoList);
    ConfirmOrderVC *vc = [[ConfirmOrderVC alloc]init];
    vc.seletecdArray=shopNoteVoList;
    [self navigatePushViewController:vc animate:YES];


}
#pragma mark ------------------------View Event---------------------------
- (void)rightClick:(UIButton *)btn {
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.rightBtn.selected) {
        self.settlementBtn.selected = YES;
        self.totalMoney.hidden = YES;
        self.freightLabel.hidden = YES;
        self.settlementBtn.backgroundColor = [UIColor whiteColor];
        
        
        //是否有效产品的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:EditorGoodsCenter object:@1];
    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:EditorGoodsCenter object:@0];
        self.settlementBtn.selected = NO;
        self.totalMoney.hidden = NO;
        self.freightLabel.hidden = NO;
        self.settlementBtn.backgroundColor = KCOLOR_Main;
    }
    
    [self.shopCartTableView reloadData];
     

}

-(void)showGoodsSpecView:(NSIndexPath *)index{
    UIView *bv = [[UIView alloc] initWithFrame:self.view.window.frame];
    bv.tag = 112;
    bv.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
    [self.view.window addSubview:bv];
    WEAK_SELF
    [bv addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
           UIView *_bv = [weak_self.view.window viewWithTag:112];
           [_bv removeFromSuperview];
           weak_self.addCartView.delegate = nil;
           [weak_self.addCartView removeFromSuperview];
    }];
    
    
    self.addCartView = [[[NSBundle mainBundle] loadNibNamed:@"AddToCartView" owner:self options:nil] lastObject];
    
     GoodsModel *model = [self.shopCartArray[index.section] listArr][index.row];
    self.oldSpecId=model.specificationId;
    self.goodsId = model.goodsId;
       [self.addCartView _initCartViewInfo:model.goodsThumb
                                     price:model.goodsPrice
                                       msg:model.goodsName
                                   specArr:model.specificationList];
       
       self.addCartView.delegate = self;
       [self.view.window addSubview:self.addCartView];
       [self.addCartView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(self.view.mas_left);
           make.right.equalTo(self.view.mas_right);
           make.bottom.equalTo(self.view.mas_bottom);
           make.height.mas_equalTo(385);
       }];
    
    self.addCartView.seletecdSpecBlock = ^(NSString * _Nullable gs_specificationId) {
        weak_self.addCartView.delegate = nil;
      [weak_self.addCartView removeFromSuperview];
      UIView *bv = [weak_self.view.window viewWithTag:112];
      [bv removeFromSuperview];
        [weak_self _modifySpecGoodsNewSpec:gs_specificationId];
       
    };
}

#pragma mark ----结算or删除所选
- (IBAction)settlementClick:(id)sender {

    
   
    
    
    if (self.settlementBtn.selected) {
        if ([ShopCartManger sharedManager].seletedCount==0||self.shopCartArray.count ==0) {
            [self showMessage:@"您还未选择宝贝"];
            return;
        }
        WEAK_SELF
        [self.showAlertView show:@"确定要删除选中的商品吗？"];
           self.showAlertView.seletecdBlock = ^(NSInteger index) {
               if (index==1) {
                   [weak_self showHub];
                          [[ShopCartManger sharedManager]deleteSeletedArray:^(BOOL isSuccess) {
                              [weak_self dissmiss];
                              if (isSuccess) {
                                  
                                  [weak_self refreshBottomUI];
                                  
                              }else{
                                 [weak_self showMessage:@"失败"];
                              }
                          }];
               }
           };
        
       
        
        
    }else{
     
        if ([ShopCartManger sharedManager].seletedCount==0||self.shopCartArray.count ==0) {
            
            
            [self showMessage:@"您还未选择宝贝"];
            
    
        }else{
        
            [self _settlementOrder];
            
        }

    }
}

- (IBAction)allSeletedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[ShopCartManger sharedManager]isSeletedAllGoods:sender.selected];
    [self refreshBottomUI];
    
}


#pragma mark ------------------------Delegate-----------------------------
#pragma mark --------- 购物车规格回调
 
- (void)addToCart_Cancel{
   self.addCartView.delegate = nil;
    [self.addCartView removeFromSuperview];
    UIView *bv = [self.view.window viewWithTag:112];
    [bv removeFromSuperview];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.shopCartArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.shopCartArray[section] listArr].count;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 25;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    _shopCartHeaderView = BoundNibView(@"ShopCartHeaderView", ShopCartHeaderView);
    _shopCartHeaderView.model = self.shopCartArray[section];
    _shopCartHeaderView.tag = section + 2000;
    WEAK_SELF
    _shopCartHeaderView.headerViewBlock = ^(NSInteger index,BOOL isSeleted){
    
        [weak_self clickedWhichHeaderViewIsSeleted:isSeleted AndSectionIndex:index];
        
    };
    [_shopCartHeaderView.bgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
        StoreModel *m=weak_self.shopCartArray[section];
        vc.shopAccId = m.storeId;
        [weak_self navigatePushViewController:vc animate:YES];
    }];

    
    return _shopCartHeaderView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //圆角化尾部的view
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    footerView.backgroundColor = [UIColor clearColor];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, kScreenWidth-28, 25)];
    subView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:subView];
    //创建 layer圆角化上左 上右
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      maskLayer.frame = subView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = subView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    maskLayer.frame = subView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    subView.layer.mask = maskLayer;
    return footerView;
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShopCartCell *cell = [self.shopCartTableView dequeueReusableCellWithIdentifier:@"ShopCartCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.shopCartArray[indexPath.section] listArr][indexPath.row];
    cell.isCart=YES;
    WEAK_SELF
    //选中产品
    cell.seletedBlock = ^(UITableViewCell *cell){
    
        [weak_self clickedSeletedLeftBtn:cell];
        
    };
    //修改数量
    cell.goodsNumBlock = ^(UITableViewCell *cell,NSNumber*num){
    
        [weak_self changeTheShopCount:cell count:num];
    };
    
    [cell.specBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self showGoodsSpecView:indexPath];
    }];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GoodsModel *model = [self.shopCartArray[indexPath.section] listArr][indexPath.row];
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
    vc.goodsID = [model.cartId intValue];
    vc.goodsImgUrl=model.goodsThumb;
    [self navigatePushViewController:vc animate:YES];
    

}

//右滑动删除
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    StoreModel * storeModel = [self.shopCartArray objectAtIndex:indexPath.section];
//    GoodsModel *goodsModel = [ storeModel.listArr objectAtIndex:indexPath.row];
//    
//    
//    StoreModel * model = [self.shopCartArray[indexPath.section]listArr][indexPath.row];
//    NSMutableArray * ary = [self.shopCartArray[indexPath.section] listArr];
//    WEAK_SELF
//    [self showHub];
//    [[ShopCartManger sharedManager] requestDeleteShopCartGoodsForGoodsIds:@[@{@"goodsId":goodsModel.productId,@"specificationId":goodsModel.specificationId}].mutableCopy  deleteShopCartBlock:^(BOOL isDelete) {
//        if (isDelete) {
//            [weak_self dissmiss];
//            [ary removeObject:model];
//            if (ary.count == 0) {
//                [weak_self.shopCartArray removeObjectAtIndex:indexPath.section];
//                [weak_self.shopCartTableView reloadData];
//            }else{
//                
//                [weak_self.shopCartTableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//                
//            }
//            
//            
//            [[ShopCartManger sharedManager]GetTotalBill];
//            [weak_self refreshBottomUI];
//
//            
//        }else{
//            
//            [weak_self showErrorInfoWithStatus:@"失败"];
//            
//        }
//        
//    }];
//
//    
// 
//
//
//}
//修改删除按钮的文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------
-(ShowAlertView*)showAlertView{
    if (!_showAlertView) {
        _showAlertView=[ShowAlertView sharedInstance];
    }
    return _showAlertView;
}

 @end
