//
//  UserInfomationCell.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "CommonCell.h"
@class UserInfomationCell;
@protocol UserInformationCellTextFieldDelegate <NSObject>

@optional
- (void)userInformationCell:(UserInfomationCell *)cell textFieldDidBeginEditing:(UITextField *)textField;
- (void)userInformationCell:(UserInfomationCell *)cell textFieldDidEndEditing:(UITextField *)textField;
- (void)userInformationCell:(UserInfomationCell *)cell textFieldShouldReturn:(UITextField *)textField;

@end

@interface UserInfomationCell : CommonCell<UITextFieldDelegate>

@property (assign, nonatomic) id <UserInformationCellTextFieldDelegate> delegateTextField;
@property (retain, nonatomic) NSIndexPath *indexPath;

- (void)setCellBackgroundImageView:(int)row;
- (void)setTextFieldEnabled:(BOOL)enable;
- (void)setLabLeft:(NSString *)strLeft textfieldRight:(NSString *)strRight;

@property (nonatomic, retain) UITextField *textFieldRight;
@end
