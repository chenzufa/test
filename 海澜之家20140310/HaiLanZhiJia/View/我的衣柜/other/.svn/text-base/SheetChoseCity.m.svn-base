//
//  SheetChoseCity.m
//  ForHaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-20.
//  Copyright (c) 2013年 summer. All rights reserved.
//

#import "SheetChoseCity.h"
#import <QuartzCore/QuartzCore.h>
#define MissingTime 0.25
@implementation SheetChoseCity
{
//    NSArray *arr1;
//    NSArray *arr2;
//    NSArray *arr3;
//    NSArray *arr4;
    
    UIView *contentsView;   // 放置所有控件的view
    UIView *blackView;      // 黑色半透明
    
    NSArray *arrProvinces;      //省份 数组
    NSArray *arrCitys;          //城市 数组
    NSArray *arrDistrict;       //区   数组
    
    int selectRowProvince;  // 选中的省列的行数
    int selectRowCity;      // …………城市列的行数
    int selectRowDistrict;  // …………区列的行数
}
//@synthesize contentsView = _contentsView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
//    self.arrcitys = nil;
    [contentsView release];
    [blackView release];
    
    arrProvinces = nil;
    arrCitys = nil;
    arrDistrict = nil;
    
    self.cityPicker.delegate = nil;
    self.cityPicker.dataSource = nil;
    self.cityPicker = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setFrame:CGRectMake(0, 0, MainViewWidth, MainViewHeight)];

        [self initUI];
        
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    
    if (self.tag == 0) {  //  tag = 0 时  是地址选择器  非0时  是性别选择器
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *docmentsPath = [self getDocumentDirectoryPath];           //获取沙河目录路径
        NSString *directoryPath = [docmentsPath stringByAppendingPathComponent:@"chooseCity"];  //  新创建的文件夹路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:@"city.txt"];        //  新创建的文件路径
        if (![fm fileExistsAtPath:filePath]) {
            
            XmlParser *parser = [[XmlParser alloc]init];  //  xml解析
            arrProvinces = [[parser parseByPath:[[NSBundle mainBundle]pathForResource:@"省市区" ofType:@"xml"]]retain];
                        
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrProvinces];
            [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            if ([fm createFileAtPath:filePath contents:data attributes:nil]) {
                NSLog(@" ++++++  yes");
            }else NSLog(@"------- no");
            
            [parser release];
        }else {
            NSData *data = [fm contentsAtPath:filePath];
            arrProvinces = [(NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data] retain];
        }
        
        
        
        ProvinceEntity *p = [arrProvinces objectAtIndex:0]; //取得省对象
        arrCitys = [p.arrCitys retain];                     //该省的城市数组
        
        CityEntity *c = [p.arrCitys objectAtIndex:0];       //取得该省第一个城市
        arrDistrict = [c.arrDistricts retain];              //取得该城市的区数组
        
    }else {
        arrProvinces = [[NSArray alloc]initWithObjects:@"男",@"女",@"保密", nil];
    }
    
}

- (NSString *)getDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    return documentsDirectory;
}

- (void)show
{
    
    [contentsView setFrame:CGRectMake(0, MainViewHeight - 45 - 250 + 20, MainViewWidth, 250 + 45)];

    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [contentsView.layer addAnimation:animation forKey:nil];
    [animation setRemovedOnCompletion:YES];
    
    
}

- (void)dismissed
{
    [contentsView setFrame:CGRectMake(0, MainViewHeight, MainViewWidth, 250 + 45)];

    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:MissingTime];
    [contentsView.layer addAnimation:animation forKey:nil];
    [animation setRemovedOnCompletion:YES];
    
    [blackView removeFromSuperview];
}

