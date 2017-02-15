//
//  HomeVC.m
//  EnSpaceGame
//
//  Created by ZhongSpace on 2017/2/3.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import "NumberExamVC.h"

@interface NumberExamVC ()

@end

@implementation NumberExamVC

#pragma mark life-cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self deployTitleView];
    
}

-(void)deployTitleView
{
    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 50, 50);
    label.text = @"I love Space";
    self.navigationItem.titleView = label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
