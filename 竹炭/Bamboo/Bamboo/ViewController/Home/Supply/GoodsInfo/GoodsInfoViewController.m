//
//  GoodsInfoViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "GoodsCommentController.h"
#import "Masonry.h"
#import "SDCycleScrollView.h"
#import "SupplyGoodsInfoView.h"
#import "ExpressInfoView.h"
#import "CommentHeaderView.h"
#import "CommentOneView.h"
#import "ShopInfoView.h"
#import "BottumBuyView.h"
#import "AddToCartView.h"
#import "ConfirmOrderVC.h"
#import "SDWebImage.h"
#import "SupplyGoodsDetailModel.h"
#import "ShopCartViewController.h"
#import "ShopCartManger+request.h"
#import "PersonDetailViewController.h"
#import "Util.h"
#import "WTShareManager.h"
#import "WTShareContentItem.h"
#import "ShowHomeView.h"
#import "UIView+Frame.h"
@interface GoodsInfoViewController ()<UIScrollViewDelegate, SupplyGoodsInfoDelegate,ExpressInfoViewDlegate,ShopInfoViewDelegate,BottumBuyViewDelegate,AddToCartDelegate,CommentHeaderViewDelegate,SDCycleScrollViewDelegate>

//返回按钮
@property (nonatomic, strong) UIButton *backBtn;

//底部scrollview
@property (nonatomic, strong) UIScrollView  *mainScrollerView;

//顶部左右滑动大图
@property (nonatomic, strong) SDCycleScrollView *infoImgScrollView;
@property (nonatomic, strong) NSMutableArray    *imagesURLStringsArray;

//显示当前图片数的label
@property (nonatomic, strong) UILabel   *imageNumberLabel;

//商品基本信息view
@property (nonatomic, strong) SupplyGoodsInfoView *goodsInfoView;

//商品规格view
@property (nonatomic, strong) UIView *specView;

//物流view
@property (nonatomic, strong) UIView *expressView;
//弹出的物流详情view
@property (nonatomic, strong) ExpressInfoView *expressInfoView;

//评论的头部View
@property (nonatomic, strong) CommentHeaderView *commentheaderview;
//具体的评论
@property (nonatomic, strong) CommentOneView *commnetView_1;
@property (nonatomic, strong) CommentOneView *commnetView_2;

//商店信息
@property (nonatomic, strong) ShopInfoView *shopInfoView;

//产品详情大图view
@property (nonatomic, strong) UIView *productImgView;


//最下方的聊一聊 、 加购物车的view
@property (nonatomic, strong) BottumBuyView *buyView;

//加入购物车弹出框
@property (nonatomic, strong) AddToCartView *addCartView;

@property (nonatomic, strong) UIButton *goBackBtn;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIView   *topView;

//农产品  农资种苗   农机具  三个类别
@property (nonatomic, strong) UIButton *class_btn1;
@property (nonatomic, strong) UIButton *class_btn2;
@property (nonatomic, strong) UIButton *class_btn3;

//选中某一个类别后下方的小图标
@property (nonatomic, strong) UIView   *selectedView;
@property (nonatomic,strong)NSArray *bannarArr;
@property (nonatomic, strong)SupplyGoodsDetailModel *dgModel;
@property (nonatomic,assign)NSInteger index;//0是加入购物车 1是立即购买
@property (nonatomic,strong)WTShareContentItem *item;
@property (nonatomic,strong)UILabel *descLabel;
@property (nonatomic,strong)UIView *descView;

@end

@implementation GoodsInfoViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fd_prefersNavigationBarHidden=YES;
    if (UserIsLogin) {
    [self requestShopCarNum];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.mainScrollerView = [[UIScrollView alloc] init];
    self.mainScrollerView.delegate = self;
   WEAK_SELF
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
       if (@available(iOS 11.0, *)) {
             weak_self.mainScrollerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
          }
       
   });
   
    
    [self.view addSubview:self.mainScrollerView];
    
    [self.mainScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weak_self.view.mas_top).offset(0);
        make.left.equalTo(weak_self.view.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        if (weak_self.isStoreMangerPush) {
            make.height.mas_equalTo(kScreenHeight);
        }else{
            if(IS_Iphonex_Series){
            make.height.mas_equalTo(kScreenHeight-70);
            }else{
            make.height.mas_equalTo(kScreenHeight-60);
            }
                          
            
        }
    }];
    
    self.mainScrollerView.contentSize = CGSizeMake(kScreenWidth, 6100);
    self.mainScrollerView.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
    
    [self initGoodsInfo_buyview];            //底部购买view
    
    
    
//    [self initGoodsInfo_TitleView];
//    [self initGoodsInfo_SpecView];           //规格
//    [self initGoodsInfo_expressView];        //物流信息
//    [self initGoodsInfo_commentHeaderView];  //评论头部
//    [self initGoodsInfo_commentView];        //显示的两条评论
//    [self initGoodsInfo_shopInfoView];       //店铺信息
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self initGoodsInfo_webView];            //详情大图
//    });
//
//
//    [self initGoodsInfo_buyview];            //底部购买view
    
    //返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(15,kStatusBarAndNavigationBarHeight/2-5, 29, 29);
    [self.backBtn setImage:IMAGE(@"supply_backArrow") forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    //顶部滑动隐藏、出现的view
    [self _initTopView];
    
    
    [self getGoodsDetailByID];
}


