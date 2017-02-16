//
//  SPSHud.m
//  EnSpaceGame
//
//  Created by IAskSpace on 2017/2/16.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import "SPSHud.h"

@interface SPSHud()

@property(nonatomic,assign)CGRect superViewFrame;

@property(nonatomic,weak)UILabel * centerLabel;

@property(nonatomic,strong)NSTimer * coundownTimer;

@property(nonatomic,assign)NSInteger time;

@property(nonatomic,weak)SPSHud * hud;

@end

@implementation SPSHud

+(SPSHud *)shareHud
{
    static SPSHud * shareHud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareHud = [[self alloc] init];
    });
    return shareHud;
}
+(SPSHud *)showHud:(UIView *)view AndCoundownTime:(NSInteger)time
{
    SPSHud * hud = [self shareHud];
    hud.layer.masksToBounds = YES;
    hud.layer.cornerRadius = 10.0;
    hud.layer.borderColor = [UIColor grayColor].CGColor;
    hud.superViewFrame = view.frame;
    hud.time = time;
    hud.backgroundColor = [UIColor blackColor];
    hud.centerLabel.text = [NSString stringWithFormat:@"%ld",(long)time];
    [hud deployView];
    hud.hidden = NO;
    [view addSubview:hud];
    return hud;
}

-(instancetype)init
{
    if (self = [super init]) {
        UILabel *  centerLabel = [UILabel new];
        centerLabel.font = [UIFont systemFontOfSize:25];
        centerLabel.textColor = [UIColor whiteColor];
        centerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:centerLabel];
        self.centerLabel = centerLabel;
    }
    return self;
}


-(void)deployView
{
    CGFloat hudWidth = 150;
    CGFloat hudHeight = 100;
    CGFloat hudX = (self.superViewFrame.size.width - hudWidth) * 0.5;
    CGFloat hudY = (self.superViewFrame.size.height - hudHeight) * 0.5;
    self.frame = CGRectMake(hudX, hudY, hudWidth, hudHeight);
    self.centerLabel.frame = self.bounds;
}

-(void)setHidden:(BOOL)hidden
{
    if (hidden) {
        [self removeTimer];
        
    }else
    {
        [self addTimer];
    }
    [super setHidden:hidden];
}

-(void)dismissHud
{
    self.hidden = YES;
}

+(void)dismissHud
{
    SPSHud * hud = [self shareHud];
    hud.hidden = YES;
}

-(void)countDownBegin
{
    self.time--;
    if (self.time >= 1) {
        self.centerLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.time];
    }else
    {
        self.centerLabel.text = @"GO!";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.hidden =YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:countdownDidEndNotification object:nil];
        });
    }
}

#pragma mark Tool
-(void)addTimer
{
    if (self.coundownTimer == nil) {
        self.coundownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownBegin) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.coundownTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)removeTimer
{
    [self.coundownTimer invalidate];
    self.coundownTimer = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
