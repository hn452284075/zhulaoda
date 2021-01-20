//
//  SearchViewController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/18.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SearchViewController.h"
#import "HMSegmentedControl.h"
#import "HMSegementController.h"
#import "SearchListVC.h"
#import "MycommonTableView.h"
#import "SearchCell.h"
#import "MyCommonCollectionView.h"
#import "AddressCell.h"
#import "EWAddressModel.h"
#import "AddressHeaderView.h"
#import "AddressShowView.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "UIView+Frame.h"
#import "ScreeningVC.h"
#import "CQSideBarManager.h"
#import "CategoryShowView.h"
#import "GoodsInfoViewController.h"
#import "GoodsCategoryModel.h"
@interface SearchViewController ()<CQSideBarManagerDelegate,AddressShowViewDelegate,UITextFieldDelegate>
{
    UIView  *lineView;
}
@property (nonatomic,strong)ScreeningVC *screeningVC;//筛选页面，用控制器方便后续扩展
@property (nonatomic,strong)UITextField *searchField;
@property (nonatomic,assign)NSInteger indexBtn;
@property (nonatomic,assign)NSInteger typeindexBtn;
@property (nonatomic,strong)NSMutableArray *buttonArr;
@property (nonatomic,strong)NSMutableArray *buttonTypeArr;
@property (strong, nonatomic)HMSegmentedControl *topBarControl;
@property (strong, nonatomic)HMSegementController *topBarController;
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,strong)AddressShowView *addressShowView;
@property (nonatomic,strong)CategoryShowView *categoryShowView;
@property (nonatomic,strong)NSString *nearSortState;//全部或者附近搜索
@property (nonatomic,strong)NSMutableArray *cateGoryArr;

@property (nonatomic, strong) NSDictionary *allAddressDic;
@property (nonatomic,strong)NSDictionary *searDic;//搜索内容

@property (nonatomic, strong) NSMutableArray        *categoryArray; //类目数组
@property (nonatomic, strong) NSMutableArray        *categoryIDArray; //类目ID数组

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nearSortState=@"0";
    [self _initTopView];
    [self searchData];
    
    [self.view addSubview:self.listTableView];
    [self _requestGoodsAllCategory];
}