#pragma mark ------------------------Init---------------------------------
-(void)_initTopView{
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStatusBarAndNavigationBarHeight)];
    _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.goBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackBtn.frame = CGRectMake(10,kStatusBarAndNavigationBarHeight/2, 40, 20);
    [self.goBackBtn setImage:IMAGE(@"greenArrow") forState:UIControlStateNormal];
    [self.goBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:self.goBackBtn];
    
    self.class_btn1 = [self getCustomBtn:self.class_btn1 title:@"商品" tag:1];
    //self.class_btn2 = [self getCustomBtn:self.class_btn2 title:@"评价" tag:2];
    self.class_btn2 = [self getCustomBtn:self.class_btn2 title:@"物流" tag:2];
    self.class_btn3 = [self getCustomBtn:self.class_btn3 title:@"详情" tag:3];

    [_topView addSubview:self.class_btn2];
    [self.class_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topView.mas_centerX);
        make.centerY.equalTo(self.goBackBtn.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];

    [_topView addSubview:self.class_btn1];
    [self.class_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.class_btn2.mas_top);
        make.right.equalTo(self.class_btn2.mas_left).offset(-50);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];

    [_topView addSubview:self.class_btn3];
    [self.class_btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.class_btn2.mas_top);
        make.left.equalTo(self.class_btn2.mas_right).offset(50);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(25);
    }];

    self.selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 3.5)];
    self.selectedView.layer.cornerRadius = 1.75;
    self.selectedView.backgroundColor = kGetColor(0x47, 0xc6, 0x7c);
    [_topView addSubview:self.selectedView];
    
    [self.class_btn1 setTitleColor:kGetColor(0x46, 0xc6, 0x7b) forState:UIControlStateNormal];
    [self.class_btn2 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    [self.class_btn3 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectedView.center = CGPointMake(self.class_btn1.center.x, self.class_btn1.center.y+15);
    });
    
    
    
    [self.view addSubview:_topView];
}

- (UIButton *)getCustomBtn:(UIButton *)btn title:(NSString *)string tag:(int)tag
{
    btn = [[UIButton alloc] init];
    btn.tag = tag;
    [btn setTitle:string forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(classBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return btn;
}


- (void)initImageScrollView
{
    self.infoImgScrollView = [[SDCycleScrollView alloc] init];
    self.infoImgScrollView.delegate = self;
    self.infoImgScrollView.showPageControl = NO;
    [self.mainScrollerView addSubview:self.infoImgScrollView];
    [self.infoImgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollerView.mas_top).offset(0);
        make.left.equalTo(self.mainScrollerView.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(375);
    }];
        
    self.infoImgScrollView.imageURLStringsGroup = self.bannarArr;
    self.infoImgScrollView.autoScroll = NO;
    
    //显示当前图片数量位置
    self.imageNumberLabel = [[UILabel alloc] init];
    [self.infoImgScrollView addSubview:self.imageNumberLabel];
    [self.infoImgScrollView bringSubviewToFront:self.imageNumberLabel];
    [self.imageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.infoImgScrollView.mas_bottom).offset(-20);
        make.right.equalTo(self.infoImgScrollView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(55);
    }];
    NSString *tmpstr = @"1";
    if(self.bannarArr.count == 0)
        tmpstr = @"0";
    self.imageNumberLabel.text = [NSString stringWithFormat:@"%@/%lu",tmpstr,(unsigned long)self.bannarArr.count];
    self.imageNumberLabel.font = CUSTOMFONT(14);
    self.imageNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.imageNumberLabel.textColor = UIColorFromRGB(0xffffff);
    self.imageNumberLabel.layer.cornerRadius = 9.5;
    self.imageNumberLabel.layer.masksToBounds = YES;
    self.imageNumberLabel.backgroundColor = [UIColor colorWithRed:0x66/255. green:0x66/255. blue:0x66/255. alpha:0.45];
}


- (void)initGoodsInfo_TitleView
{
    self.goodsInfoView = [[[NSBundle mainBundle] loadNibNamed:@"SupplyGoodsInfoView" owner:self options:nil] lastObject];
    self.goodsInfoView.delegate = self;
    [self.mainScrollerView addSubview:self.goodsInfoView];
    [self.goodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoImgScrollView.mas_bottom).offset(0);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
//        make.height.mas_equalTo(159);
        make.height.mas_equalTo(125);
    }];
    [self.goodsInfoView _initGoodsTitleInfo:self.dgModel.goodName
                      price:self.dgModel.goodPrice
                       unit:self.dgModel.goodUnit
                     weight:[NSString stringWithFormat:@"  %@ %@起  ",self.dgModel.quantity,self.dgModel.goodUnit]
                   distance:self.dgModel.distance
                        see:self.dgModel.viewCount];
    
    self.goodsInfoView.collectionBtn.selected =self.dgModel.collectionState;
    
    self.goodsInfoView.monthBrowsing.text=[NSString stringWithFormat:@"%@人看过",self.dgModel.viewCount];
}

