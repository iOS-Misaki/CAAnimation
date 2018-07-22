//
//  CellSpringAnimationViewController.m
//  CoreAnimation
//
//  Created by 余意 on 2018/7/22.
//  Copyright © 2018年 余意. All rights reserved.
//

#import "CellSpringAnimationViewController.h"

#define  RGBA(R,G,B,A)            [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]
#define  RANDOMCOLOR              RGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define  SCREENWIDTH              [UIScreen mainScreen].bounds.size.width
#define  SCREENHEIGHT             [UIScreen mainScreen].bounds.size.height

@interface CellSpringAnimationViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * springTableView;

@end

@implementation CellSpringAnimationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self cellAnimation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cellAnimation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self.springTableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld个cell",indexPath.row];
    cell.backgroundColor = [self colorAtIndex:(double)indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


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


- (UIColor *)colorAtIndex:(double)index
{
    CGFloat redfloat =  index / 20.0 ;
    return [UIColor colorWithRed:redfloat green:0 blue:1 alpha:1];
}

- (UITableView *)springTableView
{
    if (!_springTableView)
    {
        _springTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _springTableView.delegate = self;
        _springTableView.dataSource = self;
        _springTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_springTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:_springTableView];
    }
    return _springTableView;
}

@end
