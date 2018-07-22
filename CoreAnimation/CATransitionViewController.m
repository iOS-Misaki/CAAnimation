//
//  CATransitionViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/21.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "CATransitionViewController.h"

typedef NS_ENUM(NSInteger,CATransactionType) {
    CATransactionType_Fade = 0,                 //默认
    CATransactionType_MoveIn,                   //覆盖
    CATransactionType_Push,                     //推入
    CATransactionType_Reveal,                   //揭开
    
    CATransactionType_Cube,                     //立体
    CATransactionType_SuckEffect,               //吮吸
    CATransactionType_OglFlip,                  //翻转
    CATransactionType_RippleEffect,             //波纹
    CATransactionType_PageCurl,                 //翻页
    CATransactionType_PageUnCurl,               //反翻页
    CATransactionType_CameraIrisHollowOpen,     //开镜头
    CATransactionType_CameraIrisHollowClose,    //关镜头
};


@interface CATransitionViewController ()

@property (nonatomic,strong) UIImageView * bgView ;

@property (nonatomic,assign) CATransactionType transactionType;

@property (nonatomic, assign) NSInteger subtype;

@property (nonatomic,strong) UIColor * typeNormalColor;
@property (nonatomic,strong) UIColor * typeSelectedColor;

@property (nonatomic,strong) UIColor * subtypeNormalColor;
@property (nonatomic,strong) UIColor * subtypeSelectedColor;

@end

@implementation CATransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _subtype = 12;
    _transactionType = 0;
    
    self.typeNormalColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:0.3];
    self.typeSelectedColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:0.9];
    self.subtypeNormalColor = [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:0.3];
    self.subtypeSelectedColor = [UIColor colorWithRed:0.2 green:0.2 blue:1 alpha:0.9];
    
    self.bgView = [UIImageView new];
    self.bgView.image = [UIImage imageNamed:@"拉姆.jpeg"];
    self.bgView.frame = self.view.bounds;
    [self.view addSubview:self.bgView];
    
    [self setupBtn];
}

- (void)btnClick:(UIButton *)sender
{
    UIButton * lastBtn;
    NSInteger index = sender.tag - 100;
    if (index > 11)
    {
        lastBtn = (UIButton *)[self.view viewWithTag:_subtype + 100];
        [lastBtn setBackgroundImage:[self createImageWithColor:self.subtypeNormalColor] forState:UIControlStateNormal];
        [sender setBackgroundImage:[self createImageWithColor:self.subtypeSelectedColor] forState:UIControlStateNormal];
        _subtype = index;
    }
    else
    {
        lastBtn = (UIButton *)[self.view viewWithTag:_transactionType + 100];
        [lastBtn setBackgroundImage:[self createImageWithColor:self.typeNormalColor] forState:UIControlStateNormal];
        [sender setBackgroundImage:[self createImageWithColor:self.typeSelectedColor] forState:UIControlStateNormal];
        _transactionType = index;
    }
    
    NSString * subtypeString ;
    
    switch (_subtype % 4) {
        case 0:
            subtypeString = kCATransitionFromTop;
            break;
        case 1:
            subtypeString = kCATransitionFromBottom;
            break;
        case 2:
            subtypeString = kCATransitionFromLeft;
            break;
        case 3:
            subtypeString = kCATransitionFromRight;
            break;
            
        default:
            break;
    }
    
    
    
    switch (_transactionType) {
        case CATransactionType_Fade:
            [self CATransitionWithType:kCATransitionFade WithSubtype:subtypeString];
            break;
        case CATransactionType_MoveIn:
            [self CATransitionWithType:kCATransitionMoveIn WithSubtype:subtypeString];
            break;
        case CATransactionType_Push:
            [self CATransitionWithType:kCATransitionPush WithSubtype:subtypeString];
            break;
        case CATransactionType_Reveal:
            [self CATransitionWithType:kCATransitionReveal WithSubtype:subtypeString];
            break;
        
        case CATransactionType_Cube:
            [self CATransitionWithType:@"cube" WithSubtype:subtypeString];
            break;
        case CATransactionType_SuckEffect:
            [self CATransitionWithType:@"suckEffect" WithSubtype:subtypeString];
            break;
        case CATransactionType_OglFlip:
            [self CATransitionWithType:@"oglFlip" WithSubtype:subtypeString];
            break;
        case CATransactionType_RippleEffect:
            [self CATransitionWithType:@"rippleEffect" WithSubtype:subtypeString];
            break;
        case CATransactionType_PageCurl:
            [self CATransitionWithType:@"pageCurl" WithSubtype:subtypeString];
            break;
        case CATransactionType_PageUnCurl:
            [self CATransitionWithType:@"pageUnCurl" WithSubtype:subtypeString];
            break;
        case CATransactionType_CameraIrisHollowOpen:
            [self CATransitionWithType:@"cameraIrisHollowOpen" WithSubtype:subtypeString];
            break;
        case CATransactionType_CameraIrisHollowClose:
            [self CATransitionWithType:@"cameraIrisHollowClose" WithSubtype:subtypeString];
            break;
            
            
        default:
            break;
    }
    
    static NSInteger i = 0;
    self.bgView.image = i % 2 ? [UIImage imageNamed:@"拉姆.jpeg"] :[UIImage imageNamed:@"蕾姆.jpeg"];
    i ++;
}

- (void)CATransitionWithType:(NSString *)type WithSubtype:(NSString *)subtype
{
    CATransition * animation = [CATransition animation];
    animation.duration = 2.f;
    animation.type = type;
    animation.subtype = subtype;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (void)setupBtn
{
    NSArray * titleArray = @[@"默认",@"覆盖",@"推入",@"揭开",
                             @"立体",@"吮吸",@"翻转",@"波纹",
                             @"翻页",@"反翻页",@"开镜头",@"关镜头",
                             @"上",@"下",@"左",@"右"];
    
    for (NSInteger i = 0 ; i < titleArray.count ; i ++)
    {
        UIButton * btn = [UIButton new];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        if (i > 11)
        {
            [btn setBackgroundImage:[self createImageWithColor:self.subtypeNormalColor] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[self createImageWithColor:self.typeNormalColor] forState:UIControlStateNormal];
        }
             
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        NSInteger row = i % 4;
        NSInteger section = i / 4 ;
        CGFloat margin = 15 ;
        CGFloat width = (self.view.bounds.size.width - 75) / 4;
        btn.frame = CGRectMake(row * (width + margin) + margin, 200 + section * 70 , width, 40);
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




@end
