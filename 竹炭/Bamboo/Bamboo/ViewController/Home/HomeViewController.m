//
//  HomeViewController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "HomeViewController.h"
#import "MyCommonCollectionView.h"
#import "HomeAllCollectionCell.h"
#import "AddressCell.h"
#import "HomeHeaderView.h"
#import "SearchGoodsVC.h"
#import "SupplyViewController.h"
#import "AppDelegate.h"
#import "ShopCartViewController.h"
#import "ClassGoodsVC.h"
#import "BuyHallVC.h"
#import "GoodsInfoViewController.h"
#import "SupplyGoodsModel.h"
#import "GoodsCategoryModel.h"
#import "SearchViewController.h"
#import "OSMainViewController.h"
#import "ShopCartManger+request.h"
#import "AFHTTPSessionManager.h"
#import "Util.h"
#import "SELUpdateAlert.h"
#import "ShopModel.h"
#import "OSApplyViewController.h"
#import <CoreTelephony/CTCellularData.h>
#import "PublishGoodsVC.h"
#import "PublishProcurementVC.h"
#import "PersonDetailViewController.h"
@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong)MyCommonCollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)HomeHeaderView *headerV;
@property (nonatomic,strong) NSMutableArray *cycImageArray;  //首页推荐商品数组
@property (nonatomic,strong) NSMutableArray *goodsArray;  //首页推荐商品数组
@property (nonatomic,strong) NSMutableArray *recommendGoodsArray;  //首页推荐商品数组
@property (nonatomic,strong) NSMutableDictionary *categoryDic; //类目数组
@property (nonatomic,strong) NSMutableArray *categoryArray; //类目数组
@property (nonatomic,assign)int topHeight;
@property (nonatomic,strong)UILabel *numLabel;//购物车数量

@property (nonatomic, strong) ShopModel *shopInfo;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _initTop];
    [self _initCollection];
    self.placeholderViewHeight=kStatusBarAndTabBarHeight;
    WEAK_SELF
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self _checkNetWork:^(BOOL isNetWork){            
            if (isNetWork)
            {
                [weak_self requstImagesAndGoodsList];
                [weak_self requstCategoryList];
                
            }
        }];
    });

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.fd_prefersNavigationBarHidden=YES;
    if (UserIsLogin) {
        [self requestShopCarNum];
    }
    
}

 

-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}
 
