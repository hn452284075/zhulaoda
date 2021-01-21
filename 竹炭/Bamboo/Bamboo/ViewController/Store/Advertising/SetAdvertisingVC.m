//
//  SetAdvertisingVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetAdvertisingVC.h"
#import "ShopCartCell.h"
#import "MycommonTableView.h"
#import "GoodsModel.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "PublishGoodsVC.h"
@interface SetAdvertisingVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)NSMutableArray *selectedArr;
@end

@implementation SetAdvertisingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"设置广告位商品";
//    [self initBottomView];
    [self.view addSubview:self.listTableView];
    self.view.backgroundColor=KViewBgColor;
    
    
    [self removeLine];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem initWithTitle:@"添加" titleColor:KCOLOR_Main titleSize:15 target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem=rightItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self _requestOrderData];
}
-(void)add{
    PublishGoodsVC *vc = [[PublishGoodsVC alloc]init];
    [self navigatePushViewController:vc animate:YES];
}

-(void)initBottomView{
    
    for (UIView *view in self.view.subviews) {
          if (view.tag==1) {
              [view removeFromSuperview];
          }
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-56-kStatusBarAndNavigationBarHeight, kScreenWidth, 56)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.tag = 1;
    [self.view addSubview:bottomView];

    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmBtn.frame = CGRectMake(kScreenWidth-72-14, 12, 72, 32);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=CUSTOMFONT(15);
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundColor:KCOLOR_Main];
    confirmBtn.layer.cornerRadius=16;
    [bottomView addSubview:confirmBtn];

//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cancelBtn.frame = CGRectMake(kScreenWidth-72*2-14*2, 12, 72, 32);
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font=CUSTOMFONT(15);
//    [cancelBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
//    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
//    cancelBtn.layer.cornerRadius=16;
//    cancelBtn.layer.borderColor=UIColorFromRGB(0xDEDEDE).CGColor;
//    cancelBtn.layer.borderWidth=0.5;
//    [bottomView addSubview:cancelBtn];

}
-(void)confirmBtnClick{
    self.selectedArr = [[NSMutableArray alloc]init];
    for (GoodsModel *model in self.listTableView.dataLogicModule.currentDataModelArr) {
        if (model.selected) {
            [self.selectedArr addObject:model.goodsId];
        }
    }
    
    if (_selectedArr.count==0) {
        [self showMessage:@"请选择商品"];
        return;
    }
    
        WEAK_SELF
        [self showHub];
        NSDictionary *param = @{@"goodsIds":[self.selectedArr componentsJoinedByString:@","]};
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"SupplyApi/updateHorseBusinessAdvertisingGoods" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                [weak_self showSuccessInfoWithStatus:resultDic[@"params"][@"desc"]];
                 weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
               weak_self.listTableView.dataLogicModule.requestFromPage=1;
               [weak_self _requestOrderData];
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
   
    
    
}

-(void)cancelBtnClick{
    
}

-(void)_requestOrderData{
    
        WEAK_SELF
        [self showHub];
        NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize)};
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"SupplyApi/selectHorseBusinessGoodsList" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                if (!isEmpty(resultDic[@"params"][@"records"])) {
                    [weak_self initBottomView];
                }
                
               
                NSArray *arr = [[GoodsModel objectGoodsModelWithGoodsArr:resultDic[@"params"][@"records"]] mutableCopy];
                
              [weak_self.listTableView configureTableAfterRequestPagingData:arr];
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.tableHeaderView = [UIView new];
//    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0,15,0,15)];
//    }

    [self.listTableView reloadData];
}

- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 11, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-11-56) style:UITableViewStylePlain];
//        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 110.0f;
    _listTableView.noDataLogicModule.nodataAlertTitle=@"您还未添加商品";
        WEAK_SELF
        [_listTableView configurecellNibName:@"ShopCartCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            GoodsModel *model =(GoodsModel *)cellModel;
            ShopCartCell *orderCell =(ShopCartCell *)cell;
            orderCell.bgviewLeft.constant=0;
            orderCell.bgviewRight.constant=0;
            orderCell.model=model;
            [orderCell.goodsImage sd_SetImgWithUrlStr:model.goodsThumb placeHolderImgName:nil];
            orderCell.price.text = [NSString stringWithFormat:@"%@",model.price];
            orderCell.goodsName.text = [NSString stringWithFormat:@"%@",model.name];
            orderCell.addSubtractButton.hidden=YES;
            orderCell.specBtn.hidden=YES;
            orderCell.specLabel.hidden=YES;
            orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"%@",cellModel);
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            
            
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


@end
