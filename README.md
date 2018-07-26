

## CAAnimation继承关系

&ensp;&ensp;&ensp;&ensp;引用官方文档：
>Core Animation provides high frame rates and smooth animations without burdening the CPU and slowing down your app. Most of the work required to draw each frame of an animation is done for you. You configure animation parameters such as the start and end points, and Core Animation does the rest, handing off most of the work to dedicated graphics hardware, to accelerate rendering. For more details, see [Core Animation Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514).

&ensp;&ensp;&ensp;&ensp;`Core Animation`提供了高帧率和流畅的动画，而不会加重CPU负担，也不会减慢应用程序的速度。你可以配置动画参数，如起始点和结束点，`Core animation`完成其余部分，将大部分工作交给专用的图形硬件，以加速渲染。

![CAAnimation类图.jpg](https://upload-images.jianshu.io/upload_images/1487718-98d399ad7b624a91.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

&ensp;&ensp;&ensp;&ensp;对于`CAAnimation`,是核心动画基础类，不直接使用，一般用它的子类。`CAAnimation`有三个子类`CAPropertyAnimation、CATransition、CAAnimationGroup`。第二个`CATransition`是转场动画，第三个`CAAnimationGroup`是动画组。第一个`CAPropertyAnimation`又分为两个子类`CABasicAnimation、CAKeyframeAnimation`。`CAKeyframeAnimation`是关键帧动画。`CABasicAnimation`下面还有个子类`CASpringAnimation`是弹簧动画。

&ensp;&ensp;&ensp;&ensp;`CAPropertyAnimation`通过`animationWithKeyPath`来创建动画，可以看看有哪些属性可以创建动画。详见[官方文档](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html#//apple_ref/doc/uid/TP40004514-CH11-SW2)

```
anchorPoint
backgroundColor
backgroundFilters
borderColor
borderWidth
bounds
compositingFilter
contents
contentsRect
cornerRadius
doubleSided
filters
frame
hidden
mask
masksToBounds
opacity
position
shadowColor
shadowOffset
shadowOpacity
shadowPath
shadowRadius
sublayers
sublayerTransform
transform
zPosition
```
---
## CAKeyframeAnimation 关键帧动画

&ensp;&ensp;&ensp;&ensp;可以使用继承的`animationWithKeyPath:`方法创建一个`CAKeyframeAnimation`对象，并指定要在层上动画的属性的关键路径。然后可以指定用于控制时间和动画行为的关键帧值。对于大多数动画类型，可以使用值和`keyTimes`属性指定关键帧值。在动画期间，`Core animation`通过在您提供的值之间插入来生成中间值。当动画一个坐标点(例如layer的位置)的值时，你可以指定该点的路径，而不是单独的值。动画的节奏由你提供的时间信息控制。

### 重要属性
属性 | 描述 
- | :-: 
values|用来存放关键帧的数组
path |基于点的属性的路径。
keyTimes |对应关键帧段的时间点的NSNumber数组
timingFunctions |关键帧动画节奏的数组，比如快进慢出、慢进快出等
calculationMode |确定沿路径动画的对象是否旋转以匹配路径切线
tensionValues |定义曲线的紧密性的NSNumber数组
continuityValues |定义时间曲线锐角的NSNumber数组
biasValues |定义曲线相对于控制点的位置的NSNumber数组
Rotation Mode Values |rotationMode属性使用这些常量
Value calculation modes |calculationMode属性使用这些常量

### 效果代码
```
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

```
### 效果图
![CAKeyframeAnimation.gif](https://upload-images.jianshu.io/upload_images/1487718-9916176ef3035803.gif?imageMogr2/auto-orient/strip)

&ensp;&ensp;&ensp;&ensp;需要注意的是removedOnCompletion设置为NO的时候，不需要layer的时候要根据key手动移除动画。
```
[self.pointView.layer removeAnimationForKey:@"position.values"];
[self.pointView.layer removeAnimationForKey:@"position.path"];
```

---
## CATransition 转场动画

&ensp;&ensp;&ensp;&ensp;`CATransition`的父类是`CAAnimation`，和`CAPropertyAnimation`、`CAAnimationGroup`同级。`CATransition`是用来视图的转场动画。
>You can transition between a layer's states by creating and adding a [CATransition](apple-reference-documentation://hckyNQAwLg) object to it. The default transition is a cross fade, but you can specify different effects from a set of predefined transitions.

### 重要属性
属性 | 描述 
- | :-: 
startProgress | 整个变形接收的起点
endProgress | 整个变形接收的终点
type | 指定转换类型
subtype | 转换方向的子类型
filter | 提供转换的图像过滤器对象
Common Transition Types | 指定可以与type属性一起使用的转换类型的常量
Common Transition Subtypes | 指定可以与subtype属性一起使用的转换类型的常量

### 效果代码
&ensp;&ensp;&ensp;&ensp;其中`type`和`subtype`有官方指定的类型
```
/* Common transition types. */

CA_EXTERN NSString * const kCATransitionFade
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionMoveIn
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionPush
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionReveal
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);

/* Common transition subtypes. */

CA_EXTERN NSString * const kCATransitionFromRight
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionFromLeft
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionFromTop
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
CA_EXTERN NSString * const kCATransitionFromBottom
CA_AVAILABLE_STARTING (10.5, 2.0, 9.0, 2.0);
```
&ensp;&ensp;&ensp;&ensp;还有几种效果是私有API，在官方文档中找不到，**慎用**
```
Cube,                     //立体
SuckEffect,               //吮吸
OglFlip,                  //翻转
RippleEffect,             //波纹
PageCurl,                 //翻页
PageUnCurl,               //反翻页
CameraIrisHollowOpen,     //开镜头
CameraIrisHollowClose,    //关镜头
```
&ensp;&ensp;&ensp;&ensp;这里写了一个例子，有12种`type`转场效果和4种`subtype`转场方向，用枚举来封装一下
```
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

- (void)CATransitionWithType:(NSString *)type WithSubtype:(NSString *)subtype
{
    CATransition * animation = [CATransition animation];
    animation.duration = 2.f;
    animation.type = type;
    animation.subtype = subtype;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.layer addAnimation:animation forKey:nil];
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
```
### 效果图
![CATransition1.gif](https://upload-images.jianshu.io/upload_images/1487718-1a8800f104907166.gif?imageMogr2/auto-orient/strip)
![CATransition2.gif](https://upload-images.jianshu.io/upload_images/1487718-1da95c682f270d71.gif?imageMogr2/auto-orient/strip)

---
## CAAnimationGroup 动画组

&ensp;&ensp;&ensp;&ensp;分组动画在`CAAnimationGroup`实例指定的时间中运行。分组动画的持续时间不会被缩放到他们的`CAAnimationGroup`的持续时间。相反，动画被剪切到动画组的持续时间。例如，在一个动画组中分组的10秒动画，持续时间为5秒，只显示动画的前5秒。
### 效果代码
```
#pragma mark - 一个红包雨的例子
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

```
### 效果图
![CAAnimationGroup.gif](https://upload-images.jianshu.io/upload_images/1487718-fbc767740432f20c.gif?imageMogr2/auto-orient/strip)

---
## CASpringAnimation 弹簧动画

&ensp;&ensp;&ensp;&ensp;`CASpringAnimation`的父类是`CABasicAnimation`, `CABasicAnimation`可以看成是只有头尾有值的关键帧动画。
>You would typically use a spring animation to animate a layer's position so that it appears to be pulled towards a target by a spring. The further the layer is from the target, the greater the acceleration towards it is.
CASpringAnimation allows control over physically based attributes such as the spring's damping and stiffness.

&ensp;&ensp;&ensp;&ensp;`CASpringAnimation`是基于物理的属性控制，比如弹簧的阻尼和刚度。
### 重要属性
属性 | 描述 
- | :-: 
damping |定义弹簧运动如何受到阻尼的影响
initialVelocity |初速度
mass|连接到弹簧末端的物体的质量
settlingDuration|预估静止时间
stiffness |弹簧刚度系数
### 效果代码
```
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
```
### 效果图
![CASpringAnimation.gif](https://upload-images.jianshu.io/upload_images/1487718-ae46d1313229aaa6.gif?imageMogr2/auto-orient/strip)


---
### UIView的弹簧动画
另外在看看`cell`上用`UIView Block`弹簧动画的特效
#### 效果代码
```
+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
```

```
- (void)cellAnimation
{
    [self.springTableView reloadData];

    NSArray * cellArrays = self.springTableView.visibleCells;
    CGFloat height = self.springTableView.bounds.size.height;

    for (UITableView * cell in cellArrays)
    {
        cell.transform = CGAffineTransformMakeTranslation(-SCREENWIDTH, height);
    }

    for (NSInteger i = 0 ; i < cellArrays.count ; i ++ )
    {
        UITableViewCell * cell = (UITableViewCell *)cellArrays[i];
        [UIView animateWithDuration:1.5
                              delay:0.05 * i
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:0 animations:^{
                    cell.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:nil];
    }
}
```
#### 效果图
![CellSpringAnimation.gif](https://upload-images.jianshu.io/upload_images/1487718-0a62c12dc5195c94.gif?imageMogr2/auto-orient/strip)

[**源码: CAAnimation**](https://github.com/iOS-Misaki/CAAnimation)
