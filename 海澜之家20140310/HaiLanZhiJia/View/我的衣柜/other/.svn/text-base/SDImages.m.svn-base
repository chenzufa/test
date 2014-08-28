//
//  SDImages.m
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-4.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "SDImages.h"

@implementation SDImages
@synthesize imgViewArray = _imgViewArray;
@synthesize imgArray = _imgArray;
@synthesize point = _point;
@synthesize rect = _rect;
@synthesize count = _count;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgViewArray = [[NSMutableArray alloc] init];
        _imgArray = [[NSMutableArray alloc] init];
        self.frame = CGRectMake(0, self.frame.origin.y, 320, 154);
    }
    return self;
}

- (void)dealloc{
    [_imgViewArray release];_imgViewArray = nil;
    [_imgArray release];_imgArray = nil;
    [super dealloc];
}

- (void)initViewsWithArray:(NSArray*)array{
    [_imgArray removeAllObjects];
    [_imgArray addObjectsFromArray:array];
    
    for (int i = 0; i < self.imgArray.count; i++) {
        UIView* aview = [[UIView alloc] init];
        aview.frame = CGRectMake((i%4)*80,(i/4)*77, 67, 67);
        aview.clipsToBounds = NO;
        [self addSubview:aview];
        
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(9,7,60, 60);
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:[self.imgArray objectAtIndex:i]];
        [aview addSubview:imageView];
        [imageView release];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 1;
        [aview addGestureRecognizer:pan];
        [pan release];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(55, 0, 21, 21);
        [button setBackgroundImage:[UIImage imageNamed:@"user_icon_share_delete2@2x.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
        [aview addSubview:button];
        
        [_imgViewArray addObject:aview];
        
        [aview release];
    }
}

- (void)panGesture:(UIPanGestureRecognizer*)gesture{
    [self insertSubview:gesture.view atIndex:_imgViewArray.count - 1];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _point = [gesture locationInView:gesture.view.superview.superview]; //拖拽时以当前窗口为基准
    }
    if (gesture.state == UIGestureRecognizerStateChanged && gesture.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [gesture locationInView:gesture.view.superview.superview];
        if (_point.x != location.x && _point.y != location.y) {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint p = gesture.view.center;
                p.x = p.x - _point.x + location.x;
                p.y = p.y - _point.y + location.y;
                gesture.view.center = p;
                _point = location;
                if ([self needExchange:gesture.view]) {
                    int l = [self locationAtView:gesture.view];
                    int idx = [_imgViewArray indexOfObject:gesture.view];
                    NSLog(@"%d,%d",idx,l);
                    if (l >= _imgViewArray.count || idx >= _imgViewArray.count || l == idx) {
                        return ;
                    }/*else{
                        for (int i = MIN(l, idx); i <= MAX(l, idx) - 1; i++) {
                            [_imgViewArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }*/

                    if (idx < l) {
                        for (int i = MIN(l, idx); i <= MAX(l, idx) - 1; i++) {
                            [_imgViewArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                            [_imgArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                        for (int i = idx; i < l; i++) {
                            [(UIView*)[_imgViewArray objectAtIndex:i] setFrame:CGRectMake((i%4)*80,(i/4)*77, 67, 67)];
                        }
                    }else{
                        for (int i = MAX(l, idx); i >= MIN(l, idx) + 1; i--) {
                            [_imgViewArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                            [_imgArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                        }
                        for (int i = l+1; i <= idx; i++) {
                            [(UIView*)[_imgViewArray objectAtIndex:i] setFrame:CGRectMake((i%4)*80,(i/4)*77, 67, 67)];
                        }
                    }
                }
            }];
        }
    }else{
        NSLog(@"手势识别失败");
    }
    if (gesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.3 animations:^{
            gesture.view.frame = CGRectMake(([_imgViewArray indexOfObject:gesture.view]%4)*80,([_imgViewArray indexOfObject:gesture.view]/4)*77, 67, 67);
        }];
    }
}

- (BOOL)needExchange:(UIView*)view{
    int idx = [_imgViewArray indexOfObject:view];
    _rect = CGRectMake((idx%4)*80,(idx/4)*77, 67, 67);
    BOOL isTrue;
    CGRect r = view.frame;
    NSLog(@"%f,%f-------%f,%f",r.origin.x,r.origin.y,_rect.origin.x,_rect.origin.y);
    
    NSLog(@"%f",_rect.size.width/2.00);
    
    if (fabs(_rect.origin.x - r.origin.x) > 40 && r.origin.x > 0 && r.origin.x < 240 && idx <= _imgViewArray.count) {
        isTrue = YES;
    }else if (fabs(_rect.origin.y - r.origin.y) > 38.5 && r.origin.y > 0){
        isTrue = YES;
    }else{
        isTrue = NO;
    }
    return isTrue;
}

- (NSInteger)locationAtView:(UIView*)view{
    int idx = [_imgViewArray indexOfObject:view];
    _rect = CGRectMake((idx%4)*80,(idx/4)*77, 67, 67);
    CGRect r = view.frame;
    
    if (fabs(_rect.origin.x - r.origin.x) > 40 && r.origin.x > 0 && r.origin.x < 240 && r.origin.y > 0) {
        if (_rect.origin.x > r.origin.x){
            if (round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4  >= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 ;
            }
        }else{
            if (round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4>= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 ;
            }
        }
    }else if (fabs(_rect.origin.x - r.origin.x) > 40 && r.origin.x > 0 && r.origin.x < 240 && r.origin.y < 0) {
        if (_rect.origin.x > r.origin.x){
            /*if (round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 -5 >= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 -5;
            }*/
            return round(fabs(r.origin.x) / 80.0) ;
        }else{
            /*if (round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 - 4>= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 - 4;
            }*/
            return round(fabs(r.origin.x) / 80.0) ;
        }
    }else if (fabs(_rect.origin.y - r.origin.y) > r.size.height / 2.00 && r.origin.y > 0){
        if (_rect.origin.y > r.origin.y){
            if (round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 - 4 >= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 ;
            }
        }else{
            if (round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 >= _imgViewArray.count) {
                return _imgViewArray.count - 1;
            }else{
                return round(fabs(r.origin.x) / 80) + round(fabs(r.origin.y) / 77)*4 ;
            }
        }
    }else{
        
    }
    
    /*if(  round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 >=_imgViewArray.count){
        return _imgViewArray.count - 1;
    }else if (round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 <= 0){
        return 0;
    }else{
        if (_rect.origin.x > r.origin.x){
            return round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 -1;
        }else if (_rect.origin.y > r.origin.y){
            return round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 -4;
        }else{
            return round(fabs(r.origin.x) / r.size.width) + round(fabs(r.origin.y) / r.size.height)*4 ;
        }
    }*/
}

- (void)deletePicture:(UIButton*)sender{
    NSLog(@"click");
    
    if (_imgArray.count == 0) {
        return;
    }
    
    int index = [_imgViewArray indexOfObject:sender.superview];
    
    [self.imgArray removeObjectAtIndex:index];
    [(UIView*)[_imgViewArray objectAtIndex:index] removeFromSuperview];
    [_imgViewArray removeObjectAtIndex:index];
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteImageIn:andIndex:)]){
        [self.delegate deleteImageIn:self andIndex:index];
    }
    for (int i = index; i<_imgViewArray.count; i++) {
        [UIView animateWithDuration:0.3 animations:^{
            [(UIView*)[_imgViewArray objectAtIndex:i] setFrame:CGRectMake((i%4)*80,(i/4)*77, 67, 67)];
        }];
    }
    _count = _imgViewArray.count;
}

- (void)refreshData{
    for (int i =  _count; i < self.imgArray.count; i++) {
        UIView* aview = [[UIView alloc] init];
        aview.frame = CGRectMake((i%4)*80,(i/4)*77, 67, 67);
        aview.clipsToBounds = NO;
        [self addSubview:aview];
        
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(9,7,60, 60);
        imageView.userInteractionEnabled = YES;
        imageView.image = [self.imgArray objectAtIndex:i];
        [aview addSubview:imageView];
        [imageView release];
        
        UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        pan.minimumNumberOfTouches = 1;
        pan.maximumNumberOfTouches = 1;
        [aview addGestureRecognizer:pan];
        [pan release];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(55, 0, 21, 21);
        [button setBackgroundImage:[UIImage imageNamed:@"user_icon_share_delete2@2x.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
        [aview addSubview:button];
        
        [_imgViewArray addObject:aview];
    }
    _count = _imgViewArray.count;
}

@end
