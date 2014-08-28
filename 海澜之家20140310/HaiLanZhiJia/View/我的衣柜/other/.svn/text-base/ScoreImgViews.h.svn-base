//
//  ScoreImgViews.h
//  MeiLiYun
//
//  Created by summer on 13-10-9.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScoreImgViews;
@protocol ScoreImgViewsDelegate <NSObject>

@optional
- (void)scoreImgViews:(ScoreImgViews *)scoreView clickedScore:(int)score;

@end

@interface ScoreImgViews : UIView

- (void)scoreImageViewWithScore:(NSInteger)score;

@property (assign, nonatomic) id <ScoreImgViewsDelegate> delegate;
@end
