//
//  DWBubbleMenuButton.h
//  DWBubbleMenuButtonExample
//
//  Created by Derrick Walker on 10/8/14.
//  Copyright (c) 2014 Derrick Walker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ExpansionDirection) {
    DirectionLeft = 0,
    DirectionRight,
    DirectionUp,
    DirectionDown
};


@class DWBubbleMenuButton;

@protocol DWBubbleMenuViewDelegate <NSObject>

@optional
- (void)bubbleMenuButtonWillExpand:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidExpand:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonWillCollapse:(DWBubbleMenuButton *)expandableView;
- (void)bubbleMenuButtonDidCollapse:(DWBubbleMenuButton *)expandableView;

@end

@interface DWBubbleMenuButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak, readonly) NSArray *buttons;

/**用于点击延伸的的homeButtonView*/
@property (nonatomic, strong) UIView *homeButtonView;

/**当前的状态，是否已经展开*/
@property (nonatomic, readonly) BOOL isCollapsed;

/**代理*/
@property (nonatomic, weak) id <DWBubbleMenuViewDelegate> delegate;

/**按钮伸展动画的方向*/
@property (nonatomic) enum ExpansionDirection direction;


@property (nonatomic) BOOL animatedHighlighting;

/**点击菜单按钮是否收缩，默认点击之后不收缩*/
@property (nonatomic) BOOL collapseAfterSelection;

/**动画执行的时间*/
@property (nonatomic) float animationDuration;

/**homeButton简单的点击动画属性*/
@property (nonatomic) float standbyAlpha;

/**homeButton简单的点击动画属性*/
@property (nonatomic) float highlightAlpha;

/**每个按钮的间距*/
@property (nonatomic) float buttonSpacing;

/**初始化方法，建议按钮的大小和homeView的大小一样*/
- (instancetype)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction;

/**初始化方法，建议按钮的大小和homeView的大小一样*/
- (instancetype)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction homeButtonView:(UIView *)homeButtomView;

/**添加按钮数组*/
- (void)addButtons:(NSArray *)buttons;

/**添加单个按钮*/
- (void)addButton:(UIButton *)button;

/**动画展示*/
- (void)showButtons;

/**动画消失*/
- (void)dismissButtons;

@end
