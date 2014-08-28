//
//  UserInfomationCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "UserInfomationCell.h"

@implementation UserInfomationCell
{
    UILabel *labLeft;
    UIImageView *lineImgView;
}

- (void)dealloc
{
    [labLeft release];
    [lineImgView release];
    self.indexPath = nil;
//    [textFieldRight release];
    self.textFieldRight = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self initUI];
    }
    return self;
}

- (void)setCellBackgroundImageView:(int)row
{
    NSString *imageName;
    NSString *imageName_press;
    switch (row) {
        case 0:
            imageName = @"bg_list2_up.png";
            imageName_press = @"bg_list2_up_press.png";
            [lineImgView setHidden:NO];
            break;
        case 1:
            [lineImgView setHidden:NO];
            imageName = @"bg_list2_middle.png";
            imageName_press = @"bg_list2_middle_press.png";
            break;
        case 2:
            [lineImgView setHidden:YES];
            imageName = @"bg_list2_down.png";
            imageName_press = @"bg_list2_down_press.png";
            break;
            
        default:
            imageName = nil;
            imageName_press = nil;
            
            break;
    }
    self.backgroundView = [[[UIImageView alloc]initWithImage:GetImage(imageName)]autorelease];
    self.selectedBackgroundView= [[[UIImageView alloc]initWithImage:GetImage(imageName_press)]autorelease];
    
}

- (void)initUI
{
    labLeft = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 65, FontSize15)];
    [self.contentView addSubview:labLeft];
    [labLeft setFont:SetFontSize(FontSize15)];
    [labLeft setTextColor:ColorFontBlack];
    [labLeft setBackgroundColor:[UIColor clearColor]];
    [labLeft setClipsToBounds:YES];
    
    lineImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"segmentation_line.png"]]        ;
    [lineImgView setFrame:CGRectMake(00, self.frame.size.height - lineImgView.frame.size.height, lineImgView.image.size.width, lineImgView.image.size.height)];
    [self addSubview:lineImgView];
    
    UITextField *tempTextField = [[UITextField alloc]initWithFrame:CGRectMake(labLeft.frame.origin.x + labLeft.frame.size.width + 10, 0, 190, self.frame.size.height)];
    
    tempTextField.delegate = self;
    [tempTextField setFont:SetFontSize(FontSize15)];
    [tempTextField setTextColor:ColorFontgray];
    [tempTextField setTextAlignment:NSTextAlignmentRight];
    [tempTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];  // 垂直方向居中
    [tempTextField setBorderStyle:UITextBorderStyleNone];
    [tempTextField setReturnKeyType:UIReturnKeyDone];
    [tempTextField setClearButtonMode:UITextFieldViewModeWhileEditing]; //编辑时显示删除按钮
    [tempTextField setBackgroundColor:[UIColor clearColor]];
    
    
    
    //////////  给键盘添加按钮  点击收起键盘
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [tempTextField setInputAccessoryView:topView];
    
    
    self.textFieldRight = tempTextField;
    [self.contentView addSubview:self.textFieldRight];
    [tempTextField release];
    [doneButton release];
    [btnSpace release];
    [topView release];
}

- (void)dismissKeyBoard
{
    [self.textFieldRight resignFirstResponder];
}

- (void)setLabLeft:(NSString *)strLeft textfieldRight:(NSString *)strRight
{
    [labLeft setText:strLeft];
    if ([strRight isKindOfClass:[NSString class]]) {
        [self.textFieldRight setText:strRight];
    }
    
}

- (void)setTextFieldEnabled:(BOOL)enable     // 设置输入框可编辑
{
    [self.textFieldRight setEnabled:enable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.indexPath.section == 1 && self.indexPath.row == 2) {
        NSString *str = [textField.text stringByAppendingString:string];
        if (str.length > 11) {
            return NO;
        }else return YES;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegateTextField respondsToSelector:@selector(userInformationCell:textFieldDidBeginEditing:)]) {
        [self.delegateTextField userInformationCell:self textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegateTextField respondsToSelector:@selector(userInformationCell:textFieldDidEndEditing:)]) {
        [self.delegateTextField userInformationCell:self textFieldDidEndEditing:textField];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegateTextField respondsToSelector:@selector(userInformationCell:textFieldShouldReturn:)]) {
        [self.delegateTextField userInformationCell:self textFieldShouldReturn:textField];
    }
    
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
