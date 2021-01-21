//
//  AddBCardViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AddBCardViewController.h"
#import "BankCardListViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "MeViewController.h"

@interface AddBCardViewController ()

@property (nonatomic, strong) UIButton *goBtn;
@property (nonatomic, assign) BOOL      isCheck;

@property (nonatomic, strong) UIView *rowView_1;
@property (nonatomic, strong) UIView *rowView_2;
@property (nonatomic, strong) UIView *rowView_3;
@property (nonatomic, strong) UIView *rowView_4;

@property (nonatomic, strong) UIViewController * baiduVc;
@property (nonatomic, strong) NSString *bankCardString;   //识别到的银行卡号
@property (nonatomic, strong) NSString *bankBaseString;   //识别到该卡是哪家银行
@property (nonatomic, strong) NSString *banTypeString;    //识别到的银行卡类型 1-借记卡 2-信用卡

@property (nonatomic, strong) NSString *phoneString;      //电话号码

@end

@implementation AddBCardViewController
{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"填写银行卡信息";
    self.isCheck = NO;
    
    self.bankCardString = @"";
    self.bankBaseString = @"";
    self.banTypeString  = @"";
    
    [self _initMsgView];
    [self _initBottumView];
    
    
    // 授权百度SDK： 下载授权文件，添加至资源
    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    if(!licenseFileData) {
//        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];
    
    
    [self configCallback];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initMsgView
{
    UILabel *lab1 = [[UILabel alloc] init];
    [self.view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(55);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(20);
    }];
    lab1.text = @"添加银行卡";
    lab1.font = [UIFont boldSystemFontOfSize:20];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.textColor = UIColorFromRGB(0x111111);
    
    UILabel *lab2 = [[UILabel alloc] init];
    [self.view addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(20);
    }];
    lab2.text = @"请绑定持卡人本人银行卡";
    lab2.font = [UIFont systemFontOfSize:14];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.textColor = UIColorFromRGB(0x111111);
    
    self.rowView_1 = [self customRowView:CGRectMake(0, 0, kScreenWidth, 53)
                                   title:@"持卡人"
                                 content:[UserModel sharedInstance].truename
                          contentDefault:@""
                                    icon:@"bc_infoicon"
                                     tag:1];
    self.rowView_2 = [self customRowView:CGRectMake(0, 0, kScreenWidth, 53)
                                   title:@"卡号"
                                 content:@""
                          contentDefault:@"请输入银行卡号"
                                    icon:@"bc_camreicon"
                                     tag:2];
    self.rowView_3 = [self customRowView:CGRectMake(0, 0, kScreenWidth, 53)
                                   title:@"卡类型"
                                 content:@""
                          contentDefault:@"卡的类型"
                                    icon:@""
                                     tag:3];
    self.rowView_4 = [self customRowView:CGRectMake(0, 0, kScreenWidth, 53)
                                   title:@"手机号"
                                 content:@""
                          contentDefault:@"请输入银行预留手机号"
                                    icon:@"bc_infoicon"
                                     tag:4];
    [self.view addSubview:self.rowView_1];
    [self.view addSubview:self.rowView_2];
    [self.view addSubview:self.rowView_3];
    [self.view addSubview:self.rowView_4];
    [self.rowView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(55);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(53);
    }];
    [self.rowView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rowView_1.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(53);
    }];
    [self.rowView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rowView_2.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(53);
    }];
    [self.rowView_4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rowView_3.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(53);
    }];
    
    [self.rowView_1 viewWithTag:11].userInteractionEnabled = NO;
    [self.rowView_2 viewWithTag:11].userInteractionEnabled = NO;
    [self.rowView_3 viewWithTag:11].userInteractionEnabled = NO;
    
    self.rowView_3.hidden = YES;
    self.rowView_4.hidden = YES;
}

