//
//  SupplyViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SupplyViewController.h"
#import "ProjectStandardUIDefineConst.h"
#import "Masonry.h"
#import "SupplyGoodsCell.h"
#import "GoodsInfoViewController.h"
#import "SupplyGoodsModel.h"
#import "GoodsCategoryModel.h"
#import "ClassGoodsVC.h"
#import "SearchGoodsVC.h"
#import "MycommonTableView.h"
#import "SearchViewController.h"
#import "UIButton+WebCache.h"

@interface SupplyViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSString *class_name_1;
@property (nonatomic, strong) NSString *class_name_2;
@property (nonatomic, strong) NSString *class_name_3;
@property (nonatomic, strong) NSMutableArray    *class_arr_1;
@property (nonatomic, strong) NSMutableArray    *class_arr_2;
@property (nonatomic, strong) NSMutableArray    *class_arr_3;
@property (nonatomic, strong) NSMutableArray    *classView_Array;

//农产品  农资种苗   农机具  三个类别
@property (nonatomic, strong) UIButton *class_btn1;
@property (nonatomic, strong) UIButton *class_btn2;
@property (nonatomic, strong) UIButton *class_btn3;
@property (nonatomic, assign) int selectedIndex;

//选中某一个类别后下方的小图标
@property (nonatomic, strong) UIView   *selectedView;
@property (nonatomic, strong) UIButton *adBtn;

@property (nonatomic, strong) MycommonTableView *goodsTableview;

@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *seachBtn;
@property (nonatomic, strong) UIView   *topView;

@property (nonatomic, strong) NSMutableArray    *goodsArray;  //用来装获取到的产品数据
@property (nonatomic, strong) NSMutableArray    *placesArray; //用来装产地
@property (nonatomic, strong) NSDictionary      *allAddressDic;

@end

@implementation SupplyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fd_prefersNavigationBarHidden=YES;
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
        
    //解析首页传过来的 分类数据
    [self getCategoryInfo];
    self.selectedIndex = 0;
    
    self.goodsArray = [[NSMutableArray alloc] init];
    
    
//    //添加下方的uitableview
//    self.goodsTableview = [[MycommonTableView alloc] init];
//    if (@available(iOS 11.0, *)) {
//        self.goodsTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }else{
//    }
//    int buttomHeight = 0;
//    if(IS_Iphonex_Series)
//        buttomHeight = 15;
//    [self.view addSubview:self.goodsTableview];
//    [self.goodsTableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-buttomHeight);
//        make.width.mas_equalTo(kScreenWidth);
//    }];
//    self.goodsTableview.delegate = self;
//    self.goodsTableview.dataSource = self;
//    self.goodsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.goodsTableview.tableHeaderView = [self tableHeaderView];
//
//    [self _initTopView];
    
    
    //获取下方列表数据
    [self getGoodsListData];
    [self getSupplyInfo];
        
}



#pragma mark ------------------------View Event---------------------------

#pragma mark ------------------------ 返回上级页面
- (void)goBack:(id)sender
{
    [self goBack];
}

#pragma mark ------------------------ 顶部搜索按钮点击事件
- (void)seachBtnclick
{
    if (self.topView.isUserInteractionEnabled) {
        SearchGoodsVC *vc = [[SearchGoodsVC alloc] init];
        [self navigatePushViewController:vc animate:YES];
    }
    
}

