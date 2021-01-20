//
//  TCTGExpendDetailVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCTGExpendDetailVC.h"
#import "TCTGExpendDetailCell.h"
#import "MycommonTableView.h"
@interface TCTGExpendDetailVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@end

@implementation TCTGExpendDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"花费明细";
    self.view.backgroundColor=KViewBgColor;
    [self.view addSubview:self.listTableView];
    [_listTableView configureTableAfterRequestPagingData:@[@"",@"",@"",@"",@"",@""]];
    [self _requestOrderData];
}

-(void)_requestOrderData{
    //    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"patientsId":[UserModel sharedInstance].patientsId,@"status":self.orderType};
    //       WEAK_SELF
    //       [OrderModel getProductListWithParameter:param andHudView:self.navigationController.view withRequestDidFinished:^(NSDictionary * _Nullable results) {
    //           NSLog(@"%@",results);
    //           if (results.count > 0) {
    //               NSDictionary *data = [results objectForKey:@"data"];
    //               NSArray *records = [data objectForKey:@"records"];
    //               [weak_self.listTableView configureTableAfterRequestPagingData:records];
    //           }
    //       }];
    
}

- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 185, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-185) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 50.0f;
        
        WEAK_SELF
        [_listTableView configurecellNibName:@"TCTGExpendDetailCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            
            
    
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