- (void)initUI
{
    
    blackView = [[UIView alloc]initWithFrame:self.bounds];
    [blackView setAlpha:0.5];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:blackView];
    
    contentsView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:contentsView];   
    
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, MainViewWidth, 45)];
    [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [contentsView addSubview:toolBar];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clicked:)];
    cancelItem.tag = 0;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(clicked:)];
    doneItem.tag = 1;

    UIBarButtonItem *spacItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    spacItem.width = 208;
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelItem,spacItem,doneItem, nil]];
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolBar.frame.origin.y + toolBar.frame.size.height, MainViewWidth, 250)];
    [picker setShowsSelectionIndicator:YES];
    picker.delegate = self;
    picker.dataSource = self;
    [picker setBackgroundColor:[UIColor whiteColor]];
    
    [contentsView addSubview:picker];
    self.cityPicker = picker;
    
    
    
    [toolBar release];
    [cancelItem release];
    [doneItem release];
    [spacItem release];
    [picker release];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.tag == 0) {
        return 3;
    }else return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.tag == 0) {
        switch (component) {
            case 0:
                return arrProvinces.count;
                break;
            case 1:
                return arrCitys.count;
                break;
            case 2:
                return arrDistrict.count;
                break;
                
            default:
                return 0;
                break;
        }
    }else return arrProvinces.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *text ;
    if (self.tag == 0) {
        switch (component) {
            case 0:
            {
                ProvinceEntity *p = [arrProvinces objectAtIndex:row];
                text = p.provinceName;
            }
                break;
            case 1:
            {
                CityEntity *c = [arrCitys objectAtIndex:row];
                text = c.cityName;
            }
                break;
            case 2:
            {
                DistrictEntity *d = [arrDistrict objectAtIndex:row];
                text = d.districtName;
            }
                break;
            default:
                text = nil;
                break;
        }
    }else {
        text = [arrProvinces objectAtIndex:row];
    }
    
    return text;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{

    UILabel *pickerLab = (UILabel *)view;
    if (!pickerLab) {
        pickerLab = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 20)]autorelease];
        [pickerLab setFont:[UIFont systemFontOfSize:13]];
        [pickerLab setTextAlignment:NSTextAlignmentCenter];
        [pickerLab setBackgroundColor:[UIColor clearColor]];
    }
    
    pickerLab.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLab;
    
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
//    if ([self.delegate respondsToSelector:@selector(sheetPickerView:didSelectRow:inComponent:)]) {
//        [self.delegate sheetPickerView:pickerView didSelectRow:row inComponent:component];
//    }
    
    NSLog(@"row = %i   component = %i",row,component);
    if (self.tag == 0) {
        switch (component) {
            case 0:
            {
                ProvinceEntity *p = [arrProvinces objectAtIndex:row];
                arrCitys = [p.arrCitys retain];
                
                CityEntity *c = [arrCitys objectAtIndex:0];
                arrDistrict = [c.arrDistricts retain];
                
                [pickerView reloadAllComponents];
                [pickerView selectRow:0 inComponent:1 animated:YES]; // 选择省份之后 城市   自动滚到第一行
                [pickerView selectRow:0 inComponent:2 animated:YES]; // 选择省份之后 区    自动滚到第一行
                
                selectRowProvince = row;
                selectRowCity = 0;
            }
                
                break;
            case 1:
            {
                CityEntity *c = [arrCitys objectAtIndex:row];
                if (c.arrDistricts.count > 0) {
                    arrDistrict = [c.arrDistricts retain];
                }else {
                    DistrictEntity *districtEnti = [[DistrictEntity alloc]init];
                    districtEnti.districtId = @"-1";
                    districtEnti.districtName = @"";
                    arrDistrict = [[NSArray arrayWithObject:districtEnti]retain];
                    [districtEnti release];
                }
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES]; // 选择城市之后 区自动滚到第一行
                
                selectRowCity = row;
                selectRowDistrict = 0;
            }
                break;
            case 2:
            {
                selectRowDistrict = row;
            }
                break;
            default:
                break;
        }
    }else {
        selectRowProvince = row;
        NSLog(@"sex:%d",selectRowProvince);
    }
    
    
}

