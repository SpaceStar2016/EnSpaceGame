//
//  EnTabBarController.m
//  EnSpaceGame
//
//  Created by ZhongSpace on 2017/2/7.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import "EnTabBarController.h"
#import "NumberExamVC.h"
#import "MonthController.h"
@interface EnTabBarController ()

@end

@implementation EnTabBarController

+(void)initialize  // 第一次用到这个类的时候，就会调用这个方法！！！所以可以拿到全局的tabBarItems;
{
    //    NSLog(@"%s",__func__);
    //    UITabBarItem * Item = [UITabBarItem appearance];  //只要一个类遵守UIAppearance协议，就能拿到它！不常用，一改就改全部可以用另外一种方法，如下;
    NSArray * array = [NSArray arrayWithObject:self];//只是修改TabBarItem(self)这个类里面的Items不用全局修改！
    UITabBarItem * Item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:array];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    dict[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    [Item setTitleTextAttributes:dict forState:UIControlStateSelected];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard * NumberExamSB = [UIStoryboard storyboardWithName:@"NumberExam" bundle:[NSBundle mainBundle]];
    NumberExamVC * numberVC = [NumberExamSB instantiateViewControllerWithIdentifier:@"NumberExam"];
    UINavigationController * numberNav = [[UINavigationController alloc] initWithRootViewController:numberVC];
    
    
    MonthController * month = [[MonthController alloc] init];
    UINavigationController * monthTest = [[UINavigationController alloc] initWithRootViewController:month];
    
    [self setUpChildController:numberNav image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"] title:@"Number"];
    
    
    [self setUpChildController:monthTest image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"] title:@"Month"];
    
    
    [self addChildViewController:numberNav];
    [self addChildViewController:monthTest];
    
}


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  
    
    
}

-(void)setUpChildController:(UIViewController*)VC image:(UIImage*)image selectedImage:(UIImage*)selectedImage title:(NSString*)title
{
    //设置tabbar
    VC.tabBarItem.image = image;
    VC.tabBarItem.selectedImage = selectedImage;
    VC.tabBarItem.title = title;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