//根据商品规格展示界面
- (void)initGoodsInfo_SpecView
{
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.9/斤",@"次品",
//                               @"2.9/斤",@"好品",
//                               @"2.9/斤",@"良品",
//                               @"2.9/斤",@"优品",nil];
//    NSArray *keyarr = [dic allKeys];
    
    int rows = (int)self.dgModel.goodsSpecArray.count;
    
    
    self.specView = [[UIView alloc] init];
    [self.mainScrollerView addSubview:self.specView];
    [self.specView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsInfoView.mas_bottom).offset(6.5);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(17+30*rows);
    }];
    self.specView.backgroundColor = [UIColor whiteColor];
    
    UILabel *specLab = [[UILabel alloc] init];
    [self.specView addSubview:specLab];
    [specLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specView.mas_top).offset(17);
        make.left.equalTo(self.specView.mas_left).offset(14);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    specLab.textAlignment = NSTextAlignmentCenter;
    specLab.text = @"规格";
    specLab.font = [UIFont systemFontOfSize:14];
    specLab.textColor = kGetColor(0x99, 0x99, 0x99);
    
    if(self.dgModel.goodsSpecArray != nil)
    {
        for(int i=0;i<self.dgModel.goodsSpecArray.count;i++)
        {
            UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(84, 17+33*i, (kScreenWidth-84)/2, 15)];
            
            UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(lab1.frame.origin.x+lab1.frame.size.width, 17+33*i, (kScreenWidth-120)/2, 15)];
            
            lab1.textAlignment = NSTextAlignmentLeft;
            lab2.textAlignment = NSTextAlignmentRight;
            
            lab1.font = [UIFont systemFontOfSize:14];
            lab2.font = [UIFont systemFontOfSize:14];
            
            lab1.textColor = kGetColor(0x11, 0x11, 0x11);
            lab2.textColor = kGetColor(0x11, 0x11, 0x11);
            
            SupplyGDSpceModel *sm = [self.dgModel.goodsSpecArray objectAtIndex:i];
            
            lab1.text = sm.gs_name;       //[dic objectForKey:keyarr[i]];
            lab2.text = [NSString stringWithFormat:@"%@元/%@",sm.gs_unit_price,self.dgModel.goodUnit]; //keyarr[i];
            
            
            [self.specView addSubview:lab1];
            [self.specView addSubview:lab2];
        }
    }
}

//物流栏
- (void)initGoodsInfo_expressView
{
    self.expressView = [[UIView alloc] init];
    [self.mainScrollerView addSubview:self.expressView];
    [self.expressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.specView.mas_bottom).offset(6.5);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(45);
    }];
    self.expressView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    [self.expressView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(14);
        make.centerY.equalTo(self.expressView.mas_centerY);
    }];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"物流";
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = kGetColor(0x99, 0x99, 0x99);
    
    UILabel *infolab = [[UILabel alloc] init];
    [self.expressView addSubview:infolab];
    [infolab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(83);
        make.centerY.equalTo(self.expressView.mas_centerY);
    }];
    infolab.textAlignment = NSTextAlignmentCenter;
    infolab.text = @"整车快递，费用待商议"; //self.dgModel.materials;
    infolab.font = [UIFont systemFontOfSize:14];
    infolab.textColor = kGetColor(0x11, 0x11, 0x11);
    
    UIImageView *showinfoImg = [[UIImageView alloc] init];
    [self.expressView addSubview:showinfoImg];
    [showinfoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.centerY.equalTo(self.expressView.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    showinfoImg.image = IMAGE(@"rightArrow");
    showinfoImg.hidden = YES;
    
    UIButton *showinfobtn = [[UIButton alloc] init];
    [self.expressView addSubview:showinfobtn];
    [showinfobtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.centerY.equalTo(self.expressView.mas_centerY);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(18);
    }];
    [showinfobtn addTarget:self action:@selector(showExpressInfoView:) forControlEvents:UIControlEventTouchUpInside];
}

//评论
- (void)initGoodsInfo_commentHeaderView
{
    self.commentheaderview = [[[NSBundle mainBundle] loadNibNamed:@"CommentHeaderView" owner:self options:nil] lastObject];
    self.commentheaderview.delegate = self;
    [self.mainScrollerView addSubview:self.commentheaderview];
    [self.commentheaderview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressView.mas_bottom).offset(6.5);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(80);
    }];
}

