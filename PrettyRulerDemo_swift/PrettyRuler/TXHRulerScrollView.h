//
//  TXHRulerScrollView.h
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DISTANCELEFTANDRIGHT 8.f // 标尺左右距离
#define DISTANCEVALUE 8.f // 每隔刻度实际长度8个点
#define TOPANDHEIGHTRATIO 20 / 100.0 // 刻度顶部距离和ruler 的frame高度比
#define MEDIUMANDLONGESTRATIO 25 / 33.0 // 中等刻度和最长刻度的比例
#define SHORTESTANDLONGESTRATIO 17 / 33.0 // 最短刻度和最长刻度的比例
@interface TXHRulerScrollView : UIScrollView

@property (nonatomic) NSUInteger rulerCount;

@property (nonatomic) NSNumber * rulerAverage;

@property (nonatomic) NSUInteger rulerHeight;

@property (nonatomic) NSUInteger rulerWidth;

@property (nonatomic) CGFloat rulerValue;

@property (nonatomic) BOOL mode;

@property (nonatomic,assign) CGFloat distanceLeftAndRight; //尺子左右距离
@property (nonatomic,assign) CGFloat spaceOfScales; //刻度之间的距离
@property (nonatomic,assign) CGFloat widthOfScales; //刻度的宽度

@property (nonatomic,strong) UIColor *textColor;//字体颜色
@property (nonatomic,strong) UIFont *textFont;//字体

@property (nonatomic,strong) UIColor *integerScaleColor;//整数刻度颜色
@property (nonatomic,strong) UIColor *DecimalScaleColor;//小数刻度颜色

- (CGSize)getTextSize;

- (void)drawRuler;

@end
