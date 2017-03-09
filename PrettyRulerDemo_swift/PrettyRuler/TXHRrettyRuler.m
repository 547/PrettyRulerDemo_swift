//
//  TXHRrettyRuler.m
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//  withCount:(NSUInteger)count average:(NSUInteger)average

#import "TXHRrettyRuler.h"

#define SHEIGHT_SCALE 8 / 140.0 // 中间指示器顶部闭合三角形高度和ruler 的frame高度比

@implementation TXHRrettyRuler {
    TXHRulerScrollView * rulerScrollView;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        rulerScrollView = [self rulerScrollView];
        rulerScrollView.backgroundColor = self.backgroundColor;
        rulerScrollView.rulerHeight = frame.size.height;
        rulerScrollView.rulerWidth = frame.size.width;
    }
    return self;
}

- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode {
    NSAssert(rulerScrollView != nil, @"***** 调用此方法前，请先调用 initWithFrame:(CGRect)frame 方法初始化对象 rulerScrollView\n");
    NSAssert(currentValue < [average floatValue] * count, @"***** currentValue 不能大于直尺最大值（count * average）\n");
    rulerScrollView.rulerAverage = average;
    rulerScrollView.rulerCount = count;
    rulerScrollView.rulerValue = currentValue;
    rulerScrollView.mode = mode;
    rulerScrollView.spaceOfScales = self.spaceOfScales;
    rulerScrollView.textColor = self.textColor;
    rulerScrollView.textFont = self.textFont;
    rulerScrollView.widthOfScales = self.widthOfScales;
    rulerScrollView.integerScaleColor = self.integerScaleColor;
    rulerScrollView.DecimalScaleColor = self.DecimalScaleColor;
    [rulerScrollView drawRuler];
    [self addSubview:rulerScrollView];
    [self drawRacAndLine];
}

- (TXHRulerScrollView *)rulerScrollView {
    TXHRulerScrollView * rScrollView = [TXHRulerScrollView new];
    rScrollView.delegate = self;
    rScrollView.showsHorizontalScrollIndicator = NO;
    return rScrollView;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(TXHRulerScrollView *)scrollView {
//    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - self.distanceLeftAndRight;
    CGFloat ruleValue = (offSetX / self.spaceOfScales) * [scrollView.rulerAverage floatValue];
    if (ruleValue < 0.f) {
        return;
    } else if (ruleValue > scrollView.rulerCount * [scrollView.rulerAverage floatValue]) {
        return;
    }
    if (self.rulerDeletate) {
        if (!scrollView.mode) {
            scrollView.rulerValue = ruleValue;
        }
        scrollView.mode = NO;
        [self.rulerDeletate txhRrettyRuler:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(TXHRulerScrollView *)scrollView {
    [self animationRebound:scrollView];
}

- (void)scrollViewDidEndDragging:(TXHRulerScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self animationRebound:scrollView];
}

- (void)animationRebound:(TXHRulerScrollView *)scrollView {
//    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - DISTANCELEFTANDRIGHT;
    CGFloat offSetX = scrollView.contentOffset.x + self.frame.size.width / 2 - self.distanceLeftAndRight;
    CGFloat oX = (offSetX / self.spaceOfScales) * [scrollView.rulerAverage floatValue];
#ifdef DEBUG
    NSLog(@"ago*****************ago:oX:%f",oX);
#endif
    if ([self valueIsInteger:scrollView.rulerAverage]) {
        oX = [self notRounding:oX afterPoint:0];
    }
    else {
        oX = [self notRounding:oX afterPoint:1];
    }
#ifdef DEBUG
    NSLog(@"after*****************after:oX:%.1f",oX);
#endif
//    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * self.spaceOfScales + DISTANCELEFTANDRIGHT - self.frame.size.width / 2;
    CGFloat offX = (oX / ([scrollView.rulerAverage floatValue])) * self.spaceOfScales + self.distanceLeftAndRight - self.frame.size.width / 2;
    [UIView animateWithDuration:.2f animations:^{
        scrollView.contentOffset = CGPointMake(offX, 0);
    }];
}

- (void)drawRacAndLine {
    // 圆弧
    CAShapeLayer *shapeLayerArc = [CAShapeLayer layer];
    shapeLayerArc.strokeColor = self.arcColor.CGColor;
    shapeLayerArc.fillColor = [UIColor clearColor].CGColor;
    shapeLayerArc.lineWidth = self.widthOfScales;
    shapeLayerArc.lineCap = kCALineCapButt;
    shapeLayerArc.frame = self.bounds;
    
    // 渐变
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = @[(id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:0.0f].CGColor,
                        (id)[[UIColor whiteColor] colorWithAlphaComponent:1.f].CGColor];
    
    gradient.locations = @[[NSNumber numberWithFloat:0.0f],
                           [NSNumber numberWithFloat:0.6f]];
    
    gradient.startPoint = CGPointMake(0, .5);
    gradient.endPoint = CGPointMake(1, .5);
    
    CGMutablePathRef pathArc = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathArc, NULL, 0, TOPANDHEIGHTRATIO * self.frame.size.height);
    CGPathAddQuadCurveToPoint(pathArc, NULL, self.frame.size.width / 2, - 20, self.frame.size.width, TOPANDHEIGHTRATIO * self.frame.size.height);
    
    shapeLayerArc.path = pathArc;
    [self.layer addSublayer:shapeLayerArc];
    [self.layer addSublayer:gradient];
    
    // 红色指示器
    CAShapeLayer *shapeLayerLine = [CAShapeLayer layer];
    shapeLayerLine.strokeColor = self.IndicatorColor.CGColor;
    shapeLayerLine.fillColor = self.IndicatorColor.CGColor;
    shapeLayerLine.lineWidth = self.widthOfScales;
    shapeLayerLine.lineCap = kCALineCapSquare;
    
    CGFloat triangleHeight = SHEIGHT_SCALE * self.frame.size.height; //中间指示器顶部闭合三角形高度
    NSUInteger ruleHeight = rulerScrollView.getTextSize.height; // 文字高度
    CGMutablePathRef pathLine = CGPathCreateMutable();
    CGPathMoveToPoint(pathLine, NULL, self.frame.size.width / 2, self.frame.size.height - TOPANDHEIGHTRATIO * self.frame.size.height - ruleHeight);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, TOPANDHEIGHTRATIO * self.frame.size.height + triangleHeight);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 - triangleHeight / 2, TOPANDHEIGHTRATIO * self.frame.size.height);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2 + triangleHeight / 2, TOPANDHEIGHTRATIO * self.frame.size.height);
    CGPathAddLineToPoint(pathLine, NULL, self.frame.size.width / 2, TOPANDHEIGHTRATIO * self.frame.size.height + triangleHeight);
    
    shapeLayerLine.path = pathLine;
    [self.layer addSublayer:shapeLayerLine];
}

