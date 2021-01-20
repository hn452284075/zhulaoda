//
//  SetPriceViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetPriceViewController.h"
#import "SetPriceTableViewCell.h"
#import "SetPriceModel.h"
#import "UnitView.h"

@interface SetPriceViewController ()<UITableViewDelegate,UITableViewDataSource,SetPriceDelegate,UnitViewDelegate>

@property (nonatomic, strong) UIView        *topView;
@property (nonatomic, strong) UITableView   *tablview;
@property (nonatomic, strong) NSMutableArray    *priceArray;
@property (nonatomic, strong) NSArray           *tagArray;

@property (nonatomic, strong) UnitView      *unitView;  //计量单位弹窗

@property (nonatomic, strong) NSString      *unitString; //选择的计量单位
@property (nonatomic, strong) NSString      *unitStart;  //最低起批量

@end

@implementation SetPriceViewController
@synthesize delegate;
@synthesize categateID;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"设置价格";
    
    self.tagArray = [[NSArray alloc] init];
    self.unitString = @"斤";
    self.unitStart  = @"";
    
    if(self.defaultUnit.length > 0)
    {
        self.unitString = self.defaultUnit;
        self.unitStart  = self.defaultSunit;
        self.priceArray = [[NSMutableArray alloc] initWithArray:self.defaultArr];
    }
    else
    {
        self.priceArray = [[NSMutableArray alloc] init];
        SetPriceModel *pm = [[SetPriceModel alloc] init];
        pm.priceSpec = @"";
        pm.pricevalue = @"";
        pm.priceMsg = @"元/斤";
        [self.priceArray addObject:pm];
    }
    
    
    
    self.view.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
    
    //tableview
    self.tablview = [[UITableView alloc] init];
    [self.view addSubview:self.tablview];
    [self.tablview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        //make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.height.mas_equalTo(50*4+self.priceArray.count*50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    self.tablview.tableFooterView = [[UIView alloc] init];
    self.tablview.delegate = self;
    self.tablview.dataSource = self;
    self.tablview.separatorColor = UIColorFromRGB(0xf2f2f2);
    
    //底部的确定按钮
    UIButton *okBtn = [[UIButton alloc] init];
    [self.view addSubview:okBtn];
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:okBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"确定"
            fontsize:18
              corner:22
                 tag:2];
    
    
}

#pragma mark ------------------------Init---------------------------------


#pragma mark ------------------------Private------------------------------
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
-(void)_requestDataWithCID:(int)cid{

    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"categoryId":[NSNumber numberWithInt:cid]} subUrl:@"ShopApi/chooseCategoryUnit" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
                        
            weak_self.tagArray = resultDic[@"params"];
            
            if(weak_self.unitView)
            {
                weak_self.unitView.delegate = nil;
                [weak_self.unitView removeFromSuperview];
            }
            weak_self.unitView = [[UnitView alloc] initWithFrame:CGRectMake(0, -kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) title:@"" tagArr:self.tagArray];
            weak_self.unitView.delegate = weak_self;
            [weak_self.view addSubview:weak_self.unitView];

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}


#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(id)sender
{
    for(int i=0;i<self.priceArray.count;i++)
    {
        SetPriceModel *pm = [self.priceArray objectAtIndex:i];
        NSIndexPath *path_1 = [NSIndexPath indexPathForRow:3+i inSection:0];
        UITableViewCell *cell_1 = [self.tablview cellForRowAtIndexPath:path_1];
        SetPriceTableViewCell *viewcell_1 = (SetPriceTableViewCell *)[cell_1 viewWithTag:100];
        UITextField *filed_1 = [viewcell_1 viewWithTag:3];
        UITextField *filed_2 = [viewcell_1 viewWithTag:4];
        pm.priceSpec  = filed_1.text;
        pm.pricevalue = filed_2.text;
        
        if(filed_1.text.length == 0 || filed_2.text.length == 0)
        {
            [self showMessage:@"所有选项不能为空"];
            return;
        }
    }
    if(self.unitString.length == 0 || self.unitStart.length == 0)
    {
        [self showMessage:@"所有选项不能为空"];
        return;
    }
    
    [self.delegate priceInfoOfSpecs:self.unitString sunit:self.unitStart specsArr:self.priceArray];
    
    [self goBack];
    
}

