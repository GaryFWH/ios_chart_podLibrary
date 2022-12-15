//
//  ChartLineObject.m
//  ChartLibraryDemo
//
//  Created by william on 27/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartLineObject.h"
#import "ChartDrawCommon.h"

@implementation ChartLineObject
//@synthesize chartDataDict;
- (NSDate *)getDateForKey:(NSString *)groupingKey {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            return data.date;
        }
    }
    return nil;
}

- (CGFloat)getMaxValueForKey:(NSString *)groupingKey {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            return data.high;
        }
    }
    return -0.0001f;
}

- (CGFloat)getMinValueForKey:(NSString *)groupingKey {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            return data.low;
        }
    }
    return -0.0001f;
}

- (CGFloat)getValueForKey:(NSString *)groupingKey forDisplayType:(ChartDataDisplayType)displayType {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            CGFloat value;
            switch (displayType) {
                case ChartDataDisplayTypeOpen:
                    value = data.open;
                    break;
                case ChartDataDisplayTypeClose:
                default:
                    value = data.close;
                    break;
                case ChartDataDisplayTypeHigh:
                    value = data.high;
                    break;
                case ChartDataDisplayTypeLow:
                    value = data.low;
                    break;
                case ChartDataDisplayTypeVolume:
                    value = data.volume;
                    break;
            }
            return value;
        }
    }
    return -0.0001f;
}

- (void)setChartDataByChartDataList:(NSArray *)chartDataList {
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    for (ChartData * data in chartDataList){
        [mutDict setObject:data forKey:data.groupingKey];
    }
    self.chartDataDict = mutDict;
}

//- (void)setChartDataByChartDataList:(NSArray *)chartDataList forChartDisplayType:(ChartDataDisplayType)displayType {
//    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
//    for (ChartData * data in chartDataList){
//        ChartData * simpleData = [[ChartData alloc] init];
//        CGFloat value;
//        switch (displayType) {
//            case ChartDataDisplayTypeOpen:
//                value = data.open;
//                break;
//            case ChartDataDisplayTypeClose:
//            default:
//                value = data.close;
//                break;
//            case ChartDataDisplayTypeHigh:
//                value = data.high;
//                break;
//            case ChartDataDisplayTypeLow:
//                value = data.low;
//                break;
//            case ChartDataDisplayTypeVolume:
//                value = data.volume;
//                break;
//        }
//        simpleData.open = value;
//        simpleData.close = value;
//        simpleData.low = value;
//        simpleData.high = value;
//        simpleData.volume = value;
//        simpleData.date = data.date;
//        simpleData.groupingKey = data.groupingKey;
//        [mutDict setObject:simpleData forKey:data.groupingKey];
//    }
//    self.chartDataDict = mutDict;
//}

- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    //Not draw by its own
    return;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    return [UIColor blackColor];
}

@end

@implementation ChartLineObjectSingleValue

- (void)setChartDataByChartDataList:(NSArray *)chartDataList forChartDisplayType:(ChartDataDisplayType)displayType {
    [super setChartDataByChartDataList:chartDataList];
    self.displayType = displayType;
}

- (CGFloat)getMaxValueForKey:(NSString *)groupingKey {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            return [self valueFromChartData:data];
        }
    }
    return -0.0001f;
}

- (CGFloat)getMinValueForKey:(NSString *)groupingKey {
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            return [self valueFromChartData:data];
        }
    }
    return -0.0001f;
}

- (CGFloat)valueFromChartData:(ChartData *)data {
    CGFloat value;
    switch (self.displayType) {
        case ChartDataDisplayTypeOpen:
            value = data.open;
            break;
        case ChartDataDisplayTypeClose:
        default:
            value = data.close;
            break;
        case ChartDataDisplayTypeHigh:
            value = data.high;
            break;
        case ChartDataDisplayTypeLow:
            value = data.low;
            break;
        case ChartDataDisplayTypeVolume:
            value = data.volume;
            break;
    }
    return value;
}

