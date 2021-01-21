//
//  NewETViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "NewETViewController.h"
#import "SetPriceTableViewCell.h"
#import "UnitView.h"
#import "SetExpressDetailModel.h"
#import "SelectedProvinceView.h"

@interface NewETViewController ()<UIGestureRecognizerDelegate,UnitViewDelegate,SelectedProviceDelegate>

@property (nonatomic, strong) UIScrollView  *bgscrollview;
@property (nonatomic, strong) UIView        *topView;
@property (nonatomic, strong) UIButton      *okBtn;

@property (nonatomic, strong) SetPriceTableViewCell *rowview_1;
@property (nonatomic, strong) SetPriceTableViewCell *rowview_2;
@property (nonatomic, strong) UnitView              *unitView;  //计费单位弹窗
@property (nonatomic, strong) NSArray               *tagArray;  //计费单位--测试数组
@property (nonatomic, strong) SelectedProvinceView  *pView;     //选择省份地区的view
@property (nonatomic, assign) int                   activeRow;  //记录操作的cellview

@property (nonatomic, assign) BOOL                  isEdit;

@end

@implementation NewETViewController
@synthesize modelData;
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageTitle = @"新建模板";
    
    [self _initUI];
    
    //画模板
    [self drawTemplateRowView];
    
}


#pragma mark ------------------------Init---------------------------------
-(void)_initUI{
    //test data
       self.tagArray = [[NSArray alloc] initWithObjects:@"袋",@"斤",@"车",@"头",@"个",@"两",@"方",@"色",@"亩", nil];
       int iphonex_height = 60;
       if (IS_Iphonex_Series) {
           iphonex_height = 85;
       }
       
       self.bgscrollview = [[UIScrollView alloc] init];
       [self.view addSubview:self.bgscrollview];
       [self.bgscrollview mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view.mas_top);
           make.bottom.equalTo(self.view.mas_bottom).offset(-iphonex_height);
           make.left.equalTo(self.view.mas_left);
           make.right.equalTo(self.view.mas_right);
       }];
       self.bgscrollview.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
       
       [self _initTopView];
       
       self.okBtn = [[UIButton alloc] init];
       [self.view addSubview:self.okBtn];
       [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.bgscrollview.mas_bottom).offset(10);
           make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
           make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
           make.height.mas_equalTo(45);
       }];
       [self factory_btn:self.okBtn
              backColor:KCOLOR_Main
              textColor:[UIColor whiteColor]
            borderColor:KCOLOR_Main
                  title:@"确定"
               fontsize:18
                 corner:22
                    tag:2];
       
}
- (void)_initTopView
{
    self.topView = [[UIView alloc] init];
    [self.bgscrollview addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgscrollview.mas_top).offset(14);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.height.mas_offset(100);
    }];
    self.topView.layer.cornerRadius = 5.;
    self.topView.backgroundColor = [UIColor whiteColor];

    
    self.rowview_1 = [[SetPriceTableViewCell alloc] init];
    self.rowview_1.tag = 100;
    [self.topView addSubview:self.rowview_1];
    [self.rowview_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.height.mas_equalTo(50);
    }];
    self.rowview_1.layer.cornerRadius = 5.;
    self.rowview_1.backgroundColor = [UIColor whiteColor];
    NSString *name_1 = modelData.templateName.length>0?modelData.templateName:@"";
    [self.rowview_1 configCellTitle:@"模板名称"
                actionImg:@""
                 f1String:name_1
          f1DefaultString:@"模板名称"
                 f2String:@""
          f2DefaultString:@""
                msgString:@""];

    [self.rowview_1 configCellTitleShow:YES filed1:YES filed2:NO msglab:NO arrowImg:NO];
    
    self.rowview_2 = [[SetPriceTableViewCell alloc] init];
    self.rowview_2.tag = 101;
    [self.topView addSubview:self.rowview_2];
    [self.rowview_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rowview_1.mas_bottom);
        make.left.equalTo(self.topView.mas_left);
        make.right.equalTo(self.topView.mas_right);
        make.height.mas_equalTo(50);
    }];
    self.rowview_2.layer.cornerRadius = 5.;
    self.rowview_2.backgroundColor = [UIColor whiteColor];
    NSString *unit_2 = modelData.unitPrice.length>0?modelData.unitPrice:@"";
    [self.rowview_2 configCellTitle:@"计费单位"
                actionImg:@""
                 f1String:unit_2
          f1DefaultString:@"按袋计算"
                 f2String:@""
          f2DefaultString:@""
                msgString:@""];
    [self.rowview_2 viewWithTag:3].userInteractionEnabled = NO;
    [self.rowview_2 configCellTitleShow:YES filed1:YES filed2:NO msglab:NO arrowImg:YES];
    
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPriceUnit:)];
    tapgesture.delegate = self;
    [self.rowview_2 addGestureRecognizer:tapgesture];
    
}

