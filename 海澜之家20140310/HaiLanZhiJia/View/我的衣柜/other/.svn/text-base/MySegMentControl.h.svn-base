//
//  MySegMentControl.h
//  MeiLiYun
//
//  Created by summer on 13-10-8.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MySegMentControl;
@protocol MYSegMentControlDelegate <NSObject>

@optional
- (void)segmentControl:(MySegMentControl *)setMentControl touchedAtIndex:(NSInteger)index;

@end

@interface MySegMentControl : UIView

@property (nonatomic, assign) id<MYSegMentControlDelegate> delegate;

@property (nonatomic, retain) NSArray *segments;
- (void)createSegments;
@end