- (CGFloat)getValueForKey:(NSString *)groupingKey forDisplayType:(ChartDataDisplayType)displayType {
    //Ignore input display Type
    if (self.chartDataDict){
        ChartData * data = [self.chartDataDict objectForKey:groupingKey];
        if (data){
            CGFloat value;
            switch (self.displayType) {
                case ChartDataDisplayTypeOpen:
                    value = data.open;
                    break;
                case ChartDataDisplayTypeClose:
                default:
                    value = data.close;
                    break;
                case ChartDataDisplayTypeHigh:
                    value = data.high;
                    break;
                case ChartDataDisplayTypeLow:
                    value = data.low;
                    break;
                case ChartDataDisplayTypeVolume:
                    value = data.volume;
                    break;
            }
            return value;
        }
    }
    return -0.0001f;
}

@end


@implementation ChartLineObjectBar

- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor {
    if (self = [self init]){
        self.upColor = upColor;
        self.downColor = downColor;
    }
    return self;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    if (cData.close >= cData.open){
        return self.upColor;
    }
    return self.downColor;
}

- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect{
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    
    CGFloat width = displayInfo.chartSetting.xAxisPerValue * displayInfo.chartSetting.xAxisPerGapScale;
    
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }

        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
         
        [coorDict setObject:@(xValue) forKey:@"xValue"];
        CGFloat highY = [displayInfo GetYCoodinateForValue:cData.high];
        CGFloat openY = [displayInfo GetYCoodinateForValue:cData.open];
        CGFloat closeY = [displayInfo GetYCoodinateForValue:cData.close];
        CGFloat lowY = [displayInfo GetYCoodinateForValue:cData.low];
        
        [coorDict setObject:@(highY) forKey:@"high"];
        [coorDict setObject:@(openY) forKey:@"open"];
        [coorDict setObject:@(closeY) forKey:@"close"];
        [coorDict setObject:@(lowY) forKey:@"low"];
        
        if (cData.close >= cData.open){
            [coorDict setObject:@(YES) forKey:@"isUp"];
        } else {
            [coorDict setObject:@(NO) forKey:@"isUp"];
        }
        
        [coorDataDict addObject:coorDict];
    }
    [self DrawBarOnContext:context rect:chartRect pointList:coorDataDict width:width upColor:self.upColor downColor:self.downColor];
}

- (void)DrawBarOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList width:(CGFloat)width upColor:(UIColor *)upColor downColor:(UIColor *)downColor {
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    for (NSDictionary * dict in pointList){
        CGFloat xValue = [[dict objectForKey:@"xValue"] floatValue];
        CGFloat high = [[dict objectForKey:@"high"] floatValue];
        CGFloat open = [[dict objectForKey:@"open"] floatValue];
        CGFloat low = [[dict objectForKey:@"low"] floatValue];
        CGFloat close = [[dict objectForKey:@"close"] floatValue];
        
        CGPoint topPoint = CGPointMake(xValue, high);
        CGPoint bottomPoint = CGPointMake(xValue, low);
        
        BOOL isUp = [[dict objectForKey:@"isUp"] boolValue];
        UIColor * color;
        BOOL isFill;
        if (isUp){
            color = upColor;
            isFill = NO;
        } else {
            color = downColor;
            isFill = YES;
        }
        
        [ChartDrawCommon DrawLineOnContext:context pointA:topPoint pointB:bottomPoint color:color];
        
        CGPoint openPoint = CGPointMake(xValue, open);
        CGPoint closePoint = CGPointMake(xValue, close);
        
        CGPoint openLeftPoint = CGPointMake(openPoint.x - width/2, openPoint.y);
        CGPoint closeRightPoint = CGPointMake(closePoint.x + width/2, closePoint.y);
        
        [ChartDrawCommon DrawLineOnContext:context pointA:openLeftPoint pointB:openPoint color:color];
        [ChartDrawCommon DrawLineOnContext:context pointA:closePoint pointB:closeRightPoint color:color];
        
//        NSLog(@"DrawBarOnContext Top{%.2f, %.2f}, Bot{%.2f, %.2f}", topPoint.x, topPoint.y, bottomPoint.x, bottomPoint.y);
//        NSLog(@"DrawBarOnContext openLeft{%.2f, %.2f}, open{%.2f, %.2f}", openLeftPoint.x, openLeftPoint.y, openPoint.x, openPoint.y);
//        NSLog(@"DrawBarOnContext closePoint{%.2f, %.2f}, closeRightPoint{%.2f, %.2f}", closePoint.x, closePoint.y, closeRightPoint.x, closeRightPoint.y);
    }
    CGContextRestoreGState(context);
}

