//
//  TXHRulerScrollView.m
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//

#import "TXHRulerScrollView.h"

@implementation TXHRulerScrollView
{
    CGSize textSize;
    CGFloat longest;
}
- (void)setRulerValue:(CGFloat)rulerValue {
    _rulerValue = rulerValue;
}

- (void)drawRuler {
    
    CGMutablePathRef pathRef1 = CGPathCreateMutable();
    CGMutablePathRef pathRef2 = CGPathCreateMutable();
    //小数刻度
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.strokeColor = self.DecimalScaleColor.CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.lineWidth = self.widthOfScales;
    shapeLayer1.lineCap = kCALineCapButt;
    //整数刻度
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    shapeLayer2.strokeColor = self.integerScaleColor.CGColor;
    shapeLayer2.fillColor = [UIColor clearColor].CGColor;
    shapeLayer2.lineWidth = self.widthOfScales;
    shapeLayer2.lineCap = kCALineCapButt;
    
    for (int i = 0; i <= self.rulerCount; i++) {
        UILabel *rule = [[UILabel alloc] init];
        rule.textColor = self.textColor;
        rule.font = self.textFont;
        rule.text = [NSString stringWithFormat:@"%.0f",i * [self.rulerAverage floatValue]];
        textSize = [rule.text sizeWithAttributes:@{ NSFontAttributeName : rule.font }];
        if (i % 10 == 0) {
            CGPathMoveToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.spaceOfScales * i , TOPANDHEIGHTRATIO * self.rulerHeight);
            CGPathAddLineToPoint(pathRef2, NULL, self.distanceLeftAndRight + self.spaceOfScales * i, self.rulerHeight - TOPANDHEIGHTRATIO * self.rulerHeight - textSize.height);
            longest = self.rulerHeight - TOPANDHEIGHTRATIO * self.rulerHeight * 2 - textSize.height;
            rule.frame = CGRectMake(self.distanceLeftAndRight + self.spaceOfScales * i - textSize.width / 2, self.rulerHeight - TOPANDHEIGHTRATIO * self.rulerHeight - textSize.height, 0, 0);
            [rule sizeToFit];
            [self addSubview:rule];
        }
        else if (i % 5 == 0) {
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.spaceOfScales * i ,TOPANDHEIGHTRATIO * self.rulerHeight + longest * 0.5 * (1 - MEDIUMANDLONGESTRATIO));
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.spaceOfScales * i, TOPANDHEIGHTRATIO * self.rulerHeight + longest * 0.5 * (1 - MEDIUMANDLONGESTRATIO) + longest * MEDIUMANDLONGESTRATIO);
        }
        else
        {
            CGPathMoveToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.spaceOfScales * i , TOPANDHEIGHTRATIO * self.rulerHeight + longest * 0.5 * (1 - SHORTESTANDLONGESTRATIO));
            CGPathAddLineToPoint(pathRef1, NULL, self.distanceLeftAndRight + self.spaceOfScales * i, TOPANDHEIGHTRATIO * self.rulerHeight + longest * 0.5 * (1 - SHORTESTANDLONGESTRATIO) + longest * SHORTESTANDLONGESTRATIO);
        }
    }
    
    shapeLayer1.path = pathRef1;
    shapeLayer2.path = pathRef2;
    
    [self.layer addSublayer:shapeLayer1];
    [self.layer addSublayer:shapeLayer2];
    
    self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight);
    
    // 开启最小模式
    if (_mode) {
        UIEdgeInsets edge = UIEdgeInsetsMake(0, self.rulerWidth / 2.f - self.distanceLeftAndRight, 0, self.rulerWidth / 2.f - self.distanceLeftAndRight);
        self.contentInset = edge;
        self.contentOffset = CGPointMake(self.spaceOfScales * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth + (self.rulerWidth / 2.f + self.distanceLeftAndRight), 0);
    }
    else
    {
        self.contentOffset = CGPointMake(self.spaceOfScales * (self.rulerValue / [self.rulerAverage floatValue]) - self.rulerWidth / 2.f + self.distanceLeftAndRight, 0);
    }
    
    self.contentSize = CGSizeMake(self.rulerCount * self.spaceOfScales + self.distanceLeftAndRight + self.distanceLeftAndRight, self.rulerHeight);
    
}
- (CGSize)getTextSize{
    return textSize;
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

- (CGFloat)widthOfScales {
    if (!_widthOfScales) {
        self.widthOfScales = 1.0;
    }
    return _widthOfScales;
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

@end
