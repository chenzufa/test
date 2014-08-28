//
//  ColurCell.m
//  HaiLanZhiJia
//
//  Created by creaver on 13-12-11.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ColurCell.h"
#import "UIImageView+WebCache.h"
@implementation ColurCell
{
    UIImageView *productView;
    
    
}

- (void)dealloc
{
    [productView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        productView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:productView];
        
        
    }
    return self;
}

-(void)creatView:(NSString *)urlString
{
    productView.frame = CGRectMake(5, 5, 80, 80);
    NSURL *url = [NSURL URLWithString:urlString];
    [productView setImageWithURL:url placeholderImage:GetImage(@"列表小图.png")];
    
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
