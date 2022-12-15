//
//  ChartClass.m
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartClass.h"
#import "ChartDrawCommon.h"

@interface ChartClass()

//@property (nonatomic, strong) NSString * selectedKey;
//@property (nonatomic, strong) ChartDisplayInfo * currentDisplayInfo;
//@property (nonatomic, strong) NSMutableArray * defaultKeyList;
//@property (nonatomic, strong) ChartGlobalSetting * defaultGlobalSetting;
//@property (nonatomic, strong) NSMutableArray * defaultXAxis;
@property (nonatomic, strong) id<ChartClassDisplayDelegate> displayDelegate;
@property (nonatomic, strong) NSMutableArray<ChartLineObject *> * chartObjectList;
@property (nonatomic, strong) NSMutableArray *custYAxisLines;
@property (nonatomic, assign) CGFloat yAxisMarginLeft;
@property (nonatomic, assign) ChartAxisLineType axisLineType;
@property (nonatomic, assign) BOOL bShowMinMax;

//@property (nonatomic, strong) NSArray * xAxisList;
@end
@implementation ChartClass

- (NSArray *)keyList {
    if (self.displayDelegate){
        return [self.displayDelegate groupingKeyList];
    }
//    if (self.defaultKeyList){
//        return self.defaultKeyList;
//    }
    return @[];
}

- (UIFont * )axisFont {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(axisFont)]){
        return [self.displayDelegate axisFont];
    }
    return [UIFont fontWithName:@"Arial" size:12.f];
}

- (NSString *)formatValue:(CGFloat)value {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(formatValue:)]){
        return [self.displayDelegate formatValue:value];
    }
    return [NSString stringWithFormat:@"%.3f", value];
}

- (NSString *)formatMinMaxValue:(CGFloat)value {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(formatMinMaxValue:)]){
        return [self.displayDelegate formatMinMaxValue:value];
    }
    return [NSString stringWithFormat:@"%.3f", value];
}

- (NSString *)formatDate:(NSDate *)date {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(formatDate:)]){
        return [self.displayDelegate formatDate:date];
    }
    NSString * dateFormat = @"dd/MM HH:mm";
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale systemLocale]];
    return [formatter stringFromDate:date];
}

- (UIColor *)axisColor {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(colorConfig)]){
        return self.displayDelegate.colorConfig.axisLineColor;
    }
    return [UIColor blackColor];
//    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(axisColor)]){
//        return [self.displayDelegate axisColor];
//    }
//    return [UIColor blackColor];
}

- (ChartAxisLineType)axisLineType {
    return _axisLineType;
}

- (ChartGlobalSetting *)globalSetting {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(globalSettingForChartClass:)]){
        return [self.displayDelegate globalSettingForChartClass:self];
    }
//    if (self.defaultGlobalSetting){
//        return self.defaultGlobalSetting;
//    }
    return [[ChartGlobalSetting alloc] init];
}

- (NSArray *)getXAxisKeyList {
//    return [self.displayDelegate getXAxisKeyList];
    if (self.displayDelegate){
        return [self.displayDelegate getXAxisKeyList];
    }
//    if (self.defaultXAxis){
//        return self.defaultXAxis;
//    }
    return [NSArray array];

}

- (YAxisInfo *)getYAxisKeyListWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue{
    
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(getYAxisInfoForChartClass:withDataMinValue:maxValue:)]){
        return [self.displayDelegate getYAxisInfoForChartClass:self withDataMinValue:minValue maxValue:maxValue];
    }
    
    ChartGlobalSetting *chartSetting = self.currentDisplayInfo.chartSetting;
    YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];
    
    CGFloat rangeDiff = maxValue - minValue;
    CGFloat displayYMaxValue = maxValue + rangeDiff * chartSetting.chartYAxisRangeDiffGapScale;
    CGFloat displayYMinValue = minValue - rangeDiff * chartSetting.chartYAxisRangeDiffGapScale;
    
    if (maxValue < 0 && displayYMaxValue > 0){
        displayYMaxValue = 0;
    }
    if (minValue > 0 && displayYMinValue < 0){
        displayYMinValue = 0;
    }
    
    if (minValue > maxValue){
        displayYMinValue = 0;
        displayYMaxValue = 0;
    }
    yAxisInfo.YValueMax = displayYMaxValue;
    yAxisInfo.YValueMin = displayYMinValue;
