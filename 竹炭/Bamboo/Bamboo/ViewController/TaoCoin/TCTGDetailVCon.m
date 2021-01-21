//
//  TCTGDetailVCon.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/22.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCTGDetailVCon.h"
#import "TCSupplyModel.h"
#import "TCTGExpendDetailVC.h"
#import "YCTGRankingVC.h"
@interface TCTGDetailVCon ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView        *productView;   //推广产品
@property (nonatomic, strong) UIView        *limitView;     //推广限额
@property (nonatomic, strong) UITableView   *tableView;     //推广搜索词tablview
@property (nonatomic, strong) UIView        *bottomView;    //底部开启推广view

@property (nonatomic, strong) NSArray       *searchStrArray;
@property (nonatomic, strong) NSArray       *searchPriceArray;

@end

@implementation TCTGDetailVCon

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
    
    //test data
    TCSupplyModel *mm = [[TCSupplyModel alloc] init];
    mm.supply_goodsID = 1;
    mm.supply_unit = @"公斤";
    mm.supply_price = @"23.58";
    mm.supply_title = @"又大又红的正宗新疆大西瓜";
    mm.supply_imgurl = @"http://pic.enorth.com.cn/005/008/058/00500805855_7c27df5b.jpg";
    
    self.searchStrArray = [[NSArray alloc] initWithObjects:@"首页推荐",@"供应大厅",@"水果",@"核仁果类",@"山东水果", nil];
    self.searchPriceArray = [[NSArray alloc] initWithObjects:@"1.1",@"2.2",@"3.3",@"4.4",@"5.5", nil];
    
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);

    [self _initTopview];
    [self _initProductViewWith:mm];
    [self _initLimitViewWith:@"100"];
    
    [self _initTableView];
    
    [self _initBottomView];
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
    [shareBtn setTitle:@"花费明细" forState:UIControlStateNormal];
    [shareBtn setTitleColor:KTextColor forState:UIControlStateNormal];
    [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    shareBtn.titleLabel.font= CUSTOMFONT(12);
    [self.view addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight/2+5);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.width.mas_equalTo(55);
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
    
    UILabel *titleLab = [[UILabel alloc] init];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    titleLab.text = @"推广详情";
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = CUSTOMFONT(18);
}

- (void)_initProductViewWith:(TCSupplyModel *)model
{
    self.productView = [[UIView alloc] init];
    [self.view addSubview:self.productView];
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kStatusBarAndNavigationBarHeight/2+30+16);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(150);
    }];
    self.productView.layer.cornerRadius = 5.0;
    self.productView.layer.masksToBounds = YES;
    self.productView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelab = [[UILabel alloc] init];
    [self.productView addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_top).offset(16);
        make.left.equalTo(self.productView.mas_left).offset(15);
    }];
    titlelab.text = @"推广产品";
    titlelab.font = CUSTOMFONT(16);
    titlelab.textColor = UIColorFromRGB(0x111111);
    
    UIImageView *goodsimg = [[UIImageView alloc] init];
    [self.productView addSubview:goodsimg];
    [goodsimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.productView.mas_left).offset(15);
        make.top.equalTo(titlelab.mas_bottom).offset(24);
        make.size.width.equalTo(@68);
        make.size.height.equalTo(@68);
    }];
    goodsimg.layer.masksToBounds = YES;
    goodsimg.layer.cornerRadius = 2.5;
    [goodsimg sd_setImageWithURL:[NSURL URLWithString:model.supply_imgurl]];
    
    UILabel *contentlab = [[UILabel alloc] init];
    [self.productView addSubview:contentlab];
    [contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titlelab.mas_bottom).offset(34);
        make.left.equalTo(goodsimg.mas_right).offset(19);
    }];
    contentlab.font = CUSTOMFONT(14);
    contentlab.textColor = UIColorFromRGB(0x222222);
    contentlab.text = model.supply_title;
    
    UILabel *pricelab = [[UILabel alloc] init];
    [self.productView addSubview:pricelab];
    [pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(goodsimg.mas_bottom).offset(-10);
        make.left.equalTo(goodsimg.mas_right).offset(19);
    }];
    pricelab.font = CUSTOMFONT(12);
    pricelab.textColor = UIColorFromRGB(0xFF4706);
    pricelab.text = [NSString stringWithFormat:@"￥%@ /%@",model.supply_price,model.supply_unit];
    if(model.supply_price.length > 1 && model.supply_unit.length > 0)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",pricelab.text]];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1,str.length-model.supply_unit.length-1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str.length-model.supply_unit.length-1,model.supply_unit.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0xFF, 0x47, 0x06) range:NSMakeRange(0,str.length)];
        [pricelab setAttributedText:str];
    }
}

