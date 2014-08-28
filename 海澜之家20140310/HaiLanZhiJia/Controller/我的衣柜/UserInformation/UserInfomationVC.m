//
//  UserInfomationVC.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "UserInfomationVC.h"

@interface UserInfomationVC ()

@end

@implementation UserInfomationVC
{
    UITableView *userTableView;
    CustomerInfoEntity *tempEnti;
    NSArray *arrProvinces;      //省份 数组
    NSArray *arrCitys;          //城市 数组
    NSArray *arrDistrict;       //区   数组
    
    int iProvieceID;            //选中的省份id
    int iCityID;
    int iDistrictID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [userTableView release];
    self.entiCustInfo = nil;
    
    arrProvinces = nil;
    arrCitys = nil;
    arrDistrict = nil;
    
    tempEnti = nil;
    
    self.requestOjb.delegate = nil;
    self.requestOjb = nil;
    [userTableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    
    [self setTitleString:@"个人信息"];
    [self createMyButtonWithTitleAndImage];
    [self setMyRightButtonTitle:@"保存"];
    [self setMyRightButtonBackGroundImageView:@"button1.png" hightImage:@"button1_press.png"];
    
    userTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, TITLEHEIGHT, 300, MainViewHeight - TITLEHEIGHT - 20)];
    [userTableView setBackgroundColor:[UIColor clearColor]];
    [userTableView setShowsVerticalScrollIndicator:NO];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    [userTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    userTableView.tableFooterView = [[[UIView alloc]init]autorelease];
    if ([userTableView respondsToSelector:@selector(setSeparatorInset:)]) { //去掉ios7每行分割线前的空白
        [userTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:userTableView];
    
//    UITapGestureRecognizer *gesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shouqiKeyBoard:)];
//    [self.view addGestureRecognizer:gesTap];
//    [gesTap release];
    
    iProvieceID = -1;
    iCityID = -1;
    iDistrictID = -1;
    
    [self request:0];
}

//- (void)shouqiKeyBoard:(UITapGestureRecognizer *)gesTap
//{
//    [userTableView endEditing:YES];
//}

- (void)myRightButtonAction:(UIButton *)button
{
    [userTableView endEditing:YES];
    [self request:1];
}

- (void)request:(int)type  //  0 获取个人信息  1 修改个人信息
{
    [userTableView addHUDActivityView:Loading];  //提示 加载中
    if (!self.requestOjb) {
        DSRequest *request = [[DSRequest alloc]init];
        request.delegate = self;
        self.requestOjb = request;
        [request release];
    }
    
    if (type == 0) {
        [self.requestOjb requestDataWithInterface:GetCustomerInfo param:[self GetCustomerInfoParam] tag:type];
        
    }else [self.requestOjb requestDataWithInterface:ModifyCustomerInfo param:[self ModifyCustomerInfoParam:tempEnti.nickname name:tempEnti.name sex:tempEnti.sex birthday:tempEnti.birthday provinceid:iProvieceID cityid:iCityID districtid:iDistrictID mobile:tempEnti.mobile tel:tempEnti.tel qq:tempEnti.qq email:tempEnti.email] tag:type];
    
    
}

#pragma mark DSRequestDelegate
- (void)requestDataSuccess:(id)dataObj tag:(int)tag
{
    NSLog(@"请求成功!");
    [userTableView removeHUDActivityView];        //加载成功  停止转圈
    
    if (tag == 0) {
        self.entiCustInfo = (CustomerInfoEntity *)dataObj;
        tempEnti = self.entiCustInfo ;
        
        [userTableView reloadData];
    }else {
        StatusEntity *entiState = (StatusEntity *)dataObj;
        if (entiState.response == 1) {
            [self.view.window addHUDLabelView:@"修改成功" Image:nil afterDelay:2];
        }else if (entiState.response == 2)
        {
            [self.view.window addHUDLabelView:entiState.failmsg Image:nil afterDelay:2];
        }
        
//        [self popViewController];
        
        if ([self.backDelegate respondsToSelector:@selector(userInformationVCDisMissReloadData)]) {
            [self.backDelegate userInformationVCDisMissReloadData];
        }
    }
        
}

- (void)requestDataFail:(enum InterfaceType)type tag:(int)tag error:(NSError *)error
{
    NSLog(@"请求失败");
    [userTableView removeHUDActivityView];        //加载失败  停止转圈并弹出提示框
    [userTableView addHUDLabelView:error.domain Image:nil afterDelay:2];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"tableviewcell";
    UserInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UserInfomationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.delegateTextField = self;
    }
    cell.indexPath = indexPath;
    [cell setCellBackgroundImageView:indexPath.row];
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [cell setLabLeft:@"昵称" textfieldRight:tempEnti.nickname];
                break;
            case 1:
                [cell setLabLeft:@"姓名" textfieldRight:tempEnti.name];
                break;
            case 2:
                [cell setLabLeft:@"性别" textfieldRight:tempEnti.sex];
                break;
            default:
                break;
        }
        
    }else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                [cell setLabLeft:@"生日" textfieldRight:tempEnti.birthday];
                break;
            case 1:
                [cell setLabLeft:@"城市" textfieldRight:tempEnti.city];
                break;
            case 2:
                [cell setLabLeft:@"手机" textfieldRight:tempEnti.mobile];
                [cell.textFieldRight setKeyboardType:UIKeyboardTypeNumberPad];  //设置键盘类型
                break;
            default:
                break;
        }
        
    }else {
        
        switch (indexPath.row) {
            case 0:
                [cell setLabLeft:@"联系电话" textfieldRight:tempEnti.tel];
                [cell.textFieldRight setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 1:
                [cell setLabLeft:@"QQ" textfieldRight:tempEnti.qq];
                [cell.textFieldRight setKeyboardType:UIKeyboardTypeNumberPad];
                break;
            case 2:
                [cell setLabLeft:@"邮箱" textfieldRight:tempEnti.email];
//                [cell.textFieldRight setKeyboardType:UIKeyboardTypeEmailAddress];
                break;
            default:
                break;
        }
        
    }
    
    if (indexPath.section == 0 ) {
        if (indexPath.row == 2) {
            [cell setArrowHidden:NO];
            [cell setTextFieldEnabled:NO];
        }else {
            [cell setArrowHidden:YES];
            [cell setTextFieldEnabled:YES];
        }
        
    }else if (indexPath.section == 1){
        [cell setTextFieldEnabled:NO];
        
        if (indexPath.row == 2) {
            [cell setArrowHidden:YES];
        }else{
            [cell setArrowHidden:NO];
        }
        
    }else if (indexPath.section == 2){
        [cell setArrowHidden:YES];
        if (indexPath.row == 2) {
            [cell setTextFieldEnabled:NO];
        }else[cell setTextFieldEnabled:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 10)]autorelease];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    if (section < 2) {
        return 15;
//    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (section < 2) {
        UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 15)]autorelease];
        [view setBackgroundColor:[UIColor clearColor]];
        return view;
