//
//  ViewController.m
//  IOS动画
//
//  Created by zhougj on 15/7/2.
//  Copyright (c) 2015年 iiseeuu. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MyLayer.h"
#import "MyView.h"

#define  kImage(imageName)  [UIImage imageNamed:imageName]

@interface ViewController ()
{
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *layoutImageview;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *horizonContraint;
@property (strong, nonatomic) IBOutlet UIView *customView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _customView.backgroundColor = [UIColor yellowColor];
//    [self customLayer];
    MyView *myView = [[MyView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    [self.view addSubview:myView];
}

//如果显示出来的东西需要跟用户进行交互的话，用UIView；如果不需要跟用户进行交互，用UIView或者CALayer都可以
//如果一个控件是另外一个控件的子控件，那么这个控件的layer也是另一个控件的子layer。
/********************CALayer*************************/

- (void)customLayer
{
     MyLayer *layer = [MyLayer layer];
     layer.backgroundColor=[UIColor brownColor].CGColor;
     layer.bounds=CGRectMake(0, 0, 200, 150);
     layer.anchorPoint=CGPointZero;
     layer.position=CGPointMake(100, 100);
     layer.cornerRadius=20;
     layer.shadowColor=[UIColor blackColor].CGColor;
     layer.shadowOffset=CGSizeMake(10, 20);
     layer.shadowOpacity=0.6;

    [layer setNeedsDisplay];
    [self.view.layer addSublayer:layer];
}


- (void)setupLayer
{
    self.customView.layer.borderWidth = 2;
    self.customView.layer.borderColor = [UIColor orangeColor].CGColor;
    _customView.layer.cornerRadius = 20;
    //在layer上面添加一个iamge
    _customView.layer.contents = (id)[UIImage imageNamed:@"10.jpg"].CGImage;
//    _customView.layer.masksToBounds = YES;
    //设置阴影(如果设置了超过主图层的部分减掉，则设置阴影不会有显示效果)
    _customView.layer.shadowColor = [UIColor redColor].CGColor;
    _customView.layer.shadowOffset = CGSizeMake(15, 5);
    _customView.layer.shadowOpacity = 0.6;
}

- (void)setTransfrom
{
    //2D效果
//    _imageView.transform = CGAffineTransformMakeTranslation(0, -100);
    
    //通过layer来设置(3D效果)
//    _imageView.layer.transform = CATransform3DMakeTranslation(100, 20, 0);

    //设置旋转
    _imageView.layer.transform = CATransform3DMakeRotation(M_PI_4, 1, 1, 0.5);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setTransfrom];
}

- (void)createLayer
{
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = [UIColor brownColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 200, 200);
    layer.position = CGPointMake(100, 100);
    
    [self.view.layer addSublayer:layer];
}
//postion和锚点决定位置
- (void)createAnchorPoint
{
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = CGPointMake(100, 100);
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.view.layer addSublayer:layer];
}


//隐式动画


/********************Animation*************************/

/**
 *  UIView来展示动画：frame/bounds/center/transform/alpha/backgroupd/contentStrech
 */

- (void)baseAnimation
{
    /*  */
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_imageView cache:YES];
    [UIView commitAnimations];
  
    
    /*
     _horizonContraint.constant = 10;
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [self.view layoutIfNeeded];//ok
//        [self.view setNeedsDisplay]; //不行，而setNeedsDisplay会调用自动调用drawRect方法
//        [self.view setNeedsLayout];//不行，setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据
        
    } completion:^(BOOL finished) {
        
    }];
     
    */
}

- (void)revertAnimation
{
    [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        _layoutImageview.frame = CGRectMake(0, 0, 150,150);
    } completion:^(BOOL finished) {
        
    }];
}


/**
 *  CATransition
 *  不同于UIView动画，它的作用于UIView的layer层，主要用于UIView的两个视图切换过渡的动画
 */

- (void)caTransitionAnimation
{
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 2.0f;
    transition.repeatCount = 4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];//加速方式
//    transition.type = kCATransitionReveal;//动画类型
    transition.type = @"pageCurl";
    transition.subtype = kCATransitionFromBottom;//子类行
    NSInteger index = [self.view.subviews indexOfObject:_imageView];
    NSInteger toindex = [self.view.subviews indexOfObject:_layoutImageview];
    [self.view exchangeSubviewAtIndex:index withSubviewAtIndex:toindex];
    [self.view.layer addAnimation:transition forKey:@"animation"];
}


//CAAnimation子类:CABasicAnimation、CAKeyframeAnimation、CATransition/CAAnimationGroup
//CATransition只针对图层，不针对视图
//图层的属性值还是动画执行前的初始值，并没有真正被改变
//groupAnimation
- (void)groupAnimation
{
    //贝塞尔曲线路径
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(10.0, 10.0)];
    [movePath addQuadCurveToPoint:CGPointMake(100, 300) controlPoint:CGPointMake(300, 100)];

   //关键帧动画（位置）
    CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    posAnim.path = movePath.CGPath;

   //缩放动画
   CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnim.toValue = [NSNumber numberWithFloat:0.1];

    //透明动画
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
   
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:posAnim, scaleAnim, opacityAnim, nil];
    animGroup.duration = 3;
    animGroup.autoreverses = NO;
    animGroup.fillMode = kCAFillModeBackwards;
    animGroup.removedOnCompletion = NO;
    animGroup.delegate = self;
    [_imageView.layer addAnimation:animGroup forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag)
    {
        CGPoint currentRect = [[self.view.layer presentationLayer]position];
        self.view.layer.position = currentRect;
        _imageView.center = currentRect;
        return;
    }
}


- (void)imageViewAnimation
{
    NSArray *images = @[kImage(@"10.jpg"),kImage(@"11.jpg"),kImage(@"12.jpg"),kImage(@"13.jpg"),kImage(@"14.jpg")];
    _imageView.animationDuration = 3;
    _imageView.animationImages = images;
    _imageView.animationRepeatCount = 4;
    [_imageView startAnimating];
}

- (IBAction)beginAnimationAction:(UIButton *)sender
{
//    [self baseAnimation];
//    [self caTransitionAnimation];
//    [self groupAnimation];
    //改变view的frame
//    _imageView.frame = CGRectMake(100, 200, 200, 200);

//    [self imageViewAnimation];
}

- (IBAction)reverAnimationAction:(UIButton *)sender
{
    [self revertAnimation];
}




@end