//    if ((displayYMaxValue - displayYMinValue) == 0){
//        yAxisInfo.yAxisPerValue = 0;
//    } else {
//        yAxisInfo.yAxisPerValue = self.globalSetting.chartHeight / (displayYMaxValue - displayYMinValue);
//    }
    CGFloat valueDiff = displayYMaxValue - displayYMinValue;
    
    
    NSMutableArray * array = [NSMutableArray array];
    if (valueDiff > 0){
        NSInteger lineNumber = chartSetting.chartYAxisLineNum;
//        CGFloat lineSep = self.globalSetting.chartHeight/lineNumber;
        for (NSInteger i = 0; i < lineNumber; i++){
            CGFloat yValue = yAxisInfo.YValueMin + (i + 0.5) * valueDiff/lineNumber;
//            CGFloat yValue = yAxisInfo.YValueMin + (i + 0.5) * lineSep / yAxisInfo.yAxisPerValue;
            [array addObject:@(yValue)];
        }
    }
    yAxisInfo.yAxisList = [NSArray arrayWithArray:array];
    
    return yAxisInfo;
}

- (void)initWithChartObjectList:(NSMutableArray *)chartObjectList displayDelegate:(id<ChartClassDisplayDelegate>)delegate {
    self.chartObjectList = chartObjectList;
    self.displayDelegate = delegate;
    self.custYAxisLines = [NSMutableArray array];
    self.bShowMinMax = NO;
//    self.xAxisList = xAxisList;
}

//- (void)initWithChartObjectList:(NSMutableArray *)chartObjectList keyList:(NSMutableArray *)keyList globalSetting:(ChartGlobalSetting *)globalSetting xAxis:(NSMutableArray *)xAxis {
//    self.chartObjectList = chartObjectList;
//    self.defaultKeyList = keyList;
//    self.defaultGlobalSetting = globalSetting;
//    self.defaultXAxis = xAxis;
//}

- (void)updateChartData:(ChartData *)chartData forRefKey:(NSString *)refKey {
    for (ChartLineObject * lineObject in self.chartObjectList){
        if ([lineObject.refKey isEqualToString:refKey]){
            [lineObject.chartDataDict setObject:chartData forKey:chartData.groupingKey];
            break;
        }
    }
}
- (CGFloat)yAxisMarginLeft {
    return 5.0f;
}

- (NSArray *)getChartLineObjectList {
    return self.chartObjectList;
}

- (void)addChartLineObjects:(NSArray<ChartLineObject *> *)chartLineObject {
    [self.chartObjectList addObjectsFromArray:chartLineObject];
}

- (ChartLineObject *)getChartLineObjectByKey:(NSString *)key {
    for (ChartLineObject * lineObject in self.chartObjectList){
        if ([lineObject.refKey isEqualToString:key]){
            return lineObject;
        }
    }
    return nil;
}

- (void)removeChartLineObjectOtherThanKey:(NSString *)key {
    NSMutableArray * removeAry = [NSMutableArray array];
    for (ChartLineObject * lineObject in self.chartObjectList){
        if (![lineObject.refKey isEqualToString:key]){
            [removeAry addObject:lineObject];
        }
    }
    for (ChartLineObject * obj in removeAry){
        [self.chartObjectList removeObject:obj];
    }
}

- (void)replaceChartLineObjectByKey:(NSString *)key withLineObject:(ChartLineObject *)chartLineObject {
    NSInteger index = 0;
    for (ChartLineObject * lineObject in self.chartObjectList){
        if ([lineObject.refKey isEqualToString:key]){
            break;
        }
        index ++;
    }
    if (index < [self.chartObjectList count]){
        [self.chartObjectList replaceObjectAtIndex:index withObject:chartLineObject];
    } else {
        [self.chartObjectList addObject:chartLineObject];
    }
}

- (void)removeChartLineObjectByKey:(NSString *)key {
    NSMutableArray * removeAry = [NSMutableArray array];
    for (ChartLineObject * lineObject in self.chartObjectList){
        if ([lineObject.refKey isEqualToString:key]){
            [removeAry addObject:lineObject];
        }
    }
    for (ChartLineObject * obj in removeAry){
        [self.chartObjectList removeObject:obj];
    }
}

- (CGFloat)maximumScrollOffsetX {
    return [self getContentSize].width - self.globalSetting.chartWidth - self.globalSetting.yAxisWidth;
}

- (CGSize)getContentSize {
    CGFloat height = self.globalSetting.chartHeight + self.globalSetting.xAxisHeight;
//    CGFloat width = self.globalSetting.startXOffset + self.globalSetting.xAxisPerValue * ([self.keyList count]-1) + self.globalSetting.endXOffset + self.globalSetting.yAxisWidth;
    CGFloat width = [self.globalSetting GetXCoodinateForIndex:([self.keyList count])] + self.globalSetting.endXOffset + self.globalSetting.yAxisWidth;
    
    if (width < self.globalSetting.chartWidth + self.globalSetting.yAxisWidth) {
        width = self.globalSetting.chartWidth + self.globalSetting.yAxisWidth;
    }

    return CGSizeMake(width, height);
}

- (bool)isShowingLatest{
    NSString * latestKey = [[self keyList] lastObject];
    if ([self.currentDisplayInfo.timestampSorted containsObject:latestKey]){
        return YES;
    }
    return NO;
}

