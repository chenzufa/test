//
//  GuideView.h
//  MeiLiYun
//
//  Created by summer on 13-10-14.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuideView;
@protocol GuideViewDelegate <NSObject>

@optional
- (void)guideView:(GuideView *)guideview clickedAtButtonIndex:(NSInteger)index;

@end

@interface GuideView : UIView

@property (nonatomic, assign) id<GuideViewDelegate> delegate;
//- (void)beginMissingAnimation;
@end