-(void)searchData{
    if(self.searchGoodsID > 0)
    {
        [self _requestGoodsList:@{@"searchKey":_searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
        kRequestPageSizeKey:@(kRequestDefaultPageSize),@"nearSortState":_nearSortState}];
    }
    else if(self.searchStr.length > 0)
    {
        [self _requestGoodsList:@{@"searchKey":_searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
        kRequestPageSizeKey:@(kRequestDefaultPageSize),@"nearSortState":_nearSortState}];
    }else
    {
        [self _requestGoodsList:@{@"place":[NSNumber numberWithInt:self.searchPlaceID],kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
        kRequestPageSizeKey:@(kRequestDefaultPageSize)}];
    }
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
    _searchField.text = _searchStr;
    _searchField.textColor = KTextColor;
    _searchField.borderStyle = UITextBorderStyleNone;
    _searchField.placeholder = @"请输入搜索关键词";
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.delegate=self;
    [seachView addSubview:_searchField];

    self.navigationItem.titleView = seachView;
    
    UIView *seletecdBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    seletecdBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seletecdBgView];
    
    _buttonArr = [[NSMutableArray alloc]init];
    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
    lineV.backgroundColor = KLineColor;
    [seletecdBgView addSubview:lineV];
    NSArray  *allTitllesArr = @[@"全部",@"附近"];
       UIButton *toBtn;
       for (int i=0; i<allTitllesArr.count; i++) {
           UIButton *senderBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/2*i, 0, kScreenWidth/2, seletecdBgView.frame.size.height-2)];
           senderBtn.titleLabel.font=[UIFont systemFontOfSize:17];
           [senderBtn setTitle:allTitllesArr[i] forState:UIControlStateNormal];
           [senderBtn setTitleColor:KCOLOR_MAIN_TEXT forState:UIControlStateNormal];
           [senderBtn setTitleColor:KCOLOR_Main forState:UIControlStateSelected];
           senderBtn.tag=1000+i;
           [seletecdBgView addSubview:senderBtn];
           [senderBtn addTarget:self action:@selector(senderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
           if (i ==_indexBtn) {
               senderBtn.selected=YES;
               toBtn =senderBtn;
           }
           
           [_buttonArr addObject:senderBtn];
       }
       if (_indexBtn ==0) {
        lineView=[[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2/2-12, seletecdBgView.height/2+12,24, 3)];
       }
       lineView.layer.cornerRadius=1.5;
       lineView.backgroundColor=KCOLOR_Main;
       [seletecdBgView addSubview:lineView];
    
    
    //条件选择view
    UIView *typeBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 40)];
       typeBgView.backgroundColor = [UIColor whiteColor];
       [self.view addSubview:typeBgView];
       
       _buttonTypeArr = [[NSMutableArray alloc]init];
       UIView *lView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kScreenWidth, 0.5)];
       lView.backgroundColor = KLineColor;
       [typeBgView addSubview:lineV];
       NSArray  *titllesArr = @[@"产地",@"品类",@"销量",@"筛选"];
          UIButton *currenBtn;
          for (int i=0; i<titllesArr.count; i++) {
              UIButton *senderBtn=[UIButton buttonWithType:UIButtonTypeCustom];
              senderBtn.frame = CGRectMake(kScreenWidth/4*i, 0, kScreenWidth/4, typeBgView.frame.size.height-2);
              senderBtn.titleLabel.font=[UIFont systemFontOfSize:14];
              [senderBtn setTitle:titllesArr[i] forState:UIControlStateNormal];
              [senderBtn setTitleColor:KCOLOR_MAIN_TEXT forState:UIControlStateNormal];
              [senderBtn setTitleColor:KCOLOR_Main forState:UIControlStateSelected];
              if (i==0||i==1) {
              [senderBtn setImage:IMAGE(@"grayArrow") forState:UIControlStateNormal];
              [senderBtn setImage:IMAGE(@"greenSeletecd") forState:UIControlStateSelected];
              [senderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
              [senderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
              }
             
              if (i==3) {
              [senderBtn setImage:IMAGE(@"saixuan") forState:UIControlStateNormal];
                  [senderBtn setImage:IMAGE(@"saixuan-grenn") forState:UIControlStateSelected];
                  [senderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
                  [senderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
              }
              
              senderBtn.tag=2000+i;
              [typeBgView addSubview:senderBtn];
              [senderBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//              if (i ==_typeindexBtn) {
//                  senderBtn.selected=YES;
//
//              }
              currenBtn =senderBtn;
              if (i ==2) {//灰色线
                     UIView *smallView=[[UIView alloc]initWithFrame:CGRectMake(senderBtn.frame.size.width-1, 12, 1, 15)];
                     smallView.backgroundColor=[UIColor colorWithRed:0.812 green:0.812 blue:0.812 alpha:0.5];
                     [senderBtn addSubview:smallView];
                }
              
              [_buttonTypeArr addObject:senderBtn];
          }
}
 
 




#pragma mark ------------------------Private------------------------------
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
        if(cname == nil)
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
            if(dname == nil)
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

#pragma mark ------------------------Api----------------------------------
-(void)_requestGoodsList:(NSDictionary *)dic{
       WEAK_SELF
       [self showHub];
    if (isEmpty(dic[@"searchKey"])) {
        [self showMessage:@"请输入搜索关键词"];
    }
    self.searDic=dic;
    [AFNHttpRequestOPManager postWithParameters:dic subUrl:@"search/query" block:^(NSDictionary *resultDic, NSError *error) {
           [weak_self dissmiss];
           NSLog(@"resultDic:%@",resultDic);
           if ([resultDic[@"code"] integerValue]==200) {
               
              
                [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"goodsVoPage"][@"records"]];
                   
           }else{
               [weak_self showMessage:resultDic[@"msg"]];
           }
       }];
}

-(void)_requestGoodsAllCategory{
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
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
#pragma mark ---全部、附近---点击
-(void)senderBtnClick:(UIButton *)sender{
  
    for (UIButton *typeBtn in _buttonTypeArr) {
           typeBtn.selected = NO;
          
      }
    
    for (UIButton *btn in _buttonArr) {
        
        if (btn == sender) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    __block UIView *line=lineView;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect=line.frame;
        rect.origin.x=sender.frame.origin.x+(kScreenWidth/2/2-12);
        line.frame=rect;
    }];
    if (sender.tag == 1000) {
        _indexBtn = 0;
        _nearSortState=@"0";
    }else{
        _nearSortState=@"1";
        _indexBtn = 1;
    }
    
}
#pragma mark --产地 品类 销量 筛选--点击
-(void)typeBtnClick:(UIButton *)sender{
    for (UIButton *btn in _buttonTypeArr) {
           
       if (btn == sender) {
           if (sender.tag==2002) {
           sender.selected =!sender.selected;
           }else{
           btn.selected = YES;
           }
           
       }else{
           btn.selected = NO;
       }
    }
    
    if (sender.tag == 2000) {
        _typeindexBtn = 0;
        if (_categoryShowView!=nil) {
            [_categoryShowView colse];
            _categoryShowView=nil;
        }
        if (_addressShowView==nil) {
            
            _addressShowView = [[AddressShowView alloc]initWithAddresFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-80-kStatusBarAndNavigationBarHeight)];
            _addressShowView.delegate = self;
            WEAK_SELF
            _addressShowView.addressBlock = ^(NSString * _Nonnull str) {
                NSLog(@"%@",str);
                weak_self.addressShowView.delegate = nil;
                weak_self.addressShowView=nil;
            };
            
            [self.view addSubview:_addressShowView];
        }
       
        
    }else if (sender.tag == 2001){
        _typeindexBtn = 1;
        if (_addressShowView!=nil) {
            [_addressShowView colse];
            _addressShowView=nil;
        }
        if (_categoryShowView==nil) {
            _categoryShowView = [[CategoryShowView alloc]initWithCategoryShowViewFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-80-kStatusBarAndNavigationBarHeight) AndDataSource:self.categoryArray];
            WEAK_SELF
            _categoryShowView.seletecdTypeBlock = ^(NSString * _Nullable str) {
                NSLog(@"%@",str);
                weak_self.categoryShowView=nil;
                weak_self.searchField.text = str;
                weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
                           weak_self.listTableView.dataLogicModule.requestFromPage=1;
                [weak_self _requestGoodsList:@{@"searchKey":weak_self.searchField.text,kRequestPageNumKey:@(weak_self.listTableView.dataLogicModule.requestFromPage),
                kRequestPageSizeKey:@(kRequestDefaultPageSize),@"nearSortState":weak_self.nearSortState}];
                
                
            };
            [self.view addSubview:_categoryShowView];
        }
    }else if (sender.tag == 2002){
        [_categoryShowView colse];
        [_addressShowView colse];
        _categoryShowView=nil;
        _addressShowView=nil;
      
        _typeindexBtn = 2;
        NSString *salesSortState;
        if (sender.selected) {
            salesSortState=@"1";
        }else{
            salesSortState=@"0";
        }
        self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
        self.listTableView.dataLogicModule.requestFromPage=1;
        [self _requestGoodsList:@{@"searchKey":_searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
                                  kRequestPageSizeKey:@(kRequestDefaultPageSize),@"salesSortState":salesSortState,@"nearSortState":_nearSortState}];
    }else{
        [_categoryShowView colse];
        [_addressShowView colse];
        _categoryShowView=nil;
        _addressShowView=nil;
        
           
        _typeindexBtn = 3;
         [[CQSideBarManager sharedInstance] openSideBar:self];
    }
    
  
    
}


 

- (IBAction)goBackClick:(id)sender{
    [self goBack];
}

-(void)searchClick{
    [self.view endEditing:YES];
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    [self searchData];
    [self _requestGoodsList:self.searDic];
}

#pragma mark ------------------------Delegate-----------------------------
- (void)adressSelectedPro:(NSString *)prostr city:(NSString *)city area:(NSString *)area
{
    int adress_id = -1;
    if(city == nil || city.length == 0)
        city = nil;
    if(area == nil || area.length == 0)
        area = nil;
    adress_id = [self getIDAddressFormFile:prostr cityname:city disname:area];
    NSLog(@"地区ID = %d  %@",adress_id,prostr);
    if(adress_id == -1)
    {
        [self _requestGoodsList:@{@"place":[NSNumber numberWithInt:adress_id],@"searchKey":self.searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
        kRequestPageSizeKey:@(kRequestDefaultPageSize)}];
    }
    else
    {
        [self _requestGoodsList:@{@"searchKey":self.searchField.text,kRequestPageNumKey:@(self.listTableView.dataLogicModule.requestFromPage),
        kRequestPageSizeKey:@(kRequestDefaultPageSize)}];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchField.text.length>0) {
        [self searchClick];
        [self.searchField  resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - CQSideBarManagerDelegate
- (UIView *)viewForSideBar
{
    /*
     *  如果使用VC的view作为侧边栏视图，那么需要注意在ARC模式下控制器出了作用域会被释放掉这种情况，导致无法响应点击事件，个别同学已经碰到这种问题，现已作出解释。比如以下这个写法:
     *  SideBarViewController *sideBarVC = [[SideBarViewController alloc] init];
     *  sideBarVC.view.cq_width = self.view.cq_width - 35.f;
     *  return sideBarVC.view;
     */
    return self.screeningVC.view;
}

- (BOOL)canCloseSideBar
{
    return YES;
}


#pragma mark ------------------------Getter / Setter----------------------
- (ScreeningVC *)screeningVC
{
    if (!_screeningVC) {
        _screeningVC = [[ScreeningVC alloc] init];
        _screeningVC.view.width = kScreenWidth-99;
        WEAK_SELF
        _screeningVC.screeningDataBlock = ^(NSString * _Nullable lowStr,NSString * _Nullable highStr,NSString * _Nullable dayStr) {
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
            
            [weak_self _requestGoodsList:@{@"searchKey":weak_self.searchField.text,kRequestPageNumKey:@(weak_self.listTableView.dataLogicModule.requestFromPage),
                                           kRequestPageSizeKey:@(kRequestDefaultPageSize),@"priceStart":lowStr,@"priceEnd":highStr,@"withinDays":dayStr,@"nearSortState":weak_self.nearSortState}];
            
        };
    }
    return _screeningVC;
}
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0,80,kScreenWidth, kScreenHeight-80-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 163.0f;
        
        [_listTableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
        WEAK_SELF
        [_listTableView configurecellNibName:@"SearchCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
        
            SearchCell *searchCell = (SearchCell *)cell;
            [searchCell setDic:(NSDictionary *)cellModel];
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
         
            NSDictionary *dicresultDic=(NSDictionary *)cellModel;
            
            GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
             vc.goodsID = [dicresultDic[@"goodsId"]intValue];
             [self navigatePushViewController:vc animate:YES];
            
        }];
        
        
       [_listTableView headerRreshRequestBlock:^{
           weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
           weak_self.listTableView.dataLogicModule.requestFromPage=1;
            [weak_self _requestGoodsList:self.searDic];
        }];
               
               
       [_listTableView footerRreshRequestBlock:^{
           [weak_self _requestGoodsList:self.searDic];
           
       }];
        
        
        
    }
    
    return _listTableView;
}



 


 
@end