- (void)initGoodsInfo_commentView
{
    SupplyGEvaluModel *mm1 = [[SupplyGEvaluModel alloc] init];
    SupplyGEvaluModel *mm2 = [[SupplyGEvaluModel alloc] init];
    mm1.nickName = @"李贺";
    mm1.content = @"货质量不错，也没有损坏，发货速度很快。老板人很实在，良心卖家。很满意的一次合作。";
    mm1.evaluateDate = @"2020-05-04";
    mm1.specification = @"大果";
    
    mm2.nickName = @"赵建国";
    mm2.content = @"货质量不错，也没有损坏，发货速度很快。老板人很实在，良心卖家。很满意的一次合作。";
    mm2.evaluateDate = @"2020-07-22";
    mm2.specification = @"小果";
    if(self.dgModel.evaluateVosArray.count > 0)
    {
//        mm1 = [self.dgModel.evaluateVosArray objectAtIndex:0];
//        mm2 = [self.dgModel.evaluateVosArray objectAtIndex:0];
    }
//    if(self.dgModel.evaluateVosArray.count > 1)
//        mm2 = [self.dgModel.evaluateVosArray objectAtIndex:0];
    
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:14]
    };
    CGSize size = [mm1.content boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    int count = (int)mm1.picUrls.count%4==0?(int)mm1.picUrls.count/4:((int)mm1.picUrls.count/4)+1;
    int cvheight = size.height+50+(kScreenWidth-24)/4*count+60;
    
    self.commnetView_1 = [[CommentOneView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)
                                                     headImage:IMAGE(@"supply_goodsimg")
                                                          name:mm1.nickName
                                                       comment:mm1.content
                                                        images:mm1.picUrls
                                                          time:mm1.evaluateDate
                                                          spec:mm1.specification
                                                        weight:mm1.nickName
                                                         place:@""];
    [self.mainScrollerView addSubview:self.commnetView_1];
    [self.commnetView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentheaderview.mas_bottom).offset(0);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(cvheight-10);
    }];
    self.commnetView_1.backgroundColor = [UIColor whiteColor];
    
    
    self.commnetView_2 = [[CommentOneView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)
                                                     headImage:IMAGE(@"supply_goodsimg")
                                                          name:mm2.nickName
                                                       comment:mm2.content
                                                        images:mm2.picUrls
                                                          time:mm2.evaluateDate
                                                          spec:mm2.specification
                                                        weight:mm2.nickName
                                                         place:@""];
    [self.mainScrollerView addSubview:self.commnetView_2];
    [self.commnetView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commnetView_1.mas_bottom).offset(0);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(cvheight-10);
    }];
    self.commnetView_2.backgroundColor = [UIColor whiteColor];
    
}

- (void)initGoodsInfo_shopInfoView
{
    NSArray *tagarr = self.dgModel.storeInfo.shopTagArray;
    
//    NSArray *tagarr = [[NSArray alloc] initWithObjects:@"企",@"实力", nil];
    
    self.shopInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ShopInfoView" owner:self options:nil] lastObject];
    self.shopInfoView.delegate = self;
    WEAK_SELF
    [self.shopInfoView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self  enterShopController];
    }];
    NSString *str1;
    if (isEmpty(self.dgModel.storeInfo.shopLevel)) {
        str1= @"";
    }else{
        str1= [NSString stringWithFormat:@"店铺等级:%@",self.dgModel.storeInfo.shopLevel];
    }
     
