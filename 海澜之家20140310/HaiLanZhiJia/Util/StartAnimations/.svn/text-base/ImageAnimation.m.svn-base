//
//  ImageAnimation.m
//  YuJingWan
//
//  Created by hua on 12-11-9.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "ImageAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageAnimation
@synthesize logoImage = _logoImage;
@synthesize largeLogoImage = _largeLogoImage;
@synthesize changeImage1 = _changeImage1;
@synthesize changeImage2 = _changeImage2;
@synthesize changeImage3 = _changeImage3;
@synthesize changeImage4 = _changeImage4;
@synthesize imagearray = _imagearray;
@synthesize timer;

- (void) dealloc{
    [_logoImage release];
    [_largeLogoImage release];
    [_changeImage1 release];
    [_changeImage2 release];
    [_changeImage3 release];
    [_changeImage4 release];
    [_imagearray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        curFlag = LogoImageEnum;
        iCounting = 0;
        animationOver = NO;
        [self initImageView];
    }
    return self;
}

- (void) setImageView: (NSBundle *)imageBundle{
    if (_imagearray == nil) {
        _imagearray=[[NSMutableArray alloc] init];
    }
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *directoryPath = [imageBundle bundlePath];
    NSArray *fileNameArr = [fileMgr contentsOfDirectoryAtPath:directoryPath error:&error];
    //分析文件的后缀名，把文件的后缀名是jpg，JPG，png，PNG的文件的绝对路径加入到_imagePathArr数组中
    for (NSString *fileName in fileNameArr) {
        NSArray *strArr = [fileName componentsSeparatedByString:@"."];
        NSString *suffix = [strArr lastObject];
        if ([suffix isEqualToString:@"jpg"] || [suffix isEqualToString:@"JPG"] || [suffix isEqualToString:@"png"] || [suffix isEqualToString:@"PNG"]) {
            NSString *filePath = [directoryPath stringByAppendingFormat:@"/%@",fileName];
            [_imagearray addObject:filePath];
        }
    }
    
    _logoImage.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 0]];
    _changeImage1.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 1]];
    _changeImage2.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 2]];
    _changeImage3.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 3]];
    _changeImage4.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 4]];
    _largeLogoImage.image=[UIImage imageWithContentsOfFile:[_imagearray objectAtIndex: 5]];
    [self startTimer];
}


- (void) initImageView{
    _logoImage=[[UIImageView alloc] initWithFrame: self.frame];
    _logoImage.alpha=0.0;
    [self addSubview: _logoImage];
    
    _changeImage1=[[UIImageView alloc] initWithFrame: self.frame];
    _changeImage1.alpha=0.0;
    [self addSubview: _changeImage1];
    
    _changeImage2=[[UIImageView alloc] initWithFrame: self.frame];
    _changeImage2.alpha=0.0;
    [self addSubview: _changeImage2];
    
    _changeImage3=[[UIImageView alloc] initWithFrame: self.frame];
    _changeImage3.alpha=0.0;
    [self addSubview: _changeImage3];
    
    _changeImage4=[[UIImageView alloc] initWithFrame: self.frame];
    _changeImage4.alpha=0.0;
    [self addSubview: _changeImage4];
    
    _largeLogoImage=[[UIImageView alloc] initWithFrame: self.frame];
    _largeLogoImage.alpha=0.0;
    [self addSubview: _largeLogoImage];
}

- (void)startTimer 
{
	timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                             target:self
                                           selector:@selector(timerProc:)
                                           userInfo:nil
                                            repeats:YES];
}


- (void)stopTimer
{
	if (timer) {
		[timer invalidate];
		
		//show main view
		CATransition *animation = [CATransition animation];
		animation.delegate = self;
		animation.duration = 0.2f;
		animation.timingFunction = UIViewAnimationCurveEaseInOut;
		animation.type = kCATransitionPush;
		animation.subtype = kCATransitionFromRight;
//		[self addSubview: self.viewController.view];
		[self.layer addAnimation:animation forKey:nil];
	}
}


- (void)timerProc:(NSTimer *)timer
{
	if (LogoImageEnum == curFlag) 
	{
		_logoImage.alpha += 0.100000;
        
		if (1 == abs(_logoImage.alpha)) {
			if (animationOver) {
				[self stopTimer];
			}
			
			curFlag = ChangeImage1Enum;
		}
	}
	else if	(LargeLogoImageEnum == curFlag)
	{
		if (iCounting>=40) {
			_largeLogoImage.frame = CGRectMake(0, 0, 0, 0);
			curFlag = LogoImageEnum;
			iCounting = 0;
			animationOver = YES;
			return;
		}
		
		float width = (float)475/40;
		CGFloat heigth = (CGFloat)158/40;
		
		_changeImage4.alpha -= 0.025;
		_largeLogoImage.frame = CGRectMake(-315+width*iCounting, 84+heigth*iCounting, 951/40*(40-iCounting), 315/40*(40-iCounting));
		
		//[NSThread sleepForTimeInterval:1];
        
		iCounting++;
	}
	else if (ChangeImage1Enum == curFlag)
	{
		_changeImage1.alpha += 0.04;
		_changeImage1.center = CGPointMake(160, iCounting*10);
		iCounting++;
		
		if (1 == abs(_changeImage1.alpha)) {
			curFlag = ChangeImage2Enum;
			iCounting = 0;
		}
	}
	else if (ChangeImage2Enum == curFlag)
	{
		_changeImage2.alpha += 0.02;
		if (150+iCounting*2<=240) {
			_changeImage2.center = CGPointMake(160, 150+iCounting*2);
			iCounting++;
		}
		
		if (1 == abs(_changeImage2.alpha)) {
			curFlag = ChangeImage3Enum;
			iCounting = 0;
		}
		
	}
	else if (ChangeImage3Enum == curFlag)
	{
		_changeImage3.alpha += 0.05;
		if (330-iCounting*10>=160) {
			_changeImage3.center = CGPointMake(330-iCounting*10, 240);
			iCounting++;
		}
		
		if (1 == abs(_changeImage3.alpha)) {
			curFlag = ChangeImage4Enum;
			iCounting = 0;
		}
	}
	else if (ChangeImage4Enum == curFlag)
	{
		_changeImage4.alpha += 0.05;
		if (-10+iCounting*10<=160) {
			_changeImage4.center = CGPointMake(-10+iCounting*10, 240);
			iCounting++;
		}
		
		if (1 == abs(_changeImage4.alpha)) {
			curFlag = LargeLogoImageEnum;
			iCounting = 0;
			_logoImage.alpha = 0;
			_changeImage1.alpha = 0;
			_changeImage2.alpha = 0;
			_changeImage3.alpha = 0;
			_largeLogoImage.alpha = 1.0;
		}
		
	}
}



@end
