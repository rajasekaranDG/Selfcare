//
//  UIView+Frame.m
//  40 Days of Happiness
//
//  Created by Karthikeyan on 30/01/14.
//  Copyright (c) 2014 Hubbl. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin
{
    CGRect newFrame = self.frame;
    newFrame.origin = newOrigin;
    self.frame = newFrame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)newSize
{
    CGRect newFrame = self.frame;
    newFrame.size = newSize;
    self.frame = newFrame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = newX;
    self.frame = newFrame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY
{
    CGRect newFrame = self.frame;
    newFrame.origin.y = newY;
    self.frame = newFrame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)newHeight
{
    CGRect newFrame = self.frame;
    newFrame.size.height = newHeight;
    self.frame = newFrame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth
{
    CGRect newFrame = self.frame;
    newFrame.size.width = newWidth;
    self.frame = newFrame;
}

- (CGFloat)maxx
{
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)maxy
{
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)minx
{
    return CGRectGetMinX(self.frame);
}
- (CGFloat)miny
{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)vheight
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)vWidth
{
    return CGRectGetWidth(self.frame);
}

@end