- (UIView *)getTemplateCell:(SetExpressDetailModel *)dm viewTag:(int)tag
{
    UIView *rowbgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 165)];
    rowbgv.tag = tag;
    rowbgv.layer.cornerRadius = 5.;
    rowbgv.backgroundColor = [UIColor whiteColor];
        
    
    NSString *str = [self getProviceString:(NSArray  *)dm.areaArray];
    
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowbgv addSubview:selectedBtn];
    [selectedBtn setTitle:str forState:UIControlStateNormal];
    [selectedBtn setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    selectedBtn.titleLabel.font= [UIFont boldSystemFontOfSize:14];
    selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rowbgv addSubview:selectedBtn];
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowbgv.mas_top).offset(15);
        make.left.equalTo(rowbgv.mas_left).offset(15);
        make.right.equalTo(rowbgv.mas_right).offset(-55);
        make.height.mas_equalTo(15);
    }];
    selectedBtn.tag = 111;
    [selectedBtn addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowbgv addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedBtn.mas_centerY).offset(0);
        make.right.equalTo(rowbgv.mas_right).offset(5);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(55);
    }];
    closeBtn.tag = 112;
    [closeBtn setImage:IMAGE(@"storecloseicon") forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
    lineview.alpha = 1;
    [rowbgv addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectedBtn.mas_bottom).offset(15);
        make.left.equalTo(rowbgv.mas_left).offset(0);
        make.right.equalTo(rowbgv.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
        
    UIView *rowview_1 = [self detailInfoView:@"首重"
                                      value1:dm.default_weight
                                        str2:@"袋"
                                        str3:@"运费"
                                      value2:dm.default_price
                                        str4:@"元"];
    rowview_1.tag = 88;
    [rowbgv addSubview:rowview_1];
    [rowview_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectedBtn.mas_bottom).offset(10);
        make.left.equalTo(rowbgv.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(60);
    }];
    
    UIView *rowview_2 = [self detailInfoView:@"每增加"
                                      value1:dm.add_weight
                                        str2:@"袋"
                                        str3:@"运费增加"
                                      value2:dm.add_price
                                        str4:@"元"];
    rowview_2.tag = 99;
    [rowbgv addSubview:rowview_2];
    [rowview_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowview_1.mas_bottom).offset(-10);
        make.left.equalTo(rowbgv.mas_left).offset(0);
        make.width.mas_equalTo(kScreenWidth-30);
        make.height.mas_equalTo(60);
    }];
    
    return rowbgv;
}


