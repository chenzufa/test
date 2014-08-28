//
//  LunBoView.h
//  LunBoDemo
//
//  Created by apple on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomUIPageControl.h"

@protocol LunBoViewDelegate <NSObject>

@optional
- (void)imageSelected:(NSString*)str;
- (void)updateTitleContentDelegateAction:(int)current_page_index;
- (void)clickLunBoImgDelegateAction:(int)img_index;
- (void) handletapImage:(UIImageView *) imageview;
@end

@interface LunBoView : UIView <UIScrollViewDelegate, CustomUIPageControlDelegate>
{
    id <LunBoViewDelegate>          _delegate;
    
    NSMutableArray                  *_images;
    UIScrollView                    *_scrollView;
    
    NSTimer                         *_timer;
    NSInteger                       _currentIndex;
    
    UIImageView                     *_pageControlBG;
    CustomUIPageControl             *_pageControl;
    UILabel                         *_focus_title_Lab;
}

@property (assign) id <LunBoViewDelegate>                       delegate;
@property (nonatomic, retain) NSMutableArray                    *images;
@property (nonatomic, retain) UIScrollView                      *scrollView;
@property (nonatomic, retain) UIImageView                       *pageControlBG;
//@property (nonatomic, retain) CustomUIPageControl               *pageControl;//hu
@property (nonatomic, retain) UIPageControl               *pageControl;
@property (nonatomic, retain) UILabel                           *focus_title_Lab;

- (void)setLunBoData:(NSMutableArray*)array;
- (void)setLunBoImage:(NSMutableArray*)array;
- (void)hiddenDots;
- (void)start;
- (void)stop;

@end
