//
//  PersonDetailViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "PDHeadInfoView.h"
#import "PDHeadInfoTextView.h"
#import "PDBottumInfoView.h"
#import "PDStoreCellView.h"
#import "PDItemCellView.h"
#import "SupplyGoodsModel.h"
#import "GoodsInfoViewController.h"
@interface PersonDetailViewController ()<UITableViewDelegate,UITableViewDataSource,PDHeadInfoTextViewDelegate,PDStoreCellViewDelegate,PDItemCellViewDelegate>

@property (nonatomic, assign) BOOL          showAllSearchItemFlag;
@property (nonatomic, assign) int           showAllSearchItemHeight;

@property (nonatomic, strong) UITableView   *tableview;

@property (nonatomic, strong) PersonDetailModel *personModel;
@property (nonatomic, strong) NSString *personInfo_title;
@property (nonatomic, strong) NSString *personInfo_msg;
@property (nonatomic, strong) NSMutableArray *personInfo_imageArray;
@property (nonatomic, strong) NSString       *personInfo_year;
@property (nonatomic, strong) NSString       *personInfo_grade;

@property (nonatomic, strong) NSString *store_name;
@property (nonatomic, strong) NSString *store_days;
@property (nonatomic, strong) NSString *store_money;
@property (nonatomic, strong) NSString *store_orders;
@property (nonatomic, strong) NSMutableArray *store_tagsArray;

@property (nonatomic, strong) NSMutableArray *goodsInfoArray;
@property (nonatomic,strong)PDHeadInfoView *hview;

@end

@implementation PersonDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.fd_prefersNavigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
       self.fd_prefersNavigationBarHidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (isEmpty(_shopAccId)) {
        _shopAccId = [UserModel sharedInstance].userId;
    }
    [self requstShopDetailsInformation];
    
    self.showAllSearchItemFlag = NO;
    self.showAllSearchItemHeight = 120;
    
//    [self _initTopview];
//    [self _initTable];
}


#pragma mark ------------------------Init---------------------------------
- (void)_initTopview
{
    //顶部背景图片
    UIImageView *topImg = [[UIImageView alloc] init];
    [self.view addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(198.5);
    }];
    topImg.image = IMAGE(@"topImage");
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:IMAGE(@"my-shareicon") forState:UIControlStateNormal];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    shareBtn.titleLabel.font= CUSTOMFONT(12);
    shareBtn.hidden=YES;
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight/2+5);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(16);
    }];
    [shareBtn setBackgroundColor:[UIColor clearColor]];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //返回箭头
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight/2+5);
        make.left.equalTo(self.view.mas_left).offset(12);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    [backBtn setBackgroundImage:IMAGE(@"supply_back") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backFrontController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_initTable
{
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.tableHeaderView = [self _tableHeaderView:0 showFlag:NO];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}



 
#pragma mark ------------------------Private------------------------------
- (UIView *)_tableHeaderView:(int)height showFlag:(BOOL)flag
{
    self.hview = [[[NSBundle mainBundle] loadNibNamed:@"PDHeadInfoView" owner:self options:nil] lastObject];
    self.hview.backgroundColor = [UIColor clearColor];
    WEAK_SELF
    [self.hview.attentionBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self focus];
    }];
    
    if (self.personModel.followState==1) {
        self.hview.attentionBtn.selected=YES;
        [self.hview.attentionBtn setImage:IMAGE(@"") forState:UIControlStateNormal];
    }else{
        [self.hview.attentionBtn setImage:IMAGE(@"my-addicon") forState:UIControlStateNormal];
    }
    [self.hview configViewData:self.personModel];
    self.hview.frame = CGRectMake(0, 0, kScreenWidth, 190);
    
    NSArray *imageTempArray = self.personInfo_imageArray;
    
    PDHeadInfoTextView *tview = [[PDHeadInfoTextView alloc] initWithFrame:CGRectMake(0, 195, kScreenWidth, 250) title:self.personInfo_title msg:self.personInfo_msg imageArray:imageTempArray showFlag:flag];
    tview.delegate = self;
    
    //固定的高度
    int oldH = 270;
    //计算图片的高度
    int row = (int)imageTempArray.count / 4;
    if(imageTempArray.count % 4 != 0)
        row +=1;
    int w = (kScreenWidth-30)/4-1;
    int imageH = w*row+5;
    //计算文字的高度
    int textH = [self calcLabSize:self.personInfo_msg fontSize:12 maxWidth:kScreenWidth-30].height;
    if(textH > 56)
        textH = 56;
    
    int totalH = 0;
    if(height > 0)
    {
        totalH = imageH+height+oldH;
    }
    else
    {
        totalH = imageH+textH+oldH;
    }
    
    CGFloat storeHeight=164;
    if ([self.personModel.hasOpenShopState intValue]==0) {
        storeHeight=30;
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, totalH+storeHeight)];
    
    [backView addSubview:self.hview];
    
    tview.frame = CGRectMake(0, 195, kScreenWidth, 50+totalH-oldH);
    [backView addSubview:tview];
    
    
    PDBottumInfoView *bview = [[[NSBundle mainBundle] loadNibNamed:@"PDBottumInfoView" owner:self options:nil] lastObject];
    [bview configViewText1:self.personInfo_year text2:self.personInfo_grade];
    bview.backgroundColor = [UIColor clearColor];
    bview.frame = CGRectMake(0, tview.frame.origin.y+tview.frame.size.height+20, kScreenWidth, storeHeight);
    if ([self.personModel.hasOpenShopState intValue]==0) {
        bview.backView.hidden=YES;
        bview.backViewHeight.constant=0;
    }
    [backView addSubview:bview];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    return backView;
}

