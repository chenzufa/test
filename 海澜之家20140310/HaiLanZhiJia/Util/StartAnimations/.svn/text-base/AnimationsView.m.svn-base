//
//  AnimationsView.m
//  Donson template
//
//  Created by 陈双龙 on 12-11-9.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "AnimationsView.h"
#import "ImageAnimation.h"


@implementation AnimationsView

@synthesize animationsType = _animationsType;
@synthesize frameImageBundle = _frameImageBundle;
@synthesize videoName = _videoName;
@synthesize fadeImage = _fadeImage;
@synthesize delegate = _delegate;


/**
 @功能:初始化方法
 @参数:无
 @返回值:无
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/**
 @功能:设置动画类型
 @参数:AnimationsType 动画类型 枚举类型
 @返回值:无
 */
- (void) setAnimationsType:(AnimationsType)animationsType
{
    // 
    if ( _animationsType != animationsType ) {
        [self stopAnimations];
    }
    _animationsType = animationsType;
    
    switch ( animationsType ) {
        case eVideo:
            break;
        case eFadeImage:
            break;
        case eFrame:
            break;
        default:
            break;
    }
}

/**
 @功能:改变视图大小和位置
 @参数:CGRect 新的位置和大小
 @返回值:无
 */
- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [aMovie.view setFrame:self.bounds]; // iPhone
    animationimg.frame = self.bounds;
}

/**
 @功能:启动动画
 @参数:无
 @返回值:无
 */
- (void) startAnimations
{
    switch ( _animationsType ) {
        case eVideo:{
            [self playVideo];
            break;
        }
            
        case eFadeImage:{
            [self startImageAnimations];
            break;
        }
            
        case eFrame:{
            [self initImage];
            break;
        }
            
        default:
            break;
    }
    
    if ( self.delegate != nil && 
        [self.delegate respondsToSelector:@selector(animationsStart:)] ) {
        [self.delegate animationsStart:self];
    }
}

/**
 @功能:停止动画
 @参数:无
 @返回值:无
 */
- (void) stopAnimations
{
    switch ( _animationsType ) {
        case eVideo:
            [aMovie stop];
            break;
        case eFadeImage:{
            break;
        }
            
        case eFrame:
            break;
        default:
            break;
    }
    
    
}

//设置图片
- (void) setImageBundle: (NSBundle *)imageBundle{
    _frameImageBundle = imageBundle;
}

#pragma mark 多张图片切换方法

- (void) initImage{
    ImageAnimation *imganimation=[[ImageAnimation alloc] initWithFrame: self.frame];
    [imganimation setImageView: _frameImageBundle];
    [self addSubview: imganimation];
    [imganimation release];
}

#pragma mark 视频方法

//播放视频动画
- (void) playVideo{
    
    //视频播放区域
    NSString *moviePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.videoName];;
    
    NSURL *movieURL = [NSURL fileURLWithPath: moviePath];
    
    if ( nil == aMovie) {
        aMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    }
    
    [aMovie.view setFrame:self.bounds]; 
    
    aMovie.controlStyle = MPMovieControlStyleNone;
    aMovie.scalingMode = MPMovieScalingModeNone;
    aMovie.initialPlaybackTime = -1;
    aMovie.view.userInteractionEnabled = NO;
    
    [self addSubview:aMovie.view];
    
    //添加注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(movePlayFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:aMovie];
    
    [self addNotificationCenter];
}

//视频播放结束
- (void) movePlayFinished:(NSNotification *)note
{    
    //视频播放对象 
    MPMoviePlayerController *theMovie = [note object];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    [self animationsFinish];
}

#pragma mark 图片动画方法

//图片淡入淡出动画 
- (void) startImageAnimations{
    
    
    animationimg=[[UIImageView alloc] initWithImage: _fadeImage];
    animationimg.frame=self.bounds;
    animationimg.alpha=1.0f;
    animationimg.contentMode=UIViewContentModeScaleToFill;
    [self addSubview: animationimg];
    
    [UIView beginAnimations:@"countdown" context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopped)];
   // animationimg.alpha = 0.0f;
    [UIView commitAnimations];
}

//图片播放结束
- (void)animationDidStopped{
    [UIView beginAnimations:@"countdown1" context:nil];
    [UIView setAnimationDuration:2.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStopped)];
    animationimg.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void) animationStopped
{
    [self animationsFinish];
}

//动画结束的委托
- (void) animationsFinish
{
    [self removeNotificationCenter];
    if ( self.delegate != nil && 
        [self.delegate respondsToSelector:@selector(animationsFinish:)] ) {
        [self.delegate animationsFinish:self];
    }
}

/**
 @method 添加应用程序状态通知
 @param UIApplication* 应用程序代理类对象
 @result 空
 */
- (void) addNotificationCenter
{
    UIApplication * app= [UIApplication sharedApplication];
    
    // 程序失去焦点
	[[NSNotificationCenter defaultCenter ] addObserver:self
											  selector:@selector(applicationDidEnterBackground:)
												  name:UIApplicationDidEnterBackgroundNotification
												object:app];
    
    // 程序获得焦点
    [[NSNotificationCenter defaultCenter ] addObserver:self
											  selector:@selector(applicationWillEnterForeground:)
												  name:UIApplicationWillEnterForegroundNotification
												object:app];
}

/**
 @method 移除应用程序状态通知
 @param UIApplication* 应用程序代理类对象
 @result 空
 */
- (void) removeNotificationCenter
{
    UIApplication * app= [UIApplication sharedApplication];
    
    // 程序失去焦点
	[[NSNotificationCenter defaultCenter ] removeObserver:self 
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:app];
    
    // 程序获得焦点
    [[NSNotificationCenter defaultCenter ] removeObserver:self 
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:app];
}

/**
 @method 程序进入到后台
 @param UIApplication* 应用程序代理类对象
 @result 空
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [aMovie pause];
}

/**
 @method 程序进入到前台
 @param UIApplication* 应用程序代理类对象
 @result 空
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [aMovie play];
}

#pragma mark --

/**
 @功能:内存释放
 @参数:无
 @返回值:无
 */
- (void) dealloc
{
    [aMovie release];
    aMovie = nil;
    [animationimg release];
    [_fadeImage release];
    [_videoName release];
    [_frameImageBundle release];
    [super dealloc];
}

@end
