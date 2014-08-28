//
//  PullImageCell.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "PullImageCell.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"

@implementation PullImageCell
{
    UIImageView *productView;
    UILabel *nameLabel;
    UILabel *muchLabel;
    NSMutableArray *heightAry;
}

- (void)dealloc
{
    self.imageView = nil;
    self.titleLable = nil;
    [productView release];
    [nameLabel release];
    [muchLabel release];
    [super dealloc];
}

-(void)clickPuBuCell:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"ddddddddd:%d",[singleTap view].tag);//selectell
    int tag = [singleTap view].tag;
    if(self.delgate &&[self.delgate respondsToSelector:@selector(selectPuBuCell:)])
    {
        [self.delgate selectPuBuCell:tag];
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = UITextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        
        muchLabel = [[UILabel alloc]init];
        muchLabel.font = SYSTEMFONT(14);
        muchLabel.textAlignment = NSTextAlignmentCenter;
        muchLabel.backgroundColor = [UIColor clearColor];
        muchLabel.textColor = [UIColor redColor];
        [self addSubview:productView];
        [self addSubview:nameLabel];
        [self addSubview:muchLabel];
        if(!heightAry)
        {
            heightAry = [[NSMutableArray alloc]initWithObjects:@"200",@"170",@"230",@"222",@"190",@"144",@"179",@"150",@"190",@"230", nil];
        }
        
    }
    return self;
}


-(void)creatCell:(NSString *)urlString andName:(NSString *)nameString andMuch:(NSString *)muchString andIndex:(int)indexCell
{
    int someHeight = indexCell%10;
     productView.clipsToBounds = YES;
    productView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPuBuCell:)];
    [productView addGestureRecognizer:tap];
    UIView *singleTapView = [tap view];
    singleTapView.tag = indexCell;
    [tap release];
    
    
    int height = [[heightAry objectAtIndex:someHeight] intValue];
    productView.contentMode = UIViewContentModeScaleAspectFill;
    productView.frame = CGRectMake(0, 0, 290/2+3, height);
    [productView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:GetImage(@"home_photo.png")];
    nameLabel.text= nameString;
    CGSize size = [nameString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290/2, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    if(size.height>34.0)
    {
        size.height = 34.0;
    }
    nameLabel.frame = CGRectMake(0, height, 290/2+3, size.height);
    muchLabel.frame = CGRectMake(0,  height+size.height, 290/2+3, 20);
    muchLabel.text = [NSString stringWithFormat:@"¥%@",muchString];
}



+(float)getCellHeight :(GoodEntity *)goodEntity andIndex:(int)indexCell
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:@"200",@"170",@"230",@"222",@"190",@"144",@"179",@"150",@"190",@"230", nil];
     int someHeight = indexCell%10;
    int height = [[array objectAtIndex:someHeight] intValue];
    CGSize size = [goodEntity.goodsname sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(290/2, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    if(size.height>34.0)
    {
        size.height = 34.0;
    }
    [array release];
    return height+size.height+20;
   
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [imageView setImageWithURL:[NSURL URLWithString:[object objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"商品大图.png"]];
//    
//    //UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"url"]]]];
//    if (imageView.image) {
//        height += floorf(imageView.image.size.height / (imageView.image.size.width / width));
//    }
//    [imageView release];
//    int height = 0.0;
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView setImageWithURL:[NSURL URLWithString:goodEntity.goodsimg] placeholderImage:nil];
//    [imageView sizeToFit];
//    height +=imageView.frame.size.height;
    
  //  NSString *title = goodEntity.goodsname;
//    int someHeight = arc4random()%9;
//    int height = [[heightAry objectAtIndex:someHeight] intValue];
    
    
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
