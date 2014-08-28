//
//  GongGeCell.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GongGeCell.h"

@implementation GongGeCell
{
    UIImageView *productView;
    UILabel *nameLabel;
    UILabel *muchLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        muchLabel = [[UILabel alloc]init];
        muchLabel.font = SYSTEMFONT(14);
        muchLabel.textAlignment = NSTextAlignmentCenter;
        muchLabel.backgroundColor = [UIColor clearColor];
        muchLabel.textColor = [UIColor clearColor];
        [self addSubview:productView];
        [self addSubview:nameLabel];
        [self addSubview:muchLabel];
    }
    return self;
}

-(void)creatCell:(NSString *)urlString andName:(NSString *)nameString andMuch:(NSString *)muchString
{
    UIImage *proImage = GETIMG(urlString);
    productView.frame = CGRectMake(0, 0, 290/2, proImage.size.height);
    productView.image = proImage;
    nameLabel.frame = CGRectMake(0, proImage.size.height+5, 290/2, 20);
    nameLabel.text= nameString;
    muchLabel.frame = CGRectMake(0, proImage.size.height+5+20, 290/2, 15);
    muchLabel.text = muchString;
}

-(void)creatShaiDanCell:(NSString *)urlString andName:(NSString *)nameString{
    UIImage *proImage = GETIMG(urlString);
    productView.frame = CGRectMake(0, 0, 290/2, proImage.size.height);
    productView.image = proImage;
    nameLabel.frame = CGRectMake(0, proImage.size.height+5, 290/2, 40);
    nameLabel.numberOfLines = 2;
    nameLabel.text= nameString;
    muchLabel.hidden = YES;
}

@end
