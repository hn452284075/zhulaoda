//
//  ClassGoodsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ClassGoodsVC.h"
#import "UIView+Frame.h"
#import "SearchGoodsVC.h"
#import "ClassGoodsCell.h"
#import "MycommonTableView.h"
#import "ClassGoodsCollectionCell.h"
#import "CellCalculateModel.h"
#import "JJCollectionViewRoundFlowLayout.h"
#import "AddressCell.h"
#import "GoodsCategoryModel.h"
#import "SearchViewController.h"
#import "MyCommonCollectionView.h"
#import "BuyHallResultVC.h"


@interface ClassGoodsVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,JJCollectionViewDelegateRoundFlowLayout>
@property (nonatomic,strong)UITextField *searchField;
@property(nonatomic,strong)MycommonTableView *classTableView;
@property (nonatomic,strong)NSIndexPath *lastLeftIndex;
@property (nonatomic,strong)NSIndexPath *lastRightIndex;
@property (nonatomic,strong)NSMutableArray *catListArr;
@property (nonatomic,strong)MyCommonCollectionView *collectionView;
@property (nonatomic,strong)JJCollectionViewRoundFlowLayout *flowlayout;

@property (nonatomic, strong) NSMutableArray *selectedCateArray;
@property (nonatomic, strong) NSArray *selectedHotCateArray;
@property (nonatomic, strong) NSArray *allHotCateArray;


@end

