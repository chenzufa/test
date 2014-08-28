//
//  ShouQianZiXunCell.m
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "ShouQianZiXunCell.h"
@interface ShouQianZiXunCell()
@property(nonatomic,retain)UILabel*nameLabel;
@property(nonatomic,retain)UILabel*timeLabel;
@property(nonatomic,retain)UILabel*commentLabel;//问题
@property(nonatomic,retain)UILabel*huiFuLabel;
//@property(nonatomic,retain)UIImageView *line1;
@property(nonatomic,retain)UIImageView *line2;
@property(nonatomic,retain)UIImageView *answerV;
@property(nonatomic,retain)UILabel *isAgree;
@end
@implementation ShouQianZiXunCell
-(void)dealloc
{
    [_nameLabel release];_nameLabel=nil;
    [_timeLabel release];_timeLabel=nil;
    [_commentLabel release];_commentLabel=nil;
    [_huiFuLabel release];_huiFuLabel=nil;
    //[_line1 release];_line1=nil;
    [_line2 release];_line2=nil;
    [_ziXunObject release];_ziXunObject=nil;
    [_isAgree release];_isAgree=nil;
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
        CGFloat y = -0.5;
        CGFloat w = 320;
        CGFloat h ;//= lineImage.size.height/2;
        /*
        UIImageView *lingImageView=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        lingImageView.image=lineImage;
        [self addSubview:lingImageView];
        self.line1=lingImageView;
        [lingImageView release];*/
        
        x=10;
        y=5;
        w=120;
        h=30;
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.textAlignment = NSTextAlignmentLeft;
        nameL.font = [UIFont systemFontOfSize:12];
        nameL.textColor = RGBCOLOR(186,180,180);
        nameL.numberOfLines = 0;
        [self addSubview:nameL];
        self.nameLabel = nameL;
        [nameL release];
        
        UILabel *isAgreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x+w, 5, 60, 30)];
        isAgreeLabel.backgroundColor = [UIColor clearColor];
        isAgreeLabel.textAlignment =NSTextAlignmentLeft;
        isAgreeLabel.font = [UIFont systemFontOfSize:10];
        isAgreeLabel.textColor = RGBCOLOR(186,180,180);
        isAgreeLabel.numberOfLines = 1;
        [self addSubview:isAgreeLabel];
        self.isAgree = isAgreeLabel;
        [isAgreeLabel release];

        
        
        x=160;
        y=5;
        w=150;
        h=30;
        UILabel *timeL = [[UILabel alloc]initWithFrame:CGRectMake(x,y,w,MAX(h, 30))];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.textAlignment = NSTextAlignmentRight;
        timeL.font = [UIFont systemFontOfSize:12];
        timeL.textColor = RGBCOLOR(186,180,180);
        timeL.numberOfLines = 0;
        [self addSubview:timeL];
        self.timeLabel = timeL;
        [timeL release];
        
        UIImage *qI=[UIImage imageNamed:@"mall_icon_question@2x.png"];
        x = 10;
        y = nameL.frame.origin.y+nameL.frame.size.height+5;
        w = 15;
        h = 15;
        UIImageView *qV=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        qV.image=qI;
        [self addSubview:qV];
        [qV release];
        
        x=30;
        y=nameL.frame.origin.y+nameL.frame.size.height+5;
        w=280;
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
        
        UIImage *aI=[UIImage imageNamed:@"mall_details_icon_answer@2x.png"];
         x = 10;
         y = commentL.frame.size.height+commentL.frame.origin.y+5;
         w = 15;
         h = 15;
        UIImageView *aV=[[UIImageView alloc]initWithFrame:CGRectMake(x,y,w,h)];
        aV.image=aI;
        [self addSubview:aV];
        self.answerV = aV;
        [aV release];
        
        x=30;
        y=commentL.frame.size.height+commentL.frame.origin.y+5;
        w=280;
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
    if (_ziXunObject.username)
    {
        nameLength=_ziXunObject.username.length;
        
        if (nameLength==2||nameLength==1)
        {
            nameM = [NSString stringWithFormat:@"%@***",[_ziXunObject.username substringToIndex:1]];
        }
        if (nameLength>=3)
        {
          nameM = [NSString stringWithFormat:@"%@***%@",[_ziXunObject.username substringToIndex:1],[_ziXunObject.username substringFromIndex:nameLength-1]];
        }
        
    }else {
        nameM = @"";
    }
    
    _nameLabel.text = nameM;
    _timeLabel.text = _ziXunObject.date;
    _commentLabel.text = _ziXunObject.question;
    _huiFuLabel.text = _ziXunObject.answer;
    if(_ziXunObject.approved)
    {
        _isAgree.text = @"";
    }
    else
    {
       _isAgree.text = @"";
    }
    
    
    CGRect commentF =  _commentLabel.frame;
    commentF.size.height = [_ziXunObject.question sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    _commentLabel.frame = commentF;
    
    CGRect huiFuF =  _huiFuLabel.frame;
    huiFuF.size.height = [_ziXunObject.answer sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    huiFuF.origin.y=_commentLabel.frame.size.height+_commentLabel.frame.origin.y+5;
    _huiFuLabel.frame = huiFuF;
    
    /*CGRect line1F =  _line1.frame;
    line1F.origin.y=0;
    _line1.frame = line1F;*/
    
    CGRect line2F =  _line2.frame;
    line2F.origin.y=_huiFuLabel.frame.size.height+_huiFuLabel.frame.origin.y+4.5;
    _line2.frame = line2F;
    
    CGRect aVF =  _answerV.frame;
    aVF.origin.y=_huiFuLabel.frame.origin.y;
    _answerV.frame = aVF;
    
    if (_ziXunObject.answer.length==0) {
        self.answerV.hidden = YES;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
#pragma mark -- cellHeight
+(CGFloat)cellHeight:(SaleConsultEntity*)entity
{
    CGFloat height=0;
    CGFloat h1 = [entity.question sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    CGFloat h2 = [entity.answer sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, MAXFLOAT)].height;
    height = 5+30+5+h1+5+h2+5;
    return height;
}
@end
