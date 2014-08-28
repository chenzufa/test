//
//  MoreCell1.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "MoreCell1.h"
#import "AppDelegate.h"
//#import "SinaWeibo.h"
@implementation MoreCell1
{
    UILabel *titleLabel;
}

- (void)dealloc
{
    [titleLabel release];
    [super dealloc];
}

//bg_list2_up.png
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
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font  = SYSTEMFONT(15);
    [self.contentView addSubview:titleLabel];
   
}


-(void)setCellTitleString:(NSString *)titleString
{
    titleLabel.text = titleString;
}


-(void)initBtn:(int)row andSection:(int)section
{
        UIImage *bangImg = GETIMG(@"icon_next.png");
        UIButton *  rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(280, 15, bangImg.size.width, bangImg.size.height);
        [rightBtn setBackgroundImage:bangImg forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:GETIMG(@"icon_next.png") forState:UIControlStateHighlighted];
        [self.contentView addSubview:rightBtn];
    
}

-(void)setCellBackGroundView:(int)row andSection:(int)section
{
    NSString *imageName = nil;
    NSString *imageName_press = nil;
    if(section==0||section==2)
    {
        switch (row) {
            case 0:
            {
                imageName = @"bg_list2_up.png";
                imageName_press = @"bg_list2_up_press.png";

            }
                break;
            case 1:
            {
                imageName = @"bg_list2_middle.png";
                imageName_press = @"bg_list2_middle_press.png";
 
            }
                break;
            case 2:
            {
                imageName = @"bg_list2_down.png";
                imageName_press = @"bg_list2_down_press.png";
 
            }
                break;
            default:
            {
                imageName = nil;
                imageName_press = nil;
            }
                break;
        }
       
    }
    
    if(section==1)
    {
        switch (row) {
            case 0:
            {
                imageName = @"bg_list2_up.png";
                imageName_press = @"bg_list2_up_press.png";
 
            }
                break;
            case 1:
            {
                imageName = @"bg_list2_middle.png";
                imageName_press = @"bg_list2_middle_press.png";
 
            }
                break;
//            case 2:
//            {
//                imageName = @"bg_list2_middle.png";
//                imageName_press = @"bg_list2_middle_press.png";
// 
//            }
//                break;
            case 2:
            {
                imageName = @"bg_list2_down.png";
                imageName_press = @"bg_list2_down_press.png";
            }
                break;
            default:
                imageName = nil;
                imageName_press = nil;
                break;
        }
 
    }
//    NSLog(@"%@",imageName);
//    NSLog(@"%@",imageName_press);
    self.backgroundView =[[[UIImageView alloc]initWithImage:GETIMG(imageName)] autorelease];
    self.selectedBackgroundView = [[[UIImageView alloc]initWithImage:GETIMG(imageName_press) ]autorelease];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