- (UIView *)detailInfoView:(NSString *)str1 value1:(NSString *)value1 str2:(NSString *)str2
                      str3:(NSString *)str3 value2:(NSString *)value2 str4:(NSString *)str4
{
    int w = kScreenWidth-30;
    
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 60)];
    
    UILabel *lab1 = [[UILabel alloc] init];
    [bgv addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgv.mas_centerY).offset(0);
        make.left.equalTo(bgv.mas_left).offset(2);
        make.width.mas_equalTo(w/6);
        make.height.mas_equalTo(30);
    }];
    [self factoryLabel:lab1 text:str1 tag:1];
    
    UITextField *filed1 = [[UITextField alloc] init];
    [bgv addSubview:filed1];
    [filed1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1.mas_centerY).offset(0);
        make.left.equalTo(lab1.mas_right).offset(10);
        make.width.mas_equalTo(w/6);
        make.height.mas_equalTo(30);
    }];
    filed1.keyboardType = UIKeyboardTypeNumberPad;
    [self factoryFiled:filed1 defaultstr:@"" text:value1 tag:2];
    [filed1 addTarget:self action:@selector(filed1TextChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    UILabel *lab2 = [[UILabel alloc] init];
    [bgv addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgv.mas_centerY).offset(0);
        make.left.equalTo(filed1.mas_right).offset(-15);
        make.width.mas_equalTo(w/6-15);
        make.height.mas_equalTo(30);
    }];
    [self factoryLabel:lab2 text:str2 tag:3];
    
    UILabel *lab3 = [[UILabel alloc] init];
    [bgv addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgv.mas_centerY).offset(0);
        make.left.equalTo(lab2.mas_right).offset(0);
        make.width.mas_equalTo(w/6+15);
        make.height.mas_equalTo(30);
    }];
    [self factoryLabel:lab3 text:str3 tag:4];
    
    UITextField *filed2 = [[UITextField alloc] init];
    filed2.keyboardType = UIKeyboardTypeDecimalPad;
    [bgv addSubview:filed2];
    [filed2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1.mas_centerY).offset(0);
        make.left.equalTo(lab3.mas_right).offset(10);
        make.width.mas_equalTo(w/6);
        make.height.mas_equalTo(30);
    }];
    [filed2 addTarget:self action:@selector(filed2TextChanged:) forControlEvents:UIControlEventEditingChanged];
    [self factoryFiled:filed2 defaultstr:@"" text:value2 tag:5];
    
    UILabel *lab4 = [[UILabel alloc] init];
    [bgv addSubview:lab4];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgv.mas_centerY).offset(0);
        make.left.equalTo(filed2.mas_right).offset(-15);
        make.width.mas_equalTo(w/6-10);
        make.height.mas_equalTo(30);
    }];
    [self factoryLabel:lab4 text:str4 tag:6];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w/6, 1)];
    line1.backgroundColor = UIColorFromRGB(0xf2f2f2);
    line1.alpha = 1.0;
    [bgv addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(filed1.mas_bottom).offset(10);
        make.left.equalTo(lab1.mas_right).offset(10);
        make.width.mas_equalTo(w/6);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w/6, 1)];
    line2.backgroundColor = UIColorFromRGB(0xf2f2f2);
    line2.alpha = 1.0;
    [bgv addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(filed2.mas_bottom).offset(10);
        make.left.equalTo(lab3.mas_right).offset(10);
        make.width.mas_equalTo(w/6);
        make.height.mas_equalTo(0.5);
    }];
    
    return bgv;
}

 
#pragma mark ------------------------Private------------------------------
- (void)drawTemplateRowView
{
    for(UIView *v in self.bgscrollview.subviews)
    {
        if(v.tag > 199)
            [v removeFromSuperview];
    }
    
    int start_tag = 200;
    int x = 14;
    int y = 125;
    int w = kScreenWidth - 28;
    int h = 165;
    int y_gap = 10;
    for(int i=0;i<self.modelData.expressDetailArray.count;i++)
    {
        UIView * cellview = [self getTemplateCell:[self.modelData.expressDetailArray objectAtIndex:i]
                                          viewTag:start_tag++];
        [self.bgscrollview addSubview:cellview];
        cellview.frame = CGRectMake(x, y+(y_gap+h)*i, w, h);
    }
        
    self.bgscrollview.contentSize = CGSizeMake(kScreenWidth, y+self.modelData.expressDetailArray.count*(h+y_gap)+80);
    
    //增加地区运费
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    newBtn.tag = 500;
    newBtn.frame = CGRectMake(15, y+(y_gap+h)*self.modelData.expressDetailArray.count+10, 200, 20);
    [newBtn setImage:IMAGE(@"storenewtemplateicon") forState:UIControlStateNormal];
    [newBtn setTitle:@"  增加地区运费" forState:UIControlStateNormal];
    [newBtn setTitleColor:kGetColor(0x9a, 0x9a, 0x9a) forState:UIControlStateNormal];
    [newBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    newBtn.titleLabel.font= CUSTOMFONT(14);
    [self.bgscrollview addSubview:newBtn];
    [newBtn setBackgroundColor:[UIColor clearColor]];
    [newBtn addTarget:self action:@selector(newBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    newBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)factoryLabel:(UILabel *)lab text:(NSString *)str tag:(int)tag
{
    lab.text = str;
    lab.font = CUSTOMFONT(14);
    lab.textColor = UIColorFromRGB(0x222222);
    lab.textAlignment = NSTextAlignmentRight;
}

- (void)factoryFiled:(UITextField *)fd defaultstr:(NSString *)dstr text:(NSString *)str tag:(int)tag
{
    if(str.length > 0)
        fd.text = str;
    else
        fd.placeholder = dstr;
    fd.font = CUSTOMFONT(14);
    fd.textColor = UIColorFromRGB(0x222222);
    fd.textAlignment = NSTextAlignmentCenter;
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
//提交模板数据
-(void)postTemplateData:(SetExpressModel *)model{
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for (int a=0;a<model.expressDetailArray.count;a++) {
        SetExpressDetailModel *dicModel = model.expressDetailArray[a];
        NSString *str = [(NSArray  *)dicModel.areaArray componentsJoinedByString:@"_"];
        [array addObject:@{@"area":str,@"freightFirst":dicModel.default_price,@"freightInc":dicModel.add_price,@"weightFirst":dicModel.default_weight,@"weightInc":dicModel.add_weight}];
    }
 
     WEAK_SELF
    NSDictionary *param = @{@"name":model.templateName,@"unit":model.unitPrice,@"freightInfoVos":array};
  
        
     [self showHub];
     [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"ShopApi/newFreightTemplate" block:^(NSDictionary *resultDic, NSError *error) {
         [weak_self dissmiss];
         NSLog(@"resultDic:%@",resultDic);
         if ([resultDic[@"code"] integerValue]==200) {
             [weak_self showSuccessInfoWithStatus:@"新建模板成功"];
             [self.delegate expressTemplateChanged:weak_self.modelData];
             [self goBack];

         }else{
             [weak_self showMessage:resultDic[@"desc"]];
         }

     }];
}

- (void)getAllUnit
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"ShopApi/getAllCategoryUnit" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            weak_self.tagArray = resultDic[@"params"];
            
            if(weak_self.unitView)
            {
                weak_self.unitView.delegate = nil;
                [weak_self.unitView removeFromSuperview];
            }
            weak_self.unitView = [[UnitView alloc] initWithFrame:CGRectMake(0, 0-kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) title:@"" tagArr:self.tagArray];
            weak_self.unitView.delegate = self;
            [weak_self.view addSubview:weak_self.unitView];
            [weak_self.unitView setDefaultSelected:weak_self.modelData.unitPrice];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}



#pragma mark ------------ 编辑模板 根据模板ID
- (void)updateTemplateById:(SetExpressModel *)model
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
       for (int a=0;a<model.expressDetailArray.count;a++) {
           SetExpressDetailModel *dicModel = model.expressDetailArray[a];
           NSString *str = [(NSArray  *)dicModel.areaArray componentsJoinedByString:@"_"];
           [array addObject:@{@"area":str,@"freightFirst":dicModel.default_price,@"freightInc":dicModel.add_price,@"weightFirst":dicModel.default_weight,@"weightInc":dicModel.add_weight}];
       }
    
        WEAK_SELF
    int _tid = model.tId;
    NSDictionary *param = @{@"id":[NSNumber numberWithInt:_tid],@"name":model.templateName,@"unit":model.unitPrice,@"freightInfoVos":array};
     
           
        [self showHub];
        [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"ShopApi/updateFreightTemplate" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                [weak_self showSuccessInfoWithStatus:@"新建模板成功"];
                [self.delegate expressTemplateChanged:weak_self.modelData];
                [self goBack];

            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }

        }];
}


