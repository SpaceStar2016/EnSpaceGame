//
//  SPSHud.h
//  EnSpaceGame
//
//  Created by IAskSpace on 2017/2/16.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const countdownDidEndNotification = @"countdownDidEndNotification";

@interface SPSHud : UIView

+(SPSHud *)showHud:(UIView *)view AndCoundownTime:(NSInteger)time;

-(void)dismissHud;

+(void)dismissHud;

@end