- (void)_initLimitViewWith:(NSString *)limitstr
{
    self.limitView = [[UIView alloc] init];
    [self.view addSubview:self.limitView];
    [self.limitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(56);
    }];
    self.limitView.layer.cornerRadius = 5.0;
    self.limitView.layer.masksToBounds = YES;
    self.limitView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelab = [[UILabel alloc] init];
    [self.limitView addSubview:titlelab];
    [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.limitView.mas_centerY).offset(0);
        make.left.equalTo(self.limitView.mas_left).offset(15);
    }];
    titlelab.text = @"推广限额 ";
    titlelab.font = CUSTOMFONT(14);
    titlelab.textColor = UIColorFromRGB(0x222222);
    
    UILabel *limitlab = [[UILabel alloc] init];
    [self.limitView addSubview:limitlab];
    [limitlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.limitView.mas_centerY).offset(0);
        make.right.equalTo(self.limitView.mas_right).offset(-15);
    }];
    limitlab.text = [NSString stringWithFormat:@"%@田币/天",limitstr];
    limitlab.font = CUSTOMFONT(14);
    limitlab.textColor = UIColorFromRGB(0xFF4706);
    
    
}

- (void)_initTableView
{
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitView.mas_bottom).offset(8);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-96);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)_initBottomView
{
    int vheight = IS_Iphonex_Series? 57+20 : 57;
    UIView *bottomView = [[UIView alloc] init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_bottom).offset(-vheight);
        make.height.mas_equalTo(vheight);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:pauseBtn];
    [pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(28);
        make.top.equalTo(bottomView.mas_top).offset(13);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    [pauseBtn setBackgroundImage:IMAGE(@"tb_pause.png") forState:UIControlStateNormal];
    
    UILabel *lab1 = [[UILabel alloc] init];
    [bottomView addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pauseBtn.mas_centerY).offset(0);
        make.left.equalTo(pauseBtn.mas_right).offset(50);
    }];
    lab1.text = @"15.66";
    lab1.font = CUSTOMFONT(12);
    lab1.textColor = UIColorFromRGB(0x333333);
    
    UILabel *lab2 = [[UILabel alloc] init];
    [bottomView addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(pauseBtn.mas_centerY).offset(0);
        make.left.equalTo(lab1.mas_right).offset(40);
    }];
    lab2.text = @"6666";
    lab2.font = CUSTOMFONT(12);
    lab2.textColor = UIColorFromRGB(0x333333);
    
    UILabel *lab1_1 = [[UILabel alloc] init];
    [bottomView addSubview:lab1_1];
    [lab1_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pauseBtn.mas_bottom).offset(7);
        make.centerX.equalTo(pauseBtn.mas_centerX).offset(0);
    }];
    lab1_1.text = @"已停止";
    lab1_1.font = CUSTOMFONT(10);
    lab1_1.textColor = UIColorFromRGB(0x999999);
    
    UILabel *lab2_1 = [[UILabel alloc] init];
    [bottomView addSubview:lab2_1];
    [lab2_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pauseBtn.mas_bottom).offset(7);
        make.centerX.equalTo(lab1.mas_centerX).offset(0);
    }];
    lab2_1.text = @"今日花费";
    lab2_1.font = CUSTOMFONT(10);
    lab2_1.textColor = UIColorFromRGB(0x999999);
    
    UILabel *lab3_1 = [[UILabel alloc] init];
    [bottomView addSubview:lab3_1];
    [lab3_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pauseBtn.mas_bottom).offset(7);
        make.centerX.equalTo(lab2.mas_centerX).offset(0);
    }];
    lab3_1.text = @"今日花费";
    lab3_1.font = CUSTOMFONT(10);
    lab3_1.textColor = UIColorFromRGB(0x999999);
    
    UIButton *startBtn = [[UIButton alloc] init];
    [bottomView addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top).offset(8);
        make.right.equalTo(bottomView.mas_right).offset(-15);
        make.width.mas_equalTo(102);
        make.height.mas_equalTo(42);
    }];
    [self customBtnBy:startBtn backColor:UIColorFromRGB(0x46C67B) textColor:UIColorFromRGB(0xffffff) title:@"开启推广" tag:1];
    
}