#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
#pragma mark ------------------- 弹出计费单位的选择框
- (void)showPriceUnit:(id)sneder
{
    [self.view endEditing:YES];
    [self getAllUnit];
}

#pragma mark ------------------- 弹出地区选择的选择框
- (void)selectedBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.activeRow = (int)btn.superview.tag; //得到点击的哪一行
    
    //得到所有已经选了的地址
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i=0;i<self.modelData.expressDetailArray.count;i++)
    {
        SetExpressDetailModel *dm = [self.modelData.expressDetailArray objectAtIndex:i];
        
        if(dm.areaArray.count > 0 && i!=self.activeRow-200)
        {
            NSArray *strArr = [[dm.areaArray objectAtIndex:0] componentsSeparatedByString:@"_"];
            for(int j=0;j<strArr.count;j++)
            {
                [arr addObject:[[strArr objectAtIndex:j] mutableCopy]];
            }
        }
        
        
        
    }
    
    
    NSArray *self_arry = [[NSArray alloc] init];
    if(self.modelData.templateName != nil)
    {
        SetExpressDetailModel *m = [self.modelData.expressDetailArray objectAtIndex:self.activeRow-200];
        if(m.areaArray.count > 0)
        {
            NSString *areaStr = [m.areaArray objectAtIndex:0];
            self_arry = [areaStr componentsSeparatedByString:@"_"];
        }
    }
    
    if(self.pView)
    {
        [self.pView removeFromSuperview];
    }
    
    BOOL flag = NO;
    if(self_arry.count > 0 && [self_arry[0] rangeOfString:@"请"].location == NSNotFound)
    {
        flag = YES;
    }
    
    self.pView = [[SelectedProvinceView alloc] initWithFrame:CGRectMake(0, -55, kScreenWidth, kScreenHeight) usedArray:arr isEidt:flag EditArray:self_arry];
    self.pView.delegate = self;
    [self.view addSubview:self.pView];
}

