//
//  UserCommentCell.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//
#import "UserCommentCell.h"
#import "ScoreImgViews.h"
#define kShaiDanWidth 57
@interface UserCommentCell()<SwipeViewDataSource,SwipeViewDelegate>
@property(nonatomic,retain)UILabel*nameLabel;
@property(nonatomic,retain)UILabel*timeLabel;
@property(nonatomic,retain)UILabel*commentLabel;
@property(nonatomic,retain)UILabel*huiFuLabel;
//@property(nonatomic,retain)UIImageView *line1;
@property(nonatomic,retain)UIImageView *line2;
@property(nonatomic,retain)SwipeView *scrollView;
@property(nonatomic,retain)ScoreImgViews *scoreImgView;
@end
@implementation UserCommentCell
-(void)dealloc
{
    [_nameLabel release];_nameLabel=nil;
    [_timeLabel release];_timeLabel=nil;
    [_commentLabel release];_commentLabel=nil;
    [_huiFuLabel release];_huiFuLabel=nil;
    //[_line1 release];_line1=nil;
    [_line2 release];_line2=nil;
    [_commentObject release];_commentObject=nil;
    [_scrollView release];_scrollView=nil;
    self.delegate=nil;
    self.scoreImgView=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    if (self)
    {
        UIImage *lineImage=[UIImage imageNamed:@"division line.png"];
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = 320;
        CGFloat h ;//= lineImage.size.height/2;
        /*UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView.image=lineImage;
        [self addSubview:lingImageView];
        self.line1=lingImageView;
        [lingImageView release];*/

        
        x=10;
        y=5;
        w=200;
        h=15;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,15))];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.font = [UIFont systemFontOfSize:12];
        nameL.textColor = ColorFontgray;
        nameL.numberOfLines = 0;
        [self addSubview:nameL];
        self.nameLabel = nameL;
        [nameL release];
        
         x=160;
         y=5;
         w=150;
         h=15;
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,15))];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.textAlignment = NSTextAlignmentRight;
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.textColor = ColorFontgray;
        timeL.numberOfLines = 0;
        [self addSubview:timeL];
        self.timeLabel = timeL;
        [timeL release];
        
        x=10;
        y=nameL.frame.origin.y+nameL.frame.size.height+5;
        w=300;
        h=30;
        UILabel *commentL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        commentL.backgroundColor = [UIColor clearColor];
        commentL.textAlignment = NSTextAlignmentLeft;
        commentL.font = [UIFont systemFontOfSize:14];
        commentL.textColor = RGBCOLOR(60,60,60);
        commentL.numberOfLines = 0;
        [self addSubview:commentL];
        self.commentLabel = commentL;
        [commentL release];
        
        x=10;
        y=_commentLabel.frame.size.height+_commentLabel.frame.origin.y;
        w=300;
        h=kShaiDanWidth;
        SwipeView *sv = [[SwipeView alloc]initWithFrame: CGRectMake(x,y,w,h)];
        self.scrollView = sv;
        _scrollView.bounces = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.wrapEnabled = YES;//循环
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.dataSource = self;
        
        [self  addSubview:sv];
        [sv release];
        
        x=10;
        y=_scrollView.frame.size.height+_scrollView.frame.origin.y+5;
        w=300;
        h=30;
        UILabel *huiFuL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        huiFuL.backgroundColor = [UIColor clearColor];
        huiFuL.textAlignment = NSTextAlignmentLeft;
        huiFuL.font = [UIFont systemFontOfSize:14];
        huiFuL.textColor = RGBCOLOR(234,82,89);
        huiFuL.numberOfLines = 0;
        [self addSubview:huiFuL];
        self.huiFuLabel = huiFuL;
        [huiFuL release];
        
        x=71;
        y=_scrollView.frame.size.height+_scrollView.frame.origin.y+5;
        ScoreImgViews *imgScore = [[ScoreImgViews alloc]initWithFrame:CGRectMake(x,y, 50, 50)];
        [self addSubview:imgScore];
        self.scoreImgView = imgScore;
        [imgScore release];
        
        x=-61;
        y=2;
        w=61;
        h=15;
        UILabel *pingFenL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h,15))];
        pingFenL.backgroundColor = [UIColor clearColor];
        pingFenL.textAlignment = NSTextAlignmentLeft;
        pingFenL.font = [UIFont systemFontOfSize:12];
        pingFenL.textColor = ColorFontgray;
        pingFenL.text = @"综合评分:";
        [self.scoreImgView addSubview:pingFenL];
        [pingFenL release];
        
         x = 0;
         y=huiFuL.frame.size.height+huiFuL.frame.origin.y+5;
         w = 320;
         h = lineImage.size.height/2;
        UIImageView *lingImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView2.image=lineImage;
        [self addSubview:lingImageView2];
        self.line2=lingImageView2;
        [lingImageView2 release];
        
        
    }
    return self;
}
-(void)layoutSubviews
{
    int nameLength = 0;
    NSString *nameM=nil;
    if (_commentObject.username)
    {
        nameLength=_commentObject.username.length;
        
        if (nameLength==2||nameLength==1)
        {
            nameM = [NSString stringWithFormat:@"%@***",[_commentObject.username substringToIndex:1]];
        }
        if (nameLength>=3)
        {
            nameM = [NSString stringWithFormat:@"%@***%@",[_commentObject.username substringToIndex:1],[_commentObject.username substringFromIndex:nameLength-1]];
        }
        
    }else {
      nameM = @"";
    }
    

    _nameLabel.text = nameM;
    _timeLabel.text = _commentObject.date;
    _commentLabel.text = _commentObject.comment;
    _huiFuLabel.text = [NSString stringWithFormat:@"回复:%@",_commentObject.csr];
    
   CGRect commentF =  _commentLabel.frame;
    commentF.size.height = MAX([_commentObject.comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height, 15);
    if ([_commentObject.comment isKindOfClass:NSNull.class])
    {
        _commentObject.comment=@"";
    }
    if (_commentObject.comment.length==0)
    {
        commentF.size.height=0;
    }
    _commentLabel.frame = commentF;
    CGFloat y = _commentLabel.frame.origin.y+_commentLabel.frame.size.height+5;
    
    if (self.commentObject.thumbnailimg.count>0)
    {
        _scrollView.frame = CGRectMake(10,y,300,kShaiDanWidth);
        [_scrollView reloadData];
        y = _scrollView.frame.origin.y+_scrollView.frame.size.height+5;
    }else
    {
        _scrollView.frame = CGRectMake(10,y,300,0);
    }
    
    CGRect pingFenF = _scoreImgView.frame;
    pingFenF.origin.y=y;
    _scoreImgView.frame = pingFenF;
    if (_commentObject.score!=-1)
    {
        _scoreImgView.hidden = NO;
        [_scoreImgView scoreImageViewWithScore:_commentObject.score];
        _scoreImgView.backgroundColor = [UIColor clearColor];
    }else
    {
        pingFenF.size.height=0;
        _scoreImgView.frame = pingFenF;
      _scoreImgView.hidden = YES;
    }
    
    
    y= _scoreImgView.frame.size.height+_scoreImgView.frame.origin.y+5;
    CGRect huiFuF =  _huiFuLabel.frame;
    huiFuF.size.height = MAX([([_commentObject.csr isKindOfClass:NSNull.class])?@"":_commentObject.csr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height, 15);
    if ([_commentObject.csr isKindOfClass:NSNull.class])
    {
        _commentObject.csr=@"";
    }
    if (_commentObject.csr.length==0)
    {
        huiFuF.size.height=0;
    }
    huiFuF.origin.y=y;
    _huiFuLabel.frame = huiFuF;
    _huiFuLabel.backgroundColor = [UIColor clearColor];
    
    /*CGRect line1F =  _line1.frame;
    line1F.origin.y=-0.5;
    _line1.frame = line1F;*/
    
    CGRect line2F =  _line2.frame;
    line2F.origin.y=[[self class]cellHeight:self.commentObject]-0.5;
    _line2.frame = line2F;
    [self initBtn];
    
    if(self.commentObject.thumbnailimg.count< 6)
    {
        _scrollView.scrollEnabled = NO;
    }

}

-(void)initBtn
{
    if(self.commentObject.thumbnailimg.count>5)
    {
        
        UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *leftImage=[UIImage imageNamed:@"home_icon_left.png"];
        leftBtn.frame=CGRectMake(-3, 50, 15, 40);
        [leftBtn setBackgroundColor:[UIColor clearColor]];
        [leftBtn setImage:leftImage forState:UIControlStateNormal];
        [self.contentView addSubview:leftBtn];
       
        
        
        UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *rightImage=[UIImage imageNamed:@"home_icon_right.png"];
        rightBtn.frame=CGRectMake(MainViewWidth-12, 50, 15, 40);
        [rightBtn setBackgroundColor:[UIColor clearColor]];
        [rightBtn setImage:rightImage forState:UIControlStateNormal];
       
        [self.contentView addSubview:rightBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma mark -- cellHeight
+(CGFloat)cellHeight:(UserCommentEntity*)entity
{
    if ([entity.comment isKindOfClass:NSNull.class])
    {
        entity.comment=@"";
    }
    if ([entity.csr isKindOfClass:NSNull.class])
    {
        entity.csr=@"";
    }
    
    CGFloat height=0;
    CGFloat h1 = [entity.comment sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    CGFloat h2 = [entity.csr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, MAXFLOAT)].height;
    CGFloat h3 = (entity.thumbnailimg.count>0)?kShaiDanWidth:0;
    height = 5+15+5+(entity.comment.length>0?MAX(h1, 15):0)+5+(entity.csr.length>0?MAX(h2,15):0)+5+h3+5+((entity.score==-1)?0:20);
    return height;
}
#pragma mark -- swipeViewDelegate
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.commentObject.thumbnailimg.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil)
    {
        view = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,61.0f,60.0f)] autorelease];
        
        UIImageView *ditu = [[UIImageView alloc]initWithFrame:CGRectMake(0,1,kShaiDanWidth,58)];
        ditu.image = [UIImage imageNamed:@"列表小图.png"];
        ditu.userInteractionEnabled = YES;
        [view addSubview:ditu];
        [ditu release];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(1.5,2.6,53.8,52.5)];
        [imageV setImageWithURL:[NSURL URLWithString:self.commentObject.thumbnailimg[index]] placeholderImage:[UIImage imageNamed:@""]];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 0x1001;
        imageV.clipsToBounds = YES;
        [view addSubview:imageV];
        [imageV release];
    }else
    {
        UIImageView *imageV = (UIImageView*)[view viewWithTag:0x1001];
        [imageV setImageWithURL:[NSURL URLWithString:self.commentObject.thumbnailimg[index]] placeholderImage:[UIImage imageNamed:@""]];
    }
    return view;
}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView
{
}
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:scrollView:clickedAtIndex:)])
    {
        [self.delegate cell:self scrollView:swipeView clickedAtIndex:index];
    }
}

@end