- (CGSize)calcLabSize:(NSString *)string fontSize:(int)size maxWidth:(int)w
{
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:size]
    };
    return [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
}
 
#pragma mark ------------------------Api----------------------------------
#pragma mark ---- 个人店铺详情
- (void)requstShopDetailsInformation
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"shopAccId":_shopAccId} subUrl:@"ShopApi/supplierAndShopInformation" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            NSLog(@"resultDic = %@",resultDic);
            
            NSDictionary *tempDic = resultDic[@"params"];
            weak_self.goodsInfoArray=tempDic[@"goodsList"][@"records"];
            //头部信息
            weak_self.personModel = [[PersonDetailModel alloc] init];
            weak_self.personModel.name = tempDic[@"userInformationEntity"][@"nickName"];
            weak_self.personModel.headImg = tempDic[@"userInformationEntity"][@"avatar"];
            weak_self.personModel.hasOpenShopState =[NSString stringWithFormat:@"%@",tempDic[@"userInformationEntity"][@"hasOpenShopState"]];
            weak_self.personModel.tagFlag = [tempDic[@"userInformationEntity"][@"realNameVerifyState"] intValue];
            weak_self.personModel.followState =[tempDic[@"followState"]intValue];
             
            if (isEmpty(tempDic[@"addressMergeName"])) {
            weak_self.personModel.adressString = tempDic[@"detailedAddress"];
            }else{
            weak_self.personModel.adressString = tempDic[@"addressMergeName"];
            }
            
            
            weak_self.personModel.fansNumber =  [NSString stringWithFormat:@"%@",tempDic[@"fansNumber"]];
            
            weak_self.personModel.visitorNumber = [NSString stringWithFormat:@"%@",tempDic[@"visitorsNumber"]];
            
            weak_self.personModel.chatNumber = [NSString stringWithFormat:@"%@",tempDic[@"communicatesNumber"]];
            
            //个人信息
            NSString *tmp_str1 = tempDic[@"userInformationEntity"][@"capacity"];
            NSString *tmp_str2 = tempDic[@"userInformationEntity"][@"major"];
            weak_self.personInfo_title = [NSString stringWithFormat:@"%@ | %@",tmp_str1,tmp_str2];
            
            weak_self.personInfo_imageArray = [[NSMutableArray alloc] init];
            
            NSArray *picArray = tempDic[@"userInformationEntity"][@"annexes"];
            for(int i=0;i<picArray.count;i++)
            {
                NSDictionary *_dic = [picArray objectAtIndex:i];
                [weak_self.personInfo_imageArray addObject:_dic[@"picUrl"]];
            }
            
            weak_self.personInfo_msg = tempDic[@"userInformationEntity"][@"introduction"];
            
            NSArray *tmpArr = tempDic[@"shopTags"];
            if(tmpArr.count > 1)
            {
                weak_self.personInfo_year  = tmpArr[0];
                weak_self.personInfo_grade = tmpArr[1];
            }
            
            //店铺详情
            weak_self.store_name = tempDic[@"shopname"];
            
            
            weak_self.store_days = [NSString stringWithFormat:@"持续经营:%@",tempDic[@"operatingDays"]];
            weak_self.store_money = [NSString stringWithFormat:@"累计交易:%@",tempDic[@"transactionAmount"]];
            weak_self.store_orders = [NSString stringWithFormat:@"订单笔数:%@",tempDic[@"orderCount"]];
            weak_self.store_tagsArray = [[NSMutableArray alloc] init];
            weak_self.store_tagsArray = tempDic[@"categories"];
            
            
            [weak_self _initTopview];
            [weak_self _initTable];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
            [weak_self goBackAfter:1];
        }
    }];
}



