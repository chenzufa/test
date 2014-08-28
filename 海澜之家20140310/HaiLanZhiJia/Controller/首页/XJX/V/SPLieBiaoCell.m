//
//  SPLieBiaoCell.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SPLieBiaoCell.h"
#import "NetImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface SPLieBiaoCell()
@property(nonatomic,retain)UIImageView *imageView_;
@property(nonatomic,retain)UILabel*nameLabel;
@property(nonatomic,retain)UILabel*jiaGeLabel;
@property(nonatomic,retain)UILabel*yanSeLabel;
@end

@implementation SPLieBiaoCell
-(void)dealloc
{
    [_nameLabel release];_nameLabel=nil;
    [_jiaGeLabel release];_jiaGeLabel=nil;
    [_yanSeLabel release];_yanSeLabel=nil;
    [_imageView_ release];_imageView_=nil;
    [_object release];_object=nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat x = 15;
        CGFloat y = 7;
        CGFloat w = 100;
        CGFloat h = 100;
        
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        view.image = [UIImage imageNamed:@"列表小图.png"];
        [self addSubview:view];
        [view release];
        
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(x+3,y+3,w-6,h-10)];
        [self addSubview:imageV];
        self.imageView_=imageV;
        [imageV release];
        
        x=imageV.frame.origin.x+imageV.frame.size.width+10;
        y=14;
        w=190;
        h=40;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.font = [UIFont systemFontOfSize:14];
        nameL.textColor = RGBCOLOR(62,62,62);
        nameL.numberOfLines = 2;
        [self addSubview:nameL];
        self.nameLabel = nameL;
        [nameL release];
        
        y=nameL.frame.origin.y+nameL.frame.size.height+25;
        w=190;
        h=15;
        UILabel *jiaGeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
        jiaGeL.backgroundColor = [UIColor clearColor];
        jiaGeL.textAlignment = NSTextAlignmentLeft;
        jiaGeL.font = [UIFont systemFontOfSize:14];
        jiaGeL.textColor = RGBCOLOR(220,40,49);
        jiaGeL.numberOfLines = 0;
        [self addSubview:jiaGeL];
        self.jiaGeLabel = jiaGeL;
        [jiaGeL release];
        
        y=jiaGeL.frame.origin.y+jiaGeL.frame.size.height;
        w=190;
        h=20;
        UILabel *yanSeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 20))];
        yanSeL.backgroundColor = [UIColor clearColor];
        yanSeL.textAlignment = NSTextAlignmentLeft;
        yanSeL.font = [UIFont systemFontOfSize:14];
        yanSeL.textColor = RGBCOLOR(60,60,60);
        yanSeL.numberOfLines = 0;
        [self addSubview:yanSeL];
        self.yanSeLabel = yanSeL;
        [yanSeL release];
        
        UIImage *yI = GetImage(@"mall_button_choose@2x.png");
        x=210;
        y=75;
        w=yI.size.width/2.0;
        h=yI.size.height/2.0;
        UIButton *yanSeChiMaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [yanSeChiMaBtn setBackgroundImage:yI forState:UIControlStateNormal];
        [yanSeChiMaBtn setBackgroundImage:GetImage(@"mall_button_choose_press@2x.png") forState:UIControlStateHighlighted];
        [yanSeChiMaBtn setFrame:CGRectMake(x,y,w,h)];
        [yanSeChiMaBtn addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
        //[self addSubview:yanSeChiMaBtn];
        
        /*UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
        x = 0;
        y = 0-0.5;
        w = 320;
        h = lineImage.size.height/2;
        UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView.image=lineImage;
        [self addSubview:lingImageView];
        [lingImageView release];*/
        
        UIImage *lineImage2=[UIImage imageNamed:@"division line.png"];
        x = 0;
        y = [[self class]cellHeight:nil]-0.5;
        w = 320;
        h = lineImage2.size.height/2;
        UIImageView *lingImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView2.image=lineImage2;
        [self addSubview:lingImageView2];
        [lingImageView2 release];
    }
    return self;
}

-(void)layoutSubviews
{
    [self.imageView_ setImageWithURL:[NSURL URLWithString:_object.goodsimg] placeholderImage:[UIImage imageNamed:@""]];
    
    //CGRect nameF = _nameLabel.frame;
    //nameF.size.height = MAX([_object.goodsname sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, MAXFLOAT)].height, 30);
    //_nameLabel.frame = nameF;
    _nameLabel.text = _object.goodsname;
    NSString *xPStr = @"";
    if ([_object.price  hasPrefix:@"¥"])
    {
        xPStr = _object.price;
    }else
    {
        xPStr = [NSString stringWithFormat:@"¥%@",_object.price];
    }
    _jiaGeLabel.text = xPStr;
    _yanSeLabel.text = @"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma mark -- cellHeight
+(CGFloat)cellHeight:(GoodEntity*)entity
{
    return 110;
}

@end