- (void)updateChartDisplayInfoForContentOffset:(CGPoint)contentOffset {
    if (!self.currentDisplayInfo){
        self.currentDisplayInfo = [[ChartDisplayInfo alloc] init];
    }
    self.currentDisplayInfo.chartSetting = self.globalSetting;
    
//    self.currentDisplayInfo.minXAxis = contentOffset.x;
//    self.currentDisplayInfo.maxXAxis = contentOffset.x + self.globalSetting.chartWidth;
//
    [self updateChartDisplayInfoForMinXAxis:contentOffset.x maxAxis:(contentOffset.x + self.globalSetting.chartWidth)];
    
}

- (void)updateChartDisplayInfoForMinXAxis:(CGFloat)minXAxis maxAxis:(CGFloat)maxXAxis {
    if (!self.currentDisplayInfo){
        self.currentDisplayInfo = [[ChartDisplayInfo alloc] init];
    }
    self.currentDisplayInfo.chartSetting = self.globalSetting;
    
    self.currentDisplayInfo.minXAxis = minXAxis;
    self.currentDisplayInfo.maxXAxis = maxXAxis;
    
    CGFloat minXAxisWithOffset = self.currentDisplayInfo.minXAxis - self.globalSetting.startXOffset;
    if (minXAxisWithOffset < 0){
        minXAxisWithOffset = 0;
    }
    CGFloat maxXAxisWithOffset = self.currentDisplayInfo.maxXAxis - self.globalSetting.startXOffset;
    if (maxXAxisWithOffset < 0){
        maxXAxisWithOffset = 0;
    }
    
    if (self.keyList){
        NSInteger kStart = floor(minXAxisWithOffset / self.globalSetting.xAxisPerValue);
        if (kStart < 0) {
            kStart = 0;
        }
        if (kStart > 0){
            kStart -= 1; // -1 for extra previous
        }
        NSInteger kEnd = ceil(maxXAxisWithOffset / self.globalSetting.xAxisPerValue);
        if (kEnd >= [self.keyList count]){
            kEnd = [self.keyList count] - 1;
        }
        
        NSMutableDictionary * timestampDict = [NSMutableDictionary dictionary];
        NSMutableArray * mutArray = [NSMutableArray array];
        for (NSInteger j = kStart; j <= kEnd; j++){
            NSString * key = [self.keyList objectAtIndex:j];
            [timestampDict setObject:@(j) forKey:key];
            [mutArray addObject:key];
        }
        
        self.currentDisplayInfo.timestampToIndex = timestampDict;
        self.currentDisplayInfo.timestampSorted = mutArray;
        
        YMinMaxInfo * minMaxInfo = [self getYMinMaxInfoForDisplay:self.currentDisplayInfo forChartObjectList:self.chartObjectList];
        
        YAxisInfo * yAxisInfo = [self getYAxisKeyListWithMinValue:minMaxInfo.minValue maxValue:minMaxInfo.maxValue];
        
        self.currentDisplayInfo.yAxisInfo = yAxisInfo;
        
        CGFloat diff = yAxisInfo.YValueMax - yAxisInfo.YValueMin;
        if (diff > 0){
            self.currentDisplayInfo.yAxisPerValue = self.globalSetting.chartHeight/diff;
        } else {
            self.currentDisplayInfo.yAxisPerValue = 0;
        }
        
        NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
        for (ChartLineObject * lineObject in self.chartObjectList){
            if (lineObject.chartDataDict){
    //            ChartLineType lineType = lineObject.lineType;
                for (NSString * groupingkey in self.currentDisplayInfo.timestampSorted){
                    ChartData * cData = [lineObject.chartDataDict objectForKey:groupingkey];
                    if (cData && ![cData isEmpty]){
                        [indexSet addIndex:[[self.currentDisplayInfo.timestampToIndex objectForKey:groupingkey] integerValue]];
                    }
                }
            }
        }
        self.currentDisplayInfo.indexWithData = indexSet;
//        YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];
//        if (array && [array count] >1){
//            yAxisInfo.YValueMin = [[array firstObject] doubleValue];
//            yAxisInfo.YValueMax = [[array lastObject] doubleValue];
//        } else {
//            yAxisInfo.YValueMin = minMaxInfo.minValue;
//            yAxisInfo.YValueMax = minMaxInfo.maxValue;
//        }
//
//        if ((yAxisInfo.YValueMax - yAxisInfo.YValueMin) <= 0){
//            yAxisInfo.yAxisPerValue = 0;
//        } else {
//            yAxisInfo.yAxisPerValue = self.globalSetting.chartHeight / (yAxisInfo.YValueMax - yAxisInfo.YValueMin);
//        }
        
//        CGFloat rangeDiff = minMaxInfo.maxValue - minMaxInfo.minValue;
//        CGFloat displayYMaxValue = minMaxInfo.maxValue + rangeDiff * 0.2;
//        CGFloat displayYMinValue = minMaxInfo.minValue - rangeDiff * 0.2;
//
//        if (minMaxInfo.maxValue < 0 && displayYMaxValue > 0){
//            displayYMaxValue = 0;
//        }
//        if (minMaxInfo.minValue > 0 && displayYMinValue < 0){
//            displayYMinValue = 0;
//        }
//
//        if (minMaxInfo.minValue > minMaxInfo.maxValue){
//            displayYMinValue = 0;
//            displayYMaxValue = 0;
//        }
//        yAxisInfo.YValueMax = displayYMaxValue;
//        yAxisInfo.YValueMin = displayYMinValue;
//        if ((displayYMaxValue - displayYMinValue) == 0){
//            yAxisInfo.yAxisPerValue = 0;
//        } else {
//            yAxisInfo.yAxisPerValue = self.globalSetting.chartHeight / (displayYMaxValue - displayYMinValue);
//        }
        
        
    }
}