#pragma mark ------------------------ 中间部分农产品、农资种苗、农机具点击事件
- (void)classBtnClicked:(id)sender
{
    [self.class_btn1 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    [self.class_btn2 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    [self.class_btn3 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
    
    NSMutableArray *temparr;
    
    for(int i=0;i<self.classView_Array.count;i++)
    {
        UIView *v = [self.classView_Array objectAtIndex:i];
        v.hidden = YES;
    }
    switch (btn.tag) {
        case 1:
        {
            self.selectedView.center = CGPointMake(btn.frame.origin.x+btn.frame.size.width-25, btn.center.y+15);
            temparr = self.class_arr_1;
            self.selectedIndex = 0;
        }
            break;
        case 2:
        {
            self.selectedView.center = CGPointMake(btn.center.x, btn.center.y+15);
            temparr = self.class_arr_2;
            self.selectedIndex = 1;
        }
            break;
        case 3:
        {
            self.selectedView.center = CGPointMake(btn.frame.origin.x+16, btn.center.y+15);
            temparr = self.class_arr_3;
            self.selectedIndex = 2;
        }
            break;
        default:
            break;
    }
    for(int i=0;i<temparr.count;i++)
    {
        if(i == 9)
        {
            UIView *v = [self.classView_Array objectAtIndex:i];
            v.hidden = NO;
            for(UIView *_v in v.subviews)
            {
                if([_v isKindOfClass:[UILabel class]])
                {
                    UILabel *lab = (UILabel *)_v;
                    lab.text = @"查看全部";
                }
            }
        }
        else
        {
            NSDictionary *m = [temparr objectAtIndex:i];
            UIView *v = [self.classView_Array objectAtIndex:i];
            v.hidden = NO;
            for(UIView *_v in v.subviews)
            {
                if([_v isKindOfClass:[UILabel class]])
                {
                    UILabel *lab = (UILabel *)_v;
                    lab.text = m[@"cateGoryName"];
                }
                else if([_v isKindOfClass:[UIButton class]])
                {
                    UIButton *btn = (UIButton *)_v;
                    [btn sd_setImageWithURL:[NSURL URLWithString:m[@"iconUrl"]] forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark ------------------------ 切换产地按钮点击事件
- (void)placeBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *str = btn.titleLabel.text;
    
    int adress_id = [self getIDAddressFormFile:str cityname:nil disname:nil];
    
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchStr = str;
    vc.searchPlaceID = adress_id;
    [self navigatePushViewController:vc animate:YES];
}


#pragma mark ------------------------ 种类分类按钮点击事件
- (void)productClassViewClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int tag = (int)btn.tag - 100;
    NSMutableArray *tmparr;
    if(self.selectedIndex == 0)
        tmparr = self.class_arr_1;
    else if(self.selectedIndex == 1)
        tmparr = self.class_arr_2;
    else
        tmparr = self.class_arr_3;
    NSDictionary *m = [tmparr objectAtIndex:tag];

    ClassGoodsVC *vc = [[ClassGoodsVC alloc] init];
    vc.categoryArray = self.categoryArray;
    vc.jumpFlagValue = 1;
    vc.currentCategoryId = [m[@"cateGoryId"] intValue];
    vc.currentCateName = m[@"cateGoryName"];
    [self navigatePushViewController:vc animate:YES];
}

- (void)adBtnClicked:(id)sender
{
    SearchViewController *vc = [[SearchViewController alloc] init];
    vc.searchStr = @"水果";
    vc.searchGoodsID = 4;
    [self navigatePushViewController:vc animate:YES];
}


#pragma mark ------------------------Init---------------------------------
-(void)_initTopView{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:0];
    _topView.userInteractionEnabled=YES;
    WEAK_SELF
    [_topView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self seachBtnclick];
    }];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-75,kStatusBarAndNavigationBarHeight/2, 150,20)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment=1;
    self.titleLabel.text = @"供应大厅";
    self.titleLabel.font=CUSTOMFONT(17);
    self.titleLabel.alpha=0;
    [_topView addSubview:self.titleLabel];
    
    self.goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackBtn.frame = CGRectMake(0,kStatusBarAndNavigationBarHeight/2, 50, 30);
    [self.goBackBtn setImage:IMAGE(@"supply_back") forState:UIControlStateNormal];
    [self.goBackBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, 0, 0)];
    [self.goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_topView];
    [self.view addSubview:self.goBackBtn];
}

- (UIView *)tableHeaderView
{
    //标题
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 570-105)];
    hview.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
    UIImageView *topImg = [[UIImageView alloc] init];
    [hview addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hview.mas_top);
        make.left.equalTo(hview.mas_left);
        make.right.equalTo(hview.mas_right);
        make.height.mas_equalTo(198.5);
    }];
    topImg.image = IMAGE(@"supply_backimg");
    
    UILabel *titleLab = [[UILabel alloc] init];
    [hview addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hview.mas_top).offset(kStatusBarAndNavigationBarHeight/2);
        make.left.equalTo(hview.mas_left);
        make.right.equalTo(hview.mas_right);
        make.height.mas_equalTo(15.5);
    }];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"供应大厅";
    titleLab.font = [UIFont systemFontOfSize:16];
    titleLab.textColor = kGetColor(255, 255, 255);
        
 
    WEAK_SELF
   self.seachBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.seachBtn setImage:IMAGE(@"home-seacher") forState:UIControlStateNormal];
    [self.seachBtn setTitle:@"请输入商品" forState:UIControlStateNormal];
    [self.seachBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [self.seachBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    self.seachBtn.titleLabel.font= CUSTOMFONT(12);
    [hview addSubview:self.seachBtn];
    self.seachBtn.backgroundColor = [UIColor whiteColor];
    self.seachBtn.layer.cornerRadius=15;
    [self.seachBtn addTarget:self action:@selector(seachBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.seachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(titleLab.mas_bottom).offset(11.5);
              make.left.equalTo(hview.mas_left).offset(14);
              make.right.equalTo(hview.mas_right).offset(-14);
              make.height.mas_equalTo(30);
    }];
    
    
    //搜索框下方广告图
    self.adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hview addSubview:self.adBtn];
    [self.adBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weak_self.seachBtn.mas_bottom).offset(10);
        make.left.equalTo(hview.mas_left).offset(11);
        make.right.equalTo(hview.mas_right).offset(-11);
        make.height.mas_equalTo(120);
    }];
    self.adBtn.layer.cornerRadius = 5.;
    self.adBtn.layer.masksToBounds = YES;
    [self.adBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.adBtn addTarget:self action:@selector(adBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //中间部分 产品种类view
    UIView *productView = [[UIView alloc] init];
    [hview addSubview:productView];
    [productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adBtn.mas_bottom).offset(7);
        make.left.equalTo(hview.mas_left).offset(14);
        make.right.equalTo(hview.mas_right).offset(-14);
        make.height.mas_equalTo(228-92);
    }];
    productView.backgroundColor = [UIColor whiteColor];
    productView.layer.cornerRadius = 5.;
    
    
    self.class_btn1 = [self getCustomBtn:self.class_btn1 title:self.class_name_1 tag:1];
    self.class_btn2 = [self getCustomBtn:self.class_btn2 title:self.class_name_2 tag:2];
    self.class_btn3 = [self getCustomBtn:self.class_btn3 title:self.class_name_3 tag:3];
    
    [productView addSubview:self.class_btn1];
    [self.class_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productView.mas_top).offset(13);
        make.left.equalTo(productView.mas_left);
        make.width.mas_equalTo(productView.mas_width).dividedBy(3);
        make.height.mas_equalTo(16);
    }];
    
    [productView addSubview:self.class_btn2];
    [self.class_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(hview.mas_centerX);
        make.centerY.equalTo(self.class_btn1);
        make.width.mas_equalTo(productView.mas_width).dividedBy(3);
        make.height.mas_equalTo(16);
    }];
    
    [productView addSubview:self.class_btn3];
    [self.class_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.class_btn1);
        make.right.equalTo(productView.mas_right);
        make.width.mas_equalTo(productView.mas_width).dividedBy(3);
        make.height.mas_equalTo(16);
    }];
    
    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 2)];
    self.selectedView.backgroundColor = kGetColor(0x47, 0xc6, 0x7c);
    [productView addSubview:self.selectedView];
    
    self.class_btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.class_btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.class_btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.class_btn1 sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
    
    
    //中间产品分类
    NSMutableArray *classImg_arr1 = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        [classImg_arr1 addObject:@"home-icon_1"];
    }
    NSMutableArray *className_arr1 = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        [className_arr1 addObject:@"苹果"];
    }
    self.classView_Array = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        UIView *view = [self getCustomClassView:[UIImage imageNamed:[classImg_arr1 objectAtIndex:i]] tag:i+100 title:[className_arr1 objectAtIndex:i]];
        [self.classView_Array addObject:view];
        [productView addSubview:view];
    }
    //水平方向宽度固定等间隔
    int row = (int)self.classView_Array.count / 5;
    if(self.classView_Array.count % 5 != 0)
        row +=1;
    UIView *v = [self.classView_Array objectAtIndex:0];
    int gap = (kScreenWidth-5*v.frame.size.width-15*4)/3;
    int x = 15;
    int y = 40;
    int w = v.frame.size.width;
    int h = v.frame.size.height;
    for(int i=0;i<row;i++)
    {
        int temp = 0;
        for(int j=5*i;j<self.classView_Array.count;j++)
        {
            UIView *v = [self.classView_Array objectAtIndex:j];
            v.frame = CGRectMake(x+temp*gap+w*temp, y+h*i, w, h);
            temp++;
            if(temp > 5)
                break;
        }
    }
    
    //产地
    UIView *placeView = [[UIView alloc] init];
    [hview addSubview:placeView];
    [placeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productView.mas_bottom).offset(10);
        make.left.equalTo(hview.mas_left).offset(14);
        make.right.equalTo(hview.mas_right).offset(-14);
        make.height.mas_equalTo(36);
    }];
    placeView.backgroundColor = [UIColor whiteColor];
    placeView.layer.cornerRadius = 5.;
    
    UIScrollView *scrollview = [[UIScrollView alloc] init];
    [placeView addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeView.mas_top).offset(0);
        make.left.equalTo(placeView.mas_left).offset(60);
        make.right.equalTo(placeView.mas_right).offset(0);
        make.height.mas_equalTo(36);
    }];
    scrollview.backgroundColor = [UIColor whiteColor];
    scrollview.showsHorizontalScrollIndicator = NO;
    
    UILabel *placeLabel = [[UILabel alloc] init];
    [placeView addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(placeView.mas_centerY);
        make.left.equalTo(placeView.mas_left).offset(14);
    }];
    placeLabel.text = @"产地";
    placeLabel.font = [UIFont boldSystemFontOfSize:16];
    placeLabel.textColor = kGetColor(0x22, 0x22, 0x22);
    
    int _X = 0;
    for(int i=0;i<self.placesArray.count;i++)
    {
        CGSize sz = [self sizeWithText:self.placesArray[i] font:CUSTOMFONT(14) maxSize:CGSizeMake(120, 36)];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_X, 0, sz.width+25, 36)];
        [btn setTitle:[self.placesArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:kGetColor(0x66, 0x66, 0x66) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [scrollview addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(placeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _X+=sz.width;
        _X+=+25;
    }
    scrollview.contentSize = CGSizeMake(_X, 36);

    //最新货源
    UILabel *newGoodsLab = [[UILabel alloc] init];
    [hview addSubview:newGoodsLab];
    [newGoodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeView.mas_bottom).offset(17);
        make.centerX.equalTo(hview.mas_centerX);
        make.height.mas_equalTo(16);
    }];
    newGoodsLab.text = @"最新货源";
    newGoodsLab.font = [UIFont boldSystemFontOfSize:16];
    newGoodsLab.textColor = kGetColor(0x22, 0x22, 0x22);
    
    return hview;
}
 
