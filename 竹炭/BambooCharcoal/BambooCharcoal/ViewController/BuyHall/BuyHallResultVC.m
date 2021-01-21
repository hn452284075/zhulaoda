//
//  BuyHallResultVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallResultVC.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "BuyHallCell.h"
#import "MycommonTableView.h"
#import "AddressShowView.h"
#import "categoryShowView.h"
#import "GoodsCategoryModel.h"
#import "BuyHallInfoViewController.h"
@interface BuyHallResultVC ()
{
    UIButton *regionBtn;
    UIButton *typeBtn;
}
@property (nonatomic,strong)UITextField *searchField;
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)AddressShowView *addressShowView;
@property (nonatomic,strong)CategoryShowView *categoryShowView;

@property (nonatomic, assign) int areaID;


@property (nonatomic, strong) NSDictionary          *allAddressDic;

@property (nonatomic, strong) NSMutableArray        *categoryArray; //类目数组
@property (nonatomic, strong) NSMutableArray        *categoryIDArray; //类目ID数组


@end

@implementation BuyHallResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initTopView];
    [self.view addSubview:self.listTableView];
      
//    [_listTableView configureTableAfterRequestPagingData:@[@"",@""]];
    
    self.areaID     = -1;
    self.categoryID = -1;
    
    [self _requestOrderData:self.searchStr];
    
    [self requstCategoryList];
}

- (void)_initTopView{
    
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
    // 设置文本框的字体
    _searchField.font = [UIFont systemFontOfSize:12];
    // 设置文本的颜色
    _searchField.textColor = KTextColor;
    // 设置文本框的风格
    _searchField.borderStyle = UITextBorderStyleNone;
    // 设置文本框提示内容
//    _searchField.placeholder = @"请输入搜索关键词";
    _searchField.text = self.searchStr;
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [seachView addSubview:_searchField];

    self.navigationItem.titleView = seachView;
    
    regionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    regionBtn.frame = CGRectMake(kScreenWidth/2-80, 0, 60, 42);
    regionBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [regionBtn setTitle:@"地区" forState:UIControlStateNormal];
    [regionBtn setTitleColor:KCOLOR_MAIN_TEXT forState:UIControlStateNormal];
    [regionBtn setTitleColor:KCOLOR_Main forState:UIControlStateSelected];
    [regionBtn setImage:IMAGE(@"grayArrow") forState:UIControlStateNormal];
    [regionBtn setImage:IMAGE(@"greenSeletecd") forState:UIControlStateSelected];
    [regionBtn addTarget:self action:@selector(seletecdIndexBtn:) forControlEvents:UIControlEventTouchUpInside];
    [regionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [regionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.view addSubview:regionBtn];
    
    typeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    typeBtn.frame = CGRectMake(regionBtn.right+40, 0, 60, 42);
    typeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [typeBtn addTarget:self action:@selector(seletecdIndexBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [typeBtn setTitle:@"品类" forState:UIControlStateNormal];
    [typeBtn setTitleColor:KCOLOR_MAIN_TEXT forState:UIControlStateNormal];
    [typeBtn setTitleColor:KCOLOR_Main forState:UIControlStateSelected];
    [typeBtn setImage:IMAGE(@"grayArrow") forState:UIControlStateNormal];
    [typeBtn setImage:IMAGE(@"greenSeletecd") forState:UIControlStateSelected];
    [typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [self.view addSubview:typeBtn];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, kScreenWidth, 0.5)];
    subView.backgroundColor = UIColorFromRGB(0xf2f2f2);;
    [self.view addSubview:subView];
    
}
#pragma mark ------------------------Private-------------------------
- (int)getIDAddressFormFile:(NSString *)pname cityname:(NSString *)cname disname:(NSString *)dname
{
    if(self.allAddressDic == nil || self.allAddressDic.allKeys.count == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"thy_area" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        self.allAddressDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
        
    NSArray *array = self.allAddressDic[@"params"];
    for (int i=0;i<array.count;i++) {
        NSDictionary *dic = array[i];
        NSArray *proArray = dic[@"childList"];
        NSString *p_name = dic[@"name"];
        if(isEmpty(cname))
        {
            if([p_name isEqualToString:pname])  //只有省的情况，直接返回省ID
            {
                return [dic[@"pid"] intValue];
            }
        }
        
        for(int j=0;j<proArray.count;j++)
        {
            NSDictionary *prodic = proArray[j];
            NSArray *disArray = prodic[@"childList"];
            NSString *c_name = prodic[@"name"];
            if(isEmpty(dname))
            {
                if([c_name isEqualToString:cname])  //市的ID
                {
                    return [prodic[@"pid"] intValue];
                }
            }
            
            for(int k=0;k<disArray.count;k++)
            {
                NSDictionary *disdic = disArray[k];
                NSString *t_name = disdic[@"name"];
               
                if([t_name isEqualToString:dname])  //区ID
                {
                    return [prodic[@"pid"] intValue];
                }
            }
        }
    }
    return -1;
}

#pragma mark ------------------------View Event---------------------------
-(void)seletecdIndexBtn:(UIButton *)btn{
    if (btn==regionBtn) {
        regionBtn.selected=YES;
        typeBtn.selected=NO;
        if (_categoryShowView!=nil) {
           [_categoryShowView colse];
           _categoryShowView=nil;
        }
        if (_addressShowView==nil) {
            
            _addressShowView = [[AddressShowView alloc]initWithAddresFrame:CGRectMake(0, 42.5, kScreenWidth, kScreenHeight-42.5-kStatusBarAndNavigationBarHeight)];
            WEAK_SELF
            _addressShowView.addressBlock = ^(NSString * _Nonnull str) {
                weak_self.addressShowView=nil;
                if (!isEmpty(str)) {
                    NSArray *arr = [str componentsSeparatedByString:@"/"];
                   NSLog(@"%@",str);
                   weak_self.areaID = [weak_self getIDAddressFormFile:arr[0]
                                                             cityname:arr[1]
                                                              disname:arr[2]];
                }
               
                NSString *s_str = weak_self.searchField.text;
                if(isEmpty(weak_self.searchField.text))
                {
                    s_str = @"";
                }
                [weak_self _requestOrderData:s_str];
            };
            
            [self.view addSubview:_addressShowView];
        }
    }else{
        regionBtn.selected=NO;
        typeBtn.selected=YES;
        if (_addressShowView!=nil) {
          [_addressShowView colse];
          _addressShowView=nil;
        }
       if (_categoryShowView==nil) {
          _categoryShowView = [[CategoryShowView alloc]initWithCategoryShowViewFrame:CGRectMake(0, 42.5, kScreenWidth, kScreenHeight-42.5-kStatusBarAndNavigationBarHeight) AndDataSource:self.categoryArray];
          WEAK_SELF
          _categoryShowView.seletecdTypeBlock = ^(NSString * _Nullable str) {
              NSLog(@"%@",str);
              weak_self.categoryShowView=nil;
              int index = (int)[weak_self.categoryArray indexOfObject:str];
              weak_self.categoryID = [[weak_self.categoryIDArray objectAtIndex:index] intValue];
              [weak_self _requestOrderData:weak_self.searchStr];
          };
          [self.view addSubview:_categoryShowView];
        }
    }
    
}
-(void)searchClick
{
    if(!isEmpty(self.searchField.text)){
        self.listTableView.dataLogicModule.requestFromPage=1;
        self.listTableView.dataLogicModule.currentDataModelArr=@[].mutableCopy;
        [self _requestOrderData:self.searchField.text];
    }else{
        [self showMessage:@"请输入搜索关键词"];
    }
}


#pragma mark ------------------------Api----------------------------------
-(void)_requestOrderData:(NSString *)str{
    NSString *areaIDStr = self.areaID == -1 ? @"":[NSString stringWithFormat:@"%d",self.areaID];
    NSString *cateIDStr = self.categoryID == -1 ? @"":[NSString stringWithFormat:@"%d",self.categoryID];
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),
                            kRequestPageSizeKey:@(kRequestDefaultPageSize),
                            @"searchKey"    :str,
                            @"areaId"       :areaIDStr,
                            @"categoryId"   :cateIDStr,
    };
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"PurchaseApi/purchaseSearch" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            if(isEmpty(resultDic[@"params"]))
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
              [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"records"]];
            });
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