- (YMinMaxInfo *)getYMinMaxInfoForDisplay:(ChartDisplayInfo *)displayInfo forChartObjectList:(NSArray<ChartLineObject *> *)dataList {
    
    CGFloat rangeMax = CGFLOAT_MIN;
    CGFloat rangeMin = CGFLOAT_MAX;
    NSString * minTime = @"";
    NSString * maxTime = @"";
    for (ChartLineObject * lineObject in dataList){
        if (lineObject.chartDataDict){
//            ChartLineType lineType = lineObject.lineType;
            for (NSString * groupingkey in displayInfo.timestampSorted){
                ChartData * cData = [lineObject.chartDataDict objectForKey:groupingkey];
                if (cData && ![cData isEmpty]){
                    CGFloat compareHigh;
                    CGFloat compareLow;
                    compareHigh = [lineObject getMaxValueForKey:groupingkey];
                    compareLow = [lineObject getMinValueForKey:groupingkey];
                    
                    if (compareHigh > rangeMax){
                        rangeMax = compareHigh;
                        maxTime = cData.groupingKey;
                    }
                    if (compareLow < rangeMin){
                        rangeMin = compareLow;
                        minTime = cData.groupingKey;
                    }
                }
            }
        }
    }
    if (rangeMax == CGFLOAT_MIN){
        rangeMax = 0;
    }
    if (rangeMin == CGFLOAT_MAX){
        rangeMin = 0;
    }
    
    YMinMaxInfo * info = [[YMinMaxInfo alloc] init];
    info.maxValue = rangeMax;
    info.minValue = rangeMin;
    info.maxDataKey = maxTime;
    info.minDataKey = minTime;
    
    return info;
}

- (YMinMaxInfo *)getYMinMaxInfoForDisplay:(ChartDisplayInfo *)displayInfo forChartObjectList:(NSArray<ChartLineObject *> *)dataList InChart:(BOOL)bInChart {
    
    CGFloat rangeMax = CGFLOAT_MIN;
    CGFloat rangeMin = CGFLOAT_MAX;
    NSString * minTime = @"";
    NSString * maxTime = @"";
    for (ChartLineObject * lineObject in dataList){
        if (lineObject.chartDataDict){
            for (NSString * groupingkey in displayInfo.timestampSorted){
                CGFloat xPos = [self.currentDisplayInfo GetXCoodinateForTimestamp:groupingkey];
                if (bInChart) {
                    if (xPos < self.currentDisplayInfo.minXAxis || xPos > self.currentDisplayInfo.maxXAxis) {
                        continue;
                    }
                }
                ChartData * cData = [lineObject.chartDataDict objectForKey:groupingkey];
                if (cData && ![cData isEmpty]){
                    CGFloat compareHigh;
                    CGFloat compareLow;
                    compareHigh = [lineObject getMaxValueForKey:groupingkey];
                    compareLow = [lineObject getMinValueForKey:groupingkey];
                    
                    if (compareHigh > rangeMax){
                        rangeMax = compareHigh;
                        maxTime = cData.groupingKey;
                    }
                    if (compareLow < rangeMin){
                        rangeMin = compareLow;
                        minTime = cData.groupingKey;
                    }
                }
            }
        }
    }
    if (rangeMax == CGFLOAT_MIN){
        rangeMax = 0;
    }
    if (rangeMin == CGFLOAT_MAX){
        rangeMin = 0;
    }
    
    YMinMaxInfo * info = [[YMinMaxInfo alloc] init];
    info.maxValue = rangeMax;
    info.minValue = rangeMin;
    info.maxDataKey = maxTime;
    info.minDataKey = minTime;
    
    return info;
}

- (NSMutableArray *)getCustYAxisLines {
    return self.custYAxisLines;
}

- (void)setChartAxisLineType:(ChartAxisLineType)type {
    self.axisLineType = type;
}

