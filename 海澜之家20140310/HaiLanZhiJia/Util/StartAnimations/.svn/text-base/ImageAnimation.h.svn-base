//
//  ImageAnimation.h
//  YuJingWan
//
//  Created by hua on 12-11-9.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import <UIKit/UIKit.h>

enum imageFlag {
	LogoImageEnum,
	LargeLogoImageEnum,
	ChangeImage1Enum,
	ChangeImage2Enum,
	ChangeImage3Enum,
	ChangeImage4Enum
};

@interface ImageAnimation : UIView{
    UIImageView *_logoImage;
	UIImageView *_largeLogoImage;
	UIImageView *_changeImage1;
	UIImageView *_changeImage2;
	UIImageView *_changeImage3;
	UIImageView *_changeImage4;
    
    NSTimer *timer;
    NSMutableArray *_imagearray;
    NSInteger curFlag;
	NSInteger iCounting;
	BOOL	  animationOver;
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIImageView *logoImage;
@property (nonatomic, retain) UIImageView *largeLogoImage;
@property (nonatomic, retain) UIImageView *changeImage1;
@property (nonatomic, retain) UIImageView *changeImage2;
@property (nonatomic, retain) UIImageView *changeImage3;
@property (nonatomic, retain) UIImageView *changeImage4;
@property (nonatomic, retain) NSMutableArray *imagearray;

- (void) setImageView: (NSBundle *)imageBundle;
- (void) initImageView;

- (void)startTimer;
- (void)stopTimer;
- (void)timerProc:(NSTimer *)timer;

@end