//
//  BusinessCircleVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/25.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BusinessCircleVC.h"
#import "CircleChatCell.h"
#import "CustomManageViewController.h"

@interface BusinessCircleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *goBtn;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *midView;

@property (nonatomic, strong) UIButton *bar_leftBtn;
@property (nonatomic, strong) UIButton *bar_rightBtn;

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BusinessCircleVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if (!UserIsLogin)
    {
        [self _initTableView]; //初始化tableview
    }
//    else
//    {
//        [self _initViewWithoutLogin];
//    }
}


#pragma mark ------------------------Init---------------------------------
- (UIView *)_tableHeaderView
{
    int iphonex_height = 0;
    if(IS_Iphonex_Series)
        iphonex_height = 34;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180+iphonex_height)];
    
    UIView *bv = [[UIView alloc] init];
    [self.topView addSubview:bv];
    bv.backgroundColor = UIColorFromRGB(0x46C67B);
    [bv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.height.mas_equalTo(140+iphonex_height);
    }];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    self.bar_leftBtn = [[UIButton alloc] init];
    [self.topView addSubview:self.bar_leftBtn];
    [self.bar_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(20+iphonex_height);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(16);
    }];
    self.bar_leftBtn.titleLabel.font = CUSTOMFONT(16);
    [self.bar_leftBtn setTitle:@"商圈" forState:UIControlStateNormal];
    [self factory_btn:self.bar_leftBtn tcolor:[UIColor whiteColor] tag:1 image:@""];
    
    self.bar_rightBtn = [[UIButton alloc] init];
    [self.topView addSubview:self.bar_rightBtn];
    [self.bar_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bar_leftBtn.mas_centerY);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    [self.bar_rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self factory_btn:self.bar_rightBtn tcolor:nil tag:2 image:@"bc_barrighticon"];
    
    UIButton *seachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [seachBtn setImage:IMAGE(@"home-seacher") forState:UIControlStateNormal];
    [seachBtn setTitle:@"搜索聊天记录或联系人" forState:UIControlStateNormal];
    [seachBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [seachBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    seachBtn.titleLabel.font = CUSTOMFONT(12);
    [self.topView addSubview:seachBtn];
    [seachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bar_leftBtn.mas_right).offset(8);
        make.right.equalTo(self.bar_rightBtn.mas_left).offset(-8);
        make.centerY.equalTo(self.bar_leftBtn.mas_centerY);
        make.height.mas_equalTo(30);
    }];
    seachBtn.layer.cornerRadius=15;
    seachBtn.backgroundColor = [UIColor whiteColor];
    [self factory_btn:seachBtn tcolor:UIColorFromRGB(0x999999) tag:3 image:@""];
    
    [self _initMidView];
    return self.topView;
}

- (void)_initMidView
{
    self.midView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    [self.topView addSubview:self.midView];
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bar_leftBtn.mas_bottom).offset(18);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.right.equalTo(self.topView.mas_right).offset(-15);
        make.height.mas_equalTo(120);
    }];
    self.midView.layer.shadowRadius  = 13;
    self.midView.layer.shadowOffset  = CGSizeMake(0.0f,0.0f);
    self.midView.layer.shadowOpacity = 0.5f;
    self.midView.layer.cornerRadius  = 5.;
    self.midView.layer.shadowColor   = [UIColor lightGrayColor].CGColor;
    self.midView.backgroundColor     = [UIColor whiteColor];
    
    UIView *linev = [[UIView alloc] init];
    linev.backgroundColor = [UIColor lightGrayColor];
    linev.alpha = 0.45;
    [self.midView addSubview:linev];
    [linev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_top).offset(10);
        make.bottom.equalTo(self.midView.mas_bottom).offset(-10);
        make.centerX.equalTo(self.midView.mas_centerX);
        make.width.mas_equalTo(0.5);
    }];
    
    UIView *customView = [self getCustomClassView:IMAGE(@"bc_customimg")
                                              tag:4
                                            title:@"潜在客户"];
    UIView *manageView = [self getCustomClassView:IMAGE(@"bc_manageimg")
                                              tag:5
                                            title:@"客户管理"];
    [self.midView addSubview:customView];
    [self.midView addSubview:manageView];
    [customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midView.mas_centerY).offset(0);
        make.centerX.equalTo(self.midView.mas_centerX).dividedBy(2);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55+20);
    }];
    
    [manageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midView.mas_centerY).offset(0);
        make.centerX.equalTo(self.midView.mas_centerX).multipliedBy(1.5);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55+20);
    }];
}