@end

@implementation ChartLineObjectLine

- (instancetype)initWithMainColor:(UIColor *)mainColor {
    if (self = [self init]){
        self.mainColor = mainColor;
    }
    return self;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    return self.mainColor;
}

- (void)setChartDataByChartDataList:(NSArray *)chartDataList {
    //Default to close
    [self setChartDataByChartDataList:chartDataList forChartDisplayType:ChartDataDisplayTypeClose];
}


- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }
        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
//        if (cData.close == -0.0001f){
//            continue;
//        }
        
        
        [coorDict setObject:@(xValue) forKey:@"xValue"];
        CGFloat value = [displayInfo GetYCoodinateForValue:[self valueFromChartData:cData]];
        [coorDict setObject:@(value) forKey:@"value"];
        
        [coorDataDict addObject:coorDict];
    }
    [self DrawLineChartOnContext:context rect:chartRect pointList:coorDataDict color:self.mainColor forDisplayInfo:displayInfo];
}

- (void)DrawLineChartOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList color:(UIColor *)color forDisplayInfo:(ChartDisplayInfo *)displayInfo {
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, displayInfo.chartSetting.chartLineTypeLineLineWidth);
    
    CGMutablePathRef path=CGPathCreateMutable();
    
    BOOL isFirst = YES;
    for (NSDictionary * dict in pointList){
        CGFloat xValue = [[dict objectForKey:@"xValue"] floatValue];
        CGFloat value  = [[dict objectForKey:@"value"] floatValue];
        if (isFirst){
            CGPathMoveToPoint(path, NULL, xValue, value);
            isFirst = NO;
            continue;
        }
        CGPathAddLineToPoint(path, NULL, xValue, value);
    }
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end

@implementation ChartLineObjectArea

- (instancetype)initWithStrokeColor:(UIColor *)strokeColor gradientTopColor:(UIColor *)topColor mainColor:(UIColor *)mainColor {
    if (self = [self init]){
        self.strokeColor = strokeColor;
        self.gradientTopColor = topColor;
        self.gradientMainColor = mainColor;
    }
    return self;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    return self.strokeColor;
}

- (void)setChartDataByChartDataList:(NSArray *)chartDataList {
    //Default to close
    [self setChartDataByChartDataList:chartDataList forChartDisplayType:ChartDataDisplayTypeClose];
}

- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }
        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
         
        [coorDict setObject:@(xValue) forKey:@"xValue"];
        CGFloat value = [displayInfo GetYCoodinateForValue:[self valueFromChartData:cData]];
        [coorDict setObject:@(value) forKey:@"value"];
        
        [coorDataDict addObject:coorDict];
    }
    [self DrawAreaOnContext:context rect:chartRect pointList:coorDataDict lineColor:self.strokeColor areaTopColor:self.gradientTopColor areaMainColor:self.gradientMainColor forDisplayInfo:displayInfo];
}

