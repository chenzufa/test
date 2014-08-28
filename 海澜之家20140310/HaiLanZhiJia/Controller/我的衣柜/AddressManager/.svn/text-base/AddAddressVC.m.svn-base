//
//  AddAddressVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "AddAddressVC.h"
#import "RootVC.h"
@interface AddAddressVC ()

@end

@implementation AddAddressVC
{
    UIButton *btnDelete;
    UIButton *btnDefault;
    
    int provinceID;
    int cityID;
    int districtID;
}

enum RequestType {
    RequestTypeAddNew,
    RequestTypeChange,
    RequestTypeDelete,
    requestTypeDefalut
};

- (void)dealloc
{
    self.title = nil;
    self.entiAddress = nil;
    
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitleString:self.title];
    
    provinceID = -1;        //默认省，城市，区不做修改时  id为-1   
    cityID = -1;
    districtID = -1;
    
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"保存"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    [self initUI];
}

- (void)request:(enum RequestType)type 
{
    UITextField *tfName = (UITextField *)[self.view viewWithTag:100];
    UITextField *tfTel = (UITextField *)[self.view viewWithTag:101];
    UITextField *tfAear = (UITextField *)[self.view viewWithTag:102];
    UITextField *tfAddress = (UITextField *)[self.view viewWithTag:103];
    UITextField *tfMailcode = (UITextField *)[self.view viewWithTag:104];
    
    if (tfName.text.length > 0 && tfTel.text.length > 0 && tfAddress.text.length > 0 && tfAear.text.length > 0&& tfMailcode.text.length > 0) {
        
        if ([self isValidateMobile:tfTel.text]) {
            if ([self isValidMailCode:tfMailcode.text]) {
                [self.view addHUDActivityView:@"操作中"];  //提示 加载中
                if (!self.requestOjb) {
                    DSRequest *request = [[DSRequest alloc]init];
                    self.requestOjb = request;
                    request.delegate = self;
                    [request release];
                }
                
                
                switch (type) {
                    case RequestTypeAddNew:
                    {
                        [self.requestOjb requestDataWithInterface:AddingAddress param:[self AddingAddressParam:tfName.text tel:tfTel.text provinceid:provinceID cityid:cityID districtid:districtID address:tfAddress.text mailcode:tfMailcode.text] tag:type];
                    }
                        break;
                    case RequestTypeChange:
                    {
                        [self.requestOjb requestDataWithInterface:ModifyAddress param:[self ModifyAddressParam:self.entiAddress.addressid name:tfName.text tel:tfTel.text provinceid:provinceID cityid:cityID districtid:districtID address:tfAddress.text mailcode:tfMailcode.text] tag:type];
                    }
                        break;
                    case RequestTypeDelete:
                    {
                        [self.requestOjb requestDataWithInterface:DelAndSetDefaultAddress param:[self DelAndSetDefaultAddressParam:self.entiAddress.addressid action:1] tag:type];
                    }
                        break;
                    case requestTypeDefalut:
                        [self.requestOjb requestDataWithInterface:DelAndSetDefaultAddress param:[self DelAndSetDefaultAddressParam:self.entiAddress.addressid action:2] tag:type];
                        break;
                        
                    default:
                        break;
                }
                
                
            }else {
                WCAlertView *alert2 = [[WCAlertView alloc]initWithTitle:nil message:@"您输入的邮编不正确，请重输" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alert2 setStyle:WCAlertViewStyleWhite];
                [alert2 show];
                [alert2 release];
            }
            
        }else {
            WCAlertView *alert1 = [[WCAlertView alloc]initWithTitle:nil message:@"您输入的手机号不合法，请重输" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
            [alert1 setStyle:WCAlertViewStyleWhite];
            [alert1 show];
            [alert1 release];
        }
        
    }else {
        WCAlertView *alert = [[WCAlertView alloc]initWithTitle:nil message:@"信息没有填完整" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert setStyle:WCAlertViewStyleWhite];
        [alert show];
        [alert release];
    }
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    
    [self.view removeHUDActivityView];        //加载成功  停止转圈并弹出提示框
    StatusEntity *entiSta = (StatusEntity *)dataObj;
    if (entiSta.response == 1) {
        switch (tag) {
            case RequestTypeAddNew:
                [self.view.window addHUDLabelView:@"添加成功" Image:nil afterDelay:2];
                break;
            case RequestTypeChange:
                [self.view.window addHUDLabelView:@"修改成功" Image:nil afterDelay:2];
                break;
            case RequestTypeDelete:
                [self.view.window addHUDLabelView:@"删除成功" Image:nil afterDelay:2];
                break;
            case requestTypeDefalut:
                [self.view.window addHUDLabelView:@"设置成功" Image:nil afterDelay:2];
                break;
                
            default:
                break;
        }
        [self popViewController];
        
        if ([self.backDelegate respondsToSelector:@selector(addAddressVCDisMissedandReloadData)]) {
            [self.backDelegate addAddressVCDisMissedandReloadData];
        }
        
    }else {
        [self.view.window addHUDLabelView:@"操作失败>_<" Image:nil afterDelay:2];
    }
    
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [self.view removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [self.view addHUDLabelView:error.domain Image:nil afterDelay:2];
}

- (void)myRightButtonAction:(UIButton *)button
{
    if (self.entiAddress) {
        [self request:RequestTypeChange];
    }else [self request:RequestTypeAddNew];
    
}

- (void)initUI
{
    for (int i = 0; i < 5; i ++) {
        UIImage *image;
        NSString *strPlaceholder;
        switch (i) {
            case 0:
                image = GetImage(@"bg_list2_up.png");
                strPlaceholder = @"收件人";
                break;
            case 1:
                image = GetImage(@"bg_list2_middle.png");
                strPlaceholder = @"电话";
                break;
                
            case 2:
                image = GetImage(@"bg_list2_middle.png");
                strPlaceholder = @"所在地区";
                break;
            case 3:
                image = GetImage(@"bg_list2_middle.png");
                strPlaceholder = @"详细地址";
                break;
            case 4:
                image = GetImage(@"bg_list2_down.png");
                strPlaceholder = @"邮编";
                break;
                
            default:
                image = nil;
                strPlaceholder = nil;
                break;
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [imageView setFrame:CGRectMake(10, 74 - 20 + image.size.height * i, image.size.width, image.size.height)];
        [self.view addSubview:imageView];
        
        if (i < 4) {        //分割线
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height - 1, imageView.frame.size.width, 0.5)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:lineView];
            [lineView release];
        }
        
        
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y, imageView.frame.size.width- 30, imageView.frame.size.height)];
        textfield.delegate = self;
        [textfield setTextColor:ColorFontBlack];
        [textfield setBorderStyle:UITextBorderStyleNone];
        [textfield setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textfield setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        textfield.tag = i + 100;
        [textfield setPlaceholder:strPlaceholder];
        [self.view addSubview:textfield];
        [textfield setReturnKeyType:UIReturnKeyDone];
        if (i == 2) {
            [textfield setUserInteractionEnabled:NO];
            [imageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setCity:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            
            UIImageView *arrowImgView = [[UIImageView alloc]initWithImage:GetImage(@"icon_next.png")];
            [arrowImgView setFrame:CGRectMake(293, imageView.frame.origin.y + 15, arrowImgView.image.size.width, arrowImgView.image.size.height)];
//            [arrowImgView setCenter:CGPointMake(arrowImgView.center.x, self.center.y)];
            [self.view addSubview:arrowImgView];
        }else if (i==1 ||i==4){
            [textfield setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        }
        
        if (self.entiAddress) {  //存在 说明此界面为修改地址
            
            switch (i) {
                case 0:
                    [textfield setText:self.entiAddress.name];
                    break;
                case 1:
                    [textfield setText:self.entiAddress.tel];
                    break;
                case 2:
                    if (![self.entiAddress.area isKindOfClass:[NSNull class]]) {
                        [textfield setText:self.entiAddress.area];
                    }
                    
                    break;
                case 3:
                    [textfield setText:self.entiAddress.address];
                    break;
                case 4:
                    [textfield setText:self.entiAddress.mailcode];
                    break;
                    
                default:
                    break;
            }
            
        }
        
        [imageView release];
        [textfield release];
        
    }
    
    
    
    if ([self.title isEqualToString:@"修改地址"]) {
        
        UIImage *imgRedBtn = GetImage(@"button3.png");
        UIImage *imgWhiteBtn = GetImage(@"button4.png");
        
        btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setBackgroundImage:imgRedBtn forState:UIControlStateNormal];
        [btnDelete setBackgroundImage:GetImage(@"button3_press.png") forState:UIControlStateHighlighted];
        [btnDelete setFrame:CGRectMake(10, 288, imgRedBtn.size.width, imgRedBtn.size.height)];
        [btnDelete setTitle:@"删除收货地址" forState:UIControlStateNormal];
        [btnDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnDelete.titleLabel setFont:SetFontSize(18)];
        btnDelete.tag = RequestTypeDelete;
        [btnDelete addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        btnDefault = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDefault setBackgroundImage:imgWhiteBtn forState:UIControlStateNormal];
        [btnDefault setBackgroundImage:GetImage(@"button4_press.png") forState:UIControlStateHighlighted];
        [btnDefault setFrame:CGRectMake(10, 343, imgWhiteBtn.size.width, imgWhiteBtn.size.height)];
        [btnDefault setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [btnDefault setTitleColor:ColorFontBlack forState:UIControlStateNormal];
        [btnDefault.titleLabel setFont:btnDelete.titleLabel.font];
        btnDefault.tag = requestTypeDefalut;
        [btnDefault addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnDelete];
        [self.view addSubview:btnDefault];
        

    }
}

- (void)clickedButton:(UIButton *)btn  //  修改地址多出的两个按钮点击事件 2 删除  3 设默认
{
    [self.view endEditing:YES];
    
    if (btn.tag == 2) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        RootVC *rootVC= [RootVC shareInstance];
        [sheet showInView:rootVC.view];
        [sheet release];
    }else [self request:requestTypeDefalut];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self request:RequestTypeDelete];
    }
    
}

