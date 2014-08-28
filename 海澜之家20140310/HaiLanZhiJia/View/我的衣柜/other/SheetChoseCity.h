//
//  SheetChoseCity.h
//  ForHaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-20.
//  Copyright (c) 2013年 summer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmlParser.h"
@class SheetChoseCity;
@protocol SheetChoseCityDelegate <NSObject>

@optional

- (void)sheetChoseCity:(SheetChoseCity *)sheet clickedAtButtonIndex:(int)index province:(ProvinceEntity *)proEntity city:(CityEntity *)cityEntity district:(DistrictEntity *)disEntity; // 取消确定按钮
- (void)sheetChoseCity:(SheetChoseCity *)sheet clickedAtButtonIndex:(int)index sex:(NSString *)sex;

@end

@interface SheetChoseCity : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (assign, nonatomic) id <SheetChoseCityDelegate> delegate;
//@property (retain, nonatomic) NSString *city;
@property (retain, nonatomic) UIPickerView *cityPicker;
- (void)scorllToCity:(NSString *)strCity;
- (void)show;
@end