//    NSString *str2 = [NSString stringWithFormat:@"货品达标:%@",self.dgModel.storeInfo.logisticsServices];
//    NSString *str3 = [NSString stringWithFormat:@"卖家服务:%@",self.dgModel.storeInfo.sellerServices];
//    NSString *str4 = [NSString stringWithFormat:@"物流服务:%@",self.dgModel.storeInfo.upToStandard];
    NSString *str2 = @"货品达标";
    NSString *str3 = @"卖家服务";
    NSString *str4 = @"物流服务";
    
    [self.shopInfoView _initShopInfoWithInfo:self.dgModel.storeInfo.shopIcon
                                    shopname:self.dgModel.storeInfo.shopName
                                   shopgrade:str1
                                     grade_1:str2
                                     grade_2:str3
                                     grade_3:str4
                                      tagArr:tagarr];
    [self.mainScrollerView addSubview:self.shopInfoView];
    

    
    [self.shopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.expressView.mas_bottom).offset(6.5);
        make.right.equalTo(self.infoImgScrollView.mas_right);
        make.left.equalTo(self.infoImgScrollView.mas_left);
        make.height.mas_equalTo(152);
        if (isEmpty(self.dgModel.detail)) {
            //店铺信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self initGoodsInfo_webView];            //详情大图
            });
        }
    }];
    
    
    if (!isEmpty(self.dgModel.detail)) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.textAlignment=0;
        titleLabel.text = @"   产品详情";
        titleLabel.font=CUSTOMFONT(15);
        titleLabel.backgroundColor=[UIColor whiteColor];
        [self.mainScrollerView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(self.shopInfoView.mas_bottom).offset(19);
               make.left.equalTo(self.infoImgScrollView.mas_left);
               make.height.mas_equalTo(40);
               make.width.mas_equalTo(kScreenWidth);
        }];
        
        self.descView = [[UIView alloc] init];
        self.descView.backgroundColor=[UIColor whiteColor];
        [self.mainScrollerView addSubview:self.descView];
        
        self.descLabel = [[UILabel alloc]init];
        self.descLabel.textColor = UIColorFromRGB(0x333333);
        self.descLabel.textAlignment=0;
        self.descLabel.numberOfLines=0;
        self.descLabel.text =self.dgModel.detail;
        self.descLabel.font=CUSTOMFONT(12);
        [self.descView addSubview:self.descLabel];
    
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(titleLabel.mas_bottom);
               make.left.equalTo(self.infoImgScrollView.mas_left).offset(12.5);
               make.right.equalTo(self.infoImgScrollView.mas_left).offset(-12.5);
               make.width.mas_equalTo(kScreenWidth-25);
        }];
        
        [self.descView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(titleLabel.mas_bottom);
               make.left.equalTo(self.infoImgScrollView.mas_left).offset(0);
               make.width.mas_equalTo(kScreenWidth);
               make.bottom.equalTo(self.descLabel.mas_bottom).offset(10);
            //店铺信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.00000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weak_self initGoodsInfo_webView];            //详情大图
            });
            
        }];
        
    }
    
    
}

 
- (void)initGoodsInfo_webView
{
 
    NSArray *imagesURLStrings = self.imagesURLStringsArray;
  
   
    __block int H = 0;
    __block int defaultH=0;
    if (!isEmpty(self.dgModel.detail)) {
        defaultH = self.descView.bottom+10;
    }else{
      defaultH =self.shopInfoView.bottom;
    }
//    dispatch_group_enter 和 dispatch_group_leave 必须成对出现，否则会造成“死锁”
//    dispatch_group_wait：如果enter数不等于leave数，则线程阻塞等待，若enter数与leave数相等则继续往下执行
//    dispatch_group_notify：只有enter数和leave数相等，才会执行

    WEAK_SELF
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    for(int i=0;i<imagesURLStrings.count;i++)
    {
           
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesURLStrings[i]] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                imageView.frame = CGRectMake(0, H+defaultH, kScreenWidth, kScreenWidth/(image.size.width/image.size.height));
                H+=kScreenWidth/(image.size.width/image.size.height);
 
                [weak_self.mainScrollerView addSubview:imageView];
                
                 if (i==imagesURLStrings.count-1) {
                   
                    dispatch_group_leave(group);
                   
                     NSLog(@"hhhh = %d",H);
                   
                }
 
            }];
    
        }
    

      dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              /// 信号量 + 1
                 UIImageView *imgView = [[UIImageView alloc]init];
                 imgView.frame=CGRectMake(0, H+defaultH, kScreenWidth, 419);
                [imgView setImage:IMAGE(@"details-datu3")];

                [weak_self.mainScrollerView addSubview:imgView];
                     weak_self.mainScrollerView.contentSize = CGSizeMake(kScreenWidth, defaultH+H+430);
                      
                      NSLog(@"contentSize:%d",defaultH+H+430);
                });
      });
                
        

       
  
}



- (void)initGoodsInfo_buyview
{
    if (!_isStoreMangerPush) {
        int iphonexH = 60;
           if(IS_Iphonex_Series)
               iphonexH = 70;
           self.buyView = [[BottumBuyView alloc] initWithFrame:CGRectMake(0, kScreenHeight-iphonexH, kScreenWidth, iphonexH)];
           self.buyView.delegate = self;
            self.buyView.hidden=YES;
           [self.view addSubview:self.buyView];
    }
   
}