- (void)_initBottumView
{
    //用户协议
    UIButton *docBtn = [[UIButton alloc] init];
    [self.view addSubview:docBtn];
    [docBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-120);
        make.centerX.equalTo(self.view.mas_centerX).offset(0).offset(15);
        make.height.mas_equalTo(13);
        make.width.mas_equalTo(120);
    }];
    
    NSString * connectStr = @"同意《用户协议》";
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",connectStr]];
    [tempstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,connectStr.length)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:kGetColor(0x9a, 0x9a, 0x9a) range:NSMakeRange(0,2)];
    [tempstr addAttribute:NSForegroundColorAttributeName value:KCOLOR_Main range:NSMakeRange(2,connectStr.length-2)];
    [docBtn setAttributedTitle:tempstr forState:UIControlStateNormal];
    [docBtn addTarget:self action:@selector(docBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //勾选用户协议
    UIButton *checkBtn = [[UIButton alloc] init];
    [self.view addSubview:checkBtn];
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(docBtn.mas_left).offset(0);
        make.centerY.equalTo(docBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(35);
    }];
    [checkBtn setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    [checkBtn addTarget:self
                 action:@selector(checkBtnClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    
    //开始认证
    self.goBtn = [[UIButton alloc] init];
    self.goBtn.alpha = 0.5;
    self.goBtn.userInteractionEnabled = NO;
    [self.view addSubview:self.goBtn];
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-35);
        make.left.equalTo(self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.goBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"下一步"
            fontsize:16
              corner:22
                 tag:2];
}
 
#pragma mark ------------------------Private------------------------------
- (UIView *)customRowView:(CGRect)frame title:(NSString *)title content:(NSString *)cont contentDefault:(NSString *)contdef icon:(NSString *)iconstring tag:(int)tag
{
    UIView *rowview = [[UIView alloc] initWithFrame:frame];
    rowview.tag = tag;
    
    UILabel *lab1 = [[UILabel alloc] init];
    [rowview addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rowview.mas_centerY).offset(0);
        make.left.equalTo(rowview.mas_left).offset(30);
        make.height.mas_equalTo(15);
    }];
    lab1.tag = 10;
    lab1.text = title;
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.textColor = UIColorFromRGB(0x333333);
    
    UITextField *filed = [[UITextField alloc] init];
    [rowview addSubview:filed];
    [filed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rowview.mas_centerY).offset(0);
        make.left.equalTo(rowview.mas_left).offset(106);
        make.right.equalTo(rowview.mas_right).offset(-88);
        make.height.mas_equalTo(13);
    }];
    [filed addTarget:self action:@selector(filedTextChanged:) forControlEvents:UIControlEventEditingChanged];
    filed.tag = 11;
    filed.textAlignment = UITextLayoutDirectionLeft;
    filed.textColor = UIColorFromRGB(0x333333);
    filed.font = CUSTOMFONT(14);
    if(cont.length > 0)
        filed.text = cont;
    else
        filed.placeholder = contdef;
    if(tag == 2)
    {
        filed.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if(iconstring.length > 0)
    {
        UIButton *iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rowview addSubview:iconbtn];
        [iconbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(rowview.mas_centerY).offset(0);
            make.right.equalTo(rowview.mas_right).offset(-30);
            make.height.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        iconbtn.tag = 12;
        [iconbtn setImage:IMAGE(iconstring) forState:UIControlStateNormal];
        [iconbtn addTarget:self action:@selector(iconbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = [UIColor lightGrayColor];
    lineview.alpha = 0.3;
    [rowview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rowview.mas_bottom).offset(-1.5);
        make.left.equalTo(rowview.mas_left).offset(30);
        make.right.equalTo(rowview.mas_right).offset(-30);
        make.height.mas_equalTo(0.5);
    }];
    [rowview addSubview:lineview];
    
    
    return rowview;
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
- (void)filedTextChanged:(id)sender
{
    
}

#pragma mark ---- 每一行右侧小图标按钮
- (void)iconbtnClicked:(UIButton *)sender
{
    switch (sender.superview.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            self.baiduVc =
                    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                                 andImageHandler:^(UIImage *image) {

                                                     [[AipOcrService shardService] detectBankCardFromImage:image
                                                                                            successHandler:_successHandler
                                                                                               failHandler:_failHandler];

                                                 }];
            self.baiduVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self listSubviewsOfView:self.baiduVc.view];
            });            
            [self presentViewController:self.baiduVc animated:YES completion:nil];
        }
            break;
        case 4:
        {
            
        }
            break;
            
        default:
            break;
    }
}