#pragma mark ------------------------Private------------------------------
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}


- (UIButton *)getCustomBtn:(UIButton *)btn title:(NSString *)string tag:(int)tag
{
    btn = [[UIButton alloc] init];
    btn.tag = tag;
    [btn setTitle:string forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(classBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    return btn;
}

- (UIView *)getCustomClassView:(UIImage *)img tag:(int)tag title:(NSString *)string
{
    int w = (375-70)/5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, w+20)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    [btn setImage:img forState:UIControlStateNormal];
    btn.tag = tag;
    btn.layer.cornerRadius = w/2.;
    btn.layer.masksToBounds = YES;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(productClassViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, w-2, w, 14)];
    lab.text = string;
    lab.tag = 2;
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = UIColorFromRGB(0x333333);
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    return view;
}
 
- (void)getCategoryInfo
{
    self.class_arr_1 = [[NSMutableArray alloc] init];
    self.class_arr_2 = [[NSMutableArray alloc] init];
    self.class_arr_3 = [[NSMutableArray alloc] init];
    for(int i=0;i<self.categoryArray.count;i++)
    {
        GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
        NSMutableArray *temparr = [[NSMutableArray alloc] init];
        if(model.hasSubCategory == 1)
        {
            NSArray *model_sub_arr = model.subCateGory;
            for(int j=0;j<model_sub_arr.count;j++)
            {
                if(temparr.count == 9)
                {
                    [temparr addObject:@"查看更多"];
                }
                else if(temparr.count == 10){
                    continue;
                }
                [temparr addObject:model_sub_arr[j]];
            }
        }
        if(i == 0)
        {
            self.class_name_1 = model.cateGoryName;
            self.class_arr_1 = temparr;
        }
        else if(i == 1)
        {
            self.class_name_2 = model.cateGoryName;
            self.class_arr_2 = temparr;
        }
        else
        {
            self.class_name_3 = model.cateGoryName;
            self.class_arr_3 = temparr;
        }
        
        
    }
}

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
        NSString *p_name  = dic[@"name"];
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
- (void)requstBanner
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"position":@"2"} subUrl:@"ad/list" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            NSArray *arr = resultDic[@"params"];
            if(arr.count > 0)
            {
                NSDictionary *dic = [arr objectAtIndex:0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *picurl = dic[@"url"];
                    if([picurl rangeOfString:@"http"].location != NSNotFound)
                    {
                        [weak_self.adBtn sd_setImageWithURL:[NSURL URLWithString:picurl] forState:UIControlStateNormal];
                    }
                });
            }
        }else{
            //[weak_self showErrorInfoWithStatus:resultDic[@"desc"]];
        }
    }];
}