#pragma mark ------------------------View Event---------------------------
#pragma mark ------------------------ 商品、 评价、 详情
- (void)classBtnClicked:(id)sender
{
    [self.class_btn1 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    [self.class_btn2 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    [self.class_btn3 setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
    
    self.selectedView.center = CGPointMake(btn.center.x, btn.center.y+15);
    
    switch (btn.tag) {
        case 1:
        {
            [self.mainScrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 2:
        {
//            [self.mainScrollerView setContentOffset:CGPointMake(0, self.commentheaderview.frame.origin.y-kStatusBarAndNavigationBarHeight) animated:YES];
            
            [self.mainScrollerView setContentOffset:CGPointMake(0, self.expressView.frame.origin.y-kStatusBarAndNavigationBarHeight) animated:YES];
        }
            break;
        case 3:
        {
            [self.mainScrollerView setContentOffset:CGPointMake(0, self.productImgView.frame.origin.y-kStatusBarAndNavigationBarHeight) animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark ------------------------ 返回上级页面
- (void)goBack:(id)sender
{
    [self goBack];
}
 
#pragma mark ------------------------ 展示物流详情弹出view
- (void)showExpressInfoView:(id)sender
{
    //暂时注释掉
//    UIView *bv = [[UIView alloc] initWithFrame:self.view.frame];
//    bv.alpha = 0.5;
//    bv.tag = 112;
//    bv.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:bv];
//    WEAK_SELF
//    [bv addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
//        self.expressInfoView.delegate = nil;
//        [self.expressInfoView removeFromSuperview];
//        UIView *_v = [weak_self.view viewWithTag:112];
//        [_v removeFromSuperview];
//    }];
//
//    self.expressInfoView = [[[NSBundle mainBundle] loadNibNamed:@"ExpressInfoView" owner:self options:nil] lastObject];
//    [self.view addSubview:self.expressInfoView];
//    self.expressInfoView.delegate = self;
//    [self.expressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.mas_equalTo(335);
//    }];
//    self.expressInfoView.backgroundColor = [UIColor whiteColor];
}

#pragma mark ------------------------Api----------------------------------
-(void)getGoodsDetailByID{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        
        @"goodsId":[NSString stringWithFormat:@"%d",self.goodsID]
        
    } subUrl:@"SupplyApi/goodsDetail" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            NSDictionary *_objDic = resultDic[@"params"];
            NSArray *oldarr = _objDic[@"detailsPicsUrls"];
            weak_self.bannarArr=_objDic[@"picUrls"];
            weak_self.buyView.hidden=NO;
            if ([_objDic[@"buyState"]intValue]==0) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addBtn.frame = CGRectMake(0, 0, kScreenWidth, weak_self.buyView.frame.size.height);
                [addBtn setImage:IMAGE(@"orderPhone") forState:UIControlStateNormal];
                [addBtn setTitle:@" 打电话" forState:UIControlStateNormal];
                addBtn.titleLabel.font=CUSTOMFONT(16);
                [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [addBtn addTarget:self action:@selector(chat_action) forControlEvents:UIControlEventTouchUpInside];
                addBtn.backgroundColor=[UIColor whiteColor];
                [weak_self.buyView addSubview:addBtn];
            }
            
            weak_self.imagesURLStringsArray = [[NSMutableArray alloc] init];
            for(int i=0;i<oldarr.count;i++)
            {
                NSString *str = [oldarr objectAtIndex:i];
                if([str rangeOfString:@".mp4"].location == NSNotFound)
                {
                    [weak_self.imagesURLStringsArray addObject:str];
                }
            }
            
            weak_self.dgModel = [[SupplyGoodsDetailModel alloc] init];
            weak_self.dgModel.goodName = _objDic[@"goodName"];
            weak_self.dgModel.goodsImgArray = [[NSMutableArray alloc] initWithArray:weak_self.imagesURLStringsArray];
            weak_self.dgModel.detail =_objDic[@"detail"];
//            weak_self.imagesURLStringsArray = _objDic[@"picUrls"];
            weak_self.dgModel.accid             = _objDic[@"accid"];
            weak_self.dgModel.goodPrice      = _objDic[@"goodPrice"];
            weak_self.dgModel.goodsID        = [_objDic[@"goodsId"] intValue];
            weak_self.dgModel.distance       = _objDic[@"distance"];
            weak_self.dgModel.viewCount  = [NSString stringWithFormat:@"%@",_objDic[@"viewCount"]];
            weak_self.dgModel.goodUnit       = _objDic[@"unit"];
            weak_self.dgModel.quantity       = [NSString stringWithFormat:@"%d",[_objDic[@"quantity"] intValue]];
            weak_self.dgModel.materials      = _objDic[@"materials"];
            weak_self.dgModel.mobile      = _objDic[@"mobile"];
            weak_self.dgModel.collectionState      = [_objDic[@"collectionState"]intValue];
           
            
            //解析商品规格
            NSMutableArray *spceArray = [[NSMutableArray alloc] init];
            NSArray *arr = _objDic[@"goodsSpecifications"];
            for(int i=0;i<arr.count;i++)
            {
                SupplyGDSpceModel *spceModel = [[SupplyGDSpceModel alloc] init];
                NSDictionary *_dic = arr[i];
                spceModel.gs_name               = _dic[@"specification"];
                spceModel.gs_unit_price         = _dic[@"unit_price"];
                spceModel.gs_specificationId    = _dic[@"specificationId"];
                spceModel.gs_selected           = _dic[@"selected"];
                [spceArray addObject:spceModel];
            }
            self.dgModel.goodsSpecArray = spceArray;
            
            //解析交易评价
            NSMutableArray *evalArray = [[NSMutableArray alloc] init];
            NSArray *evalArr = _objDic[@"evaluateVos"];
            for(int i=0;i<evalArr.count;i++)
            {
                SupplyGEvaluModel *gem = [[SupplyGEvaluModel alloc] init];
                NSDictionary *_dic = evalArr[i];
                gem.content         = _dic[@"content"];
                gem.delivery        = _dic[@"delivery"];
                gem.evaluateDate    = _dic[@"evaluateDate"];
                gem.level           = _dic[@"level"];
                gem.nickName        = _dic[@"nickName"];
                gem.picUrls         = _dic[@"picUrls"];
                gem.purchase        = _dic[@"purchase"];
                gem.specification   = _dic[@"specification"];
                gem.userIcon        = _dic[@"userIcon"];
                [evalArray addObject:gem];
            }
            
            //解析店铺信息
            if (!isEmpty(_objDic[@"shopVo"])) {
                SupplyStoreModel *storeModel = [[SupplyStoreModel alloc] init];
               int le = [_objDic[@"shopVo"][@"grade"] intValue];
               storeModel.shopLevel = [NSString stringWithFormat:@"%d",le];
               storeModel.shopName          = _objDic[@"shopVo"][@"shopName"];
               storeModel.logisticsServices = _objDic[@"shopVo"][@"logisticsServices"];
               storeModel.sellerServices    = _objDic[@"shopVo"][@"sellerServices"];
               storeModel.upToStandard      = _objDic[@"shopVo"][@"upToStandard"];
               storeModel.shopIcon          = _objDic[@"shopVo"][@"shopLogo"];
               storeModel.shopTagArray      = _objDic[@"shopVo"][@"certificationMarks"];
               
               weak_self.dgModel.storeInfo = storeModel;
            }
           
            
            weak_self.dgModel.evaluateVosArray = evalArray;
            
                        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weak_self initImageScrollView];
                
                [weak_self initGoodsInfo_TitleView];
                [weak_self initGoodsInfo_SpecView];           //规格
                [weak_self initGoodsInfo_expressView];        //物流信息
//                [weak_self initGoodsInfo_commentHeaderView];  //评论头部
//                [weak_self initGoodsInfo_commentView];        //显示的两条评论
                [weak_self initGoodsInfo_shopInfoView];
              
            });

        
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

#pragma mark ---- 加入购物车
-(void)addGoodsToChartByID:(NSString *)goodsID specID:(NSString *)specID{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        
        @"goodsId":goodsID,
        @"specificationId":specID,
        
    } subUrl:@"orderCart/add" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            NSLog(@"---加入购物车成功---");
            [weak_self showSuccessInfoWithStatus:@"加入购物车成功"];
            [weak_self requestShopCarNum];
        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}


#pragma mark -----购物车数量
-(void)requestShopCarNum{
    
    WEAK_SELF
    [[ShopCartManger sharedManager]getCartGoodsAllNumBlock:^(NSString *numStr) {
            [weak_self.buyView setCartNum:numStr];
    }];
}

#pragma mark ------------------------Delegate-----------------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offsetY=scrollView.contentOffset.y;
    if (offsetY <= 0) {
            _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
            _topView.alpha=0;
        } else if (offsetY > 0 && offsetY < kStatusBarAndNavigationBarHeight) {
            
             _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent: offsetY / kStatusBarAndNavigationBarHeight];
    
            _topView.alpha= offsetY / kStatusBarAndNavigationBarHeight;

        } else if (offsetY >= kStatusBarAndNavigationBarHeight ) {
            _topView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
            _topView.alpha=1;

        }
     
    
}

#pragma mark --------- 顶部图片左右滚动代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    self.imageNumberLabel.text = [NSString stringWithFormat:@"%ld/%lu",(long)index+1,(unsigned long)cycleScrollView.imageURLStringsGroup.count];
}


#pragma mark --------- 商品分享按钮
- (void)supply_share_Action
{
    NSLog(@"供应大厅--商品分享按钮");
    WEAK_SELF
    [[ShowHomeView sharedInstance]showLeftTile:@"微信好友" withRight:@"朋友圈" AndBlock:^(NSInteger index) {
        [weak_self selectIndex:index];
      }];
    
   
    
}

-(void)selectIndex:(NSInteger)index{
    WTShareContentItem *item = [WTShareContentItem shareWTShareContentItem:@{@"title":@"买卖竹制品就上竹老大",@"content":@"你的好友给你分享了一个好物，快来瞧瞧吧~~~",@"url":[NSString stringWithFormat:@"http://www.taoyuan7.com:8081/share/appGoodsDetail/%d",_goodsID],@"img":self.goodsImgUrl}];
    
    if (index==1) {//微信好友
        [WTShareManager wt_shareWithContent:item shareType:WTShareTypeWeiXinTimeline shareResult:^(NSString *shareResult) {
                           
                
        }];
       
    }else if (index==2){//朋友圈
        [WTShareManager wt_shareWithContent:item shareType:WTShareTypeWeiXinSession shareResult:^(NSString *shareResult) {
                           
                
        }];
       
       
        
    }else{
        
    }
  
    
}

#pragma mark --------- 商品收藏按钮
- (void)supply_love_Action
{
    
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    
      NSDictionary *param = @{@"accid":[UserModel sharedInstance].userId,@"businessId":[NSString stringWithFormat:@"%d",self.goodsID],@"businessType":@"1",@"collectType":@"2"};
    
    if (self.goodsInfoView.collectionBtn.selected) {
        
        WEAK_SELF
           [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/delete" block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                   weak_self.goodsInfoView.collectionBtn.selected = NO;
                   });
                   
                   [weak_self showMessage:@"取消收藏"];
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
        
        
    }else{
    
    NSLog(@"供应大厅--商品收藏按钮");
  
    WEAK_SELF
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/add" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            weak_self.goodsInfoView.collectionBtn.selected = YES;
            });
            
            [weak_self showMessage:@"收藏成功"];
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
    }
    
}