#pragma mark - For Draw
- (void)drawOnContext:(CGContextRef)context {
    if (self.currentDisplayInfo && self.displayDelegate){
        UIColor * backgroundColor = [UIColor whiteColor];
//        if (self.displayDelegate){
            backgroundColor = self.displayDelegate.colorConfig.chartBackgroundColor;
//        }
//        [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(self.currentDisplayInfo.minXAxis, self.globalSetting.YOffsetStart, self.globalSetting.chartWidth+self.globalSetting.yAxisWidth, self.globalSetting.chartHeight+self.globalSetting.xAxisHeight) color:[UIColor grayColor] isFill:YES];
        CGRect chartRect = CGRectMake(self.currentDisplayInfo.minXAxis, self.globalSetting.YOffsetStart, self.globalSetting.chartWidth, self.globalSetting.chartHeight);
        [ChartDrawCommon DrawRectOnContext:context rect:chartRect color:backgroundColor isFill:YES];
        
        CGContextSaveGState(context);
        // Draw XAxis line & label
        [self drawXAxisOnContext:context forKeys:[self getXAxisKeyList] textColor:self.displayDelegate.colorConfig.axisTextColor lineColor:self.displayDelegate.colorConfig.axisLineColor];
        // Draw YAxis line & label
        [self drawYAxisOnContext:context textColor:self.displayDelegate.colorConfig.axisTextColor lineColor:self.displayDelegate.colorConfig.axisLineColor];
        CGContextRestoreGState(context);
        
        // Draw chart bottom border
        CGContextSaveGState(context);
        [ChartDrawCommon DrawLineOnContext:context pointA:CGPointMake(self.currentDisplayInfo.minXAxis, self.globalSetting.chartHeight + 1) pointB:CGPointMake(self.globalSetting.chartWidth, self.globalSetting.chartHeight + 1) color:self.displayDelegate.colorConfig.chartBottomLineColor];
        CGContextRestoreGState(context);
    
        // Draw min max Val (For candle)
        CGContextSaveGState(context);
        [self drawMinMaxValForCandle:context];
        CGContextRestoreGState(context);
        
        // Draw chart object
        for (ChartLineObject * obj in self.chartObjectList){
            [obj DrawInViewContext:context forDisplayInfo:self.currentDisplayInfo inChartRect:chartRect];
        }
        
        // Draw cust YAxis line
        CGContextSaveGState(context);
        [self drawCustYAxisLines:context];
        CGContextRestoreGState(context);
        
        // Draw Chart Background
        CGContextSaveGState(context);
        [self drawBackgroundOnContext:context];
        CGContextRestoreGState(context);

    }
}

- (void)drawYAxisOnContext:(CGContextRef)context textColor:(UIColor *)textColor lineColor:(UIColor * )lineColor {
//    NSMutableArray * array = [NSMutableArray array];
    ChartDisplayInfo * displayInfo = self.currentDisplayInfo;
    ChartGlobalSetting * chartSetting = displayInfo.chartSetting;
    
//    CGFloat yCoorPerValue = displayInfo.yAxisInfo.yAxisPerValue;
//    CGFloat yHeight = chartSetting.chartHeight;
    NSArray * array = displayInfo.yAxisInfo.yAxisList;
    if (array && [array count]){
//    [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(displayInfo.maxXAxis, displayInfo.chartSetting.YOffsetStart, displayInfo.chartSetting.yAxisWidth, displayInfo.chartSetting.chartHeight) color:bgColor isFill:YES];
//    if (yCoorPerValue != 0){
//        CGFloat lineSep = yHeight/lineNumber;
//        for (NSInteger i = 0; i < lineNumber; i++){
//            CGFloat yValue = displayInfo.yAxisInfo.YValueMin + (i + 0.5) * lineSep / yCoorPerValue;
//            [array addObject:@(yValue)];
//        }
        
    //    CGContextSaveGState(context);
        for (NSNumber * value in array){
            CGFloat val = [value floatValue];
            CGFloat yCoor = [displayInfo GetYCoodinateForValue:val];
            
            CGPoint startPoint = CGPointMake(displayInfo.minXAxis, yCoor);
            CGPoint endPoint = CGPointMake(displayInfo.maxXAxis, yCoor);
            
//            NSLog(@"drawYAxisOnContext - axisLineType %ld", self.axisLineType);
            if (self.axisLineType == ChartAxisLineTypeSolid) {
                [ChartDrawCommon DrawLineOnContext:context pointA:startPoint pointB:endPoint color:lineColor];
            } else {
                [ChartDrawCommon DrawDashLineOnContext:context pointA:startPoint pointB:endPoint color:lineColor];
            }
            
            chartTextBoxInfo * textInfo = [ChartDrawCommon GetTextRectFromPoint:endPoint pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(chartSetting.yAxisWidth - [self yAxisMarginLeft], CGFLOAT_MAX) text:[self formatValue:val] initialFont:[self axisFont] fontColor:textColor];
                      
            // Resize textInfo.rect
            CGRect infoRect = textInfo.rect;
            infoRect.origin.x += [self yAxisMarginLeft];

            if (CGRectGetMinY(textInfo.rect) < 0){
                infoRect.origin.y = 0;
            }
            
            if (CGRectGetMaxY(textInfo.rect) > (self.currentDisplayInfo.chartSetting.YOffsetStart + self.currentDisplayInfo.chartSetting.chartHeight)){
                infoRect.origin.y = (self.currentDisplayInfo.chartSetting.YOffsetStart + self.currentDisplayInfo.chartSetting.chartHeight) - infoRect.size.height;
            }
            
//            NSLog(@"textInfo.x+w %.2f > globalSetting %.2f", textInfo.rect.origin.x + textInfo.rect.size.width + [self yAxisMarginLeft],
//                  [self globalSetting].chartWidth + [self globalSetting].yAxisWidth);
            
            textInfo.rect = infoRect;
//            NSLog(@"textInfo.x %.2f, .w %.2f", textInfo.rect.origin.x, textInfo.rect.size.width);
            [ChartDrawCommon DrawTextOnContext:context textBoxInfo:textInfo];
            
        }
    }
//    }
    
//    CGContextRestoreGState(context);
}