//    }return nil;
    
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        
        [tableView endEditing:YES];
        
        SheetChoseCity *sheet = [[SheetChoseCity alloc]init];               // 选择性别
        [sheet setTag:1];
        sheet.delegate = self;
        [sheet scorllToCity:tempEnti.sex];
        [self.view addSubview:sheet];
        [sheet show];
        [sheet release];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [tableView endEditing:YES];
            SheetChooseDate *sheetDate = [[SheetChooseDate alloc]init];     // 选择生日
            sheetDate.delegete = self;
            
            if (tempEnti.birthday.length > 0) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *datebir = [formatter dateFromString:tempEnti.birthday];
                [sheetDate setTimePickerdate:datebir];
                [formatter release];
            }
            
            
            [self.view addSubview:sheetDate];
            [sheetDate show];
            [sheetDate release];
            
        }else if (indexPath.row == 1){
            [tableView endEditing:YES];
            
            SheetChoseCity *sheet = [[SheetChoseCity alloc]init];           // 选择城市
            [sheet setTag:0];
            sheet.delegate = self;
            [self.view addSubview:sheet];
            [sheet scorllToCity:tempEnti.city];
            [sheet show];
            [sheet release];
        }
    }
    
}

#pragma mark SheetChooseDateDelegate
- (void)sheetChooseDate:(SheetChooseDate *)sheet clickedAtIndexButton:(NSInteger)index pickerDate:(NSString *)strDate
{
    NSLog(@"日期：%@",strDate);
    if (index == 1) {
        tempEnti.birthday = strDate;
        [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark SheetChoseCityDelegate
- (void)sheetChoseCity:(SheetChoseCity *)sheet clickedAtButtonIndex:(int)index province:(ProvinceEntity *)proEntity city:(CityEntity *)cityEntity district:(DistrictEntity *)disEntity
{
    NSLog(@"index = %i",index);
    if (index == 1) {
        iProvieceID = [proEntity.provinceId intValue];
        iCityID = [cityEntity.cityId intValue];
        iDistrictID = [disEntity.districtId intValue];
        tempEnti.city = [NSString stringWithFormat:@"%@ %@ %@",proEntity.provinceName,cityEntity.cityName,disEntity.districtName];
        [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (void)sheetChoseCity:(SheetChoseCity *)sheet clickedAtButtonIndex:(int)index sex:(NSString *)sex
{
    NSLog(@"sex = %@",sex);
    if (index == 1) {
        tempEnti.sex = [NSString stringWithFormat:@"%@",sex];
        [userTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark UserInformationCellTextFieldDelegate
- (void)userInformationCell:(UserInfomationCell *)cell textFieldDidBeginEditing:(UITextField *)textField
{
    //  选中textfield时，其所在的cell往上滚动
    [userTableView setContentInset:UIEdgeInsetsMake(0, 0, 300, 0)];
    [userTableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    
    
}

- (void)userInformationCell:(UserInfomationCell *)cell textFieldDidEndEditing:(UITextField *)textField
{
    [userTableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    if (cell.indexPath.section == 0) {
        
        switch (cell.indexPath.row) {
            case 0:
                tempEnti.nickname = textField.text;
                break;
            case 1:
                tempEnti.name = textField.text;
                break;
            case 2:
                tempEnti.sex = textField.text;
                break;
            
            default:
                break;
        }
        
    }else if(cell.indexPath.section == 1){
        
        switch (cell.indexPath.row) {
            case 0:
                tempEnti.birthday = textField.text;
                break;
            case 1:
                tempEnti.city = textField.text;
                break;
            case 2:
                tempEnti.mobile = textField.text;
                break;
                
                break;
            default:
                break;
        }
        
    }else if(cell.indexPath.section == 2){
        
        switch (cell.indexPath.row) {
            case 0:
                tempEnti.tel = textField.text;
                break;
            case 1:
                tempEnti.qq = textField.text;
                break;
            case 2:
                tempEnti.email = textField.text;
                break;
        }
        
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
