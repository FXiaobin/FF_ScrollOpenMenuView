//
//  ViewController.m
//  FFScrollMenuView
//
//  Created by mac on 2018/9/19.
//  Copyright © 2018年 healifeGroup. All rights reserved.
//

#import "ViewController.h"
#import "ScrollMenuView.h"
#import <Masonry.h>



@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    v.backgroundColor = [UIColor orangeColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [v addGestureRecognizer:tap];
    [self.view addSubview:v];
    
    ScrollMenuView *menuView = [[ScrollMenuView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 50) superView:self.view];
    //__weak typeof(self) weakSelf = self;
    menuView.dataArr = @[@"全部",@"会议新闻",@"病例讨论",@"医学新闻",@"直播预告",@"会议新闻",@"神经内科",@"心脏内科",@"直播预告",@"会议新闻",@"病例讨论"];
    menuView.didSelectedIndexBlock = ^(ScrollMenuView *aMenuView, NSInteger index) {
        NSLog(@"-----index = %ld",index);
        
    };
    
    [self.view addSubview:menuView];
    
    
    
    
    
}

- (void)tap:(UITapGestureRecognizer *)sender{
    NSLog(@"----- tap ------");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
