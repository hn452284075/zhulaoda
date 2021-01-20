//
//  CollectGoodsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CollectGoodsVC.h"
#import "MycommonTableView.h"
#import "CollectGoodsCell.h"
#import "GoodsInfoViewController.h"
@interface CollectGoodsVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@end

@implementation CollectGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self _requestOrderData];
}
#pragma mark ------------------------Api----------------------------------
-(void)_requestOrderData{
    
    NSString *collectType;
    if (!_isFocus) {
        collectType = @"1";
    }else{
        collectType = @"2";
    }
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"businessType":@"1",@"memberAccid":[UserModel sharedInstance].userId,@"collectType":collectType};
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/list" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"goodsVoPage"][@"records"] ];
            });
           

        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }

    }];
    
    
}


 

#pragma mark ------------------------Delegate-----------------------------
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
//    headerView.backgroundColor = KViewBgColor;
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(14, 25, 250, 15)];
//    label.text = @"2020-06-17";
//    label.font = CUSTOMFONT(15);
//    [headerView addSubview:label];
//    return headerView;
//}
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.00000000001;
//
//}
 

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return 2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    CollectGoodsCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:@"CollectGoodsCell" forIndexPath:indexPath];
//
//    return cell;
//
//}

 
#pragma mark ------------------------Page Navigate---------------------------
-(void)_jumpGoodsId:(int)goodsId AndGoodsImG:(NSString *)img{
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
    vc.goodsID =goodsId;
    vc.goodsImgUrl=img;
    [self navigatePushViewController:vc animate:YES];
}
 

#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        WEAK_SELF
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight=129;
        [_listTableView configurecellNibName:@"CollectGoodsCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            CollectGoodsCell *goodsCell = (CollectGoodsCell *)cell;
            [goodsCell.goodsImage sd_SetImgWithUrlStr:cellModel[@"picUrl"] placeHolderImgName:@""];
            goodsCell.goodsName.text =cellModel[@"goodsName"];
            goodsCell.address.text =cellModel[@"place"];
            goodsCell.storeName.text =cellModel[@"shopName"];
            goodsCell.price.text =[NSString stringWithFormat:@"%@",cellModel[@"goodsPrice"]];
            goodsCell.unitLabel.text =[NSString stringWithFormat:@"/%@",cellModel[@"unit"]];
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            
            [weak_self _jumpGoodsId:[cellModel[@"goodsId"]intValue] AndGoodsImG:cellModel[@"picUrl"]];

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