-(void)queryGoodsByAccidAndShopAccId:(NSString *)level4Id{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{@"shopAccId":_shopAccId,@"level4Id":level4Id,kRequestPageNumKey :@(1),kRequestPageSizeKey:@(kRequestDefaultPageSize)};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"ShopApi/queryGoodsByAccidAndShopAccId" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.goodsInfoArray=@[].mutableCopy;
            weak_self.goodsInfoArray=resultDic[@"params"][@"records"];
            [weak_self.tableview reloadData];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}
#pragma mark ----关注和取消店铺------
-(void)focus{
     NSDictionary *param = @{@"businessId":self.shopAccId,@"businessType":@"2",@"collectType":@"3"};
    if (self.hview.attentionBtn.selected) {

        WEAK_SELF
        [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/delete" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                 weak_self.hview.attentionBtn.selected=NO;
                     [weak_self.hview.attentionBtn setImage:IMAGE(@"my-addicon") forState:UIControlStateNormal];
                       [weak_self.hview.attentionBtn setTitle:@" 关注" forState:UIControlStateNormal];
                });
                
                [weak_self showMessage:@"取消成功"];
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    }else{

        WEAK_SELF
        [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"collect/add" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                dispatch_async(dispatch_get_main_queue(), ^{
                 weak_self.hview.attentionBtn.selected=YES;
                    [weak_self.hview.attentionBtn setImage:IMAGE(@"") forState:UIControlStateNormal];
                });
                
                [weak_self showMessage:@"关注成功"];
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    }
    
    
   
}
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)backFrontController:(id)sender
{
    [self goBack];
}

- (void)shareBtnClicked:(id)sender
{
    
}

