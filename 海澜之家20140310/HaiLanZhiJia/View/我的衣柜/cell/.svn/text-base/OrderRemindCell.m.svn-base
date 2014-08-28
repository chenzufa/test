//
//  OrderRemindCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "OrderRemindCell.h"

@implementation OrderRemindCell
{
    UILabel *labTime;
    UILabel *labMessage;
    
    UIButton *btnDelete;
    CGPoint beginP;
}

- (void)dealloc
{
    [labMessage release];
    [labTime release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panShowDeleteButton:)];
//        [self addGestureRecognizer:pan];
//        [pan release];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapShowDeleteButton:)];
//        [self addGestureRecognizer:tap];
//        [tap release];
        
        [self initUI];
    }
    return self;
}

- (void)panShowDeleteButton:(UIPanGestureRecognizer *)pan
{
    CGPoint p =[pan locationInView:self];
    if (p.x - beginP.x > 20 ||beginP.x - p.x > 20) {
        [btnDelete setHidden:!btnDelete.hidden];
    }
    
}

- (void)initUI
{
    labTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 12)];
    [labTime setFont:SetFontSize(FontSize12)];
    [labTime setTextColor:RGBCOLOR(186, 180, 180)];
    [self.contentView addSubview:labTime];
    
    labMessage = [[UILabel alloc]initWithFrame:CGRectMake(labTime.frame.origin.x, labTime.frame.origin.y + labTime.frame.size.height + 10, labTime.frame.size.width, FontSize15)];
    [labMessage setFont:SetFontSize(FontSize15)];
    [labMessage setTextColor:ColorFontBlack];
    [self.contentView addSubview:labMessage];
    [labMessage setNumberOfLines:20];
//    [labMessage setBackgroundColor:[UIColor cyanColor]];
    
    btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDelete setImage:GetImage(@"button_delete.png") forState:UIControlStateNormal];
    [btnDelete setImage:GetImage(@"button_delete_press.png") forState:UIControlStateHighlighted];
    [btnDelete setFrame:CGRectMake(250, labTime.frame.origin.y + labTime.frame.size.height, btnDelete.imageView.image.size.width, btnDelete.imageView.image.size.height)];
    [self.contentView addSubview:btnDelete];
    [btnDelete setHidden:YES];
}

- (void)setLabtime:(NSString *)strTime LabMessage:(NSString *)strMessage
{
    [labTime setText:strTime];
    [labMessage setText:strMessage];
    
    CGSize labelSize = [strMessage sizeWithFont:labMessage.font constrainedToSize:CGSizeMake(labMessage.frame.size.width, 450) lineBreakMode:NSLineBreakByWordWrapping];
    [labMessage setFrame:CGRectMake(labMessage.frame.origin.x, labMessage.frame.origin.y, labMessage.frame.size.width, labelSize.height)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