@implementation ClassGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initTopSearchView];
//    [self initClassTableView];
//    [self initClassCollectionView];
        
    self.selectedCateArray = [[NSMutableArray alloc] init];
    
    [self requstCategoryList];
    
}
#pragma mark ------------------------Init---------------------------------
- (void)initTopSearchView{
    
    UIButton *button_na = [[UIButton alloc]initWithFrame:CGRectMake(0, 22, 25, 50)];
    [button_na setImage:[UIImage imageNamed:@"greenArrow"] forState:UIControlStateNormal];
    [button_na addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:button_na];
    self.navigationItem.leftBarButtonItem = leftItem;
    // 创建搜索框
     UIView *seachView = [[UIView alloc] initWithFrame:CGRectMake(42.5, 7, kScreenWidth-55, 30)];
     seachView.backgroundColor = UIColorFromRGB(0xF4F4F4);
     seachView.layer.cornerRadius=15;
     
    WEAK_SELF
    [seachView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self jumpSearchGoodsVC];
    }];
     UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     seachBtn.frame =CGRectMake(15,5, 20, 20);
    [seachBtn setImage:IMAGE(@"home-seacher") forState:UIControlStateNormal];
    [seachBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    seachBtn.titleLabel.font= CUSTOMFONT(12);
    [seachView addSubview:seachBtn];
     // 创建文本框
     _searchField = [[UITextField alloc] initWithFrame:CGRectMake(seachBtn.right+5, 0, seachView.width-seachBtn.right-5, 30)];
    _searchField.userInteractionEnabled=NO;
     _searchField.font = [UIFont systemFontOfSize:12];
     _searchField.textColor = KTextColor;
     _searchField.borderStyle = UITextBorderStyleNone;
     _searchField.placeholder = @"请输入搜索关键词";
     [seachView addSubview:_searchField];

     self.navigationItem.titleView = seachView;
}
- (void)initClassTableView{
    self.classTableView = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, 96, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    self.classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.classTableView.showsVerticalScrollIndicator = NO;
    self.classTableView.backgroundColor = KViewBgColor;
    self.classTableView.cellHeight = 48.0f;
    self.lastLeftIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    WEAK_SELF
    [self.classTableView configurecellNibName:@"ClassGoodsCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
        
        ClassGoodsCell *classCell = (ClassGoodsCell *)cell;
        
        classCell.titleLabel.text = (NSString*)cellModel;
            if (self.lastLeftIndex.row==index) {
                classCell.titleLabel.textColor =UIColorFromRGB(0x222222);
                classCell.backgroundColor=[UIColor whiteColor];
                classCell.seletecdView.hidden=NO;
                classCell.titleLabel.font=CUSTOMBOLDFONT(14);
                
            }else{
                classCell.seletecdView.hidden=YES;
                classCell.backgroundColor =KViewBgColor;
                classCell.titleLabel.textColor =UIColorFromRGB(0x343434);
                classCell.titleLabel.font=CUSTOMFONT(12);
            }
 
     
      
    } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
        if (weak_self.lastLeftIndex!=clickIndexPath) {
            [weak_self.collectionView reloadData];
            
             ClassGoodsCell *lastCell = (ClassGoodsCell *)[weak_self.classTableView  cellForRowAtIndexPath:weak_self.lastLeftIndex];
             lastCell.backgroundColor =KViewBgColor;
            lastCell.seletecdView.hidden=YES;
            lastCell.titleLabel.font=CUSTOMFONT(12);
            lastCell.titleLabel.textColor =UIColorFromRGB(0x343434);
            ClassGoodsCell *currentCell = (ClassGoodsCell *)[weak_self.classTableView  cellForRowAtIndexPath:clickIndexPath];
            currentCell.backgroundColor =[UIColor whiteColor];
            currentCell.seletecdView.hidden=YES;
            currentCell.titleLabel.font=CUSTOMBOLDFONT(14);
            currentCell.titleLabel.textColor =UIColorFromRGB(0x222222);
            currentCell.seletecdView.hidden=NO;
             weak_self.lastLeftIndex = clickIndexPath;
            
           [weak_self.classTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:clickIndexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                    
            NSString *selectedStr = [self.catListArr objectAtIndex:clickIndexPath.row];
            for(int i=0;i<self.categoryArray.count;i++)
            {
                GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
                if(model.hasSubCategory == 1)
                {
                    NSArray *model_sub_arr = model.subCateGory;
                    for(int j=0;j<model_sub_arr.count;j++)
                    {
                        NSDictionary *model2 = [model_sub_arr objectAtIndex:j];
                        if([model2[@"cateGoryName"] isEqualToString:selectedStr])
                        {
                            weak_self.selectedCateArray = model2[@"subCateGory"];
                        }
                    }
                }
            }
                        

//            NSDictionary *dic = (NSDictionary *)cellModel;
//            weak_self.catId =[NSString stringWithFormat:@"%@",dic[@"cat_id"]];
//            weak_self.orderlastIndex =   [NSIndexPath indexPathForRow:0 inSection:0];
//            [weak_self _initmallTableView];
            
        
        }
        
    }];
    
    self.catListArr = [[NSMutableArray alloc] init];
    [self.catListArr addObject:@"热门分类"];
    
    for(int i=0;i<self.categoryArray.count;i++)
    {
        GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
        if(model.hasSubCategory == 1)
        {
            NSArray *model_sub_arr = model.subCateGory;
            for(int j=0;j<model_sub_arr.count;j++)
            {
                NSDictionary *model2 = [model_sub_arr objectAtIndex:j];
                [self.catListArr addObject:model2[@"cateGoryName"]];
            }
        }
        
    }
        
    
    [self.classTableView  configureTableAfterRequestPagingData:self.catListArr];
    [self.view addSubview:self.classTableView];
}

-(void)initClassCollectionView{
    
    self.flowlayout = [[JJCollectionViewRoundFlowLayout alloc] init];
    
    [self.flowlayout setHeaderReferenceSize:CGSizeMake(kScreenWidth-108-14, 40)];
    [self.flowlayout setFooterReferenceSize:CGSizeMake(kScreenWidth-108-14, 10)];
    self.flowlayout.isCalculateFooter =YES;
    self.flowlayout.isCalculateHeader = YES;
    //设置滚动方向
    [self.flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView = [[MyCommonCollectionView alloc] initWithFrame:CGRectMake(108,0, kScreenWidth-108-14, kScreenHeight-kStatusBarAndNavigationBarHeight)  collectionViewLayout:self.flowlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassGoodsCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ClassGoodsCollectionCell"];
 

    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"AddressCell" bundle:nil] forCellWithReuseIdentifier:@"AddressCell"];
    
    //注册头
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
      
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
         
    [self.view  addSubview:_collectionView];
}