- (void)clicked:(UIButton *)btn
{
    if (self.tag == 0) {
        ProvinceEntity *pro = [arrProvinces objectAtIndex:selectRowProvince];
        CityEntity *city = [arrCitys objectAtIndex:selectRowCity];
        
        DistrictEntity *dis = nil;
        if (arrDistrict.count > 0) {
            dis = [arrDistrict objectAtIndex:selectRowDistrict];
        }
        
        
        if ([self.delegate respondsToSelector:@selector(sheetChoseCity:clickedAtButtonIndex:province:city:district:)]) {
            [self.delegate sheetChoseCity:self clickedAtButtonIndex:btn.tag province:pro city:city district:dis];
        }
    }else {
          NSLog(@"sex:%d",selectRowProvince);
        
        NSString *sex = [arrProvinces objectAtIndex:selectRowProvince];
        if ([self.delegate respondsToSelector:@selector(sheetChoseCity:clickedAtButtonIndex:sex:)]) {
            [self.delegate sheetChoseCity:self clickedAtButtonIndex:btn.tag sex:sex];
        }
    }
    
    
    [self dismissed];
    [self performSelector:@selector(removeContentsView) withObject:nil afterDelay:MissingTime + 0.1];
    
}

#pragma mark - 滚动到选择的城市
- (void)scorllToCity:(NSString *)strCity    // 城市内容必须有空格隔开
{
    if (self.tag == 0) {  //  tag = 0 时  是地址选择器  非0时  是性别选择器
        
        NSArray *arrSelectCity = [strCity componentsSeparatedByString:@" "];
        if (!arrSelectCity) {
            return;
        }
        if (arrSelectCity.count < 2) {
            return;
        }
        
        for (int i = 0;i<arrProvinces.count;i ++) {       // 第一行  滚动到省
            ProvinceEntity *oneProvince = [arrProvinces objectAtIndex:i];
            if ([[arrSelectCity objectAtIndex:0]isEqualToString:oneProvince.provinceName]) {
                //            [self.cityPicker selectRow:i inComponent:0 animated:YES];
                arrCitys = oneProvince.arrCitys;
                //            [self.cityPicker reloadComponent:1];
                selectRowProvince = i;
                break;
            }
        }
        
        
        
        for (int i = 0;i<arrCitys.count;i ++) {       // 第二行  滚动到城市
            CityEntity *oneCity = [arrCitys objectAtIndex:i];
            if ([[arrSelectCity objectAtIndex:1]isEqualToString:oneCity.cityName]) {
                //            [self.cityPicker selectRow:i inComponent:1 animated:YES];
                arrDistrict = oneCity.arrDistricts;
                //            [self.cityPicker reloadComponent:2];
                selectRowCity = i;
                break;
            }
        }
        
        if (arrSelectCity.count < 3) {
            return;
        }
        
        for (int i = 0;i<arrDistrict.count;i ++) {       // 第三行  滚动到区
            DistrictEntity *oneDistrict = [arrDistrict objectAtIndex:i];
            if ([[arrSelectCity objectAtIndex:2]isEqualToString:oneDistrict.districtName]) {
                //            [self.cityPicker selectRow:i inComponent:2 animated:YES];
                selectRowDistrict = i;
                break;
            }
        }
        
        [self.cityPicker reloadAllComponents];
        [self.cityPicker selectRow:selectRowProvince inComponent:0 animated:YES];
        [self.cityPicker selectRow:selectRowCity inComponent:1 animated:YES];
        [self.cityPicker selectRow:selectRowDistrict inComponent:2 animated:YES];
    }else {
        if (strCity.length >0) {
            for (int i = 0; i < arrProvinces.count; i++) {
                if ([strCity isEqualToString:[arrProvinces objectAtIndex:i]]) {
                    [self.cityPicker selectRow:i inComponent:0 animated:NO];
                    selectRowProvince = i;//胡鹏 add
                    return;
                }
            }
        }
        
    }
    
}

- (void)removeContentsView
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
