//
//  SearchStoreResultVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/29.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SearchStoreResultVC.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "SearchStoreResultCell.h"
#import "MycommonTableView.h"
#import "PersonDetailViewController.h"
@interface SearchStoreResultVC ()
@property (nonatomic,strong)UITextField *searchField;
@property (nonatomic,strong)MycommonTableView *listTableView;
@end

@implementation SearchStoreResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initTopView];
    [self.view addSubview:self.listTableView];
   
//    [_listTableView configureTableAfterRequestPagingData:@[@"",@""]];
    [self _requestStoreData];
    
}

#pragma mark ------------------------Init---------------------------------
- (void)_initTopView{
    [self removeLine];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 58, 30);
    [btn setTitle:@"搜索" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = CUSTOMFONT(14);
    [btn setBackgroundColor:KCOLOR_Main];
    btn.layer.cornerRadius=15;
    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem barButtonItemSpace:-10],rightItem];
    
    // 创建搜索框
    UIView *seachView = [[UIView alloc] initWithFrame:CGRectMake(42.5, 7, kScreenWidth-125, 30)];
    seachView.backgroundColor = [UIColor whiteColor];
    seachView.layer.cornerRadius=15;
    seachView.layer.borderColor=KCOLOR_Main.CGColor;
    seachView.layer.borderWidth=1.0f;
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seachBtn.frame =CGRectMake(15,5, 20, 20);
   [seachBtn setImage:IMAGE(@"home-seacher") forState:UIControlStateNormal];
   [seachBtn setTitleColor:KTextColor forState:UIControlStateNormal];
   seachBtn.titleLabel.font= CUSTOMFONT(12);
   [seachView addSubview:seachBtn];
    // 创建文本框
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(seachBtn.right+5, 0, seachView.width-btn.right, 30)];
    _searchField.font = [UIFont systemFontOfSize:12];
    _searchField.textColor = KTextColor;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.placeholder = @"请输入搜索关键词";
    _searchField.text=_searchStr;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [seachView addSubview:_searchField];

    self.navigationItem.titleView = seachView;
    
    UIView *seletecdBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    seletecdBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seletecdBgView];
}

#pragma mark ------------------------View Event---------------------------
-(void)searchClick{
    
    if (isEmpty(_searchField.text)) {
        [self showMessage:@"请输入搜索内容"];
        return;
    }
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self _requestStoreData];
}
#pragma mark ------------------------Api----------------------------------

-(void)_requestStoreData{
         WEAK_SELF
       [self showHub];

    NSDictionary *dic=@{@"searchKey":_searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"searchType":@"2"};
    
    [AFNHttpRequestOPManager postWithParameters:dic subUrl:@"search/query" block:^(NSDictionary *resultDic, NSError *error) {
           [weak_self dissmiss];
           NSLog(@"resultDic:%@",resultDic);
           if ([resultDic[@"code"] integerValue]==200) {
                [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"shopVoPage"][@"records"]];
                   
           }else{
               [weak_self showMessage:resultDic[@"desc"]];
           }
       }];
    
}


#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 126.0f;
        
        WEAK_SELF
        [_listTableView configurecellNibName:@"SearchStoreResultCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            SearchStoreResultCell *resultCell=(SearchStoreResultCell *)cell;
            
            resultCell.name.text = cellModel[@"shopName"];
            resultCell.content.text = [NSString stringWithFormat:@"主营:%@",cellModel[@"businessCategory"]];
            resultCell.address.text = cellModel[@"shopAddress"];
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            
            PersonDetailViewController *vc = [[PersonDetailViewController alloc]init];
            vc.shopAccId = [NSString stringWithFormat:@"%@",cellModel[@"accid"]];
            [weak_self navigatePushViewController:vc animate:YES];

            
        }];
        
        
        [_listTableView headerRreshRequestBlock:^{
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
            [weak_self _requestStoreData];
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
            [weak_self _requestStoreData];
            
        }];
        
        
        
    }
    
    return _listTableView;
}

@end
