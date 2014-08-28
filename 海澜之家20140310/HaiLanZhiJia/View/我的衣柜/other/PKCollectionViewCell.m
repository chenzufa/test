//
// PSCollectionViewCell.m
//
// Copyright (c) 2012 Peter Shih (http://petershih.com)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PKCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#define MARGIN 4.0
@interface PKCollectionViewCell ()

@end

@implementation PKCollectionViewCell

@synthesize object = _object;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)dealloc {
    self.object = nil;
    [super dealloc];
}

- (void)prepareForReuse {
}

- (void)fillViewWithObject:(id)object {
    self.object = object;
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    /*// Image
    CGFloat objectWidth = [[object objectForKey:@"width"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;*/
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageView setImageWithURL:[NSURL URLWithString:[object objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"商品大图.png"]];
    
    //UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[object objectForKey:@"url"]]]];
    if (imageView.image) {
        height += floorf(imageView.image.size.height / (imageView.image.size.width / width));
    }
    [imageView release];
    // Label
    NSString *caption = [object objectForKey:@"title"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height / 14 > 2) {
        height += 30;
    }else{
        height += labelSize.height;
    }
    height += 0;
    
    return height;
}

@end