- (void)drawXAxisOnContext:(CGContextRef)context forKeys:(NSArray *)keys textColor:(UIColor *)textColor lineColor:(UIColor * )lineColor {
    ChartDisplayInfo * displayInfo = self.currentDisplayInfo;
    ChartLineObject * mainLineObject = [self.chartObjectList firstObject];
//    NSDictionary * chartDataDict = mainLineObject.chartDataDict;
//    CGContextSaveGState(context);
//    [ChartDrawCommon DrawRectOnContext:context rect:CGRectMake(displayInfo.minXAxis, displayInfo.chartSetting.YOffsetStart+displayInfo.chartSetting.chartHeight, displayInfo.chartSetting.chartWidth, displayInfo.chartSetting.xAxisHeight) color:bgColor isFill:YES];
    for (NSString * key in keys){
        if ([[displayInfo.timestampToIndex allKeys] containsObject:key]){
            NSInteger index = [[displayInfo.timestampToIndex objectForKey:key] integerValue];
            CGFloat coor = [displayInfo.chartSetting GetXCoodinateForIndex:index];
            if (coor >= displayInfo.minXAxis && coor <= displayInfo.maxXAxis){
                
                // Draw x-axis line
                CGPoint top = CGPointMake(coor, displayInfo.chartSetting.YOffsetStart);
                CGPoint bottom = CGPointMake(coor, displayInfo.chartSetting.YOffsetStart + displayInfo.chartSetting.chartHeight);
                if (self.axisLineType == ChartAxisLineTypeSolid) {
                    [ChartDrawCommon DrawLineOnContext:context pointA:top pointB:bottom color:lineColor];
                } else {
                    [ChartDrawCommon DrawDashLineOnContext:context pointA:top pointB:bottom color:lineColor];
                }
                
                // Draw x-axis label
                if (displayInfo.chartSetting.xAxisHeight > 0){
//                    ChartData * cData = [chartDataDict objectForKey:key];
//                    if (cData){
                    NSDate * date = [mainLineObject getDateForKey:key];
                    if (date){
//                        NSLog(@"Draw XAxis: (%ld)key %@ - date %@ -> formattedDate %@", keys.count, key, date ,[self formatDate:date]);
                        chartTextBoxInfo * textInfo = [ChartDrawCommon GetTextRectFromPoint:bottom pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) text:[self formatDate:date] initialFont:[self axisFont] fontColor:textColor];
                        
                        if (CGRectGetMinX(textInfo.rect) < displayInfo.minXAxis){
                            CGRect textInfoRect = textInfo.rect;
                            textInfoRect.origin.x = displayInfo.minXAxis;
                            textInfo.rect = textInfoRect;
                        }
                        
                        if (CGRectGetMaxX(textInfo.rect) > displayInfo.maxXAxis){
                            CGRect textInfoRect = textInfo.rect;
                            textInfoRect.origin.x = displayInfo.maxXAxis - textInfo.rect.size.width;
                            textInfo.rect = textInfoRect;
                        }
                        
                        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:textInfo];
                    }
                }
            }
        }
    }
//    CGContextRestoreGState(context);
}

- (void)drawCustYAxisLines:(CGContextRef)context {
    if (!self.custYAxisLines || self.custYAxisLines.count == 0) {
        return;
    }
    
    ChartDisplayInfo * displayInfo = self.currentDisplayInfo;
//    ChartGlobalSetting * chartSetting = displayInfo.chartSetting;
    
    for (NSDictionary *dict in self.custYAxisLines) {
        NSNumber *numVal    = [dict objectForKey:@"value"];
        UIColor *lineColor  = [dict objectForKey:@"color"];
        
        CGFloat yCoord = [displayInfo GetYCoodinateForValue:[numVal floatValue]];
        
        CGPoint startPoint = CGPointMake(displayInfo.minXAxis, yCoord);
        CGPoint endPoint = CGPointMake(displayInfo.maxXAxis , yCoord);
        
        [ChartDrawCommon DrawLineOnContext:context pointA:startPoint pointB:endPoint color:lineColor];
    }
}

