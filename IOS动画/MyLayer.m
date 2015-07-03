//
//  MyLayer.m
//  IOS动画
//
//  Created by zhougj on 15/7/3.
//  Copyright (c) 2015年 iiseeuu. All rights reserved.
//

#import "MyLayer.h"

@implementation MyLayer
//在自定义的layer中- (void)drawInContext:(CGContextRef)ctx方法不会自己调用，只能自己通过setNeedDispalye调用，在view中画东西DrawRect:方法在view第一次显示的时候会自动调用

//重写该方法，在该方法中绘制图形
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 50, 100, 100));
    CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
    
    //渲染
    CGContextFillPath(ctx);
}

@end