#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self _requestDataWithCID:self.categateID];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    return 50.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4+self.priceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"setpricecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            SetPriceTableViewCell *priceview = [[SetPriceTableViewCell alloc] init];
            priceview.delegate = self;
            priceview.tag = 100;
            [cell addSubview:priceview];
            [priceview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top);
                make.left.equalTo(cell.mas_left);
                make.right.equalTo(cell.mas_right);
                make.height.mas_equalTo(50);
            }];
        });
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        SetPriceTableViewCell *priceview = (SetPriceTableViewCell *)[cell viewWithTag:100];
        priceview.row = (int)indexPath.row;
        
        if(indexPath.row == 0)
        {
            [priceview configCellTitle:@"计量单位"
                        actionImg:@""
                         f1String:self.unitString
                  f1DefaultString:@""
                         f2String:@""
                  f2DefaultString:@""
                        msgString:@""];
            [priceview viewWithTag:3].userInteractionEnabled = NO;
            [priceview configCellTitleShow:YES filed1:YES filed2:NO msglab:NO arrowImg:YES];
        }
        else if(indexPath.row == 1)
        {
            [priceview configCellTitle:@"起批量"
                        actionImg:@""
                         f1String:self.unitStart
                  f1DefaultString:@"最低起批量"
                         f2String:@""
                  f2DefaultString:@""
                        msgString:[NSString stringWithFormat:@"%@/起",self.unitString]];
            UITextField *fd = [priceview viewWithTag:3];
            fd.keyboardType = UIKeyboardTypeNumberPad;
            [priceview configCellTitleShow:YES filed1:YES filed2:NO msglab:YES arrowImg:NO];
        }
        else if(indexPath.row == 2)
        {
            [priceview configCellTitle:@"规格及价格"
                        actionImg:@""
                         f1String:@""
                  f1DefaultString:@""
                         f2String:@""
                  f2DefaultString:@""
                        msgString:@""];
            
            [priceview configCellTitleShow:YES filed1:NO filed2:NO msglab:NO arrowImg:NO];
        }
        else if(indexPath.row == 4+self.priceArray.count-1)
        {
            [priceview configCellTitle:@""
                        actionImg:@"storeaddicon"
                         f1String:@""
                  f1DefaultString:@""
                         f2String:@""
                  f2DefaultString:@""
                        msgString:@""];
            
            [priceview configCellTitleShow:NO filed1:NO filed2:NO msglab:NO arrowImg:NO];
        }
        else
        {
            SetPriceModel *pm = [self.priceArray objectAtIndex:indexPath.row-3];
            [priceview configCellTitle:@""
                        actionImg:@"storesubicon"
                         f1String:pm.priceSpec
                  f1DefaultString:@"商品规格"
                         f2String:pm.pricevalue
                  f2DefaultString:@"单价"
                        msgString:[NSString stringWithFormat:@"元/%@",self.unitString]];
            UITextField *fd = [priceview viewWithTag:4];
            fd.keyboardType = UIKeyboardTypeDecimalPad;
            [priceview configCellTitleShow:NO filed1:YES filed2:YES msglab:YES arrowImg:NO];
            
            if (self.priceArray.count == 1) {
                [priceview viewWithTag:2].userInteractionEnabled = NO;
                [priceview viewWithTag:2].alpha = 0.4;
            }
            else
            {
                [priceview viewWithTag:2].userInteractionEnabled = YES;
                [priceview viewWithTag:2].alpha = 1;
            }
        }
    
    });
    
    return cell;
}


#pragma mark---------------- 加减图标的按钮 delegate
- (void)addOrSubFunction:(int)flag row:(int)row
{
    if(self.priceArray.count == 5)
    {
        [self showMessage:@"最多添加五种规格"];
        return;
    }
    
    if(flag == 0)
    {
        SetPriceModel *pm = [[SetPriceModel alloc] init];
        pm.priceSpec  = @"";
        pm.pricevalue = @"";
        pm.priceMsg   = [NSString stringWithFormat:@"元/%@",self.unitString];
        [self.priceArray addObject:pm];
    }
    else
    {
        [self.priceArray removeObjectAtIndex:row-3];
    }
            
    [self.tablview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.height.mas_equalTo(50*4+self.priceArray.count*50);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.tablview reloadData];
        
   
}

- (void)filedTextChanged:(NSString *)filed1Str filed2:(nonnull NSString *)filed2Str event:(nonnull id)event
{
    SetPriceTableViewCell *tc = (SetPriceTableViewCell *)event;
    UITableViewCell *cell = (UITableViewCell *)tc.superview;
    NSIndexPath *indexpath = [self.tablview indexPathForCell:cell];
    if(indexpath.row > 2)
    {
        int pricerow = (int)indexpath.row - 3;
        SetPriceModel *pm = [self.priceArray objectAtIndex:pricerow];
        if(filed1Str.length > 0)
        {
            pm.priceSpec  = filed1Str;
            pm.pricevalue = filed2Str;
        }
    }
    else if(indexpath.row == 1)
    {
        self.unitStart = filed1Str;
    }
}


#pragma mark---------------- 计量单位 delegate
- (void)confirmInfo:(int)selectedIndex
{
    if(self.tagArray.count == 0)
    {
        [self.unitView removeFromSuperview];
        self.unitView.delegate = nil;
    }
    else
    {
        NSIndexPath *path_0 = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell_0 = [self.tablview cellForRowAtIndexPath:path_0];
        SetPriceTableViewCell *viewcell_0 = (SetPriceTableViewCell *)[cell_0 viewWithTag:100];
        UITextField *filed_0 = [viewcell_0 viewWithTag:3];
        filed_0.text = [self.tagArray objectAtIndex:selectedIndex];
        
        self.unitString = filed_0.text;
        
        [self.unitView removeFromSuperview];
        self.unitView.delegate = nil;
        
        [self.tablview reloadData];
    }
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------



@end
