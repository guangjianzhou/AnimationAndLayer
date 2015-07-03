//
//  MyView.m
//  IOS动画
//
//  Created by zhougj on 15/7/2.
//  Copyright (c) 2015年 iiseeuu. All rights reserved.
//

#import "MyView.h"

@implementation MyView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //2.绘制图形
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    //3.渲染
    CGContextFillPath(ctx);
//    [self.layer drawInContext:ctx];
}


@end
