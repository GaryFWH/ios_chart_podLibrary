//
//  ChartLineObject.h
//  ChartLibraryDemo
//
//  Created by william on 27/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "ChartData.h"
#import "ChartStructs.h"
#import "ChartConst.h"



NS_ASSUME_NONNULL_BEGIN

@interface ChartLineObject : NSObject

//@property (nonatomic, strong) NSArray<ChartData *> * chartDataList;
//@property (nonatomic, strong) NSDictionary<NSString *, ChartData *> * chartDataDict;
//@property (nonatomic, assign) ChartLineType lineType;
//@property (nonatomic, assign) ChartDataDisplayType chartDataDisplayType; //Not suitable for Bar and Candle Stick
//@property (nonatomic, strong) UIColor * mainColor;
//@property (nonatomic, strong) UIColor * subColor;
@property (nonatomic, strong) NSString * refKey;
@property (nonatomic, strong) NSString * dataName;
@property (nonatomic, strong) NSString * tail;

@property (nonatomic, strong) NSMutableDictionary * chartDataDict;
- (UIColor *)colorWithChartData:(ChartData *)cData;

- (NSDate *)getDateForKey:(NSString *)groupingKey;

- (CGFloat)getMaxValueForKey:(NSString *)groupingKey;
- (CGFloat)getMinValueForKey:(NSString *)groupingKey;
- (CGFloat)getValueForKey:(NSString *)groupingKey forDisplayType:(ChartDataDisplayType)displayType;

- (void)setChartDataByChartDataList:(NSArray *)chartDataList;
//- (void)setChartDataByChartDataList:(NSArray *)chartDataList forChartDisplayType:(ChartDataDisplayType)displayType;
- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect;

@end

@interface ChartLineObjectSingleValue : ChartLineObject

@property (nonatomic, assign) ChartDataDisplayType displayType;
- (void)setChartDataByChartDataList:(NSArray *)chartDataList forChartDisplayType:(ChartDataDisplayType)displayType;

@end

@interface ChartLineObjectBar : ChartLineObject

@property (nonatomic, strong) UIColor * upColor;
@property (nonatomic, strong) UIColor * downColor;

- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor;

@end

@interface ChartLineObjectLine : ChartLineObjectSingleValue

@property (nonatomic, strong) UIColor * mainColor;

- (instancetype)initWithMainColor:(UIColor *)mainColor;

@end

@interface ChartLineObjectArea : ChartLineObjectSingleValue

@property (nonatomic, strong) UIColor * strokeColor;
@property (nonatomic, strong) UIColor * gradientTopColor;
@property (nonatomic, strong) UIColor * gradientMainColor;

- (instancetype)initWithStrokeColor:(UIColor *)strokeColor gradientTopColor:(UIColor *)topColor mainColor:(UIColor *)mainColor ;

@end

@interface ChartLineObjectCandle : ChartLineObject

@property (nonatomic, strong) UIColor * upColor;
@property (nonatomic, strong) UIColor * downColor;

- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor;

@end

@interface ChartLineObjectHisto : ChartLineObjectSingleValue

@property (nonatomic, strong) UIColor * upColor;
@property (nonatomic, strong) UIColor * downColor;
//@property (nonatomic, strong) UIColor * mainColor;
//
- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor;

@end

@interface ChartLineObjectScatter : ChartLineObjectSingleValue

@property (nonatomic, strong) UIColor * mainColor;

- (instancetype)initWithMainColor:(UIColor *)mainColor;

@end

NS_ASSUME_NONNULL_END