#pragma mark ------------------------Init---------------------------------
-(void)_initTop{

    
    self.topView= [[UIView alloc] init];
    self.topView.backgroundColor = KCOLOR_Main;
    [self.view addSubview:self.topView];
  
  
    UIView *seachView = [[UIView alloc] init];
    seachView.backgroundColor = [UIColor whiteColor];
    seachView.layer.cornerRadius=15;
    WEAK_SELF
    [seachView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self jumpSeachPage];
    }];
    [self.topView addSubview:seachView];
    
    UIButton *cartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cartBtn addTarget:self action:@selector(cartClick) forControlEvents:UIControlEventTouchUpInside];
    [cartBtn setImage:IMAGE(@"home-care") forState:UIControlStateNormal];
    [self.topView addSubview:cartBtn];
    
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.textColor = KCOLOR_Main;
    self.numLabel.textAlignment=1;
    self.numLabel.backgroundColor = UIColorFromRGB(0xFFDF83);
    self.numLabel.layer.cornerRadius=6;
    self.numLabel.clipsToBounds=YES;
    self.numLabel.font=CUSTOMFONT(10);
    self.numLabel.hidden=YES;
    [self.numLabel addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self cartClick];
    }];
    [self.topView addSubview:self.numLabel];
    
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setImage:IMAGE(@"home-seacher") forState:UIControlStateNormal];
    [seachBtn setTitle:@"请输入商品" forState:UIControlStateNormal];
    [seachBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [seachBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    seachBtn.titleLabel.font= CUSTOMFONT(12);
    seachBtn.userInteractionEnabled=NO;
    [seachView addSubview:seachBtn];
    
    _topHeight=0;
    if (IS_Iphonex_Series) {
        _topHeight=15;
    }
    
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
             
         make.top.width.left.mas_equalTo(weak_self.view);
         make.height.mas_equalTo(66+weak_self.topHeight);
             
    }];
    
    [seachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(29+weak_self.topHeight);
        make.width.mas_equalTo(kScreenWidth-56);
        make.left.mas_equalTo(weak_self.view).offset(15);
        make.height.mas_equalTo(30);
        
    }];
    
    [seachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(13.5);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(20);
    }];
    
    [cartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(seachView);
        make.right.mas_equalTo(weak_self.topView.mas_right).offset(-13);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.mas_equalTo(seachView).offset(-10);
          make.right.mas_equalTo(cartBtn.mas_right);
          make.width.mas_equalTo(12);
          make.height.mas_equalTo(12);
    }];

    
}
- (void)_initCollection {
    
    [self.view addSubview:self.collectionView];
 
    WEAK_SELF
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(weak_self.topView.mas_bottom);
        make.width.left.mas_equalTo(weak_self.view);
        make.height.mas_equalTo(kScreenHeight-kStatusBarAndTabBarHeight-66+weak_self.topHeight);
 
        
    }];
    
}
#pragma mark ------------------------Delegate-----------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.collectionView.dataLogicModule.currentDataModelArr.count;
    
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
        //定制头部视图的内容
        if (kind == UICollectionElementKindSectionHeader) {
            
            self.headerV  = (HomeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderView" forIndexPath:indexPath];
            self.headerV.frame = CGRectMake(0, 0, kScreenWidth, 300+kScreenWidth/2.5+kScreenWidth/3.82);
            
            WEAK_SELF
            self.headerV.seletecdIndexBlock = ^(NSInteger index) {
                
                [weak_self jumpPageIndex:index];
            };
            
            self.headerV.headCycleView.delegate = self;
            
            self.headerV.openStoreImg.userInteractionEnabled = YES;
            [self.headerV.openStoreImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                
                [weak_self getShopInfo];
                
            }];
            NSLog(@"%@",NSStringFromCGRect(self.headerV.openStoreImg.frame));
            
            return self.headerV;
        }
 
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeAllCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeAllCollectionCell" forIndexPath:indexPath];
    
    if(self.collectionView.dataLogicModule.currentDataModelArr.count > 0)
    {
        SupplyGoodsModel *model = [self.collectionView.dataLogicModule.currentDataModelArr objectAtIndex:indexPath.row];
        [cell configCellData:model];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
      SupplyGoodsModel *model = [self.collectionView.dataLogicModule.currentDataModelArr objectAtIndex:indexPath.row];
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
    vc.goodsID = model.goodsID;
    vc.goodsImgUrl=model.imgurl;
    [self navigatePushViewController:vc animate:YES];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
       self.flowlayout.sectionInset = UIEdgeInsetsMake(10, 16, 12,16);
       self.flowlayout.minimumInteritemSpacing = 16;
       self.flowlayout.minimumLineSpacing = 16;
               
       CellCalculateNeedModel *cellCaculateNeedModel = [[CellCalculateNeedModel alloc] initWithHorizontalDisplayCount:2 horizontalDisplayAreaWidth:kScreenWidth cellImgToSideEdge:0 cellImgWidthToHeightScale:1.0 cellOterPartHeightBesideImg:90 edgeBetweenCellAndCell:16 edgeBetweenCellAndSide:16];
       CellCalculateModel *cellCaculateModel = [[CellCalculateModel alloc] initWithCalculateNeedModel:cellCaculateNeedModel];
    
        return CGSizeMake(cellCaculateModel.cellWidth, cellCaculateModel.cellHeight);
}


#pragma mark ------------ 轮播图点击事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
{
    SearchViewController *vc = [[SearchViewController alloc]init];
    if(index == 0)
    {
        vc.searchGoodsID = 29;
        vc.searchStr = @"苹果";
    }
    else if(index == 1)
    {
        vc.searchGoodsID = 30;
        vc.searchStr = @"鲜枣";
    }
    else if(index == 2)
    {
        vc.searchGoodsID = 31;
        vc.searchStr = @"石榴";
    }
    [self navigatePushViewController:vc animate:YES];
}


