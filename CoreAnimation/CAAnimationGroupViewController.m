//
//  CAAnimationGroupViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/22.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "CAAnimationGroupViewController.h"



@interface CAAnimationGroupViewController ()

@property (nonatomic,strong) NSTimer * timer;

@end

@implementation CAAnimationGroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1/4.0) target:self selector:@selector(showRain) userInfo:nil repeats:YES];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self endAnimation];
    //    });
    
    
}

- (void)showRain
{
    UIImageView * imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"page"];
    imageV.frame = CGRectMake(0, 0, 50 , 50 );
    
    CALayer * layer = [CALayer layer];
    layer.bounds = imageV.frame;
    layer.contents = (id)imageV.image.CGImage;
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = CGPointMake(0, 0);
    [self.view.layer addSublayer:layer];
    
    
    [self addAnimationWithLayer:layer];
}

- (void)addAnimationWithLayer:(CALayer *)layer
{
    int height = [UIScreen mainScreen].bounds.size.height;
    int width = [UIScreen mainScreen].bounds.size.height;
    
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(arc4random() % width, 0)];
    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() % width, height + 100)];
    moveAnimation.values = @[A,B];
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAKeyframeAnimation * tranAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D r0 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    CATransform3D r1 = CATransform3DMakeRotation(M_PI/180 * (arc4random() % 360 ) , 0, 0, -1);
    tranAnimation.values = @[[NSValue valueWithCATransform3D:r0],[NSValue valueWithCATransform3D:r1]];
    tranAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup * group = [[CAAnimationGroup alloc] init];
    group.duration = arc4random() % 200 / 100.0 + 3.5;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[moveAnimation,tranAnimation];
    [layer addAnimation:group forKey:nil];
}

- (void)endAnimation
{
    [self.timer invalidate];
    
    for (NSInteger i = 0; i < self.view.layer.sublayers.count ; i ++)
    {
        CALayer * layer = self.view.layer.sublayers[i];
        [layer removeAllAnimations];
        [layer removeFromSuperlayer];
    }
}


@end