//移除物流弹出框
- (void)expressInfoViewDismiss
{
    self.expressInfoView.delegate = nil;
    [self.expressInfoView removeFromSuperview];
    UIView *bv = [self.view viewWithTag:112];
    [bv removeFromSuperview];
}

#pragma mark --------- 查看所有交易评论
- (void)showAllCommentAction
{
    GoodsCommentController *commentCon = [[GoodsCommentController alloc] init];
    [self.navigationController pushViewController:commentCon animated:YES];
}


#pragma mark --------- 进店看看
- (void)enterShopController
{
    NSLog(@"供应大厅--进店看看");
    PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
    vc.shopAccId =  self.dgModel.accid;
    [self navigatePushViewController:vc animate:YES];
}


#pragma mark --------- 打电话
- (void)chat_action
{
    [Util dialServerNumber:self.dgModel.mobile];
    
    NSDictionary *param = @{@"accid":[UserModel sharedInstance].userId,@"businessId":[NSString stringWithFormat:@"%d",self.goodsID],@"businessType":@"1",@"collectType":@"4"};
       WEAK_SELF
       [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/add" block:^(NSDictionary *resultDic, NSError *error) {
           [weak_self dissmiss];
           NSLog(@"resultDic:%@",resultDic);
           if ([resultDic[@"code"] integerValue]==200) {
               
               
           }else{
               
           }
           
           }];
     
}

