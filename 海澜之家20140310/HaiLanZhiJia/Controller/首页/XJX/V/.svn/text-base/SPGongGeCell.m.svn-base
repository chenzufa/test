//
//  GongGeCell.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SPGongGeCell.h"
#import "NetImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "CellUnitView.h"

#define zuoBianJu 10
#define youBianJu 10
#define jianGeJu  10
#define baseTag   1
#define lieShu    2
@interface SPGongGeCell()
@property(nonatomic,retain)NSMutableArray *viewArr;
@property(nonatomic,assign)NSUInteger rankCount;
@end

@implementation SPGongGeCell
-(void)dealloc
{
    [_objects release];
    [_viewArr release];
    self.delegate=nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rankCount:(int)rankCount
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self)
    {
        [self initSubview:rankCount];
        self.rankCount = rankCount;
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubview:2];

    }
    return self;
}
-(void)initSubview:(int)rankCount
{
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat w = (320-zuoBianJu-youBianJu-(lieShu-1)*jianGeJu)/lieShu;
    CGFloat h = w;
    
    _viewArr = [[NSMutableArray arrayWithCapacity:0]retain];
    for (int i=0; i<lieShu; i++)
    {
        CellUnitView *unitView = [[CellUnitView alloc]initWithFrame:CGRectMake(x, y, w, h) tagret:self tag:baseTag+i];
        unitView.backgroundColor = [UIColor clearColor];
        unitView.cell = self;
        unitView.tag = baseTag+i;
        [self addSubview:unitView];
        [_viewArr addObject:unitView];
        unitView.hidden = YES;
        [unitView release];
        
        x=unitView.frame.origin.x+unitView.frame.size.width+jianGeJu;
    }
    
}
-(void)layoutSubviews
{
    for(int i=0;i<_viewArr.count;i++)
    {
        CellUnitView *unitView = (CellUnitView*)_viewArr[i];
        unitView.hidden = YES;
    }
    for (int i=0; i<_objects.count; i++)
    {
        CellUnitView *unitView = (CellUnitView*)_viewArr[i];
        unitView.object = _objects[i];
        [unitView setNeedsLayout];
        unitView.hidden = NO;
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma mark -- cellHeight
+(CGFloat)cellHeight:(NSArray*)objects
{
    CGFloat h1 = 140;
    
    return (10+h1+20+20+15+(isBigeriOS7version?5:0));
}
#pragma mark -- clicked
-(void)clickedButton:(UIButton*)btn
{
    NSLog(@"shangPinLieBiaoBtnTag %i",btn.tag);
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(cell:imageBtnClicked:)])
        {
            [self.delegate cell:self imageBtnClicked:btn];
        }
    }
}
@end
