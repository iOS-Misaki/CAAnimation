//
//  CASpringAnimationViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/22.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "CASpringAnimationViewController.h"

#define  RGBA(R,G,B,A)            [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define  RANDOMCOLOR              RGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define  SCREENWIDTH              [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT             [UIScreen mainScreen].bounds.size.height

@interface CASpringAnimationViewController ()

@property (nonatomic,strong) UIView * baseView;

@property (nonatomic,strong) UISlider * velocitySlider;
@property (nonatomic,strong) UISlider * massSlider;
@property (nonatomic,strong) UISlider * dampingSlider;
@property (nonatomic,strong) UISlider * stiffnessSlider;

@property (nonatomic,strong) UILabel * velocityLab;
@property (nonatomic,strong) UILabel * massLab;
@property (nonatomic,strong) UILabel * dampingLab;
@property (nonatomic,strong) UILabel * stiffnessLab;

@end

@implementation CASpringAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self stiffnessSlider];
    
    [self starAnimation];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    if (slider == self.velocitySlider)
    {
        self.velocityLab.text = [NSString stringWithFormat:@"初速度 %.f",slider.value];
    }
    else if (slider == self.massSlider)
    {
        self.massLab.text = [NSString stringWithFormat:@"质量 %.f",slider.value];
    }
    else if (slider == self.dampingSlider)
    {
        self.dampingLab.text = [NSString stringWithFormat:@"阻尼 %.f",slider.value];
    }
    else if (slider == self.stiffnessSlider)
    {
        self.stiffnessLab.text = [NSString stringWithFormat:@"刚度 %.f",slider.value];
    }
}

- (void)btnClick:(UIButton *)sender
{
    //frame属性不可动画化 只能通过 bounds 和 position完成
    CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:@"bounds"];
    
    //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    animation.mass = self.massSlider.value;
    
    //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    animation.stiffness = self.stiffnessSlider.value;
    
    //阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    animation.damping = self.dampingSlider.value;
    
    //初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    animation.initialVelocity = self.velocitySlider.value;
    
    animation.duration = 3.f;
    animation.fromValue =  [NSValue valueWithCGRect:CGRectMake(0, 0, 80, 100)];
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 80, 240)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.baseView.layer addAnimation:animation forKey:nil];
    
    CASpringAnimation * animation1 = [CASpringAnimation animationWithKeyPath:@"position"];
    animation1.duration = 3.f;
    animation1.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH / 2 , 250)];
    animation1.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH / 2 , 250 - 70)];
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    [self.baseView.layer addAnimation:animation1 forKey:nil];
}

- (void)starAnimation
{
    CASpringAnimation * animation = [CASpringAnimation animationWithKeyPath:@"position"];
    animation.mass = 20.0;
    animation.stiffness = 5000;
    animation.damping = 100.0;
    animation.initialVelocity = 5.f;
    animation.duration = 3.f;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(- SCREENWIDTH / 2, 250)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREENWIDTH / 2 , 250)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.baseView.layer addAnimation:animation forKey:nil];
}

- (UIView *)baseView
{
    if (!_baseView)
    {
        _baseView = [UIView new];
        _baseView.backgroundColor = RANDOMCOLOR;
        [self.view addSubview:_baseView];
        _baseView.frame = CGRectMake(SCREENWIDTH / 2 - 40, 200, 80, 100);
    }
    return _baseView;
}

- (UISlider *)stiffnessSlider
{
    if (!_stiffnessSlider)
    {
        
        _velocitySlider = [UISlider new];
        _velocitySlider.minimumValue = 0;
        _velocitySlider.maximumValue = 10;
        _velocitySlider.value = 0;
        [_velocitySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_velocitySlider];
        _velocitySlider.frame = CGRectMake(140, 330, SCREENWIDTH - 160, 30);
        
        _velocityLab = [UILabel new];
        _velocityLab.text = @"初速度 0";
        [self.view addSubview:_velocityLab];
        _velocityLab.frame = CGRectMake(20, 330, 120, 30);
        
        _massSlider = [UISlider new];
        _massSlider.minimumValue = 0;
        _massSlider.maximumValue = 30;
        _massSlider.value = 1;
        [_massSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_massSlider];
        _massSlider.frame = CGRectMake(140, 380, SCREENWIDTH - 160, 30);
        
        _massLab = [UILabel new];
        _massLab.text = @"质量 1";
        [self.view addSubview:_massLab];
        _massLab.frame = CGRectMake(20, 380, 120, 30);
        
        
        _dampingSlider = [UISlider new];
        _dampingSlider.minimumValue = 0;
        _dampingSlider.maximumValue = 100;
        _dampingSlider.value = 10;
        [_dampingSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_dampingSlider];
        _dampingSlider.frame = CGRectMake(140, 430, SCREENWIDTH - 160, 30);
        
        _dampingLab = [UILabel new];
        _dampingLab.text = @"阻尼 10";
        [self.view addSubview:_dampingLab];
        _dampingLab.frame = CGRectMake(20, 430, 120, 30);
        
        
        _stiffnessSlider = [UISlider new];
        _stiffnessSlider.minimumValue = 0;
        _stiffnessSlider.maximumValue = 200;
        _stiffnessSlider.value = 100;
        [_stiffnessSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_stiffnessSlider];
        _stiffnessSlider.frame = CGRectMake(140, 480, SCREENWIDTH - 160, 30);
        
        _stiffnessLab = [UILabel new];
        _stiffnessLab.text = @"刚度 100";
        [self.view addSubview:_stiffnessLab];
        _stiffnessLab.frame = CGRectMake(20, 480, 120, 30);
        
        UIButton * btn = [UIButton new];
        [btn setTitle:@"Touch  Me" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:RANDOMCOLOR];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(100, 550, SCREENWIDTH - 200, 44);
        
        
    }
    return _stiffnessSlider;
}





@end