#pragma mark ------------------------Private-------------------------

#pragma mark ------------------------Api----------------------------------
#pragma mark ---- 请求所有热门分类
- (void)requstCategoryList
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        @"secondLevelCategoryId":@"-1",
    } subUrl:@"category/queryTopCategory" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200)
        {
            weak_self.allHotCateArray = [GoodsCategoryModel mj_objectArrayWithKeyValuesArray:resultDic[@"params"]];
            
            [weak_self initTopSearchView];
            [weak_self initClassTableView];
            [weak_self initClassCollectionView];
            
            if(self.currentCateName !=nil && self.currentCateName.length > 0)
            {
                if([self.currentCateName isEqualToString:@"全部"])
                    self.currentCateName = @"热门分类";
                int selectedRow = (int)[self.catListArr indexOfObject:self.currentCateName];
                NSIndexPath *path;
                if (selectedRow==-1) {
                    path = [NSIndexPath indexPathForRow:0 inSection:0];
                }else{
                    path = [NSIndexPath indexPathForRow:selectedRow inSection:0];
                }
                NSLog(@"%d",selectedRow);
                NSLog(@"%ld",self.catListArr.count);
                
                    
                [self.classTableView selectRowAtIndexPath:path animated:YES scrollPosition: UITableViewScrollPositionNone];
                  if ([self.classTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
                    [self.classTableView.delegate tableView:self.classTableView didSelectRowAtIndexPath:path];
                }
            }
            
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

#pragma mark ------------------------Page Navigate---------------------------
-(void)jumpSearchGoodsVC{
    SearchGoodsVC *vc = [[SearchGoodsVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
#pragma mark ------------------------View Event---------------------------
-(void)moreBtnClick:(UIButton *)btn
{
    GoodsCategoryModel *model = [self.allHotCateArray objectAtIndex:btn.tag];
    NSString *str = [model.cateGoryName substringWithRange:NSMakeRange(2, model.cateGoryName.length-2)];
    int selectedRow = (int)[self.catListArr indexOfObject:str];
    NSIndexPath *path = [NSIndexPath indexPathForRow:selectedRow inSection:0];
        
    [self.classTableView selectRowAtIndexPath:path animated:YES scrollPosition: UITableViewScrollPositionNone];
      if ([self.classTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.classTableView.delegate tableView:self.classTableView didSelectRowAtIndexPath:path];
    }
}


#pragma mark ------------------------Delegate-----------------------------

- (JJCollectionViewRoundConfigModel *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout configModelForSectionAtIndex:(NSInteger)section{
    
    JJCollectionViewRoundConfigModel *model = [[JJCollectionViewRoundConfigModel alloc]init];
    model.cornerRadius = 5;
    model.borderColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    model.borderWidth = 1.0;
  
    return model;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(self.lastLeftIndex.row == 0)
    {
        return self.allHotCateArray.count;
    }
    return  [self.selectedCateArray count]+1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.lastLeftIndex.row == 0)
    {
        GoodsCategoryModel *model = [self.allHotCateArray objectAtIndex:section];
        return model.topCategories.count;
//        for(int i=0;i<self.allHotCateArray.count;i++)
//        {
//            GoodsCategoryModel *model = [self.allHotCateArray objectAtIndex:i];
//            if(model.hasTopCategories == 1)
//            {
//                NSLog(@"个数%ld",model.topCategories.count);
//                return model.topCategories.count;
//            }
//        }
    }
    else
    {
        if(section == 0)
        {
            for(int i=0;i<self.categoryArray.count;i++)
            {
                GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
                if(model.hasSubCategory == 1)
                {
                   NSArray *model_sub_arr = model.subCateGory;
                   for(int j=0;j<model_sub_arr.count;j++)
                   {
                       NSDictionary *model2 = [model_sub_arr objectAtIndex:j];
                       if(model2[@"subCateGory"] == self.selectedCateArray)
                       {
                           self.selectedHotCateArray = model2[@"topCategories"];
                           return self.selectedHotCateArray.count;
                       }
                   }
                }
            }
        }
        if(section -1 > self.selectedCateArray.count)
            return 0;
        NSDictionary *dic = [self.selectedCateArray objectAtIndex:section-1];
        if([dic[@"hasSubCategory"] intValue] == 1)
        {
            NSArray *arr = dic[@"subCateGory"];
            return arr.count;
        }
    }
    return 0;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.lastLeftIndex.row!=0) {
        
        if (indexPath.section==0) {
            ClassGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassGoodsCollectionCell" forIndexPath:indexPath];
                        
            NSDictionary *dic1 = [self.selectedHotCateArray objectAtIndex:indexPath.row];
            cell.goodsName.text = dic1[@"cateGoryName"];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:dic1[@"iconUrl"]]];
            cell.goodsImage.layer.cornerRadius = 29;
            cell.tag = [dic1[@"cateGoryId"] intValue];
            
            cell.goodsName.textColor = UIColorFromRGB(0x222222);
            cell.goodsName.font = [UIFont boldSystemFontOfSize:12];
            
            return cell;
        }else{
            AddressCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressCell" forIndexPath:indexPath];
            
            //cell.titleLabel.text = @"水果";
            
                                
            NSDictionary *dic = [self.selectedCateArray objectAtIndex:indexPath.section-1];
            if([dic[@"hasSubCategory"] intValue] == 1)
            {
                NSArray *dic_arr = dic[@"subCateGory"];
                NSDictionary *dic1 = [dic_arr objectAtIndex:indexPath.row];
                cell.titleLabel.text = dic1[@"cateGoryName"];
                cell.titleLabel.tag = [dic1[@"cateGoryId"] intValue];
                cell.titleLabel.textColor = UIColorFromRGB(0x222222);
                cell.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            }
            
            
            
            cell.titleLabel.backgroundColor = [UIColor whiteColor];
            cell.titleLabel.layer.cornerRadius=5;
            cell.titleLabel.layer.borderColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0].CGColor;
            cell.titleLabel.layer.borderWidth=0.5;
            return cell;
        }
        
    }
     
    if(self.lastLeftIndex.row == 0)
    {
        ClassGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassGoodsCollectionCell" forIndexPath:indexPath];
        
        GoodsCategoryModel *dic = [self.allHotCateArray objectAtIndex:indexPath.section];
        NSArray *arr = dic.topCategories;
        NSDictionary *obj_dic = [arr objectAtIndex:indexPath.row];
        cell.goodsName.text = obj_dic[@"cateGoryName"];
        [cell.goodsImage sd_SetImgWithUrlStr:obj_dic[@"iconUrl"] placeHolderImgName:@"hx_yundian_tupian"];
        cell.goodsImage.layer.cornerRadius = 29;
        cell.tag = [obj_dic[@"cateGoryId"] intValue];
        
        cell.goodsName.textColor = UIColorFromRGB(0x222222);
        cell.goodsName.font = [UIFont boldSystemFontOfSize:12];
        
        return cell;
    }
        
    return nil;
 
     
}

 
//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
        //定制头部视图的内容
        if (kind == UICollectionElementKindSectionHeader) {
          
            UICollectionReusableView *headerV = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
             for (UIView *view in headerV.subviews) {
                
                 [view removeFromSuperview];
                 
            }
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 19, 100, 13)];
            titleLabel.textColor = UIColorFromRGB(0x343434);
            titleLabel.textAlignment=0;
            
            if(indexPath.section-1 < self.selectedCateArray.count)
            {
                NSDictionary *dic = [self.selectedCateArray objectAtIndex:indexPath.section-1];
                titleLabel.text = dic[@"cateGoryName"];
            }
            
            if(self.lastLeftIndex.row == 0)
            {
                GoodsCategoryModel *mm = [self.allHotCateArray objectAtIndex:indexPath.section];
                titleLabel.text = mm.cateGoryName;
            }else
            {
                if(indexPath.section == 0)
                {
                    
                    if(self.selectedHotCateArray.count > 0)
                    {
                        for(int i=0;i<self.categoryArray.count;i++)
                        {
                            GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
                            if(model.hasSubCategory == 1)
                            {
                               NSArray *model_sub_arr = model.subCateGory;
                               for(int j=0;j<model_sub_arr.count;j++)
                               {
                                   NSDictionary *model2 = [model_sub_arr objectAtIndex:j];
                                   if(model2[@"topCategories"] == self.selectedHotCateArray)
                                   {
                                       titleLabel.text = [NSString stringWithFormat:@"热门%@",model2[@"cateGoryName"]];
                                       break;
                                   }
                               }
                            }
                        }
                    }
                }
            }
            
            
            titleLabel.font=CUSTOMFONT(12);
            [headerV addSubview:titleLabel];
            
           
            if (self.lastLeftIndex.row==0) {
                UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                            moreBtn.frame = CGRectMake(_collectionView.width-70, 18.5, 70, 14);
                [moreBtn setTitle:@"查看更多>>" forState:UIControlStateNormal];
                 
                moreBtn.titleLabel.font=CUSTOMFONT(10);
                [moreBtn setTitleColor:UIColorFromRGB(0x9a9a9a) forState:UIControlStateNormal];
                moreBtn.tag=indexPath.section;
                [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [headerV addSubview:moreBtn];
            }
                  
          
            
            return headerV;
        }else{
            UICollectionReusableView *footerV  = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
              
            return footerV;
                
        }
 
    return nil;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str;
    int tag = 0;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if([cell isKindOfClass:[ClassGoodsCollectionCell class]])
    {
        ClassGoodsCollectionCell *cell_1 = (ClassGoodsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        str = cell_1.goodsName.text;
        tag = (int)cell_1.tag;
    }
    else
    {
        AddressCell *cell = (AddressCell *)[collectionView cellForItemAtIndexPath:indexPath];
        tag = (int)cell.titleLabel.tag;
        str = cell.titleLabel.text;
    }
    
    if(self.jumpFlagValue == 1)
    {
        SearchViewController *vc = [[SearchViewController alloc]init];
        vc.searchGoodsID = tag;
        vc.searchStr = str;
        [self navigatePushViewController:vc animate:YES];
    }
    else if(self.jumpFlagValue == 2)
    {
        BuyHallResultVC *vc = [[BuyHallResultVC alloc]init];
        vc.categoryID = tag;
        vc.searchStr  = str;
        [self navigatePushViewController:vc animate:YES];
    }
    
}

