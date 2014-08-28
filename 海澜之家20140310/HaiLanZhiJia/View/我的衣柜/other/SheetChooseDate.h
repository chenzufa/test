//
//  SheetChooseDate.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-13.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SheetChooseDate;
@protocol SheetChooseDateDelegate <NSObject>

@optional
- (void)sheetChooseDate:(SheetChooseDate *)sheet clickedAtIndexButton:(NSInteger)index pickerDate:(NSString *)strDate;

@end

@interface SheetChooseDate : UIView
- (void)show;
- (void)setTimePickerdate:(NSDate *)date;
@property (nonatomic, assign) id<SheetChooseDateDelegate> delegete;
@end