#pragma mark --------- 聊一聊
- (void)call_action
{
    //[self showMessage:@"努力开发中"];
    

    
}

#pragma mark --------- 购物车
- (void)cart_action
{
    if (!UserIsLogin) {
          [self _jumpLoginPage];
          return;
      }
    ShopCartViewController *vc = [[ShopCartViewController alloc]init];
    [self navigatePushViewController:vc animate:YES];

    
}

#pragma mark --------- 加入购物车
- (void)addToCart_action
{
    if (!UserIsLogin) {
          [self _jumpLoginPage];
          return;
      }
    _index=0;
    [self _showSpecView];
}
#pragma mark --------- 弹出规格框
-(void)_showSpecView{
    
    if (!UserIsLogin) {
          [self _jumpLoginPage];
          return;
      }
    
    UIView *bv = [[UIView alloc] initWithFrame:self.view.frame];
    bv.tag = 112;
    bv.backgroundColor =[UIColor colorWithWhite:0.f alpha:0.5];
    [self.view addSubview:bv];
    [bv addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        UIView *_bv = [self.view viewWithTag:112]; //[bv removeFromSuperview];
        [_bv removeFromSuperview];
        self.addCartView.delegate = nil;
        [self.addCartView removeFromSuperview];
    }];
    
    self.addCartView = [[[NSBundle mainBundle] loadNibNamed:@"AddToCartView" owner:self options:nil] lastObject];
    
    NSString *_imgstr = @"";
    if(self.imagesURLStringsArray.count > 0)
        _imgstr = self.imagesURLStringsArray[0];
    [self.addCartView _initCartViewInfo:_imgstr
                                  price:self.dgModel.goodPrice
                                    msg:self.dgModel.goodName
                                specArr:self.dgModel.goodsSpecArray];
    
    self.addCartView.delegate = self;
    [self.view addSubview:self.addCartView];
    [self.addCartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(385);
    }];
    self.addCartView.backgroundColor = [UIColor whiteColor];
}


#pragma mark --------- 立即购买
- (void)buy_action
{
    if (!UserIsLogin) {
          [self _jumpLoginPage];
          return;
      }
    _index=1;
    [self _showSpecView];

}

#pragma mark --------- 确定 加入购物车
- (void)addToCart_Ok:(int)selectedIndex
{
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    
    self.addCartView.delegate = nil;
    [self.addCartView removeFromSuperview];
    UIView *bv = [self.view viewWithTag:112];
    [bv removeFromSuperview];
    
    NSLog(@"选中的规格索引 = %d",selectedIndex);
    NSString *goodsID = [NSString stringWithFormat:@"%d",self.dgModel.goodsID];
       NSString *specificationId = @"";
       
       SupplyGDSpceModel *sm = [self.dgModel.goodsSpecArray objectAtIndex:selectedIndex];
       specificationId = sm.gs_specificationId;
    if (_index==0) {
    
        [self addGoodsToChartByID:goodsID specID:specificationId];
    }else{
        ConfirmOrderVC *vc = [[ConfirmOrderVC alloc]init];
        vc.goodsDic =@{@"goodsId":goodsID,@"specificationId":specificationId}.mutableCopy;
        [self navigatePushViewController:vc animate:YES];
    }
    
}

#pragma mark --------- 取消 加入购物车
- (void)addToCart_Cancel
{
    self.addCartView.delegate = nil;
    [self.addCartView removeFromSuperview];
    UIView *bv = [self.view viewWithTag:112];
    [bv removeFromSuperview];
}



@end
