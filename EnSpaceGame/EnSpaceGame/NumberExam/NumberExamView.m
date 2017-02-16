//
//  HomeView.m
//  EnSpaceGame
//
//  Created by ZhongSpace on 2017/2/3.
//  Copyright © 2017年 ZhongSpace. All rights reserved.
//

#import "NumberExamView.h"
#import "DWBubbleMenuButton.h"
#include <time.h> 
#import <iflyMSC/iflyMSC.h>
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "SPSTextView.h"
#import "SPSHud.h"
#import <SVProgressHUD.h>
#define SPColor(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
#define SPRandomColor SPColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface NumberExamView()<IFlySpeechRecognizerDelegate,IFlyPcmRecorderDelegate>

@property(nonatomic,weak)DWBubbleMenuButton * drawDownwButton;

@property(nonatomic,weak)UIButton * homeButton;

@property(nonatomic,strong)NSTimer * timer;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UILabel *generateNumberLabel;
@property(nonatomic,assign)numberOption option;

@property (weak, nonatomic) IBOutlet SPSTextView *numberTextView;
@property (weak, nonatomic) IBOutlet SPSTextView *answerTextView;

@property (nonatomic, strong) NSString * result;

@property(nonatomic,weak)SPSHud * hud;

/** 语言识别*/
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入

//存放产生数字的数组
@property(nonatomic,strong)NSMutableArray * numberArray;

//存放用户回答的数字的数组
@property(nonatomic,strong)NSMutableArray * answerArray;

@end

static int MaxNumberCount = 10;

@implementation NumberExamView

#pragma mark 懒加载

-(NSMutableArray *)numberArray
{
    if (_numberArray == nil) {
        _numberArray = [NSMutableArray array];
    }
    return _numberArray;
}

-(NSMutableArray *)answerArray
{
    if (_answerArray == nil) {
        _answerArray = [NSMutableArray array];
    }
    return _answerArray;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIButton *homeButton = [self createHomeButtonView];
    self.homeButton = homeButton;
    DWBubbleMenuButton *drawDownwButton = [[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(15,
                                                                                          74,
                                                                                          homeButton.frame.size.width,
                                                                                          homeButton.frame.size.height)
                                                            expansionDirection:DirectionRight homeButtonView:homeButton];
    [drawDownwButton addButtons:[self createDemoButtonArray]];
    [self addSubview:drawDownwButton];
    self.drawDownwButton = drawDownwButton;
    drawDownwButton.animationDuration = 0.2;
    self.option = oneDigit;
    self.generateNumberLabel.layer.masksToBounds = YES;
    self.generateNumberLabel.layer.cornerRadius = 10;
    self.generateNumberLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.generateNumberLabel.hidden = YES;
    self.numberTextView.font = [UIFont systemFontOfSize:15];
    self.numberTextView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    self.answerTextView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    self.generateNumberLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self initRecognizer];
    //接收倒计时结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(countDownDidEnd) name:countdownDidEndNotification object:nil];
}

- (UIButton *)createHomeButtonView {
    UIButton *homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 35.0,35.0f)];
    homeButton.layer.cornerRadius = homeButton.frame.size.height / 2.f;
    homeButton.clipsToBounds = YES;
    homeButton.backgroundColor = [UIColor redColor];
    [homeButton addTarget:self action:@selector(homeButtonViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [homeButton setTitle:@"1" forState:UIControlStateNormal];
    homeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    return homeButton;
}

- (NSArray *)createDemoButtonArray {
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSString *title in @[@"1", @"2", @"3", @"4"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 35.0f, 35.0f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = SPRandomColor;
        button.clipsToBounds = YES;
        button.tag = i++;
        [button addTarget:self action:@selector(dwBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonsMutable addObject:button];
    }
    
    return [buttonsMutable copy];
}
#pragma mark 按钮点击方法
- (IBAction)beiginButtonClick:(UIButton *)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        self.hud = [SPSHud showHud:self AndCoundownTime:3];

    }else
    {
        [self removeTimer];
        [self resetAll];
    }
}


