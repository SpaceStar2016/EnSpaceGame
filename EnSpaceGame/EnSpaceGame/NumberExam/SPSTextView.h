//
//  JFTextView.h
//  JustFun
//
//  Created by ZhongSpace on 16/3/28.
//  Copyright © 2016年 zsbrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSTextView;

@protocol SPSTextViewDelegate <NSObject>

-(void)textView:(SPSTextView *)textView DidEnterTextLenght:(NSUInteger)lenght;

@end

@interface SPSTextView : UITextView

/**占位文字*/
@property(nonatomic,copy)NSString * placeHolder;

/**占位文字的颜色*/
@property(nonatomic,strong)UIColor * placeHolderColor;

/**占位文字的字体*/
@property(nonatomic,strong)UIFont * placeHolderFont;

/**最大输入的汉字数量，默认为100*/
@property(nonatomic,assign)NSUInteger maxLenght;

-(void)setTextViewArray:(NSArray *)textArray;

@end