- (void)drawBackgroundOnContext:(CGContextRef)context {
    if (self.displayDelegate && [self.displayDelegate respondsToSelector:@selector(getBackgroundList)]){
        NSArray * backgroundList = [self.displayDelegate getBackgroundList];
        for (ChartBackground * background in backgroundList){
            CGFloat xCoor = [self.currentDisplayInfo GetXCoodinateForTimestamp:background.groupingKey];
            if (xCoor == NSNotFound) {
                continue;
            }
            
            CGFloat startXCoor = xCoor - self.currentDisplayInfo.chartSetting.xAxisPerValue;
            if (xCoor >= self.currentDisplayInfo.minXAxis && startXCoor <= self.currentDisplayInfo.maxXAxis){
                CGFloat percent = 0.f;
                for (ChartBackgroundColor * bgColor in background.colorList){
                    if (percent >= 100){
                        break;
                    }
                    CGFloat coverPercentage = ((percent+bgColor.coverPecentage)>=100)?(100-percent):bgColor.coverPecentage;
                    CGFloat width = self.currentDisplayInfo.chartSetting.xAxisPerValue * coverPercentage/100 /*+0.5*/;
                    CGRect bgRect = CGRectMake(startXCoor, self.currentDisplayInfo.chartSetting.YOffsetStart, width, self.currentDisplayInfo.chartSetting.chartHeight);
                    
                    if (CGRectGetMaxX(bgRect) >= self.currentDisplayInfo.maxXAxis){
                        bgRect.size.width = self.currentDisplayInfo.maxXAxis - bgRect.origin.x;
                    }
//                    NSLog(@"rect startXCoor %.2f width %.2f sum %.2f", startXCoor, width, startXCoor + width);
                    [ChartDrawCommon DrawRectOnContext:context rect:bgRect color:bgColor.color isFill:YES];
                    
//                    NSLog(@"DrawBG key %@ coverPer %.2f Per %.2f startXCoor %.2f", background.groupingKey, coverPercentage, percent, startXCoor);
                    percent += coverPercentage;
                    startXCoor += width;
                }
            }
        }
    }
}

- (void)drawMinMaxValForCandle:(CGContextRef)context {
    ChartColorConfig * colorConfig = self.displayDelegate.colorConfig;
    
    NSMutableArray<ChartLineObject*> *mainDataArr = [NSMutableArray array];
    for (ChartLineObject * obj in self.chartObjectList) {
        if ([obj.refKey isEqualToString:@"MainData"]) {
            [mainDataArr addObject:obj];
        }
    }
    
    if (self.bShowMinMax) {
        YMinMaxInfo * minMaxInfo = [self getYMinMaxInfoForDisplay:self.currentDisplayInfo forChartObjectList:mainDataArr InChart:YES];
        NSInteger minDataIdx = [[self.currentDisplayInfo.timestampToIndex objectForKey:minMaxInfo.minDataKey] integerValue];
        NSInteger maxDataIdx = [[self.currentDisplayInfo.timestampToIndex objectForKey:minMaxInfo.maxDataKey] integerValue];
        
        CGFloat minDataX = [self.currentDisplayInfo.chartSetting GetXCoodinateForIndex:minDataIdx];
        CGFloat maxDataX = [self.currentDisplayInfo.chartSetting GetXCoodinateForIndex:maxDataIdx];
        CGFloat minDataY = [self.currentDisplayInfo GetYCoodinateForValue:minMaxInfo.minValue];
        CGFloat maxDataY = [self.currentDisplayInfo GetYCoodinateForValue:minMaxInfo.maxValue];
        
//        NSLog(@"\nMin {idx %ld val %.2f, x %.2f, y %.2f} Max {idx %ld val %.2f, x %.2f, y %.2f}",
//              minDataIdx, minMaxInfo.minValue, minDataX, minDataY,
//              maxDataIdx, minMaxInfo.maxValue, maxDataX, maxDataY);
        
        chartTextBoxInfo * minTextInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(minDataX, minDataY) pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) text:[self formatMinMaxValue:minMaxInfo.minValue] initialFont:[self axisFont] fontColor:colorConfig.minValColor];
        
        chartTextBoxInfo * maxTextInfo = [ChartDrawCommon GetTextRectFromPoint:CGPointMake(maxDataX, maxDataY) pointDirection:ChartTextBoxPointDirectionFromBottom sizeLimit:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) text:[self formatMinMaxValue:minMaxInfo.maxValue] initialFont:[self axisFont] fontColor:colorConfig.maxValColor];

        // Resize textBoxInfo
        if (minTextInfo.rect.origin.x < self.currentDisplayInfo.minXAxis){
            CGRect xRect = minTextInfo.rect;
            xRect.origin.x = self.currentDisplayInfo.minXAxis;
            minTextInfo.rect = xRect;
        }
        
        if (CGRectGetMaxX(minTextInfo.rect) > self.currentDisplayInfo.maxXAxis){
            CGRect xRect = minTextInfo.rect;
            xRect.origin.x = self.currentDisplayInfo.maxXAxis - xRect.size.width;
            minTextInfo.rect = xRect;
        }
        
        if (maxTextInfo.rect.origin.x < self.currentDisplayInfo.minXAxis){
            CGRect xRect = maxTextInfo.rect;
            xRect.origin.x = self.currentDisplayInfo.minXAxis;
            maxTextInfo.rect = xRect;
        }
        
        if (CGRectGetMaxX(maxTextInfo.rect) > self.currentDisplayInfo.maxXAxis){
            CGRect xRect = maxTextInfo.rect;
            xRect.origin.x = self.currentDisplayInfo.maxXAxis - xRect.size.width;
            maxTextInfo.rect = xRect;
        }
        
