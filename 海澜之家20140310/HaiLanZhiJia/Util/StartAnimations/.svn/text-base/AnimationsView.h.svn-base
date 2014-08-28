//
//  AnimationsView.h
//  Donson template
//
//  Created by 陈双龙 on 12-11-9.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@class AnimationsView;

// 动画类型
typedef enum {
    eVideo = 0,     // 播放一个视频作动画效果
    eFadeImage,     // 淡入一张图片做动画效果
    eFrame          // 特定方式播放帧动画
}AnimationsType;


// 动画视图委托
@protocol AnimationsViewDelegate <NSObject>

- (void) animationsFinish:(AnimationsView*) animationsView;
- (void) animationsStart:(AnimationsView*) animationsView;

@end


// 动画视图
@interface AnimationsView : UIView
{
    AnimationsType _animationsType;             // 动画类型
    UIImage     *_fadeImage;                    // 淡入效果使用的图片
    NSString    *_videoName;                    // 视频名称
    NSBundle    *_frameImageBundle;             // 帧动画的图片资源bundel
    id<AnimationsViewDelegate> _delegate;       // 事件监听
    UIImageView *animationimg;
    
    MPMoviePlayerController *aMovie;
    
}

@property (nonatomic, assign) AnimationsType animationsType;        // 动画类型
@property (nonatomic, retain) UIImage *fadeImage;                   // 淡入效果使用的图片
@property (nonatomic, retain) NSString *videoName;                  // 视频名称
@property (nonatomic, retain) NSBundle *frameImageBundle;           // 帧动画的图片资源bundel
@property (nonatomic, assign) id<AnimationsViewDelegate> delegate;  // 事件监听


/**
 @功能:启动动画
 @参数:无
 @返回值:无
 */
- (void) startAnimations;


/**
 @功能:停止动画
 @参数:无
 @返回值:无
 */
- (void) stopAnimations;

@end