#pragma mark ------------------------View Event---------------------------
- (void)backFrontController:(id)sender
{
    [self goBack];
}

- (void)shareBtnClicked:(id)sender
{
    TCTGExpendDetailVC *vc = [[TCTGExpendDetailVC alloc]init];
    [self navigatePushViewController:vc animate:YES];
}

//开启推广
- (void)startBtnClicked:(id)sender
{
    
}


#pragma mark ------------------------delegate---------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 43)];
    view.backgroundColor = UIColorFromRGB(0xebebeb);
    
    UILabel *lab1 = [[UILabel alloc] init];
    [self customLabel:lab1 tag:1];
    [view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/3+20);
    }];
    
    UILabel *lab2 = [[UILabel alloc] init];
    [self customLabel:lab2 tag:2];
    [view addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab1.mas_right);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/3-10);
    }];

    UILabel *lab3 = [[UILabel alloc] init];
    [self customLabel:lab3 tag:3];
    [view addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab2.mas_right);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/3-10);
    }];
    lab1.textColor       = UIColorFromRGB(0x222222);
    lab2.textColor       = UIColorFromRGB(0x222222);
    lab3.textColor       = UIColorFromRGB(0x222222);
    lab1.text = @"推广搜索词";
    lab2.text = @"我的出价";
    lab3.text = @"我的排名";
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchStrArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifystr = @"tgDetailCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifystr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifystr];
        UILabel *lab1 = [[UILabel alloc] init];
        [self customLabel:lab1 tag:1];
        [cell.contentView addSubview:lab1];
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo((kScreenWidth-30)/3+20);
        }];
        lab1.text = @"qwert";
        
        //有问题
        float centerX1 = (kScreenWidth-30)/17;
        float centerX2 = (kScreenWidth-30)/2.85;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 2;
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX1);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo(58);
        }];
        btn.layer.cornerRadius = 3.;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1.;
        btn.layer.borderColor = UIColorFromRGB(0xFF4706).CGColor;
        [btn setTitle:@"123" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xFF4706) forState:UIControlStateNormal];
        btn.titleLabel.font = CUSTOMFONT(14);

        UILabel *lab3 = [[UILabel alloc] init];
        [self customLabel:lab3 tag:3];
        [cell addSubview:lab3];
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX2);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo(58);
        }];
        lab3.layer.cornerRadius = 3.;
        lab3.layer.masksToBounds = YES;
        lab3.layer.borderWidth = 1.;
        lab3.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        lab3.textColor = UIColorFromRGB(0x666666);
        lab3.text = @"查看";
        
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.mas_bottom).offset(-1);
            make.left.equalTo(cell.mas_left).offset(0);
            make.right.equalTo(cell.mas_right).offset(0);
            make.height.mas_equalTo(0.8);
        }];
    }
     
    UILabel *lab1  = [cell viewWithTag:1];
    UIButton *btn2 = [cell viewWithTag:2];
    lab1.text = [self.searchStrArray objectAtIndex:indexPath.row];
    [btn2 setTitle:[self.searchPriceArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YCTGRankingVC *vc = [[YCTGRankingVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}

#pragma mark ------------------------private------------------------------
- (void)customLabel:(UILabel *)lab tag:(int)tag
{
    lab.textColor       = UIColorFromRGB(0x666666);
    lab.textAlignment   = NSTextAlignmentCenter;
    lab.font            = CUSTOMFONT(12);
    lab.tag             = tag;
}

- (void)customBtnBy:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor title:(NSString *)title tag:(int)tag
{
    [btn setBackgroundColor:bcolor];
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 21;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = CUSTOMFONT(16);
    [btn addTarget:self action:@selector(startBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
}


@end