- (void)DrawAreaOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList lineColor:(UIColor *)lineColor areaTopColor:(UIColor *)areaTopColor areaMainColor:(UIColor *)areaMainColor forDisplayInfo:(ChartDisplayInfo *)displayInfo {
    ChartGlobalSetting * chartSetting = displayInfo.chartSetting;
    
    if ([pointList count] > 0){
        CGFloat startr = 0;
        CGFloat startg = 0;
        CGFloat startb = 0;
        CGFloat endr = 0;
        CGFloat endg = 0;
        CGFloat endb = 0;
        CGFloat alpha = 0;
        
        [areaTopColor getRed:&startr green:&startg blue:&startb alpha:&alpha];
        [areaMainColor getRed:&endr green:&endg blue:&endb alpha:&alpha];
        CGFloat componts[]={ startr,startg,startb,210/255.0,
                            endr,endg,endb,210/255.0 };
    
        CGFloat locations[2] = {chartSetting.chartLineTypeAreaTopColorLocation, chartSetting.chartLineTypeAreaMainColorLocation};
        size_t num_locations = 2;
        
        // Draw Area
        CGContextSaveGState(context);
        CGContextClipToRect(context, rect);
        CGMutablePathRef pathTopLine = CGPathCreateMutable();
        CGMutablePathRef pathArea = CGPathCreateMutable();

        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, componts, locations, num_locations);
        /*
            *第一個參數：顏色空間
            *第二個參數：CGFloat數組，指定漸變的開始顏色，終止顏色，以及過度色（如果有的話）
            *第三個參數：指定每個顏色在漸變色中的位置，值介於0.0-1.0之間
                *0.0表示最開始的位置，1.0表示漸變結束的位置
            *第四個參數：漸變中使用的顏色數
        */
        
        //    for (NSInteger i = 1; i < [pointList count]; i++){
            BOOL first = NO;
            for (NSDictionary * point in pointList){
                CGFloat xValue = [[point objectForKey:@"xValue"] floatValue];
                CGFloat value  = [[point objectForKey:@"value"] floatValue];
                if (!first){
                    CGPathMoveToPoint(pathTopLine, NULL, xValue, value);
                    CGPathMoveToPoint(pathArea, NULL, xValue, value);

                    first = YES;
                    continue;
                }
        //        NSDictionary * point = [pointList objectAtIndex:i];
                CGPathAddLineToPoint(pathTopLine, NULL, xValue, value);
                CGPathAddLineToPoint(pathArea, NULL, xValue, value);
            }
        
        NSDictionary * firstPoint = [pointList firstObject];
        NSDictionary * lastPoint = [pointList lastObject];
        
        if (pointList.count == 1) {
            CGPathAddLineToPoint(pathArea, NULL, [[lastPoint objectForKey:@"xValue"] floatValue] + chartSetting.xAxisPerValue , rect.size.height);
            CGPathAddLineToPoint(pathArea, NULL, [[firstPoint objectForKey:@"xValue"] floatValue] - chartSetting.xAxisPerValue , rect.size.height);
        } else {
            CGPathAddLineToPoint(pathArea, NULL, [[lastPoint objectForKey:@"xValue"] floatValue] , rect.size.height);
            CGPathAddLineToPoint(pathArea, NULL, [[firstPoint objectForKey:@"xValue"] floatValue] , rect.size.height);
        }
        CGContextAddPath(context, pathArea);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradientRef, CGPointMake(rect.origin.x, rect.origin.y), CGPointMake(rect.origin.x, rect.size.height), 0);

        CGGradientRelease(gradientRef);
        CGColorSpaceRelease(colorSpaceRef);

        CGPathRelease(pathArea);
        CGContextRestoreGState(context);
        

        // Draw Top Line
        CGContextSaveGState(context);
        CGContextClipToRect(context, rect);
        
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        CGContextSetLineWidth(context, chartSetting.chartLineTypeAreaLineWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddPath(context, pathTopLine);
        CGContextStrokePath(context);
        
        CGPathRelease(pathTopLine);
        CGContextRestoreGState(context);
    }
}

@end

@implementation ChartLineObjectCandle

- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor {
    if (self = [self init]){
        self.upColor = upColor;
        self.downColor = downColor;
    }
    return self;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    if (cData.close >= cData.open){
        return self.upColor;
    }
    return self.downColor;
}

- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    CGFloat width = displayInfo.chartSetting.xAxisPerValue * displayInfo.chartSetting.xAxisPerGapScale;
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }
        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
        CGFloat highY = [displayInfo GetYCoodinateForValue:cData.high];
        CGFloat openY = [displayInfo GetYCoodinateForValue:cData.open];
        CGFloat closeY = [displayInfo GetYCoodinateForValue:cData.close];
        CGFloat lowY = [displayInfo GetYCoodinateForValue:cData.low];
         
        [coorDict setObject:@(xValue) forKey:@"xValue"];