- (void)listSubviewsOfView:(UIView *)view
{
    // Get the subviews of the view
    NSArray *subviews = [view subviews];
    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
    for (UIView *subview in subviews) {
        // Do what you want to do with the subview
        NSLog(@"--- %@", subview);
        if([subview isKindOfClass:[UINavigationBar class]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [subview removeFromSuperview];
            });
        }
        if([subview isKindOfClass:[UIImageView class]])
        {
            UIImageView *iv = (UIImageView *)subview;
            if((int)iv.frame.size.height == (int)iv.frame.size.height &&
               (int)iv.frame.size.height == 31)
            {
                iv.frame = CGRectMake(0, 15, 31, 31);
            }
        }
        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}


- (void)didCancelClick
{
    [self.baiduVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---- 用户协议按钮
- (void)docBtnClicked:(UIButton *)sender
{
    
}

#pragma mark ---- 下一步
- (void)btnClicked:(UIButton *)sender
{
    UITextField *phonefiled = [self.rowView_4 viewWithTag:11];
    if(self.bankCardString.length == 0 || phonefiled.text == 0)
    {
        [self showMessage:@"信息不能为空"];
    }
    else
    {
        self.phoneString = phonefiled.text;
        [self requstDetectInfo:self.phoneString carNo:self.bankCardString];
    }
}

#pragma mark ---- 勾选图标
- (void)checkBtnClicked:(UIButton *)sender
{
    if(self.isCheck)
    {
        self.goBtn.userInteractionEnabled = NO;
        self.goBtn.alpha = 0.5;
        [sender setImage:IMAGE(@"storeunselectedicon") forState:UIControlStateNormal];
    }
    else
    {
        self.goBtn.userInteractionEnabled = YES;
        self.goBtn.alpha = 1;
        [sender setImage:IMAGE(@"storeselectedicon") forState:UIControlStateNormal];
    }
    self.isCheck = !self.isCheck;
}

#pragma mark ------------------------Delegate-----------------------------
- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        
        weakSelf.bankCardString = result[@"result"][@"bank_card_number"];
        weakSelf.bankBaseString = result[@"result"][@"bank_name"];
        
        NSString *str = result[@"result"][@"bank_card_type"];
        if([str intValue] == 1)
            weakSelf.banTypeString = @"借记卡";
        else if([str intValue] == 2)
            weakSelf.banTypeString = @"信用卡";
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{

            ((UITextField *)[weakSelf.rowView_2 viewWithTag:11]).text = weakSelf.bankCardString;
            ((UITextField *)[weakSelf.rowView_3 viewWithTag:11]).text = weakSelf.bankBaseString;
            weakSelf.rowView_3.hidden = NO;
            weakSelf.rowView_4.hidden = NO;
            [weakSelf.baiduVc dismissViewControllerAnimated:YES completion:nil];
        }];
                
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
//        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"银行卡识别失败" message:@"请再次尝试" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            [weakSelf.baiduVc dismissViewControllerAnimated:YES completion:nil];
        }];
    };
}

- (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


#pragma mark ------------------------Api----------------------------------
- (void)requstDetectInfo:(NSString *)phone carNo:(NSString *)cardstring
{
    cardstring = [self removeSpaceAndNewline:cardstring];
    UITextField *phonefiled = [self.rowView_4 viewWithTag:11];
        
    
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postBodyParameters:@{
                @"accid"    :[UserModel sharedInstance].userId,
                @"bankName" :self.bankBaseString,
                @"cardNo"   :cardstring,
                @"mobile"   :phonefiled.text,
                @"userName" :[UserModel sharedInstance].truename,
                @"bankType" :self.banTypeString
    } subUrl:@"UserApi/bindBankCard" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue] == -200)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                for(UIViewController*temp in self.navigationController.viewControllers) {
                    if([temp isKindOfClass:[MeViewController class]])
                    {
                        [self.navigationController popToViewController:temp animated:NO];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCardSuceess" object:nil];
                        break;
                    }
                }
            });        
        }
        else
        {
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------



@end