#pragma mark ---- 请求品类和类目数据
- (void)requstCategoryList
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"category/allCategory" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            NSArray *_arr = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:resultDic[@"params"]];
            
            self.categoryArray   = [[NSMutableArray alloc] init];
            self.categoryIDArray = [[NSMutableArray alloc] init];
            
            for(int i=0;i<_arr.count;i++)
            {
                GoodsCategoryModel *model = [_arr objectAtIndex:i];
                if(model.hasSubCategory == 1)
                {
                   NSArray *model_sub_arr = model.subCateGory;
                   for(int j=0;j<model_sub_arr.count;j++)
                   {
                       NSDictionary *model2 = [model_sub_arr objectAtIndex:j];
                       if([model2[@"hasSubCategory"] intValue] == 1)
                       {
                           NSArray *last_sub_arr = model2[@"subCateGory"];
                           for(int k=0;k<last_sub_arr.count;k++)
                           {
                               NSDictionary *lastmodel = [last_sub_arr objectAtIndex:k];
                               
                               if([lastmodel[@"hasSubCategory"] intValue] == 1)
                               {
                                   NSArray *last_sub_arr_1 = lastmodel[@"subCateGory"];
                                   for(int k=0;k<last_sub_arr_1.count;k++)
                                   {
                                       NSDictionary *lastmodel_1 = [last_sub_arr_1 objectAtIndex:k];
                                       
                                       [self.categoryArray addObject:lastmodel_1[@"cateGoryName"]];
                                       [self.categoryIDArray addObject:lastmodel_1[@"cateGoryId"]];
                                   }
                               }
                           }
                       }
                   }
                }
            }
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}


#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0,42.5, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-42.5) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = [UIColor whiteColor];
        _listTableView.cellHeight = 165.0f;
        
        WEAK_SELF
        [_listTableView configurecellNibName:@"BuyHallCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            
            BuyHallCell *tempcell =(BuyHallCell *)cell;
            if([cellModel isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic=(NSDictionary *)cellModel;
                [tempcell setDic:dic];
            }
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            
            [tableView deselectRowAtIndexPath:clickIndexPath animated:NO];
            BuyHallInfoViewController *vc = [[BuyHallInfoViewController alloc] init];
            NSDictionary *dic=(NSDictionary *)cellModel;
            vc.hallId = dic[@"id"];
            [self navigatePushViewController:vc animate:YES];
            
        }];
        
        
        [_listTableView headerRreshRequestBlock:^{
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
            [weak_self _requestOrderData:weak_self.searchField.text];
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
            [weak_self _requestOrderData:weak_self.searchField.text];
            
        }];
        
        
        
    }
    
    return _listTableView;
}
@end