#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return self.showAllSearchItemHeight;
    return kScreenWidth/2-15-5 + 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.goodsInfoArray.count%2==0) {
    return self.goodsInfoArray.count/2+1;
    }else{
        if (self.goodsInfoArray.count==1) {
            return 2;
        }else{
            return (self.goodsInfoArray.count+1)/2+1;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"persondetailcell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        if(indexPath.row == 0)
        {
            NSMutableArray *arr=[[NSMutableArray alloc]init];
            for (NSDictionary*dic in self.store_tagsArray) {
                [arr addObject:dic[@"cateGoryName"]];
            }
            
            NSArray *tagArr = arr; //[[NSArray alloc] initWithObjects:@"苹果",@"鲜枣",@"石榴", nil];
            PDStoreCellView *tv = [cell.contentView viewWithTag:777];
            if(tv != nil)
            {
                tv.delegate = nil;
                [tv removeFromSuperview];
            }
            if(tagArr.count == 0)
                self.showAllSearchItemHeight = 75;
            
            PDStoreCellView *view = [[PDStoreCellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.showAllSearchItemHeight) title:self.store_name vaule1Str:self.store_days value2Str:self.store_money value3Str:self.store_orders tagArray:tagArr showFlag:self.showAllSearchItemFlag];
            view.delegate = self;
            view.tag = 777;
            view.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:view];
        }
        else
        {
            PDItemCellView *itemV1 = [[PDItemCellView alloc] initWithFrame:CGRectMake(15, 5, kScreenWidth/2-15-5,kScreenWidth/2-15-5 + 90)];
            [cell.contentView addSubview:itemV1];
            itemV1.delegate = self;
            itemV1.tag = 1;
            
            PDItemCellView *itemV2 = [[PDItemCellView alloc] initWithFrame:CGRectMake(kScreenWidth/2+5,5, kScreenWidth/2-15-5,kScreenWidth/2-15-5 + 90)];
            [cell.contentView addSubview:itemV2];
            itemV2.delegate = self;
            itemV2.tag = 2;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        
    if(indexPath.row != 0)
       {
        PDItemCellView *temp_v1 = [cell.contentView viewWithTag:1];
        PDItemCellView *temp_v2 = [cell.contentView viewWithTag:2];
        NSInteger row = indexPath.row-1;
        NSDictionary *dic = nil;
        for (NSInteger i=0; i<2; i++) {
            if (row*2+i>self.goodsInfoArray.count-1) {
//                temp_v2.hidden=YES;
                return cell;
            }
            dic=[self.goodsInfoArray objectAtIndex:row*2+i];
            if (i==0) {
                  [temp_v1.item_img_btn sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] forState:UIControlStateNormal];
                   temp_v1.item_msg_lab.text   =dic[@"goodsName"];
                   temp_v1.item_price_lab.text = [NSString stringWithFormat:@"￥%@/%@",dic[@"goodsPrice"],dic[@"unit"]];
                   temp_v1.item_seen_lab.text  =[NSString stringWithFormat:@"%@人看过",dic[@"viewersCount"]];
                temp_v1.tag =row*2+i;
                   NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",temp_v1.item_price_lab.text]];
                   [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,1)];
                   [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1,str.length-2)];
                   [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str.length-2,2)];
                   [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0xFF, 0x47, 0x06) range:NSMakeRange(0,str.length)];
                   [temp_v1.item_price_lab setAttributedText:str];
            }else{
                temp_v2.tag =row*2+i;
                [temp_v2.item_img_btn sd_setImageWithURL:[NSURL URLWithString:dic[@"picUrl"]] forState:UIControlStateNormal];
               temp_v2.item_msg_lab.text   =dic[@"goodsName"];
               temp_v2.item_price_lab.text = [NSString stringWithFormat:@"￥%@/%@",dic[@"goodsPrice"],dic[@"unit"]];
               temp_v2.item_seen_lab.text  =[NSString stringWithFormat:@"%@人看过",dic[@"viewersCount"]];
               
               NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",temp_v2.item_price_lab.text]];
               [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,1)];
               [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(1,str2.length-2)];
               [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str2.length-2,2)];
               [str2 addAttribute:NSForegroundColorAttributeName value:kGetColor(0xFF, 0x47, 0x06) range:NSMakeRange(0,str2.length)];
               [temp_v2.item_price_lab setAttributedText:str2];
            }
            
        }
        

           
       
       
       
        
    }
    
    return cell;
}




#pragma mark ------ 显示全部文本
- (void)changedMsgShowHeight:(int)height
{
    self.tableview.tableHeaderView = [self _tableHeaderView:height showFlag:YES];
}


#pragma mark ------ 显示全部搜索选项
- (void)PDCellViewChangeShowStatus:(int)cellHeight
{
    self.showAllSearchItemHeight = cellHeight;
    if(cellHeight == 120)
        self.showAllSearchItemFlag = NO;
    else
        self.showAllSearchItemFlag = YES;
    [self.tableview reloadData];
}

#pragma mark ------ 点击的某一个具体的选项
- (void)PDCellViewClickedItem:(NSString *)item
{
    for (NSDictionary*dic in self.store_tagsArray) {
        if ([dic[@"cateGoryName"]isEqualToString:item]) {
            [self queryGoodsByAccidAndShopAccId:dic[@"cateGoryId"]];
        }
    }
    NSLog(@"点击的搜索选项 = %@",item);
}

#pragma mark ------ 点击的cell中的某一个Item
- (void)PDItemCellViewClicked:(id)sender
{
    PDItemCellView *tempv = (PDItemCellView *)sender;
    UITableViewCell *tempcell = (UITableViewCell *)[[tempv superview] superview];
    NSIndexPath *indexpath = [self.tableview indexPathForCell:tempcell];
    NSDictionary *dic = self.goodsInfoArray[(long)tempv.tag];
    GoodsInfoViewController *vc = [[GoodsInfoViewController alloc]init];
    vc.goodsID =[dic[@"goodsId"]intValue];
    vc.goodsImgUrl = dic[@"picUrl"];
    [self navigatePushViewController:vc animate:YES];

    NSLog(@"点击的cell行 = %ld 和 Item = %ld",(long)indexpath.row,(long)tempv.tag);
    
}



#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------


@end
