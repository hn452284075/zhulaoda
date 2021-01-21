//
//  BuyHallSearchVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/7.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallSearchVC.h"
#import "UIBarButtonItem+BarButtonItem.h"
#import "UIView+Frame.h"
#import "UIImage+extern.h"
#import "TMCache.h"
#import "SearchGoodsCell.h"
#import "SearchFlowLayout.h"
#import "BuyHallResultVC.h"
@interface BuyHallSearchVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
 
@property (nonatomic,strong)UITextField *searchField;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)SearchFlowLayout *flowlayout;
@property (nonatomic,strong)NSMutableArray *searchArr;//所有搜索数据包括本地缓存
@property (nonatomic,strong)NSMutableArray *searchHistoriesArr;
@end

@implementation BuyHallSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initHistories];
    [self _initTopView];
    [self _initCollection];
}

#pragma mark ------------------------Init---------------------------------
-(void)_initHistories{
    //历史搜索数据
    _searchHistoriesArr =[[NSMutableArray alloc]initWithArray:[[TMCache sharedCache] objectForKey:HistoriesArray]];
     
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self removeLine];
    [self.collectionView reloadData];
}


- (void)_initTopView{
    
    [self removeLine];
    
    self.searchArr = [[NSMutableArray alloc]init];
    if (!isEmpty(_searchHistoriesArr)) {
        NSDictionary *hisDic=@{@"title":@"我搜索过的",@"content":_searchHistoriesArr};
        [self.searchArr addObject:hisDic];
        
    }
    
    
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
    _searchField.placeholder = @"输入产品名或地区";
    _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [seachView addSubview:_searchField];

    self.navigationItem.titleView = seachView;
    
    UIView *seletecdBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    seletecdBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:seletecdBgView];
    
     
}

#pragma mark ------------------------Init---------------------------------
- (void)_initCollection {
    
    [self.view addSubview:self.collectionView];
 
   

}

#pragma mark ------------------------Private-------------------------

#pragma mark ------------------------Api----------------------------------

#pragma mark ------------------------Delegate-----------------------------
//设置容器中有多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
   
    return self.searchArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSDictionary *dic=[self.searchArr objectAtIndex:section];
    NSArray *arrar = dic[@"content"];
    return [arrar count];
    
}

 

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
      
        UICollectionReusableView *headerV  = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeaderView" forIndexPath:indexPath];
        
        for (UIView *view in headerV.subviews) {
               [view removeFromSuperview];
        }
        
            UILabel *titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(15, 30, 150, 17)];
                   titleLabel.textColor = UIColorFromRGB(0x111111);
                   titleLabel.textAlignment=NSTextAlignmentLeft;
                   NSDictionary *dic=[self.searchArr objectAtIndex:indexPath.section];

                   titleLabel.text =dic[@"title"];
                     
                   titleLabel.font=CUSTOMFONT(16);
                   [headerV addSubview:titleLabel];
                   
                   if (indexPath.section==0&&_searchHistoriesArr.count>0) {
                       
                   UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                   delBtn.frame = CGRectMake(kScreenWidth-40, 27,40, 20);
                   [delBtn setImage:IMAGE(@"searchDelete") forState:UIControlStateNormal];
                       
                   [delBtn addTarget:self action:@selector(delBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
                   [headerV addSubview:delBtn];
                    
             
                   }
       
          return headerV;
    }
    return nil;

}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchGoodsCell" forIndexPath:indexPath];
    NSDictionary *dic=[self.searchArr objectAtIndex:indexPath.section];
    NSArray *arrar = dic[@"content"];
    cell.content.text = arrar[indexPath.row];
    
    return cell;
    
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSDictionary *dic=[self.searchArr objectAtIndex:indexPath.section];
        NSArray *arrar = dic[@"content"];
        NSString *text=arrar[indexPath.row];
    CGSize thesize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    return CGSizeMake(thesize.width + 13*2, 26);
    
}
 
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=[self.searchArr objectAtIndex:indexPath.section];
           NSArray *arrar = dic[@"content"];
           NSString *text=arrar[indexPath.row];
    NSLog(@"%@",text);
    BuyHallResultVC *vc = [[BuyHallResultVC alloc]init];
    vc.searchStr = text;
    [self navigatePushViewController:vc animate:YES];
  
}


#pragma mark ------------------------Page Navigate---------------------------

#pragma mark ------------------------View Event---------------------------
//移除搜索历史
-(void)delBtnBtnClick{
    [[TMCache sharedCache] setObject:@[] forKey:HistoriesArray];
    _searchHistoriesArr=@[].mutableCopy;
    [_searchArr removeObjectAtIndex:0];
    [self.collectionView reloadData];
}
//搜索
-(void)searchClick{
    //存储数据时 是不可变的数组
    
    if (isEmpty(_searchField.text)) {
        [self showMessage:@"请输入搜索内容"];
        return;
    }
    if (isEmpty(_searchHistoriesArr)) {
        [_searchHistoriesArr addObject:_searchField.text];
    }else{
        [_searchHistoriesArr insertObject:_searchField.text atIndex:0];
    }
    [[TMCache sharedCache] setObject:self.searchHistoriesArr forKey:HistoriesArray];
    
    NSDictionary *hisDic=@{@"title":@"我搜索过的",@"content":_searchHistoriesArr};
    if (_searchArr.count>1) {//没有搜索历史则插入数据，有则替换
    [self.searchArr replaceObjectAtIndex:0 withObject:hisDic];
    }else{
    [self.searchArr insertObject:hisDic atIndex:0];
    }
    
    BuyHallResultVC *vc = [[BuyHallResultVC alloc]init];
    vc.searchStr = _searchField.text;
    [self navigatePushViewController:vc animate:YES];

 
}
 
 

#pragma mark ------------------------Getter / Setter----------------------
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
      

       self.flowlayout = [[SearchFlowLayout alloc] init];
       self.flowlayout.minimumLineSpacing = 15;
       self.flowlayout.minimumInteritemSpacing = 15;
       self.flowlayout.sectionInset=UIEdgeInsetsMake(10, 15, 0, 15);
        [self.flowlayout setHeaderReferenceSize:CGSizeMake(kScreenWidth,60)];
//         self.flowlayout.estimatedItemSize = CGSizeMake(30, 30);
        
        //设置滚动方向
        [self.flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight)  collectionViewLayout:self.flowlayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tag=200;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        //注册cell
        [_collectionView registerClass:[SearchGoodsCell class]  forCellWithReuseIdentifier:@"SearchGoodsCell"];
    
        //注册头
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeaderView"];
    }
    return _collectionView;
}
@end


