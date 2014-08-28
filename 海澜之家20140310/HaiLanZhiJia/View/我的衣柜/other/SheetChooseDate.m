//
//  SheetChooseDate.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-13.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SheetChooseDate.h"
#define MissingTime 0.25
@implementation SheetChooseDate
{
    UIView *contentsView;   // 放置所有控件的view
    UIView *blackView;      // 黑色半透明
    UIDatePicker *timePicker;
}

- (void)dealloc
{
    [contentsView release];
    [blackView release];
    [timePicker release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)initUI
{
    
    blackView = [[UIView alloc]initWithFrame:self.bounds];
    [blackView setAlpha:0.5];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [self addSubview:blackView];
    
    contentsView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:contentsView];
    
//    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, MainViewWidth, 250)];
//    [whiteView setBackgroundColor:[UIColor whiteColor]];
//    [contentsView addSubview:whiteView];
//    [whiteView release];
    
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
    
    timePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, toolBar.frame.origin.y + toolBar.frame.size.height, MainViewWidth, 250)];
    [timePicker setBackgroundColor:[UIColor whiteColor]];
    [timePicker setDatePickerMode:UIDatePickerModeDate];
    [timePicker setMaximumDate:[NSDate date]];
    [contentsView addSubview:timePicker];
    
    [toolBar release];
    [cancelItem release];
    [doneItem release];
    [spacItem release];
    
}

- (void)setTimePickerdate:(NSDate *)date
{
    [timePicker setDate:date];
}

- (void)clicked:(UIButton *)btn
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime = [formatter stringFromDate:timePicker.date];
    
    if ([self.delegete respondsToSelector:@selector(sheetChooseDate:clickedAtIndexButton:pickerDate:)]) {
        [self.delegete sheetChooseDate:self clickedAtIndexButton:btn.tag pickerDate:strTime];
    }
    
    [self dismissed];
    [self performSelector:@selector(removeContentsView) withObject:nil afterDelay:MissingTime + 0.1];
    [formatter release];
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

- (void)removeContentsView
{
    [self removeFromSuperview];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
