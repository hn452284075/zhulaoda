//
//  CollectStoreVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "CollectStoreVC.h"
#import "MycommonTableView.h"
#import "CollectStoreCell.h"
#import "PersonDetailViewController.h"
#import "Util.h"
@interface CollectStoreVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@end

@implementation CollectStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle = @"关注店铺";
 
    [self.view addSubview:self.listTableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self _requestOrderData];
}

-(void)_requestOrderData{
 
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"businessType":@"2",@"memberAccid":[UserModel sharedInstance].userId,@"collectType":@"3"};
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/list" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"shopVoPage"][@"records"] ];
            });
           

        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }

    }];
    
    
}
 
 
#pragma mark ------------------------Page Navigate---------------------------
-(void)_jumpPersonDetailVC:(NSString *)shopId{
      PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
      vc.shopAccId =  shopId;
      [self navigatePushViewController:vc animate:YES];

}
 
#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        
        
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 95.0f;
        
        
        WEAK_SELF
        [_listTableView configurecellNibName:@"CollectStoreCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            CollectStoreCell *storeCell = (CollectStoreCell *)cell;
            [storeCell.storeImg sd_SetImgWithUrlStr:cellModel[@"shopLogo"] placeHolderImgName:@"login_logo"];
            storeCell.storeName.text = cellModel[@"shopName"];
            storeCell.businessCategory.text = cellModel[@"businessCategory"];
            [storeCell.mobileBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [weak_self shopMobile:[NSString stringWithFormat:@"%@",cellModel[@"shopMobile"]]];
            }];
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            [weak_self _jumpPersonDetailVC:cellModel[@"accid"]];
            
        }];
        
        
        [_listTableView headerRreshRequestBlock:^{
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
           
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
            
            
        }];
        
        
        
    }
    
    return _listTableView;
}

-(void)shopMobile:(NSString *)str{
    [Util dialServerNumber:str];
}

@end
