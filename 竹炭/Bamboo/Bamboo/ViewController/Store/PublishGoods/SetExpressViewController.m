//
//  SetExpressViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetExpressViewController.h"
#import "SetExpressModel.h"
#import "SetExpressDetailModel.h"
#import "NewETViewController.h"

@interface SetExpressViewController ()<NewETDelegate>

@property (nonatomic, strong) UIScrollView  *bgscrollview;
@property (nonatomic, strong) UIView        *topView;         //物流方式
@property (nonatomic, strong) UIView        *templateView;    //运费模板
@property (nonatomic, strong) UIButton      *okBtn;

@property (nonatomic, strong) NSString      *expressString;   //选择的物流方式
@property (nonatomic, assign) int           expressIndex;     //选择的物流模板索引

@property (nonatomic, strong) NSMutableDictionary *testDic;

@end

@implementation SetExpressViewController
@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"物流设置";
    self.expressString = @"整车";
    self.expressIndex  = -1;
    
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
    self.view.backgroundColor = kGetColor(0xf7, 0xf7, 0xf7);
    
    //测试数据
    self.testDic = [[NSMutableDictionary alloc] init];
    
    [self _initTopView];
    [self _initTemplateView];
    
    [self drawTemplateRowView];
    
    self.okBtn = [[UIButton alloc] init];
    [self.view addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
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
                 tag:713];
    
    [self getAllFreightTemplate];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initTopView
{
    self.topView = [[UIView alloc] init];
    [self.bgscrollview addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgscrollview.mas_top).offset(14);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.height.mas_offset(155);
    }];
    self.topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    [self.topView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(20);
        make.left.equalTo(self.topView.mas_left).offset(15);
        make.right.equalTo(self.topView.mas_right).offset(-14);
        make.height.mas_offset(15);
    }];
    lab.text = @"物流方式";
    lab.font = CUSTOMFONT(14);
    lab.textColor = UIColorFromRGB(0x999999);
    lab.textAlignment = NSTextAlignmentLeft;
    
    NSArray *valueArray = [[NSArray alloc] initWithObjects:@"整车",@"快递",@"物流专线",@"空运",@"航运",@"其它", nil];
    
    NSMutableArray *tagBtnArray = [[NSMutableArray alloc] init];
    for(int j=0;j<valueArray.count;j++)
    {
        UIButton *btn = [self factory_btn:kGetColor(0xf5, 0xf5, 0xf5)
          textColor:kGetColor(0x22, 0x22, 0x22)
        borderColor:kGetColor(0xf5, 0xf5, 0xf5)
              title:[valueArray objectAtIndex:j]
           fontsize:14
             corner:15
                tag:2];
        btn.tag = j;
        [tagBtnArray addObject:btn];
        [self.topView addSubview:btn];
        if(j == 0)
        {
            [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }
                    
    //水平方向宽度固定等间隔
    int x = 15;
    int y = 50;
    int w = (kScreenWidth-2*15-2*15-2*10)/3;
    int h = 31;
    int row = (int)tagBtnArray.count / 3;
    if(tagBtnArray.count % 3 != 0)
        row +=1;
    for(int i=0;i<row;i++)
    {
        int temp = 0;
        for(int j=3*i;j<tagBtnArray.count;j++)
        {
            UIButton *_btn = [tagBtnArray objectAtIndex:j];
            _btn.frame = CGRectMake(x+10*temp+w*temp++, y+h*i, w, h);
            if(temp > 3)
            {
                y = y+15;
                break;
            }
        }
    }
}

- (void)_initTemplateView
{
    self.templateView = [[UIView alloc] init];
    [self.bgscrollview addSubview:self.templateView];
    [self.templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-kStatusBarAndTabBarHeight*1.5);
    }];
    self.templateView.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc] init];
    [self.templateView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.templateView.mas_top).offset(20);
        make.left.equalTo(self.templateView.mas_left).offset(15);
        make.right.equalTo(self.templateView.mas_right).offset(-14);
        make.height.mas_offset(15);
    }];
    lab.text = @"运费模板";
    lab.font = CUSTOMFONT(14);
    lab.textColor = UIColorFromRGB(0x999999);
    lab.textAlignment = NSTextAlignmentLeft;
    
    //新建模板
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setImage:IMAGE(@"storenewtemplateicon") forState:UIControlStateNormal];
    [newBtn setTitle:@"新建模板" forState:UIControlStateNormal];
    [newBtn setTitleColor:KCOLOR_Main forState:UIControlStateNormal];
    [newBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    newBtn.titleLabel.font= CUSTOMFONT(12);
    [self.templateView addSubview:newBtn];
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab.mas_centerY).offset(0);
        make.right.equalTo(self.templateView.mas_right).offset(-15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    [newBtn setBackgroundColor:[UIColor clearColor]];
    [newBtn addTarget:self action:@selector(newBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (UIView *)getTemplateRowView:(SetExpressModel *)em viewTag:(int)tag
{
    UIView *rowbgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 80)];
    rowbgv.tag = tag;
    UIButton *selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rowbgv addSubview:selectedBtn];
    [selectedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rowbgv.mas_top).offset(15);
        make.left.equalTo(rowbgv.mas_left).offset(15);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    selectedBtn.tag = 1;
    [selectedBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *namelab = [[UILabel alloc] init];
    [rowbgv addSubview:namelab];
    [namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectedBtn.mas_centerY);
        make.left.equalTo(selectedBtn.mas_right).offset(-2);
        make.right.equalTo(rowbgv.mas_right).offset(-14);
        make.height.mas_offset(15);
    }];
    namelab.text = em.templateName;
    namelab.font = CUSTOMFONT(14);
    namelab.textColor = UIColorFromRGB(0x222222);
    namelab.textAlignment = NSTextAlignmentLeft;
    
    UILabel *msglab = [[UILabel alloc] init];
    [rowbgv addSubview:msglab];
    [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namelab.mas_bottom).offset(10);
        make.left.equalTo(selectedBtn.mas_right).offset(0);
        make.right.equalTo(rowbgv.mas_right).offset(-14);
        make.height.mas_offset(40);
    }];
    msglab.numberOfLines = 0;
    msglab.lineBreakMode = NSLineBreakByCharWrapping;
    
    msglab.font = CUSTOMFONT(12);
    msglab.textColor = UIColorFromRGB(0x999999);
    msglab.textAlignment = NSTextAlignmentLeft;
    
    if(em.expressDetailArray.count > 0)
    {
        SetExpressDetailModel *_dm = [em.expressDetailArray firstObject];
        
        if(_dm.areaArray.count == 0)
            return rowbgv;
        NSString *tmpAddrArr = _dm.areaArray[0];
        
        NSArray *_areaarr = _dm.areaArray;
        if([tmpAddrArr rangeOfString:@"_"].location != NSNotFound)
        {
            _areaarr = [tmpAddrArr componentsSeparatedByString:@"_"];
        }
        
        
        NSString *areastr = _areaarr[0];
        if(_areaarr.count < 3)
        {
            for(int i=1;i<_areaarr.count;i++)
            {
                areastr = [NSString stringWithFormat:@"%@、%@",areastr,_areaarr[i]];
            }
        }
        else
        {
            for(int i=1;i<3;i++)
            {
                areastr = [NSString stringWithFormat:@"%@、%@",areastr,_areaarr[i]];
            }
            areastr = [NSString stringWithFormat:@"%@等%d省市",areastr,(int)_areaarr.count];
        }
        NSString *_pricestr = [NSString stringWithFormat:@"首重%@公斤内%@元，续重每%@公斤%@元",_dm.default_weight,_dm.default_price,_dm.add_weight,_dm.add_price];
        msglab.text = [NSString stringWithFormat:@"%@:%@",areastr,_pricestr];
    }
    return rowbgv;
}
 
