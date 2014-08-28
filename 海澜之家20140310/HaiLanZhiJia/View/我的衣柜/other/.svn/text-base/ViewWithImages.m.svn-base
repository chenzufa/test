//
//  ViewWithImages.m
//  MeiLiYun
//
//  Created by summer on 13-10-9.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import "ViewWithImages.h"

@implementation ViewWithImages
- (void)dealloc
{
    self.images = nil;    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setShowsHorizontalScrollIndicator:NO];
//        [self setUserInteractionEnabled:YES];
    }
    return self;
}
- (void)createImageViews
{
    if (self.images.count > 0) {
        for (int i = 0; i < self.images.count; i ++) {
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i*80, 0, 60, 60)];
            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.clipsToBounds = YES;
//            imageview.image =[UIImage imageNamed:@"列表小图.png"];
            [imageview setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:i]] placeholderImage:GetImage(@"列表小图.png")];
            imageview.userInteractionEnabled = YES;
            imageview.tag = 1000+i;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imageview addGestureRecognizer:tap];
            [tap release];
            
            [self addSubview:imageview];
            [imageview release];
            if (i == 3) {
                break;
            }
        }
        [self setFrame:CGRectMake(0, self.frame.origin.y, 320, 60)];
        [self setCenter:CGPointMake(160, self.center.y)];
        [self setContentSize:CGSizeMake(80 * MIN(4, self.images.count) - 19, 0)];
    }
}

- (void)tapAction:(UITapGestureRecognizer*)gesture{
    if (self.viewWithImagesDelegate && [self.viewWithImagesDelegate respondsToSelector:@selector(selectedImg:atIndex:)]) {
        [self.viewWithImagesDelegate selectedImg:self atIndex:([gesture view].tag - 1000)];
    }
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