//        CGFloat value = [displayInfo GetYCoodinateForValue:cData.close];
//        [coorDict setObject:@(value) forKey:@"value"];
        [coorDict setObject:@(highY) forKey:@"high"];
        [coorDict setObject:@(lowY) forKey:@"low"];
        if (cData.close >= cData.open){
            [coorDict setObject:@(YES) forKey:@"isUp"];
            [coorDict setObject:@(openY) forKey:@"candleLow"];
            [coorDict setObject:@(closeY) forKey:@"candleHigh"];
        } else {
            [coorDict setObject:@(NO) forKey:@"isUp"];
            [coorDict setObject:@(openY) forKey:@"candleHigh"];
            [coorDict setObject:@(closeY) forKey:@"candleLow"];
        }
        
        [coorDataDict addObject:coorDict];
    }
    [self DrawCandleOnContext:context rect:chartRect pointList:coorDataDict width:width upColor:self.upColor downColor:self.downColor];
}

- (void)DrawCandleOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList width:(CGFloat)width upColor:(UIColor *)upColor downColor:(UIColor *)downColor {
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    for (NSDictionary * point in pointList){
        BOOL isUp = [[point objectForKey:@"isUp"] boolValue];
        UIColor * color;
        BOOL isFill;
        if (isUp){
            color = upColor;
            isFill = NO;
        } else {
            color = downColor;
            isFill = YES;
        }
        CGFloat topPointY = [[point objectForKey:@"high"] floatValue];
        CGFloat bottomPointY = [[point objectForKey:@"low"] floatValue];
        CGFloat candleTopY = [[point objectForKey:@"candleHigh"] floatValue];
        CGFloat candleBottomY = [[point objectForKey:@"candleLow"] floatValue];
        CGFloat xValue = [[point objectForKey:@"xValue"] floatValue];
        
        CGPoint topPoint = CGPointMake(xValue, topPointY);
        CGPoint bottomPoint = CGPointMake(xValue, bottomPointY);
        CGPoint candleTop = CGPointMake(xValue, candleTopY);
        CGPoint candleBottom = CGPointMake(xValue, candleBottomY);
        
        if (topPointY != candleTopY){
            [ChartDrawCommon DrawLineOnContext:context pointA:topPoint pointB:candleTop color:color];
        }
        if (candleBottomY != bottomPointY){
            [ChartDrawCommon DrawLineOnContext:context pointA:candleBottom pointB:bottomPoint color:color];
        }
        if (candleTopY != candleBottomY){
            CGRect candleRect = CGRectMake(xValue-width/2, candleTopY, width,  candleBottomY-candleTopY);
            [ChartDrawCommon DrawRectOnContext:context rect:candleRect color:color isFill:isFill];
        } else {
            CGPoint candleTopLeftPoint = CGPointMake(xValue-width/2, candleTopY);
            CGPoint candleTopRightPoint = CGPointMake(xValue+width/2, candleTopY);
            [ChartDrawCommon DrawLineOnContext:context pointA:candleTopLeftPoint pointB:candleTopRightPoint color:color];
        }
    }
    CGContextRestoreGState(context);
    
}

@end

@implementation ChartLineObjectHisto

- (instancetype)initWithUpColor:(UIColor *)upColor downColor:(UIColor *)downColor {
    if (self = [self init]){
//        self.mainColor = mainColor;
        self.upColor = upColor;
        self.downColor = downColor;
    }
    return self;
}

- (UIColor *)colorWithChartData:(ChartData *)cData {
    return self.upColor;
}

- (void)setChartDataByChartDataList:(NSArray *)chartDataList {
    //Default to volume
    [self setChartDataByChartDataList:chartDataList forChartDisplayType:ChartDataDisplayTypeVolume];
}

- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    CGFloat width = displayInfo.chartSetting.xAxisPerValue * 0.8;
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }
        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
         
        [coorDict setObject:@(xValue) forKey:@"xValue"];
        CGFloat value = [displayInfo GetYCoodinateForValue:[self valueFromChartData:cData]];
        [coorDict setObject:@(value) forKey:@"value"];
        [coorDict setObject:@(cData.close>=cData.open) forKey:@"isUp"];
        
        [coorDataDict addObject:coorDict];
    }
    CGFloat zeroPoint = 0.0f;
    if (displayInfo.yAxisInfo.YValueMax >= 0 && displayInfo.yAxisInfo.YValueMin <= 0){
        zeroPoint = [displayInfo GetYCoodinateForValue:0];
//        needZero = true;
    } else if (displayInfo.yAxisInfo.YValueMax >= 0) {
        zeroPoint = [displayInfo GetYCoodinateForValue:displayInfo.yAxisInfo.YValueMin];
    } else if (displayInfo.yAxisInfo.YValueMin <= 0){
        zeroPoint = [displayInfo GetYCoodinateForValue:displayInfo.yAxisInfo.YValueMax];
    }
    [self DrawHistoOnContext:context rect:chartRect pointList:coorDataDict zeroYPoint:zeroPoint width:width upColor:self.upColor downColor:self.downColor];
}

