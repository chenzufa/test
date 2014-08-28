//
//  HelpCell.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "HelpCell.h"

@implementation HelpCell
{
    UILabel *titleLabel;
    UIImageView *jianTouView;
}

-(void)dealloc
{
    [titleLabel release];
    [jianTouView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

-(void)initView
{
 
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 250, 30)];
    titleLabel.font = SYSTEMFONT(15);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:titleLabel];
    UIImage *bangImg = GETIMG(@"icon_next.png");
    jianTouView = [[UIImageView alloc]initWithFrame:CGRectMake(280, 15, bangImg.size.width, bangImg.size.height)];
    jianTouView.image = bangImg;
    [self.contentView addSubview:jianTouView];
}

-(void)creatCell:(NSString *)titleStr
{
    titleLabel.text = titleStr;
}

-(void)setCellBackGroundView:(int)row andMax:(int)maxRow
{
    NSString *imageName = nil;
    NSString *imageName_press = nil;
    if(row == 0 || row==maxRow)
    {
        if(row == 0)
        {
            imageName = @"bg_list2_up.png";
            imageName_press = @"bg_list2_up_press.png";
        }
        if(row == maxRow)
        {
            imageName = @"bg_list2_down.png";
            imageName_press = @"bg_list2_down_press.png";
        }
    }
    else
    {
        imageName = @"bg_list2_middle.png";
        imageName_press = @"bg_list2_middle_press.png";
 
    }
//    switch (row) {
//        case 0:
//        {
//            imageName = @"bg_list2_up.png";
//            imageName_press = @"bg_list2_up_press.png";
//            
//        }
//            break;
//        case 1:
//        {
//            imageName = @"bg_list2_middle.png";
//            imageName_press = @"bg_list2_middle_press.png";
//            
//        }
//            break;
//        case 2:
//        {
//            imageName = @"bg_list2_middle.png";
//            imageName_press = @"bg_list2_middle_press.png";
//            
//        }
//            break;
//            
//        case 3:
//        {
//            imageName = @"bg_list2_middle.png";
//            imageName_press = @"bg_list2_middle_press.png";
//        }
//            break;
//        case 4:
//        {
//            imageName = @"bg_list2_down.png";
//            imageName_press = @"bg_list2_down_press.png";
//        }
//            break;
//        default:
//            imageName = nil;
//            imageName_press = nil;
//            break;
//    }
self.backgroundView =[[[UIImageView alloc]initWithImage:GETIMG(imageName)] autorelease];
  self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:GETIMG(imageName_press) ]autorelease];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
