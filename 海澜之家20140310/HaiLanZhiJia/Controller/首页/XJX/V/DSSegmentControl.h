//
//  DSSegmentControl.h
//  CHYSliderDemo
//
//  Created by xiaojiaxi on 13-09-15.
//  Copyright (c) 2013年 ciderstudios.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DSSegmentControl;
@protocol DSSegmentControlDelegate <NSObject>
@optional
-(void)segmentControl:(DSSegmentControl*)segmentControl clickedAtIndex:(int)index button:(UIButton*)btn;
@end

@interface DSSegmentControl : UIView
@property(nonatomic,assign)id <DSSegmentControlDelegate>delegate;
@property(nonatomic,copy)NSString *backgroundImage;
@property(nonatomic,retain)NSArray *normalImages;
@property(nonatomic,retain)NSArray *highlightImages;
@property(nonatomic,retain)NSArray *biaoMianImages;
@property(nonatomic,retain)NSArray *titles;
@property(nonatomic,retain)UIColor *colorN;
@property(nonatomic,retain)UIColor *colorH;
-(void)initSegmentControl;
@end