//组头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(self.lastLeftIndex.row != 0)
    {
     if(section == 0){
       if(self.selectedHotCateArray.count > 0)
       {
           return CGSizeMake(kScreenWidth-108-14, 40);
       }else{
           return CGSizeMake(0, 0);
       }
     }
    }
    return CGSizeMake(kScreenWidth-108-14, 40);
}

//组尾高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if(self.lastLeftIndex.row != 0)
    {
     if(section == 0){
       if(self.selectedHotCateArray.count > 0)
       {
           return CGSizeMake(kScreenWidth-108-14, 10);
       }else{
           return CGSizeMake(0, 0);
       }
     }
    }
    return CGSizeMake(kScreenWidth-108-14, 10);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 0,10);
    self.flowlayout.minimumInteritemSpacing = 10;
    self.flowlayout.minimumLineSpacing = 10;
    
    if (self.lastLeftIndex.row!=0) {
          
      if (indexPath.section==0) {
          return CGSizeMake(((kScreenWidth-122)-2*10-20)/3, ((kScreenWidth-122)-2*10-20)/3+10);
      }else{
          return CGSizeMake(((kScreenWidth-122)-2*10-20)/3, 28);
      }
    }
    
    return CGSizeMake(((kScreenWidth-122)-2*10-20)/3, ((kScreenWidth-122)-2*10-20)/3+10);
     
}





//设置每组的边框 line间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout borderEdgeInsertsForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(7.5, 0, 0, 0);

}

 

 
 
#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------

@end
