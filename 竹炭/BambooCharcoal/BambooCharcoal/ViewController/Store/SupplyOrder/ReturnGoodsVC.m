//
//  ReturnGoodsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ReturnGoodsVC.h"
#import "ReturnGoodsHeaderView.h"
#import "WaitingPayTabCell.h"
#import "HomeAllCollectionCell.h"
#import "ReturnGoodsFooterView.h"
#import "RefusedShowView.h"
@interface ReturnGoodsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *detailsCollecView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,strong)ReturnGoodsHeaderView *headerView;
@property (nonatomic,strong)ReturnGoodsFooterView *footerView;
@end

@implementation ReturnGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initCollection];
    [self _initBottomView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.fd_prefersNavigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initCollection {
    
    [self.view addSubview:self.detailsCollecView];
   
    WEAK_SELF
    [self.detailsCollecView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.width.left.mas_equalTo(weak_self.view);
        make.bottom.mas_equalTo(weak_self.view.mas_bottom).offset(-56);
        
    }];
    if (@available(iOS 11.0, *)) {
        self.detailsCollecView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
     
    
}

-(void)_initBottomView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-56, kScreenWidth, 56)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyBtn.frame = CGRectMake(kScreenWidth-72-14, 12, 72, 32);
    [buyBtn setTitle:@"联系买家" forState:UIControlStateNormal];
    buyBtn.titleLabel.font=CUSTOMFONT(14);
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn setBackgroundColor:KCOLOR_Main];
    buyBtn.layer.cornerRadius=16;
    [bottomView addSubview:buyBtn];
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    agreeBtn.frame = CGRectMake(kScreenWidth-72*2-14*2, 12, 72, 32);
    [agreeBtn setTitle:@"同意退款" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font=CUSTOMFONT(14);
    [agreeBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setBackgroundColor:[UIColor whiteColor]];
    agreeBtn.layer.cornerRadius=16;
    agreeBtn.layer.borderColor=UIColorFromRGB(0xDEDEDE).CGColor;
    agreeBtn.layer.borderWidth=0.5;
    [bottomView addSubview:agreeBtn];
    
    UIButton *refusedBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    refusedBtn.frame = CGRectMake(kScreenWidth-72*3-14*3, 12, 72, 32);
    [refusedBtn setTitle:@"拒绝退款" forState:UIControlStateNormal];
    refusedBtn.titleLabel.font=CUSTOMFONT(14);
    [refusedBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    [refusedBtn addTarget:self action:@selector(refusedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [refusedBtn setBackgroundColor:[UIColor whiteColor]];
    refusedBtn.layer.cornerRadius=16;
    refusedBtn.layer.borderColor=UIColorFromRGB(0xDEDEDE).CGColor;
    refusedBtn.layer.borderWidth=0.5;
    [bottomView addSubview:refusedBtn];
    
}

#pragma mark ------------------------Delegate-----------------------------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    WaitingPayTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WaitingPayTabCell" forIndexPath:indexPath];
    
      return cell;
  
   
}
//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    

    if (kind == UICollectionElementKindSectionHeader) {
            
                self.headerView  = (ReturnGoodsHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReturnGoodsHeaderView" forIndexPath:indexPath];
                WEAK_SELF
                [self.headerView.gobackBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                    [weak_self goBack];
                }];
                return self.headerView;
        
        
    }else{
        
        if (kind == UICollectionElementKindSectionFooter) {
            
               self.footerView  = (ReturnGoodsFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReturnGoodsFooterView" forIndexPath:indexPath];

             return self.footerView;
            
        
        
        }
    
    }
        
 
    return 0;
    
}

//单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return CGSizeMake(kScreenWidth, 100);
     
 
}



// 设置header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth,248);
}

// 设置Footer的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
      
    return CGSizeMake(kScreenWidth, 115);
    
}


//设置每个组有多少个方块
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return 2;
}

#pragma mark ------------------------View Event---------------------------
-(void)buyBtnClick{//联系买家
    
}

-(void)agreeBtnClick{//同意退款
    
}
-(void)refusedBtnClick{//拒绝退款
    RefusedShowView *showView=[[RefusedShowView alloc]initWithRefusedFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
      showView.deliveryBlock = ^(NSString *str) {
          NSLog(@"%@",str);
      };
      [self.view addSubview:showView];
}
 
#pragma mark ------------------------Getter / Setter----------------------

- (UICollectionView *)detailsCollecView
{
    if (!_detailsCollecView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing=0;//必须设置不然会有10的x间隙
        flowLayout.minimumInteritemSpacing=0;//必须设置不然会有10的x间隙
        _detailsCollecView.alwaysBounceVertical = YES;
        _detailsCollecView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _detailsCollecView.delegate = self;
        _detailsCollecView.dataSource = self;
        _detailsCollecView.showsVerticalScrollIndicator = NO;
        _detailsCollecView.showsHorizontalScrollIndicator = NO;
        [_detailsCollecView setBackgroundColor:KViewBgColor];
        //注册cell
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"WaitingPayTabCell" bundle:nil] forCellWithReuseIdentifier:@"WaitingPayTabCell"];
     
      
        //注册头
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"ReturnGoodsHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReturnGoodsHeaderView"];
        
        //注册尾部
        [_detailsCollecView registerNib:[UINib nibWithNibName:@"ReturnGoodsFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReturnGoodsFooterView"];
    }
    return _detailsCollecView;
}
@end