- (void)_initTableView
{
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-44);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor whiteColor];
    self.tableview.tableHeaderView = [self _tableHeaderView];
}

- (void)_initViewWithoutLogin
{
    UIImageView *statusView = [[UIImageView alloc] init];
    [self.view addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(200);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    statusView.image = IMAGE(@"bc_nologinimg");
    
    UILabel *lab = [[UILabel alloc] init];
    [self.view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statusView.mas_bottom).offset(27);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(64);
    }];
    lab.text = @"登录查看最近聊天信息\n不要错过任何商机";
    lab.font = CUSTOMFONT(22);
    lab.textColor = UIColorFromRGB(0x343434);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 2;
    
    
    //去登录
    self.goBtn = [[UIButton alloc] init];
    [self.view addSubview:self.goBtn];
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-150);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.goBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"去登录"
            fontsize:18
              corner:22
                 tag:100];
}
 
#pragma mark ------------------------Private------------------------------
- (void)factory_btn:(UIButton *)btn tcolor:(UIColor *)color  tag:(int)tag image:(NSString *)imgname
{
    btn.tag = tag;
    if(imgname.length > 0)
       [btn setImage:IMAGE(imgname) forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(btnClicked:)
  forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)getCustomClassView:(UIImage *)img tag:(int)tag title:(NSString *)string
{
    int w = 55;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, w+20)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, w, w)];
    [btn setImage:img forState:UIControlStateNormal];
    btn.tag = tag;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, w+5, w, 14)];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    return view;
}


- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}

 
#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 4:
        {
            CustomManageViewController *vc = [[CustomManageViewController alloc] init];
            [self navigatePushViewController:vc animate:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"circelchatcell";
    CircleChatCell *cell = (CircleChatCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CircleChatCell" owner:nil options:nil] firstObject];
        cell.headImgview.layer.cornerRadius = 19;
        cell.countLabel.backgroundColor = [UIColor redColor];
        [cell.countLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        cell.tagLabel1.backgroundColor = [UIColor clearColor];
        cell.tagLabel1.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.tagLabel1.textColor = [UIColor orangeColor];
        cell.tagLabel1.layer.borderWidth = 1.;
        cell.tagLabel1.layer.cornerRadius = 5.;
        
        cell.tagLabel2.backgroundColor = [UIColor clearColor];
        cell.tagLabel2.layer.borderColor = [UIColor greenColor].CGColor;
        cell.tagLabel2.textColor = [UIColor greenColor];
        cell.tagLabel2.layer.borderWidth = 1.;
        cell.tagLabel2.layer.cornerRadius = 5.;
        
        cell.tagLabel3.backgroundColor = [UIColor clearColor];
        cell.tagLabel3.layer.borderColor = [UIColor redColor].CGColor;
        cell.tagLabel3.textColor = [UIColor redColor];
        cell.tagLabel3.layer.borderWidth = 1.;
        cell.tagLabel3.layer.cornerRadius = 5.;
        
        cell.countLabel.layer.cornerRadius = 6;
        
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headImgview.image = IMAGE(@"supply_goodsimg");
    [cell.countLabel setTitle:@"99" forState:UIControlStateNormal];
    cell.nameLabel.text = @"桃花源";
    cell.tagLabel1.text = @" 实名 ";
    cell.tagLabel2.text = @" 开店宝 ";
    cell.tagLabel3.text = @" 竹商 ";
    cell.msgLabel.text  = @"澳大利亚进口毛绒玩具，健康安全、好玩有趣";
    cell.timeLabel.text = @"2020/08/28";
    
    return cell;
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------



@end
