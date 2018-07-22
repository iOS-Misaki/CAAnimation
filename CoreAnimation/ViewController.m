//
//  ViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/21.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "ViewController.h"

#import "KeyframeAnimationViewController.h"
#import "CAAnimationGroupViewController.h"
#import "CATransitionViewController.h"
#import "CASpringAnimationViewController.h"
#import "CellSpringAnimationViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSArray * titleArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Core Animation";
    
    UIImage * bgImage = [self imageWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1) Withcolor:[UIColor colorWithWhite:1 alpha:0]];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    [self tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        KeyframeAnimationViewController * vc = [[KeyframeAnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        CAAnimationGroupViewController * vc = [[CAAnimationGroupViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        CATransitionViewController * vc = [[CATransitionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 3)
    {
        CASpringAnimationViewController * vc = [[CASpringAnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 4)
    {
        CellSpringAnimationViewController * vc = [[CellSpringAnimationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIImage *)imageWithFrame:(CGRect)frame Withcolor:(UIColor *)color
{
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    UIImage * theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[@"CAKeyframeAnimation-关键帧动画",
                        @"CAAnimationGroup-红包雨动画",
                        @"CATransition-转场动画",
                        @"CASpringAnimation-弹簧动画",
                        @"Cell-弹簧动画"];
    }
    return _titleArray;
}


@end
