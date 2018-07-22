//
//  KeyframeAnimationViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/21.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "KeyframeAnimationViewController.h"

#define  RGBA(R,G,B,A)            [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define  RANDOMCOLOR              RGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define  SCREENWIDTH              [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT             [UIScreen mainScreen].bounds.size.height

@interface KeyframeAnimationViewController ()

@property (nonatomic,strong) UIView * pointView;

@property (nonatomic,strong) UISegmentedControl * segmentControl;

@end

@implementation KeyframeAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self segmentControl];
}


- (void)segmentedControlClick:(UISegmentedControl *)segmentedControl
{
    self.pointView.backgroundColor = RANDOMCOLOR;
    if (segmentedControl.selectedSegmentIndex)
    {
        [self CAKeyframeAnimationWithPath];
    }
    else
    {
        [self CAKeyframeAnimationWithValues];
    }
}

#pragma mark - 指定keyPath为position，通过Values来创建关键帧动画
- (void)CAKeyframeAnimationWithValues
{
    CGFloat margin = 50.f;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    NSValue * value0 = [NSValue valueWithCGPoint:CGPointMake(margin, margin)];
    NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake(margin, SCREENHEIGHT - margin)];
    NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH - margin, SCREENHEIGHT - margin)];
    NSValue * value3 = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH - margin, margin)];
    NSValue * value4 = [NSValue valueWithCGPoint:CGPointMake(margin, margin)];
    animation.values = @[value0,value1,value2,value3,value4];
    
    //当我们动画完成时,如果希望动画就自动移除的话,我们可以设置此属性为YES,默认值为YES
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    //快入快出
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.pointView.layer addAnimation:animation forKey:@"position.values"];
}

#pragma mark - 指定keyPath为position，通过path路径来创建关键帧动画
- (void)CAKeyframeAnimationWithPath
{
    CGFloat margin = 50.f;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(margin, margin, SCREENWIDTH - margin * 2, SCREENHEIGHT - margin * 2));
    animation.path = path;
    CGPathRelease(path);
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 4;
    animation.repeatCount = MAXFLOAT;
    NSMutableArray * timingFunctionArray = [NSMutableArray new];
    for (NSInteger i = 0 ; i < 5 ; i ++)
    {
        //每一段都是快出效果
        CAMediaTimingFunction * timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [timingFunctionArray addObject:timingFunction];
    }
    animation.timingFunctions = timingFunctionArray;
    [self.pointView.layer addAnimation:animation forKey:@"position.path"];
}

- (UIView *)pointView
{
    if (!_pointView)
    {
        CGFloat radius = 20.f;
        _pointView = [UIView new];
        _pointView.backgroundColor = RANDOMCOLOR;
        _pointView.layer.cornerRadius = radius;
        [self.view addSubview:_pointView];
        _pointView.frame = CGRectMake(SCREENWIDTH / 2 - radius, SCREENHEIGHT / 2 - radius, radius * 2, radius * 2);
    }
    return _pointView;
}

- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl)
    {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"values动画-逆时针",@"path动画-顺时针"]];
        [self.view addSubview:_segmentControl];
        _segmentControl.frame = CGRectMake(SCREENWIDTH / 2 - 150, SCREENHEIGHT / 2 - 15, 300, 30);
        [_segmentControl addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

@end