- (void)setCity:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    
    SheetChoseCity *sheet = [[SheetChoseCity alloc]init];
    [sheet setTag:0];
    sheet.delegate = self;
    [self.view addSubview:sheet];
    [sheet show];
    
    UITextField *tf = (UITextField *)[self.view viewWithTag:102];
    if (tf.text.length > 0) {
        
        [sheet scorllToCity:tf.text];
    }

    [sheet release];
}

#pragma mark SheetChooseCityDelegate
- (void)sheetChoseCity:(SheetChoseCity *)sheet clickedAtButtonIndex:(int)index province:(ProvinceEntity *)proEntity city:(CityEntity *)cityEntity district:(DistrictEntity *)disEntity
{
    NSLog(@"省：%@  城市： %@ 区：%@",proEntity.provinceName,cityEntity.cityName,disEntity.districtName);
    if (index == 1) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:102];
        [tf setText:[NSString stringWithFormat:@"%@ %@ %@",proEntity.provinceName,cityEntity.cityName,disEntity.districtName]];
        
        provinceID = [proEntity.provinceId intValue];
        cityID = [cityEntity.cityId intValue];
        districtID = [disEntity.districtId intValue];
    }
    
    
}

#pragma mark UITextField
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag > 102 && !isIPhone5) {
//        [UIView beginAnimations:@"animation" context:nil];
//        [UIView setAnimationDuration:0.35];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 50, self.view.frame.size.width, self.view.frame.size.height)];
//        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag > 102 && !isIPhone5) {
        [UIView beginAnimations:@"animation" context:nil];
        [UIView setAnimationDuration:0.35];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 50, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101) {         // 手机号，限制长度为11
        NSString *str = [textField.text stringByAppendingString:string];
        if (str.length > 11) {
            return NO;
        }
        return YES;
    }else if (textField.tag == 104){    // 邮编，限制长度为6
        NSString *str = [textField.text stringByAppendingString:string];
        if (str.length > 6) {
            return NO;
        }
        return YES;
    }
    return YES;
}

#pragma mark ---判断手机号是否合法
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

#pragma mark ---判断邮编
- (BOOL) isValidMailCode:(NSString*)mailCode {
    NSString *phoneRegex = @"[1-9]\\d{5}(?!\\d)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mailCode];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