#pragma mark ------------------- 删除某一个模板
- (void)closeBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = (int)btn.superview.tag - 200;
    [self.modelData.expressDetailArray removeObjectAtIndex:index];
    [self drawTemplateRowView];
}

#pragma mark ------------------- 新建模板
-(void)newBtnClicked:(id)sender
{
    SetExpressDetailModel *dm = [[SetExpressDetailModel alloc] init];
    [self.modelData.expressDetailArray addObject:dm];
    dm.areaArray = [[NSMutableArray alloc] initWithObjects:@"请选择地区 >", nil];
    [self drawTemplateRowView];
}

#pragma mark ------------------- 确定按钮点击
- (void)btnClicked:(id)sender
{
    UITextField *namefiled = [self.rowview_1 viewWithTag:3]; //得到名称
    self.modelData.templateName = namefiled.text;
    
    if(self.modelData.templateName.length < 1 || self.modelData.unitPrice.length < 1)
    {
        [self showMessage:@"所有参数均需填写"];
        return;
    }
    NSMutableArray *arr = self.modelData.expressDetailArray;
    for(int i=0;i<arr.count;i++)
    {
        SetExpressDetailModel *dm = [arr objectAtIndex:i];
        if(dm.add_price.length < 1 || dm.add_weight.length < 1 ||
           dm.default_price.length < 1 || dm.default_weight.length < 1)
        {
            [self showMessage:@"所有参数均需填写"];
            return;
        }
        if(dm.areaArray.count == 1 &&
           [[dm.areaArray objectAtIndex:0] rangeOfString:@"请选择"].location != NSNotFound)
        {
            [self showMessage:@"所有参数均需填写"];
            return;
        }
    }
    
    if(self.modelData.tId == -1) //说明是新建
    {
        [self postTemplateData:self.modelData];
    }
    else    //说明是编辑
    {
        [self updateTemplateById:self.modelData];
    }

}


