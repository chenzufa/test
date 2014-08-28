//
//  MyReviewCell.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MyReviewCell.h"

@implementation MyReviewCell
{
    UIButton *imgViewHead;   // 图片
    UILabel *labTitle;          // 标题
    
    UILabel *labTime;           // 未评论 - 购买日期
    
    UILabel *labSize;           // 已评论 - 尺码
    ScoreImgViews *imgScore;     // 已评论 - 评分
    UILabel *labReviewText;     // 已评论 - 评论内容
}

- (void)dealloc
{
//    [imgViewHead release];
    [labTitle release];
    
    [labTime release];
    
    if (labSize) {
        [labSize release];
    }
    
    if (imgScore) {
        [imgScore release];
    }
    
    if (labReviewText) {
        [labReviewText release];
    }
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImage *bgBtn = GetImage(@"home_photo2.png");
        
        imgViewHead =[UIButton buttonWithType:UIButtonTypeCustom];//CGRectMake(10, 6, bgBtn.size.width, bgBtn.size.height)];
        [imgViewHead setFrame:CGRectMake(10, 6, 87, 91)];
        [imgViewHead setContentEdgeInsets:UIEdgeInsetsMake(3, 3, 7, 3)];
//        [imgViewHead setShowsTouchWhenHighlighted:YES];
        [imgViewHead setUserInteractionEnabled:NO];
        [imgViewHead setBackgroundImage:bgBtn forState:UIControlStateNormal];
        [self.contentView addSubview:imgViewHead];
        
        labTitle = [[UILabel alloc]initWithFrame:CGRectMake(imgViewHead.frame.origin.x + imgViewHead.frame.size.width + 10, 14, 190, FontSize15 * 2 + 6)];
        [labTitle setFont:SetFontSize(FontSize15)];
        [labTitle setTextColor:ColorFontBlack];
        [labTitle setNumberOfLines:2];
        [self.contentView addSubview:labTitle];
        
        labSize = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 3, labTitle.frame.size.width, 29)];
        [labSize setFont:SetFontSize(FontSize12)];
        [labSize setNumberOfLines:2];
        [labSize setTextColor:ColorAndSize];
        [self.contentView addSubview:labSize];
        
        [self setArrowCenterX:303 Y:50];
    }
    return self;
}

- (void)initUnReview    //初始化未评论界面
{
//    labSize = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 3, labTitle.frame.size.width, 29)];
//    [labSize setFont:SetFontSize(FontSize12)];
//    [labSize setNumberOfLines:2];
//    [labSize setTextColor:ColorAndSize];
//    [self.contentView addSubview:labSize];
    
    labTime = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 35, labTitle.frame.size.width, FontSize12)];
    [labTime setFont:SetFontSize(FontSize12)];
    [labTime setTextColor:ColorFontgray];
    [self.contentView addSubview:labTime];
    
}

- (void)initBeenReviewed        // 初始化已评论界面
{
//    labSize = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labTitle.frame.origin.y + labTitle.frame.size.height + 3, labTitle.frame.size.width, 29)];
//    [labSize setFont:SetFontSize(FontSize12)];
//    [labSize setNumberOfLines:2];
//    [labSize setTextColor:ColorAndSize];
//    [self.contentView addSubview:labSize];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labTitle.frame.origin.x, labSize.frame.origin.y + labSize.frame.size.height + 10, 62, FontSize12)];
    [label setFont:labSize.font];
    [label setTextColor:labSize.textColor];
    [self.contentView addSubview:label];
    [label setText:@"综合评分："];
    [label release];
    
    imgScore = [[ScoreImgViews alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, label.frame.origin.y - 3, 50, 50)];
    [self.contentView addSubview:imgScore];
    
    labReviewText = [[UILabel alloc]initWithFrame:CGRectMake(imgViewHead.frame.origin.x, imgViewHead.frame.origin.y + imgViewHead.frame.size.height + 10, 300, 14)];
    [labReviewText setTextColor:RGBCOLOR(100, 100, 100)];
    [labReviewText setFont:SetFontSize(14)];
    [labReviewText setNumberOfLines:4];
    [self.contentView addSubview:labReviewText];
//    [labReviewText setBackgroundColor:[UIColor cyanColor]];
}

// 给未评论界面赋值
- (void)setUnReviewImage:(NSString *)strImage labTitle:(NSString *)strTitle labTime:(NSString *)strTime labSize:(NSString *)strSize
{
    [imgViewHead setImageWithURL:[NSURL URLWithString:strImage] forState:UIControlStateNormal];
    [labTitle setText:strTitle];
    [labSize setText:strSize];
    [labTime setText:[NSString stringWithFormat:@"购买日期：%@",strTime]];
}

// 给已评论界面赋值
- (void)setBeenReviewedImage:(NSString *)strImage labTitle:(NSString *)strTitle labSize:(NSString *)strSize imgViewScore:(int)iScore labReviewText:(NSString *)strReviewText
{
    [imgViewHead setImageWithURL:[NSURL URLWithString:strImage] forState:UIControlStateNormal];
    [labTitle setText:strTitle];
    [labSize setText:strSize];
    [imgScore scoreImageViewWithScore:iScore];
    
    [labReviewText setText:[NSString stringWithFormat:@"评论：%@",strReviewText]];
    
    CGSize labelSize = [labReviewText.text sizeWithFont:labReviewText.font constrainedToSize:CGSizeMake(labReviewText.frame.size.width, 60) lineBreakMode:NSLineBreakByCharWrapping];
    [labReviewText setFrame:CGRectMake(labReviewText.frame.origin.x, labReviewText.frame.origin.y, labReviewText.frame.size.width, labelSize.height)];
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
