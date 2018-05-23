    //
    //  UIView+Frame.h
    //  40 Days of Happiness
    //
    //  Created by Karthikeyan on 30/01/14.
    //  Copyright (c) 2014 Hubbl. All rights reserved.
    //

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)newOrigin;
- (CGSize)size;
- (void)setSize:(CGSize)newSize;

- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;

- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;


-(CGFloat) maxx;
-(CGFloat) maxy;
-(CGFloat) minx;
-(CGFloat) miny;

-(CGFloat) vheight;
-(CGFloat) vWidth;

@end
