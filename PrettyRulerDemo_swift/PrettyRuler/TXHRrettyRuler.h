//
//  TXHRrettyRuler.h
//  PrettyRuler
//
//  Created by GXY on 15/12/11.
//  Copyright © 2015年 Tangxianhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXHRulerScrollView.h"

@protocol TXHRrettyRulerDelegate <NSObject>

- (void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView;
@end

@interface TXHRrettyRuler : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) id <TXHRrettyRulerDelegate> rulerDeletate;

@property (nonatomic,assign) CGFloat distanceLeftAndRight; //尺子左右距离
@property (nonatomic,assign) CGFloat spaceOfScales; //刻度之间的距离
@property (nonatomic,assign) CGFloat widthOfScales; //刻度的宽度

@property (nonatomic,strong) UIColor *arcColor;//弧线颜色
@property (nonatomic,strong) UIColor *textColor;//字体颜色
@property (nonatomic,strong) UIFont *textFont;//字体

@property (nonatomic,strong) UIColor *integerScaleColor;//整数刻度颜色
@property (nonatomic,strong) UIColor *DecimalScaleColor;//小数刻度颜色
@property (nonatomic,strong) UIColor *IndicatorColor;//中间指示器的颜色

/*
*  count * average = 刻度最大值
*  @param count        10个小刻度为一个大刻度，大刻度的数量
*  @param average      每个小刻度的值，最小精度 0.1
*  @param currentValue 直尺初始化的刻度值
*  @param mode         是否最小模式
*/
- (void)showRulerScrollViewWithCount:(NSUInteger)count
                             average:(NSNumber *)average
                        currentValue:(CGFloat)currentValue
                           smallMode:(BOOL)mode type:(TXHRulerScrollViewType)type;

@end