#pragma mark ------------------------Private------------------------------
 - (UIButton *)factory_btn:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                 tag:(int)tag;
 {
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.backgroundColor = bcolor;
     btn.layer.borderColor = dcolor.CGColor;
     [btn setTitleColor:tcolor forState:UIControlStateNormal];
     btn.layer.borderWidth = 1.;
     btn.layer.cornerRadius = csize;
     btn.titleLabel.font = CUSTOMFONT(fsize);
     [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
     [btn setTitle:title forState:UIControlStateNormal];
     btn.tag = tag;
     return btn;
 }

- (void)drawTemplateRowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(UIView *v in self.templateView.subviews)
        {
            if(v.tag > 99)
                [v removeFromSuperview];
        }
    
        NSArray *allkeys = [self.testDic allKeys];
        self.bgscrollview.contentSize = CGSizeMake(kScreenWidth, allkeys.count*80+100+200);
        int y = 60;
        for(int i=0;i<allkeys.count;i++)
        {
            SetExpressModel *_em = [self.testDic objectForKey:allkeys[i]];
            UIView *emView = [self getTemplateRowView:_em viewTag:100+i];
            [self.templateView addSubview:emView];
            emView.frame = CGRectMake(0, y+80*i, kScreenWidth-30, 80);
        }
        
    });
