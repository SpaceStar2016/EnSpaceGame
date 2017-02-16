//
//  MonthController.m
//  EnSpaceGame
//
//  Created by IAskSpace on 2017/2/16.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import "MonthController.h"

@interface MonthController ()

@end

@implementation MonthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *  centerLabel = [UILabel new];
    centerLabel.font = [UIFont systemFontOfSize:25];
    centerLabel.textColor = [UIColor grayColor];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.frame = self.view.bounds;
    centerLabel.text = @"TO BE CONTINUOUS";
    [self.view addSubview:centerLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