#pragma mark - tool method

- (CGFloat)notRounding:(CGFloat)price afterPoint:(NSInteger)position {
    NSDecimalNumberHandler*roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber*ouncesDecimal;
    NSDecimalNumber*roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc]initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces floatValue];
}

- (BOOL)valueIsInteger:(NSNumber *)number {
    NSString *value = [NSString stringWithFormat:@"%f",[number floatValue]];
    if (value != nil) {
        NSString *valueEnd = [[value componentsSeparatedByString:@"."] objectAtIndex:1];
        NSString *temp = nil;
        for(int i =0; i < [valueEnd length]; i++)
        {
            temp = [valueEnd substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return NO;
            }
        }
    }
    return YES;
}

- (CGFloat)distanceLeftAndRight {
    if (!_distanceLeftAndRight) {
        self.distanceLeftAndRight = DISTANCELEFTANDRIGHT;
    }
    return _distanceLeftAndRight;
}
- (CGFloat)spaceOfScales {
    if (!_spaceOfScales) {
        self.spaceOfScales = DISTANCEVALUE;
    }
    return _spaceOfScales;
}

- (UIColor *)arcColor{
    if (!_arcColor) {
        self.arcColor = [UIColor lightGrayColor];
    }
    return _arcColor;
}

- (UIColor *)textColor{
    if (!_textColor) {
        self.textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIFont *)textFont{
    if (!_textFont) {
        self.textFont = [UIFont systemFontOfSize:17];
    }
    return _textFont;
}

- (UIColor *)integerScaleColor{
    if (!_integerScaleColor) {
        self.integerScaleColor = [UIColor grayColor];
    }
    return _integerScaleColor;
}

- (UIColor *)DecimalScaleColor{
    if (!_DecimalScaleColor) {
        self.DecimalScaleColor = [UIColor lightGrayColor];
    }
    return _DecimalScaleColor;
}

- (UIColor *)IndicatorColor{
    if (!_IndicatorColor) {
        self.IndicatorColor = [UIColor redColor];
    }
    return _IndicatorColor;
}

- (CGFloat)widthOfScales {
    if (!_widthOfScales) {
        self.widthOfScales = 1.0;
    }
    return _widthOfScales;
}

@end
