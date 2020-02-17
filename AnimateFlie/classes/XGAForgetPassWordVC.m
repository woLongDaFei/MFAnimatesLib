//
//  XGAForgetPassWordVC.m
//  GcwClient
//
//  Created by wenbo. on 15/11/22.
//  Copyright (c) 2015年 wenbo. All rights reserved.
//

#import "XGAForgetPassWordVC.h"
#import "XGATableView.h"
#import "QPayTextField.h"
#import "ApplyUI_For_XGATabelView.h"
#import "UIView+XGA.h"
#import "XGAUserNetOBJ.h"
#import "XGAVcodeButton.h"


@interface XGAForgetPassWordVC()<XGANetWorkCenter_delegate,XGAVcodeButton_dataSourse>
@property (strong,nonatomic)UIButton * bottombutton;
@property (strong, nonatomic)UIButton * sendCodeButton;   //获取验证码button
@end

@implementation XGAForgetPassWordVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"找回密码";
    self.view.backgroundColor = AppNormalColor;
    
    [self.view addSubview:self.tableView];
    self.tableView.needData = [self needData];
    [self.tableView reloadData];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, self.bottombutton.bottom+30)];
    [view addSubview:self.bottombutton];
    self.tableView.tableFooterView = view;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#define kInputKey_oldkeyFirst @"oldkeyFirst"
#define kInputKey_newKeyFirst @"newKeyFirst"
#define kInputKey_newKeysecand @"newKeysecand"

#define kNetKey_ForgetPw @"uc/findpsw.json"
- (void)touchGO{
    NSString * phone = [self.userInputDic objectForKey:kInputKey_oldkeyFirst];
    NSString * vcode = [self.userInputDic objectForKey:kInputKey_newKeyFirst];
    NSString * password = [self.userInputDic objectForKey:kInputKey_newKeysecand];
    if (phone.length < 11) {
        [XGAPrompt_System pushPromptMessages:@"手机号码长度错误" afterDelay:1.f];
        return;
    }
    NSDictionary * dic = @{
                           @"phone":phone,
                           @"vcode":vcode,
                           @"newpwd":password,
                           };
    [[XGANetWorkCenter sharedCenter]startNetWithCode:kNetKey_ForgetPw andDic:dic andDelegate:self withIsShowMassage:YES];
}

- (void)apiNetworkDidSuccessWithData:(NSDictionary *)data fromCode:(NSString *)code andExt:(id)ext{
    if (data) {
        [XGAPrompt_System pushPromptMessages:@"找回成功" afterDelay:1.0];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)apiNetworkDidFailWithData:(id)data fromCode:(NSString *)code andExt:(id)ext andCode:(id)state{
    NSString * resultStr = @"网络请求失败";
    if ([data isKindOfClass:[NSString class]]) {
        resultStr = data;
    }
    [XGAPrompt_System pushPromptMessages:resultStr afterDelay:1.f];
}


#pragma mark - getter
- (UIButton *)bottombutton{
    if (!_bottombutton) {
        _bottombutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottombutton.frame = CGRectMake(20, 40, self.view.bounds.size.width - 2*20, 44);
        [_bottombutton setRundWithFloat:5.0f];
        [_bottombutton setTitle:@"提交" forState:UIControlStateNormal];
        [_bottombutton setBackgroundImage:[UIImage ImageWithUIColor:kColor_1_red WithSize:_bottombutton.bounds.size] forState:UIControlStateNormal];
        [_bottombutton addTarget:self action:@selector(touchGO) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottombutton;
}

- (NSArray *)needData{
    NSMutableArray * muArray = [[NSMutableArray alloc]init];
    
    XGACellItemData_field * field1 = [self getOneData_field];
    field1.cellHeaderHight = 10;
    field1.LabelTitle = @"手机号";
    field1.placeHoldText = @"请输入手机号";
    field1.cellFootHight = 10;
    
    QNPCellItem_editDataField * fielddata = [[QNPCellItem_editDataField alloc]init];
    fielddata.maxLenth = 11;
    fielddata.keyboardType = UIKeyboardTypeNumberPad;
    field1.editData = fielddata;
    field1.key = kInputKey_oldkeyFirst;
    [muArray addObject:field1];
    
    XGACellItemData_field * field2 = [self getOneData_field];
    field2.LabelTitle = @"验证码";
    field2.placeHoldText = @"请输入验证码";
    field2.rightView = self.sendCodeButton;
    [muArray addObject:field2];
    
    QNPCellItem_editDataField * fielddata1 = [[QNPCellItem_editDataField alloc]init];
    fielddata1.maxLenth = 6;
    fielddata1.keyboardType = UIKeyboardTypeNumberPad;
    field2.editData = fielddata1;
    field2.key = kInputKey_newKeyFirst;
    
    
    XGACellItemData_field * field3 = [self getOneData_field];
    field3.LabelTitle = @"新密码";
    field3.cellHeaderHight = 1.0f;
    field3.placeHoldText = @"请输入新密码";
    [muArray addObject:field3];
    
    QNPCellItem_editDataField * fielddata3 = [[QNPCellItem_editDataField alloc]init];
    fielddata3.maxLenth = 20;
    fielddata3.keyboardType = UIKeyboardTypeDefault;
    field3.editData = fielddata3;
    field3.isSEC = YES;
    field3.key = kInputKey_newKeysecand;
    
    return muArray;
}

- (XGACellItemData_field *)getOneData_field{
    XGACellItemData_field * data = [[XGACellItemData_field alloc]init];
    return data;
}

- (void)setInputFull:(BOOL)inputFull{
    _bottombutton.enabled = inputFull;
}


- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        XGAVcodeButton * button = [XGAVcodeButton getOne];
        button.type = @"2";
        button.dataSourse = self;
        _sendCodeButton = button;
    }
    return _sendCodeButton;
}

- (NSString *)getPhone{
    NSString * phone = [self.userInputDic objectForKey:kInputKey_oldkeyFirst];
    return phone;
}

@end