- (void)DrawHistoOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList zeroYPoint:(CGFloat)zeroYPoint width:(CGFloat)width upColor:(UIColor *)upColor downColor:(UIColor *)downColow{
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    for (NSDictionary * dict in pointList){
        CGFloat xValue = [[dict objectForKey:@"xValue"] floatValue];
        CGFloat value  = [[dict objectForKey:@"value"] floatValue];
        bool isUp  = [[dict objectForKey:@"isUp"] boolValue];
        CGFloat startX = xValue - width/2;
        CGFloat height = 0;
        UIColor * color;
        if (isUp){
            color = upColor;
        } else {
            color = downColow;
        }
        
        if (zeroYPoint > value){
            height = zeroYPoint - value;
            [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(startX, value, width, height) color:color isFill:YES];
        } else {
            height = value - zeroYPoint;
            [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(startX, zeroYPoint, width, height) color:color isFill:YES];
        }
    }
    CGContextRestoreGState(context);
}

@end

@implementation ChartLineObjectScatter

- (instancetype)initWithMainColor:(UIColor *)mainColor {
    if (self = [self init]){
        self.mainColor = mainColor;
    }
    return self;
}
- (UIColor *)colorWithChartData:(ChartData *)cData {
    return self.mainColor;
}

- (void)setChartDataByChartDataList:(NSArray *)chartDataList {
    //Default to close
    [self setChartDataByChartDataList:chartDataList forChartDisplayType:ChartDataDisplayTypeClose];
}


- (void)DrawInViewContext:(CGContextRef)context forDisplayInfo:(ChartDisplayInfo *)displayInfo inChartRect:(CGRect)chartRect {
    
//    CGRect chartRect = CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.chartHeight);
    
    NSMutableArray * coorDataDict = [NSMutableArray array];
    for (NSString * key in displayInfo.timestampSorted){
        ChartData * cData = [self.chartDataDict objectForKey:key];
        if (!cData || [cData isEmpty]){
            continue;
        }
        NSMutableDictionary * coorDict = [NSMutableDictionary dictionary];
        NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:index];
//        if (cData.close == -0.0001f){
//            continue;
//        }
        
        
        [coorDict setObject:@(xValue) forKey:@"xValue"];
        CGFloat value = [displayInfo GetYCoodinateForValue:[self valueFromChartData:cData]];
        [coorDict setObject:@(value) forKey:@"value"];
        
        [coorDataDict addObject:coorDict];
    }
    [self DrawScatterChartOnContext:context rect:chartRect pointList:coorDataDict color:self.mainColor];
}

- (void)DrawScatterChartOnContext:(CGContextRef)context rect:(CGRect)rect pointList:(NSArray *)pointList color:(UIColor *)color {
    CGContextSaveGState(context);
    CGContextClipToRect(context, rect);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 3);
    
//    CGMutablePathRef path=CGPathCreateMutable();
    
//    BOOL isFirst = YES;
    for (NSDictionary * dict in pointList){
        CGFloat xValue = [[dict objectForKey:@"xValue"] floatValue];
        CGFloat value  = [[dict objectForKey:@"value"] floatValue];
//        if (isFirst){
//            CGPathMoveToPoint(path, NULL, xValue, value);
//            isFirst = NO;
//            continue;
//        }
//        CGPathAddLineToPoint(path, NULL, xValue, value);
        CGContextMoveToPoint(context, xValue, value);
        CGContextAddArcToPoint(context, xValue, value, xValue, value, 3.14);
    }
//    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