-(void)getGoodsListData{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        @"searchKey":@"苹果"
    } subUrl:@"search/query" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            NSDictionary *dic = resultDic[@"params"][@"goodsVoPage"];
            if(dic[@"total"] > 0)
            {
                NSArray *dataArr = dic[@"records"];
                for (int i=0; i<dataArr.count; i++) {
                    NSDictionary *goodsDic = dataArr[i];
                    SupplyGoodsModel *gm = [[SupplyGoodsModel alloc] init];
                    gm.goodsID = [goodsDic[@"goodsId"] intValue];
                    gm.imgurl  = goodsDic[@"picUrl"];
                    gm.title   = goodsDic[@"goodsName"];
                    gm.adress  = goodsDic[@"place"];
                    gm.updateTime = goodsDic[@"updateTime"];
                    double p = [goodsDic[@"goodsPrice"] doubleValue];
                    gm.price   = [NSString stringWithFormat:@"%.2f",p];
                    gm.weight  = goodsDic[@"quantity"];
                    gm.name    = goodsDic[@"shopName"];
                    gm.unit    = goodsDic[@"unit"];
                     if ([goodsDic[@"shopTurnover"] floatValue]>0) {
                        gm.total = [NSString stringWithFormat:@"成交%.2f元",[goodsDic[@"shopTurnover"] floatValue]];
                      }else{
                       gm.total = @"";
                      }
                    
                    gm.tagArray = [[NSMutableArray alloc] initWithArray:goodsDic[@"shopTags"]];
                    
                    
                    [self.goodsArray addObject:gm];
                }
                [self.goodsTableview reloadData];
            }
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

