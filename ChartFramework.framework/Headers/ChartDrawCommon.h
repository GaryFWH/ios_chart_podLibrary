//
//  ChartDrawCommon.h
//  ChartLibraryDemo
//
//  Created by william on 28/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ChartStructs.h"
#import "ChartConst.h"
#import "ChartData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ChartTextBoxPointDirection){
    ChartTextBoxPointDirectionFromCenter,
    ChartTextBoxPointDirectionFromTopLeft,
    ChartTextBoxPointDirectionFromTopRight,
    ChartTextBoxPointDirectionFromBottomLeft,
    ChartTextBoxPointDirectionFromBottomRight,
    ChartTextBoxPointDirectionFromTop,
    ChartTextBoxPointDirectionFromBottom,
    ChartTextBoxPointDirectionFromLeft,
    ChartTextBoxPointDirectionFromRight,
};

@interface chartTextBoxInfo: NSObject
@property (strong, nonatomic) UIFont * font;
@property (strong, nonatomic) UIColor * fontColor;
@property (strong, nonatomic) UIColor * bgColor;
@property (assign, nonatomic) CGRect rect;
@property (strong, nonatomic) NSString * text;

@end

@interface ChartDrawCommon : NSObject


+ (NSDictionary *)getDataDictForChartData:(ChartData *)chartData forChartLineType:(ChartLineType)lineType chartDataDisplayType:(ChartDataDisplayType)displayType forDisplayInfo:(ChartDisplayInfo *)displayInfo;

+ (void)DrawRectOnContext:(CGContextRef)context rect:(CGRect)rect color:(UIColor *)color isFill:(bool)isFill;
+ (void)DrawLineOnContext:(CGContextRef)context pointA:(CGPoint)pointA pointB:(CGPoint)pointB color:(UIColor *)color;
+ (void)DrawDashLineOnContext:(CGContextRef)context pointA:(CGPoint)pointA pointB:(CGPoint)pointB color:(UIColor *)color;

+ (chartTextBoxInfo *)GetTextRectFromPoint:(CGPoint)refPoint pointDirection:(ChartTextBoxPointDirection)pointDirection sizeLimit:(CGSize)sizeLimit text:(NSString *)text initialFont:(UIFont *)initialFont fontColor:(UIColor *)fontColor;
+ (chartTextBoxInfo *)GetTextRectFromPoint:(CGPoint)refPoint pointDirection:(ChartTextBoxPointDirection)pointDirection sizeLimit:(CGSize)sizeLimit text:(NSString *)text initialFont:(UIFont *)initialFont fontColor:(UIColor *)fontColor bgColor:(UIColor *)bgColor;
+ (void)DrawTextOnContext:(CGContextRef)context textBoxInfo:(chartTextBoxInfo *)textBoxInfo;
@end

NS_ASSUME_NONNULL_END