#pragma mark ------------------------Getter / Setter----------------------
- (MyCommonCollectionView *)collectionView
{
    if (!_collectionView)
    {
      

        self.flowlayout = [[UICollectionViewFlowLayout alloc] init];
        
        [self.flowlayout setHeaderReferenceSize:CGSizeMake(kScreenWidth, kScreenWidth/2.5+400)];
         
        
        //设置滚动方向
        [self.flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView = [[MyCommonCollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:self.flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeAllCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HomeAllCollectionCell"];
        WEAK_SELF
        [_collectionView headerRreshRequestBlock:^{
            weak_self.collectionView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.collectionView.dataLogicModule.requestFromPage=1;
            [weak_self requstImagesAndGoodsList];
        }];
        
        [_collectionView footerRreshRequestBlock:^{
            [weak_self requstImagesAndGoodsList];
        }];
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeAllTabCell" bundle:nil] forCellWithReuseIdentifier:@"HomeAllTabCell"];
        
//        //注册头
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeHeaderView"];
    }
    return _collectionView;
}

#pragma mark ------------------------Api----------------------------------
-(void)getShopInfo{
    
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    
    
    if ([[UserModel sharedInstance].phone isEqualToString:@"18670770713"]) {
               
       PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
       [self navigatePushViewController:vc animate:YES];
       return;
    }
    
    WEAK_SELF
    [self showHub];
    
    [AFNHttpRequestOPManager postWithParameters:@{@"shopAccId":[UserModel sharedInstance].userId} subUrl:@"ShopApi/shopDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.shopInfo = [ShopModel mj_objectWithKeyValues:resultDic[@"params"]];
            
           if(self.shopInfo.openPayState == 1){
               PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
               [self navigatePushViewController:vc animate:YES];
           }else{
                OSMainViewController *vc = [[OSMainViewController alloc] init];
                vc.smodel=weak_self.shopInfo;
                [weak_self navigatePushViewController:vc animate:YES];
            }
            
        }else{
            //[weak_self showErrorInfoWithStatus:resultDic[@"desc"]];
            OSMainViewController *vc = [[OSMainViewController alloc] init];
            [self navigatePushViewController:vc animate:YES];
        }
        
    }];
    
}
#pragma mark ---- 请求首页Api接口  轮播图和推荐商品
- (void)requstImagesAndGoodsList
{
    NSDictionary *param = @{kRequestPageNumKey :@(self.collectionView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize)};
              WEAK_SELF
    
        self.goodsArray = [[NSMutableArray alloc] init];
           [self showHub];
           [AFNHttpRequestOPManager postWithParameters:param subUrl:@"homepage/index" block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   
                   //解析轮播图
                   NSArray *_goodsArray = resultDic[@"params"][@"litemallAds"];
                   if(weak_self.cycImageArray == nil || weak_self.cycImageArray.count == 0)
                   {
                       weak_self.cycImageArray = [[NSMutableArray alloc] init];
                       for(int i=0;i<_goodsArray.count;i++)
                       {
                           NSDictionary *_dic = [_goodsArray objectAtIndex:i];
                           [weak_self.cycImageArray addObject:_dic[@"url"]];
                       }
                       [weak_self.headerV setArray:weak_self.cycImageArray];
                   }
                   
                   
                   //解析商品列表
                   NSDictionary *_goodsDic = resultDic[@"params"][@"recommendGoodsVoPage"];
                   NSArray *_goodsArr = _goodsDic[@"records"];
                   for(int i=0;i<_goodsArr.count;i++)
                   {
                       NSDictionary *goodsDic = _goodsArr[i];
                       SupplyGoodsModel *gm = [[SupplyGoodsModel alloc] init];
                       gm.goodsID    = [goodsDic[@"goodsId"] intValue];
                       gm.imgurl     = goodsDic[@"picUrl"];
                       gm.title      = goodsDic[@"goodsName"];
                       gm.adress     = goodsDic[@"place"];
                       gm.updateTime = goodsDic[@"updateTime"];
                       double p      = [goodsDic[@"goodsPrice"] doubleValue];
                       gm.price      = [NSString stringWithFormat:@"%.2f",p];
                       gm.weight     = goodsDic[@"quantity"];
                       gm.name       = goodsDic[@"shopName"];
                       gm.unit       = goodsDic[@"unit"];
                       
                       if ([goodsDic[@"shopTurnover"] floatValue]>0) {
                       gm.total = [NSString stringWithFormat:@"成交%.2f元",[goodsDic[@"shopTurnover"] floatValue]];
                       }else{
                        gm.total = @"";
                       }
                       
                       
                       gm.tagArray = [[NSMutableArray alloc] initWithArray:goodsDic[@"shopTags"]];
                       [weak_self.goodsArray addObject:gm];
                   }
                   
                   [weak_self.collectionView configureCollectionAfterRequestPagingData:weak_self.goodsArray];
                   
                   //解析推荐商品
                   weak_self.recommendGoodsArray = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:resultDic[@"params"][@"recommendCategories"]];
                   [weak_self updateRecommentGoods]; //更新推荐商品
                   
                                     
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
}


#pragma mark ---- 请求品类和类目数据
- (void)requstCategoryList
{
    WEAK_SELF
//    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"category/allCategory" block:^(NSDictionary *resultDic, NSError *error) {
//        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            weak_self.categoryArray = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:resultDic[@"params"]];
//            [weak_self updateCategory];
            [weak_self getAppVersion];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}



- (void)analysisCategoryData:(NSDictionary *)dic topArr:(NSMutableString *)mstr
{
    if([dic[@"hasSubCategory"] intValue] == 1)
    {
        NSArray *dataArr = dic[@"subCateGory"];
        for(int i=0;i<dataArr.count;i++)
        {
            NSDictionary *dic = dataArr[i];
                                
            [self analysisCategoryData:dic topArr:mstr];
            
            
            NSString *_str = [NSString stringWithFormat:@"%@#%@",dic[@"cateGoryName"],dic[@"cateGoryId"]];
            if([dic[@"level"] intValue] == 2)
            {
                [mstr appendString:_str];
                [mstr appendString:@"-"];
                
            }else if([dic[@"level"] intValue] == 3){
                [mstr appendString:_str];
                [mstr appendString:@"*"];
            }else
            {
                [mstr appendString:_str];
                [mstr appendString:@"&"];
            }
        }
        //[mstr appendString:@"~~~~"];
//        NSString *_str = [NSString stringWithFormat:@"%@#%@",dic[@"cateGoryName"],dic[@"cateGoryId"]];
//        [mstr appendString:_str];
//        [mstr appendString:@"-"];
    }
    else{
        
    }
}


#pragma mark -----购物车数量
-(void)requestShopCarNum{
    
    WEAK_SELF
    [[ShopCartManger sharedManager]getCartGoodsAllNumBlock:^(NSString *numStr) {
        if ([numStr intValue]==0) {
            weak_self.numLabel.hidden=YES;
        }else{
        
            weak_self.numLabel.hidden=NO;
            weak_self.numLabel.text = numStr;
        }
    }];
}

-(void)getAppVersion{
    //当前appstore版本
       WEAK_SELF
       AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APPSTORE_ID] parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          [weak_self _checkVersion:responseObject[@"results"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
 
}

- (void)_checkVersion:(NSArray *)versionArr{
    
    NSDictionary *dict = [versionArr lastObject];
   
    NSLog(@"当前版本为：%@", dict[@"version"]);
    NSLog(@"版本描述：%@",dict[@"releaseNotes"]);
    
    NSString *currenV = [[Util appVersionStr] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *newV = [dict[@"version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    int v1=  [currenV  intValue];//本地版本号
    int v2=  [newV intValue];//最新app store版本
    if (v1<v2) {
        [SELUpdateAlert showUpdateAlertWithVersion:dict[@"version"] Description:dict[@"releaseNotes"]];
        
    }
    
    
}

#pragma mark ------------------------Private------------------------------
- (void)updateCategory
{
    
    
}

- (void)updateRecommentGoods
{
    for(int i=0;i<self.recommendGoodsArray.count;i++)
    {
        GoodsCategoryModel *model = [self.recommendGoodsArray objectAtIndex:i];
        if(i == 0)
        {
            [self.headerV.cate_btn1 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn1.tag = model.cateGoryId;
            [self.headerV.iconImg1 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 1)
        {
            [self.headerV.cate_btn2 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn2.tag = model.cateGoryId;
            [self.headerV.iconImg2 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 2)
        {
            [self.headerV.cate_btn3 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn3.tag = model.cateGoryId;
            [self.headerV.iconImg3 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 3)
        {
            [self.headerV.cate_btn4 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn4.tag = model.cateGoryId;
            [self.headerV.iconImg4 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 4)
        {
            [self.headerV.cate_btn5 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn5.tag = model.cateGoryId;
            [self.headerV.iconImg5 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 5)
        {
            [self.headerV.cate_btn6 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn6.tag = model.cateGoryId;
            [self.headerV.iconImg6 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
        else if(i == 6)
        {
            [self.headerV.cate_btn7 setTitle:model.cateGoryName forState:UIControlStateNormal];
            self.headerV.cate_btn7.tag = model.cateGoryId;
            [self.headerV.iconImg7 sd_SetImgWithUrlStr:model.iconUrl placeHolderImgName:@""];
        }
    }
    self.headerV.cate_btn8.tag = 12345;
    self.headerV.iconImg8.image=IMAGE(@"homeMore");
    
}


#pragma mark ------------------------Page Navigate------------------------
-(void)jumpSeachPage{
    SearchGoodsVC *vc = [[SearchGoodsVC alloc]init];
    [self navigatePushViewController:vc animate:YES];
}
-(void)jumpPageIndex:(NSInteger)index{
    
        
        switch (index) {
            case 0://供应大厅
                {
                    SupplyViewController *supplyCon = [[SupplyViewController alloc] init];
                    supplyCon.categoryArray = self.categoryArray;
                    [self navigatePushViewController:supplyCon animate:YES];                                        
                }
                break;
                
            case 1://求购大厅
                {
                    if (!UserIsLogin) {
                       [self _jumpLoginPage];
                    }
                    else
                    {
                        BuyHallVC *vc = [[BuyHallVC alloc]init];
                        vc.categoryArray = self.categoryArray;
                        [self navigatePushViewController:vc animate:YES];
                    }
                }
                break;
                
            case 2://一件代发
                {
//                    [self showMessage:@"努力开发中"];
                    if (!UserIsLogin) {
                       [self _jumpLoginPage];
                    }else{
                        PublishProcurementVC *vc = [[PublishProcurementVC alloc]init];
                        [self navigatePushViewController:vc animate:YES];

                    }
                }
                break;
                
            case 3://物流叫车
                {
//                    [self requstCategoryList];
//                   [self showMessage:@"努力开发中"];
                    if (!UserIsLogin) {
                        [self _jumpLoginPage];
                    }else{
                        PublishGoodsVC *vc = [[PublishGoodsVC alloc]init];
                        [self navigatePushViewController:vc animate:YES];
                    }
                    
                }
                break;
            default:{
                //找到点击的名称
                NSString *cateName = @"全部";
                for(GoodsCategoryModel *cm in self.recommendGoodsArray)
                {
                    if(cm.cateGoryId == index)
                    {
                        cateName = cm.cateGoryName;
                    }
                }
                
                ClassGoodsVC *vc = [[ClassGoodsVC alloc]init];
                vc.jumpFlagValue = 1;
                vc.categoryArray = self.categoryArray;
                vc.currentCategoryId = (int)index;
                vc.currentCateName = cateName;
                [self navigatePushViewController:vc animate:YES];
            }
                break;
        }
        


    
}

-(void)cartClick{
 
   ShopCartViewController *vc = [[ShopCartViewController alloc]init];
    [self navigatePushViewController:vc animate:YES];

}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


- (void)dealloc {
       [kNotification removeObserver:self];
}

@end
