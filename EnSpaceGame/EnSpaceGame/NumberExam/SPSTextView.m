//
//  JFTextView.m
//  JustFun
//
//  Created by ZhongSpace on 16/3/28.
//  Copyright © 2016年 zsbrother. All rights reserved.
//

#import "SPSTextView.h"

@interface SPSTextView()

@property(nonatomic,strong)NSMutableDictionary * attribute;

@property(nonatomic,copy)NSString * number;

@end

@implementation SPSTextView



#pragma mark 懒加载

-(NSMutableDictionary *)attribute
{
    if (_attribute == nil) {
        _attribute = [NSMutableDictionary dictionary];
        _attribute[NSForegroundColorAttributeName] =[UIColor grayColor];
        _attribute[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    }
    return _attribute;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 禁止滚动
        self.scrollEnabled = NO;
    }
    return self;
}

-(void)textDidChange
{

}


-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = [placeHolder copy];
    //一有文字就重绘制
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

-(void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    self.attribute[NSForegroundColorAttributeName] = self.placeHolderColor?self.placeHolderColor:[UIColor grayColor];
}

-(void)setPlaceHolderFont:(UIFont *)placeHolderFont
{
    _placeHolderFont = placeHolderFont;
    self.attribute[NSFontAttributeName] = placeHolderFont;
}
//因为汉字占用的大小是英文字符的两倍，统一用汉字大小计算
-(void)setMaxLenght:(NSUInteger)maxLenght
{
    _maxLenght = maxLenght * 2;
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

-(void)setTextViewArray:(NSArray *)textArray
{
    NSMutableString * mStr = [NSMutableString new];
    for (NSString * str in textArray) {
        [mStr appendString:str];
    }
    self.text = mStr;
}

/**通过字节计算长度*/
-(long)getTextLenght
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self.text dataUsingEncoding:enc];
    return [da length];
}



-(void)dealloc
{
    //移除消息中心
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
