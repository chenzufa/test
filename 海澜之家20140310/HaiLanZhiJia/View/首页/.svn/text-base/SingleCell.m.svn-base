//
//  SingleCell.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SingleCell.h"
#import "NetImageView.h"
#import "UIImageView+WebCache.h"
@implementation SingleCell
{
    UIImageView *prodView;
    UILabel *nameLabel;
    UILabel *muchLabel;
    UIImageView *bgView;
}

- (void)dealloc
{
    [muchLabel release];
    [bgView release];
    [prodView release];
    [nameLabel release];
    [super dealloc];
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIImageView alloc]init];
        bgView.userInteractionEnabled = YES;
        
        [self.contentView addSubview:bgView];
        
        prodView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [bgView addSubview:prodView];
        prodView.clipsToBounds = YES;
        prodView.contentMode= UIViewContentModeScaleAspectFill;
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.numberOfLines = 1;
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        muchLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        muchLabel.font = SYSTEMFONT(14);
        muchLabel.textColor = [UIColor redColor];
        muchLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:muchLabel];
        
    }
    return self;
}



-(void)creatCell:(NSString *)imageString andName:(NSString *)nameString andMuch:(NSString *)muchString
{
    UIEdgeInsets insert = UIEdgeInsetsMake(10, 10, 25, 10);
    UIImage *bgImage = GetImage(@"列表小图.png");//商品大图.png
    bgImage = [bgImage resizableImageWithCapInsets:insert];
    bgView.image = bgImage;
   
    bgView.frame = CGRectMake(10, 0, MainViewWidth-20, 160);

    [prodView setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:nil];
  //  prodView.frame = CGRectMake(15,0, 580/2, 120);
    prodView.frame = CGRectMake(2,2, MainViewWidth-20-4, 148);
  //  CGSize size = [nameString sizeWithFont:SYSTEMFONT(14) constrainedToSize:CGSizeMake(580/2, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    nameLabel.frame = CGRectMake(15, 160, MainViewWidth-20, 20);
    muchLabel.frame = CGRectMake(15, 160+20, MainViewWidth-20, 20);
    nameLabel.text = nameString;
    muchLabel.text = [NSString stringWithFormat:@"¥%@",muchString];;
      
}

+(float)getCellHeight:(GoodEntity *)goodEntity
{

//    CGSize size = [goodEntity.goodsname sizeWithFont:SYSTEMFONT(14) constrainedToSize:CGSizeMake(580/2, 1000) lineBreakMode:NSLineBreakByWordWrapping];

    return 160+45;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
