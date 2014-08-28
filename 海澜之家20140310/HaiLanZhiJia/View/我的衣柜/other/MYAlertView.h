//
//  MYAlertView.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class MYAlertView;
@protocol MYAlertViewDelegate <NSObject>

@optional
- (void)myAlertView:(MYAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MYAlertView : UIView

typedef enum {
    
    AlertViewStateBeginTalking,
    AlertViewStateWasIdentificaing,
    AlertViewStateIdentificaFailed,
    AlertViewStateidentificaSuccess
    
}AlertViewState;

@property (nonatomic, retain) UILabel *labTitle;
@property (nonatomic, retain) UILabel *labMessage;
@property (nonatomic, retain) UIImageView *imgViewContents;
@property (nonatomic, retain) UIView *coverViewContents;
@property (nonatomic, retain) UIActivityIndicatorView *activi;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) id <MYAlertViewDelegate> delegate;
@property (nonatomic, assign) int iVolume;

- (id)initWithTitle:(NSString *)title message:(NSString *)message image:(NSString *)image delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle anotherButtonTitle:(NSString *)anotherButtonTitle;

- (void)show;
- (void)beginTalking;
- (void)wasIdentificaing;
- (void)identificaSuccessed:(NSString *)strSpeak;
- (void)identificaFailed;

@end
