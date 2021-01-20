//
//  ShelvesDetailsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/31.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ShelvesDetailsVC.h"
#import "ShelvesCell.h"
#import "ShelvesHeaderView.h"
#import "MycommonTableView.h"
#import "GoodsInfoViewController.h"
#import "PublishGoodsVC.h"
@interface ShelvesDetailsVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@end

@implementation ShelvesDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor  = KViewBgColor;
    [self.view addSubview:self.listTableView];
    if ([self.typeId isEqualToString:@"1"]) {
          
          [self setIsPushPage:YES];
    }else{
          
          for (UISwipeGestureRecognizer *recognizer in [[self view] gestureRecognizers]) {
              [[self view] removeGestureRecognizer:recognizer];
        }
    }
    
}

//外部点index调用了此方法
-(void)_initLoad{
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
       self.listTableView.dataLogicModule.requestFromPage=1;
       [self _requestOrderData];
}
 

#pragma mark ------------------------Api----------------------------------
-(void)_requestOrderData{
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"isOnSale":self.typeId};
        
        WEAK_SELF
        [self showHub];
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"ShopApi/myGoods" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
             [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"]];
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
            
        }];
     
    
}

-(void)_operationIndexRequest:(NSInteger)index AndDic:(NSDictionary *)dic{
    
    WEAK_SELF
    if (index==0) {
       
       //下架商品
        if ([self.typeId intValue]==1) {
           [self showHub];
           [AFNHttpRequestOPManager postWithParameters:@{@"goodsId":dic[@"goodsId"],@"isOnSale":@0} subUrl:@"ShopApi/goodIsOnSale" block:^(NSDictionary *resultDic, NSError *error) {
              [weak_self dissmiss];
              NSLog(@"resultDic:%@",resultDic);
              if ([resultDic[@"code"] integerValue]==200) {
              weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
              weak_self.listTableView.dataLogicModule.requestFromPage=1;
                  [weak_self _requestOrderData];
                  
              }else{
                  [weak_self showMessage:resultDic[@"desc"]];
              }
              
          }];
        }else{
            //删除商品
            [self showSimplyAlertWithTitle:@"提示" message:@"确定删除此商品吗?" sureAction:^(UIAlertAction *action) {
               [self showHub];
               [AFNHttpRequestOPManager postWithParameters:@{@"goodsId":dic[@"goodsId"]} subUrl:@"ShopApi/delGoodsById" block:^(NSDictionary *resultDic, NSError *error) {
                  [weak_self dissmiss];
                  NSLog(@"resultDic:%@",resultDic);
                  if ([resultDic[@"code"] integerValue]==200) {
                  weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
                  weak_self.listTableView.dataLogicModule.requestFromPage=1;
                      [weak_self _requestOrderData];
                      
                  }else{
                      [weak_self showMessage:resultDic[@"desc"]];
                  }
                  
              }];
                
            } cancelAction:^(UIAlertAction *action) {
                
            }];
            
        }
      
        
    }else if (index==1){
        
        if ([self.typeId intValue]==1) {//预览
            GoodsInfoViewController *infoCon = [[GoodsInfoViewController alloc] init];
            infoCon.isStoreMangerPush=YES;
            infoCon.goodsID = [dic[@"goodsId"] intValue];
            infoCon.goodsImgUrl=dic[@"picUrl"];
           [self navigatePushViewController:infoCon animate:YES];
        }else{//修改
            PublishGoodsVC *vc = [[PublishGoodsVC alloc]init];
            vc.goodsId = dic[@"goodsId"];
        
            vc.goBackBlock = ^{
                [weak_self _initLoad];
            };
            [self navigatePushViewController:vc animate:YES];
        }
        
        
    }else if (index==2){
        if ([self.typeId intValue]==1) {//推广
            
            
        }else{//预览
            GoodsInfoViewController *infoCon=
            [[GoodsInfoViewController alloc] init];
            infoCon.isStoreMangerPush=YES;
           infoCon.goodsID = [dic[@"goodsId"] intValue];
            infoCon.goodsImgUrl=dic[@"picUrl"];
          [self navigatePushViewController:infoCon animate:YES];
        }
        
        
        
    }else{
        
        if ([self.typeId intValue]==1) {//擦亮
            
            [self showMessage:@"擦亮成功"];
            
        }else{
            //上架商品
            [self showHub];
          [AFNHttpRequestOPManager postWithParameters:@{@"goodsId":dic[@"goodsId"],@"isOnSale":@1} subUrl:@"ShopApi/goodIsOnSale" block:^(NSDictionary *resultDic, NSError *error) {
             [weak_self dissmiss];
             NSLog(@"resultDic:%@",resultDic);
             if ([resultDic[@"code"] integerValue]==200) {
                 [weak_self showSuccessInfoWithStatus:@"上架成功"];
                 weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
             weak_self.listTableView.dataLogicModule.requestFromPage=1;
                 [weak_self _requestOrderData];
                 
             }else{
                 [weak_self showMessage:resultDic[@"desc"]];
             }
             
         }];
        }
        
        
    }
    
       
    
    
}
 

#pragma mark ------------------------Getter / Setter----------------------

- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40-kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight=158;
        _listTableView.firstSectionHeaderHeight = 95.0f;
        [_listTableView configureFirstSectioHeaderNibName:@"ShelvesHeaderView" ConfigureTablefirstSectionHeaderBlock:^(UITableView *tableView, id cellModel, UIView *firstSectionHeaderView) {
            
        }];
        
        WEAK_SELF
        [_listTableView configurecellNibName:@"ShelvesCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
           
            ShelvesCell *shelvesCell=(ShelvesCell *)cell;
            [shelvesCell setDic:(NSDictionary *)cellModel];
            shelvesCell.seletecdIndeBlock = ^(NSInteger index) {
                [weak_self _operationIndexRequest:index AndDic:(NSDictionary *)cellModel];
            };
            if ([weak_self.typeId intValue]==0) {
                [shelvesCell.button1 setTitle:@"删除" forState:UIControlStateNormal];
                [shelvesCell.button2 setTitle:@"修改" forState:UIControlStateNormal];
                [shelvesCell.button3 setTitle:@"预览" forState:UIControlStateNormal];
                [shelvesCell.button4 setTitle:@"上架" forState:UIControlStateNormal];
            }
            
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
