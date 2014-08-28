//
//  CashConponCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CashConponCell.h"

@implementation CashConponCell
{
    UILabel *labCardNum;    //卡号
    UILabel *labMoney;      //金额
    UILabel *lablimtTime;   //有效期
    UILabel *labState;      //状态
    
    UIView  *selectedMark;  //选中状态的视图
}

- (void)dealloc
{
    [labCardNum release];
    [labMoney release];
    [lablimtTime release];
    [labState release];
    
    [selectedMark release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
        UIImage *backImg = GetImage(@"bg_list.png");
        UIImage *selectBackImg = GetImage(@"bg_list_press.png");
        backImg = [backImg resizableImageWithCapInsets:inset];
        selectBackImg = [selectBackImg resizableImageWithCapInsets:inset];
        self.backgroundView = [[[UIImageView alloc]initWithImage:backImg]autorelease];
        self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:selectBackImg]autorelease];
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    labCardNum = [[UILabel alloc]initWithFrame:CGRectMake(9, 12, 280, FontSize15)];
    [labCardNum setFont:SetFontSize(FontSize15)];
    [labCardNum setTextColor:ColorFontBlack];
    
    labMoney = [[UILabel alloc]initWithFrame:CGRectMake(labCardNum.frame.origin.x, labCardNum.frame.origin.y + 18, labCardNum.frame.size.width, labCardNum.frame.size.height)];
    [labMoney setFont:SetFontSize(FontSize15)];
    [labMoney setTextColor:ColorFontBlack];
    
    lablimtTime = [[UILabel alloc]initWithFrame:CGRectMake(labCardNum.frame.origin.x, labMoney.frame.origin.y + 18, labCardNum.frame.size.width, labCardNum.frame.size.height)];
    [lablimtTime setFont:SetFontSize(FontSize15)];
    [lablimtTime setTextColor:ColorFontBlack];
    
    labState = [[UILabel alloc]initWithFrame:CGRectMake(labCardNum.frame.origin.x, lablimtTime.frame.origin.y + 18, labCardNum.frame.size.width, labCardNum.frame.size.height)];
    [labState setFont:SetFontSize(FontSize15)];
    [labState setTextColor:ColorFontBlack];
    
    selectedMark = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 89)];
    self.backgroundColor = [UIColor clearColor];
    selectedMark.layer.borderColor = RGBCOLOR(181,8,24).CGColor;
    selectedMark.layer.cornerRadius = 3;
    selectedMark.layer.borderWidth = 2;
    UIImageView *aImgV = [[UIImageView alloc]initWithFrame:CGRectMake(270, 35, 19, 19)];
    [aImgV setImage:GetImage(@"icon_select@2x.png")];
    [selectedMark addSubview:aImgV];
    [aImgV release];
    selectedMark.hidden = YES;
    
    
    [self.contentView addSubview:labCardNum];
    [self.contentView addSubview:labMoney];
    [self.contentView addSubview:lablimtTime];
    [self.contentView addSubview:labState];
    [self.contentView addSubview:selectedMark];
}

- (void)setlabCardNum:(NSString *)strCardNum labMoney:(NSString *)strMoney lablimitTime:(NSString *)strlimitTime labState:(NSString *)strState type:(int)type
{
    [labCardNum setText:[NSString stringWithFormat:@"卡号：%@",strCardNum]];
    [labMoney setText:[NSString stringWithFormat:@"金额：￥%@",strMoney]];
    if (type == 1) {
        [lablimtTime setText:[NSString stringWithFormat:@"使用日期：%@",strlimitTime]];
        [labState setText:[NSString stringWithFormat:@"订单号：%@",strState]];
        
    }else {
        [lablimtTime setText:[NSString stringWithFormat:@"有效期至：%@",strlimitTime]];
        [labState setText:[NSString stringWithFormat:@"状态：%@",strState]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)setCellSelected:(BOOL)cellSelected
{
    selectedMark.hidden = !cellSelected;
}

@end