- (void)filed1TextChanged:(id)sender
{
    UITextField *fd = (UITextField *)sender;
    int tag = (int)fd.superview.tag;
    int dataIndex = (int)fd.superview.superview.tag;
    SetExpressDetailModel *dm = [self.modelData.expressDetailArray objectAtIndex:dataIndex-200];
    if(tag == 88)        //首重
    {
        dm.default_weight = fd.text;
    }
    else if(tag == 99)   //每增加
    {
        dm.add_weight = fd.text;
    }
}

- (void)filed2TextChanged:(id)sender
{
    UITextField *fd = (UITextField *)sender;
    int tag = (int)fd.superview.tag;
    int dataIndex = (int)fd.superview.superview.tag;
    SetExpressDetailModel *dm = [self.modelData.expressDetailArray objectAtIndex:dataIndex-200];
    if(tag == 88)        //首重
    {
        dm.default_price = fd.text;
    }
    else if(tag == 99)   //每增加
    {
        dm.add_price = fd.text;
    }
}



#pragma mark ------------------------Delegate-----------------------------
#pragma mark -------------------- 选择计量单位
- (void)confirmInfo:(int)selectedIndex
{
    [self.unitView removeFromSuperview];
    self.unitView.delegate = nil;
    
    UITextField *filed = [self.rowview_2 viewWithTag:3];
    filed.text = [self.tagArray objectAtIndex:selectedIndex];
    
    self.modelData.unitPrice = filed.text;
    
}

#pragma mark -------------------- 选中省份代理  parray即选中省份名称数组
- (void)confirmProvice:(NSArray *)parray
{
    NSArray *tempArr = [[NSArray alloc] initWithObjects:[parray componentsJoinedByString:@"_"], nil];
    
    UIButton *tempBtn = [[self.bgscrollview viewWithTag:self.activeRow] viewWithTag:111];
    
    NSString *str = [self getProviceString:tempArr];
    [tempBtn setTitle:str forState:UIControlStateNormal];
    
    SetExpressDetailModel *dm = [self.modelData.expressDetailArray objectAtIndex:self.activeRow-200];
    
    NSString *parrStr = [parray componentsJoinedByString:@"_"];
    dm.areaArray = [[NSMutableArray alloc] initWithObjects:parrStr,nil];
    
    NSLog(@"选中的省份数 = %d",(int)parray.count);
}


- (NSString *)getProviceString:(NSArray *)parr
{
    if(parr.count == 0)
        return nil;
    if([[parr objectAtIndex:0] rangeOfString:@"_"].location == NSNotFound)
    {
        return [parr objectAtIndex:0];
    }
    NSArray *parray = [[parr objectAtIndex:0] componentsSeparatedByString:@"_"];
    if(parray.count > 3)
    {
        NSString *str = [NSString stringWithFormat:@"%@、%@、%@等%d个省市 >",parray[0],parray[1],parray[2],(int)parray.count];
        return str;
    }
    else
    {
        NSString *str;
        if(parray.count == 1)
            str = [NSString stringWithFormat:@"%@ >",parray[0]];
        else if(parray.count == 2)
            str = [NSString stringWithFormat:@"%@、%@ >",parray[0],parray[1]];
        else if(parray.count == 3)
            str = [NSString stringWithFormat:@"%@、%@、%@ >",parray[0],parray[1],parray[2]];
        return str;
    }
    return @"";
}



#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------




@end