- (void)getSupplyInfo
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"page":@1,@"pageSize":@3} subUrl:@"SupplyApi/supplyHall" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            weak_self.placesArray = resultDic[@"params"][@"places"];
            
            //添加下方的uitableview
            weak_self.goodsTableview = [[MycommonTableView alloc] init];
            if (@available(iOS 11.0, *)) {
                weak_self.goodsTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }else{
            }
            int buttomHeight = 0;
            if(IS_Iphonex_Series)
                buttomHeight = 15;
            [weak_self.view addSubview:self.goodsTableview];
            [weak_self.goodsTableview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weak_self.view.mas_top).offset(0);
                make.bottom.equalTo(weak_self.view.mas_bottom).offset(-buttomHeight);
                make.width.mas_equalTo(kScreenWidth);
            }];
            weak_self.goodsTableview.delegate = weak_self;
            weak_self.goodsTableview.dataSource = weak_self;
            weak_self.goodsTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
            weak_self.goodsTableview.tableHeaderView = [weak_self tableHeaderView];
            
            [weak_self _initTopView];
            
            //获取banner图
            [self requstBanner];
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
    
}

#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------Delegate-----------------------------

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
            _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:0];
            self.titleLabel.alpha=0;
        self.topView.userInteractionEnabled=YES;
        } else if (offsetY > 0 && offsetY < kStatusBarAndNavigationBarHeight) {
            
             _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent: offsetY / kStatusBarAndNavigationBarHeight];
    
            self.titleLabel.alpha= offsetY / kStatusBarAndNavigationBarHeight;
            self.topView.userInteractionEnabled=NO;
        } else if (offsetY >= kStatusBarAndNavigationBarHeight ) {
            _topView.backgroundColor = [KCOLOR_Main colorWithAlphaComponent:1];
            self.titleLabel.alpha=1;
            self.topView.userInteractionEnabled=NO;
        }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    SupplyGoodsModel * model = [self.goodsArray objectAtIndex:indexPath.row];
    GoodsInfoViewController *infoCon = [[GoodsInfoViewController alloc] init];
    infoCon.goodsID = model.goodsID;
    infoCon.goodsImgUrl = model.imgurl;
    [self navigatePushViewController:infoCon animate:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"supplygoodscell";
    SupplyGoodsCell *cell = (SupplyGoodsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SupplyGoodsCell" owner:nil options:nil] firstObject];
        cell.goods_img.layer.cornerRadius = 5.0;
    }
    //已建 SupplyGoodsModel 数据对象  到时候解析数据用
    if(self.goodsArray.count > indexPath.row)
    {
        SupplyGoodsModel *model = [self.goodsArray objectAtIndex:indexPath.row];
        [cell.goods_img sd_setImageWithURL:[NSURL URLWithString:model.imgurl]];  //图片
        cell.goods_title.text   = model.title;  //标题
        cell.goods_weight.text  = [NSString stringWithFormat:@"%@%@起售    %@",model.weight,model.unit,@""]; //起批量
        cell.goods_price.text   = model.price;  //价钱
        cell.goods_unit.text    = model.unit;   //单位（斤、棵....）
        cell.goods_total.text   = model.total;  //成交额
        
        cell.goods_adress.text  = model.adress; //地址
        cell.goods_name.text  = model.name;   //店铺名称
        if (isEmpty(model.name)) {
            cell.addressLeft.constant=0;
        }else{
            cell.addressLeft.constant=14;
            
        }
        
        //根据店铺标签数组显示标签
        cell.tagBtn1.hidden = YES;
        cell.tagBtn2.hidden = YES;
        cell.tagBtn3.hidden = YES;
        cell.tagBtn4.hidden = YES;
        for(int i=0;i<model.tagArray.count;i++)
        {
//            if([[model.tagArray objectAtIndex:i] isEqualToString:@"牛商"])
//            {
//                cell.tagBtn1.hidden = NO;
//                cell.tagBtn1.layer.cornerRadius = 6;
//                cell.tagBtn1.layer.borderColor = UIColorFromRGB(0xff280a).CGColor;
//                [cell.tagBtn1 setTitleColor:UIColorFromRGB(0xff280a) forState:UIControlStateNormal];
//                [cell.tagBtn1 setTitle:@" 牛商 " forState:UIControlStateNormal];
//            }
//            else
                if([[model.tagArray objectAtIndex:i] isEqualToString:@"企"])
            {
                cell.tagBtn1.hidden = NO;
                cell.tagBtn1.layer.cornerRadius = 6;
                cell.tagBtn1.layer.borderColor = UIColorFromRGB(0x03c39d).CGColor;
                [cell.tagBtn1 setTitleColor:UIColorFromRGB(0x03c39d) forState:UIControlStateNormal];
                [cell.tagBtn1 setTitle:@" 企 " forState:UIControlStateNormal];
            }
            else if([[model.tagArray objectAtIndex:i] isEqualToString:@"实力"])
            {
                cell.tagBtn2.hidden = NO;
                cell.tagBtn2.layer.cornerRadius = 6;
                cell.tagBtn2.layer.borderColor = UIColorFromRGB(0xf95958).CGColor;
                [cell.tagBtn2 setTitleColor:UIColorFromRGB(0xf95958) forState:UIControlStateNormal];
                [cell.tagBtn2 setTitle:@" 实力 " forState:UIControlStateNormal];
            }
            else if([[model.tagArray objectAtIndex:i] isEqualToString:@"店"])
            {
//                cell.tagBtn4.hidden = NO;
//                cell.tagBtn4.layer.cornerRadius = 6;
//                cell.tagBtn4.layer.borderColor = UIColorFromRGB(0x00c67c).CGColor;
//                [cell.tagBtn4 setTitleColor:UIColorFromRGB(0x00c67c) forState:UIControlStateNormal];
//                [cell.tagBtn4 setTitle:@" 店 " forState:UIControlStateNormal];
            }
                
        }
    }
    return cell;
}

#pragma mark ------------------------Notification-------------------------


#pragma mark ------------------------Getter / Setter----------------------

@end