//    int h = 0;
//    if(allkeys.count*80+100+200 > kScreenHeight-self.templateView.frame.origin.y)
//        h=kScreenHeight-self.templateView.frame.origin.y;
//    else
//        h = (int)allkeys.count*80+100+200;
//    self.templateView.frame = CGRectMake(self.templateView.frame.origin.x, self.templateView.frame.origin.y, self.templateView.frame.size.width, h);
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
//获取所有运费模板

-(void)getAllFreightTemplate{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"ShopApi/getAllFreightTemplate" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            NSArray *arr = resultDic[@"params"];
            for (int a=0; a<arr.count; a++) {
                NSMutableArray *infoArr=[[NSMutableArray alloc]init];
                NSDictionary *dic = arr[a];
                SetExpressModel *exModel = [[SetExpressModel alloc]init];
                exModel.templateName = dic[@"freightTemplateName"];
                exModel.unitPrice = dic[@"freightTemplateUnit"];
                for (NSDictionary *detailsDic in dic[@"freightInfoVos"]) {
                    SetExpressDetailModel *dicModel = [[SetExpressDetailModel alloc]init];
                    dicModel.default_price= [NSString stringWithFormat:@"%d",[detailsDic[@"freightFirst"] intValue]];
                    dicModel.add_price= [NSString stringWithFormat:@"%d",[detailsDic[@"freightInc"] intValue]];
                    dicModel.default_weight= [NSString stringWithFormat:@"%d",[detailsDic[@"weightFirst"] intValue]];
                    dicModel.add_weight= [NSString stringWithFormat:@"%d",[detailsDic[@"weightInc"] intValue]];
                    dicModel.areaArray =[NSMutableArray arrayWithObject:detailsDic[@"area"]];
                    [infoArr addObject:dicModel];
                }
                exModel.expressDetailArray=infoArr;
                
                [self.testDic setValue:exModel forKey:dic[@"freightTemplateName"]];
                
            }
            [self drawTemplateRowView];
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 713)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (UIView *view in self.topView.subviews) {
            if([view isKindOfClass:[UIButton class]]){
                    UIButton *button=(UIButton *)view;
                    if (button.selected) {
                        [arr addObject:button.titleLabel.text];
                    }
                }
            
        }
        if (!isEmpty(arr)) {
            if (arr.count==1) {
                self.expressString =arr[0];
            }else{
                self.expressString = [arr componentsJoinedByString:@","];
            }
        }else{
            [self showMessage:@"请选择物流方式"];
            return;
        }
        
        if(self.expressIndex == -1)//没有选择运费模板
        {
            [self.delegate confirmExpressInfo:self.expressString name:@"运费待商议" moduleId:0];
        }else{
            NSString *keystring = [[self.testDic allKeys] objectAtIndex:self.expressIndex];
            SetExpressModel *em = [self.testDic objectForKey:keystring];
            [self.delegate confirmExpressInfo:self.expressString name:em.templateName moduleId:self.expressIndex];
        }
        [self goBack];
    }
    else
    {

        btn.selected=!btn.selected;
        if (btn.selected) {
           btn.backgroundColor = kGetColor(0xff, 0xff, 0xff);
           btn.layer.borderColor = KCOLOR_Main.CGColor;
           [btn setTitleColor:KCOLOR_Main forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
            btn.layer.borderColor = kGetColor(0xf5, 0xf5, 0xf5).CGColor;
            [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
        }
       
    }
    
}


#pragma mark ----------------- 新建模板
- (void)newBtnClicked:(id)sender
{
    SetExpressModel *em = [[SetExpressModel alloc] init];
    NewETViewController *vc = [[NewETViewController alloc] init];
    vc.modelData = em;
    vc.delegate = self;
    em.expressDetailArray = [[NSMutableArray alloc] init];
    [self navigatePushViewController:vc animate:YES];
}

#pragma mark ----------------- 选中的模板
- (void)selectedBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = -1;
    for(UIView *vv in self.templateView.subviews)
    {
        if([vv isKindOfClass:[UIView class]] && vv.tag>99)
        {
            UIButton *_btn = (UIButton *)[vv viewWithTag:1];
            [_btn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
            if(btn == _btn)
            {
                index = (int)vv.tag - 100;
            }
        }
    }
    [btn setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
    self.expressIndex = index;
    NSLog(@"选中的模板索引 = %d",index);
}


#pragma mark ------------------------Delegate-----------------------------
- (void)expressTemplateChanged:(SetExpressModel *)em
{
    if(em.templateName.length > 0)
    {
        [self.testDic setValue:em forKey:em.templateName];
    }
    [self drawTemplateRowView];
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------




@end