-(void)dwBtnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            self.option = oneDigit;
            break;
        }
        case 1:
        {
            self.option = twoDigits;
            break;
        }
        case 2:
        {
            self.option = threeDigits;
            break;
        }
        case 3:
        {
            self.option = fourDigits;
            break;
        }
            
        default:
        {
            self.option = oneDigit;
            break;
        }
    }
    [self.homeButton setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    [self.drawDownwButton dismissButtons];
}

-(void)homeButtonViewClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.drawDownwButton showButtons];
    }else
    {
        [self.drawDownwButton dismissButtons];
    }
}

-(void)NubmerShouldChange
{
    //每次游戏产生10个数字
    if (self.numberArray.count == MaxNumberCount) {
        //移除定时器
        [self removeTimer];
        //停止监听
        [_iFlySpeechRecognizer stopListening];
        [SVProgressHUD showSuccessWithStatus:@"Game Over"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    int number = generateNumberWithNumberOption(self.option);
    NSString * numberString = nil;
    if (self.numberArray.count== 0) {
       numberString = [NSString stringWithFormat:@"%d",number];
    }else
    {
       numberString = [NSString stringWithFormat:@",%d",number];
    }
    [self.numberArray addObject:numberString];
    self.generateNumberLabel.text = [NSString stringWithFormat:@"%d",number];
    [self.numberTextView setTextViewArray:self.numberArray];
}

-(void)countDownDidEnd
{
    //添加产生数字的定时器
    [self addTimer];
    //开始语音识别
    [self startRecognizer];
}

#pragma mark 业务方法

-(void)resetAll
{
    //停止语言识别
    [_iFlySpeechRecognizer stopListening];
    //清空所有数组
    [self.numberArray removeAllObjects];
    [self.answerArray removeAllObjects];
    self.answerTextView.text = @"";
    self.numberTextView.text = @"";
    //隐藏hud
    [SPSHud dismissHud];
}

#pragma mark Tool
-(void)addTimer
{
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(NubmerShouldChange) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark C Function
static inline unsigned int generateNumberWithNumberOption(numberOption option)
{
    srand((unsigned) time(NULL));
    switch (option) {
        case oneDigit:
        {
             return rand()%10;
        }
        case twoDigits:
        {
            
            return rand()%90 + 10;
        }
        case threeDigits:
        {
            
            return rand()%900 + 100;
        }
        case fourDigits:
        {
            
            return rand()%9000 + 1000;
        }
        default:
        {
            return 0;
        }
    }

}

#pragma mark 语音识别

-(void)startRecognizer
{
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    [_iFlySpeechRecognizer startListening];
    
}

/**
 设置识别参数
 ****/
-(void)initRecognizer
{

    if ([IATConfig sharedInstance].haveView == NO) {//无界面
        //单例模式，无UI的实例
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
            [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
            [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        }
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //设置最长录音时间
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //设置后端点
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //设置前端点
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //网络等待时间
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //设置采样率，推荐使用16K
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            //设置是否返回标点符号
            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            //配置语言
            [IATConfig sharedInstance].language = [IFlySpeechConstant LANGUAGE_ENGLISH];
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        
        //初始化录音器
        if (_pcmRecorder == nil)
        {
            _pcmRecorder = [IFlyPcmRecorder sharedInstance];
        }
        
        _pcmRecorder.delegate = self;
        
        [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
        
        [_pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
    }

}
#pragma mark - IFlySpeechRecognizerDelegate
/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
  

   
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    //显示数字label
    self.generateNumberLabel.hidden = NO;
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    [self removeTimer];
    self.generateNumberLabel.hidden = YES;
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@",resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    [self.answerArray addObject:resultFromJson];
    [self.answerTextView setTextViewArray:self.answerArray];
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    
}


/**
 听写取消回调
 ****/
- (void) onCancel
{
    NSLog(@"识别取消");
}



#pragma mark - IFlyPcmRecorderDelegate
- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
        
        
    }
}

- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error
{
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