//        NSLog(@"maxTextInfo {.y %.2f .h %.2f}", maxTextInfo.rect.origin.y, maxTextInfo.rect.size.height);
        
        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:minTextInfo];
        [ChartDrawCommon DrawTextOnContext:context textBoxInfo:maxTextInfo];
    }
}

#pragma mark - For Cursor
- (NSString *)setCursorSelectedIndexByPoint:(CGPoint )point needWithData:(BOOL)needWithData{
    CGRect chartRect = CGRectMake(self.currentDisplayInfo.minXAxis, self.globalSetting.YOffsetStart, self.globalSetting.chartWidth, self.globalSetting.chartHeight);
    
    if (CGRectContainsPoint(chartRect, point)) {
        NSInteger index = [self.currentDisplayInfo GetClosestIndexForXCoordinate:point.x frameOnly:NO];
        if ([self.keyList count] > index){
            if (needWithData){
                if (![self.currentDisplayInfo.indexWithData containsIndex:index]){
                    NSInteger lesserIndex = [self.currentDisplayInfo.indexWithData indexLessThanIndex:index];
                    NSInteger greaterIndex = [self.currentDisplayInfo.indexWithData indexGreaterThanIndex:index];
                    if (lesserIndex == NSNotFound && greaterIndex == NSNotFound){
                        return nil;
                    } else if (lesserIndex == NSNotFound){
                        index = greaterIndex;
                    } else {
                        if ((index - lesserIndex) <= (greaterIndex - index)){
                            index = lesserIndex;
                        } else {
                            index = greaterIndex;
                        }
                    }
                }
            }
            NSString * selectedKey = [self.keyList objectAtIndex:index];
            
            return selectedKey;
        }
        return nil;
    } else {
//        self.selectedKey = @"";
//        return NO;
        return nil;
    }
}

- (NSString *)setCursorSelectedIndexByPoint:(CGPoint )point {
    return [self setCursorSelectedIndexByPoint:point needWithData:NO];
//    CGRect chartRect = CGRectMake(self.currentDisplayInfo.minXAxis, self.globalSetting.YOffsetStart, self.globalSetting.chartWidth, self.globalSetting.chartHeight);
//
//    if (CGRectContainsPoint(chartRect, point)) {
//        NSInteger index = [self.currentDisplayInfo GetClosestIndexForXCoordinate:point.x frameOnly:NO];
//        if ([self.keyList count] > index){
//            NSString * selectedKey = [self.keyList objectAtIndex:index];
//
//            return selectedKey;
//        }
//        return nil;
//    } else {
////        self.selectedKey = @"";
////        return NO;
//        return nil;
//    }
}

- (NSArray *)getChartDataByGroupingKey:(NSString *)groupingkey {
    NSMutableArray * array = [NSMutableArray array];
    for (ChartLineObject * obj in self.chartObjectList){
        ChartData * data = [obj.chartDataDict objectForKey:groupingkey];
        if (data){
            [array addObject:
                @{
                    @"color": [obj colorWithChartData:data],
                    @"name": obj.refKey,
                    @"data": data
            }];
        }
    }
    return array;
}

- (CGPoint)getPoisitionForKey:(NSString *)key {
    CGFloat x = 0;
    CGFloat y = 0;
    
    NSNumber * indexNum = [self.currentDisplayInfo.timestampToIndex objectForKey:key];
    if (indexNum){
        x = [self.currentDisplayInfo.chartSetting GetXCoodinateForIndex:[indexNum integerValue]];
        
        ChartData * data = [[self.chartObjectList firstObject].chartDataDict objectForKey:key];
        if (data && ![data isEmpty]){
            y = [self.currentDisplayInfo GetYCoodinateForValue:data.close];
        }
    }
    
    return CGPointMake(x, y);
}
    

@end
