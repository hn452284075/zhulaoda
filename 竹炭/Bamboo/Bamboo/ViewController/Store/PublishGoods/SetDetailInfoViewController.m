//
//  SetDetailInfoViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetDetailInfoViewController.h"
#import "UIBarButtonItem+BarButtonItem.h"

@interface SetDetailInfoViewController ()

@property (nonatomic, strong) UITextView    *textview;

@end

@implementation SetDetailInfoViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"详情介绍";
    
    UIBarButtonItem *rightItem = [UIBarButtonItem initWithTitle:@"保存"
                                                     titleColor:UIColorFromRGB(0x47c67c)
                                                      titleSize:14
                                                         target:self
                                                         action:@selector(saveFucntion:)];
    
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem barButtonItemSpace:-10],rightItem];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    
    self.textview = [[UITextView alloc] init];
    [self.view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(188);
    }];
    self.textview.textColor = UIColorFromRGB(0x9a9a9a);
    self.textview.font = CUSTOMFONT(14);
    self.textview.backgroundColor = [UIColor whiteColor];
    if (!isEmpty(self.desc)) {
        self.textview.text=self.desc;
    }else{
        UILabel *placeHolderLabel = [[UILabel alloc] init];
           placeHolderLabel.text = @"如：供应特色、种养殖情况、供应量或包装及杂费情况等，更详细、准确的描述能吸引更多的采购商";
           placeHolderLabel.numberOfLines = 1;
           placeHolderLabel.textColor = [UIColor lightGrayColor];
           [placeHolderLabel sizeToFit];
           [self.textview addSubview:placeHolderLabel];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [self.textview setValue:placeHolderLabel forKey:@"_placeholderLabel"];

    }
   
    
    self.textview.font = [UIFont systemFontOfSize:14.f];
}


- (void)saveFucntion:(id)sender
{
    [self.delegate detailInfoMsg:self.textview.text];
    [self goBack];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
