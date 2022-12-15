//
//  SmallChartViewController.m
//  ChartLibraryDemo
//
//  Created by william on 10/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "SmallChartViewController.h"
#import "ChartView.h"
#import "ChartClass.h"
#import "ChartDrawCommon.h"
#import "CustomDrawView.h"
#import "MainTIList.h"
#import "ChartTICalculator.h"

@interface SmallChartViewController () <ChartViewTouchDelegate, CustomDrawViewDelegate, ChartClassDisplayDelegate>

@property (strong, nonatomic) ChartConfig * chartConfig;
@property (strong, nonatomic) ChartGlobalSetting * chartSetting;
@property (strong, nonatomic) NSMutableArray * groupingKeyList;
@property (strong, nonatomic) NSMutableArray<ChartData *> * chartDataList;
@property (retain, nonatomic) ChartView * chartView;

@property (strong, nonatomic) NSArray * xAxisKeyList;

@property (strong, nonatomic) CustomDrawView * cursorView;
@property (assign, nonatomic) UITouch * currentTouch;
@property (assign, nonatomic) CGPoint cursorPoint;
@property (strong, nonatomic) NSString * currentSelectedKey;
@property (assign, nonatomic) BOOL bDrawCursor;

@property (strong, nonatomic) NSDate * fromDate;
@property (strong, nonatomic) NSDate * toDate;

@property (strong, nonatomic) ChartTIConfig * tiConfig;
@property (assign, nonatomic) ChartMainTIEnum mainTi;
@property (strong, nonatomic) ChartTI * mainTI;

//@property (strong, nonatomic) NSDateFormatter * selectDateFormat;

@property (assign, nonatomic) float prevClose;
@end

@implementation SmallChartViewController

//------------------------------------------------------------------------------
#pragma mark - Delegate
//------------------------------------------------------------------------------
// CustomDrawViewDelegate
- (void)customDrawView:(CustomDrawView *)valueView drawRect:(CGRect)rect context:(CGContextRef)context {
    if (valueView == self.cursorView){
        if (self.currentTouch){
            CGPoint left = CGPointMake(0, self.cursorPoint.y);
            CGPoint right = CGPointMake(rect.size.width, self.cursorPoint.y);
            
            CGPoint top = CGPointMake(self.cursorPoint.x, 0);
            CGPoint bottom = CGPointMake(self.cursorPoint.x, rect.size.height);
            
            UIColor * cursorColor = self.colorConfig.cursorLineColor;
            
            if (self.currentSelectedKey){
                ChartData * mainData = [[[self.chartView.chartClass getChartDataByGroupingKey:self.currentSelectedKey] firstObject] objectForKey:@"data"];
                CGPoint yAxis = CGPointMake(self.chartSetting.chartWidth, self.cursorPoint.y);
                CGPoint xAxis = CGPointMake(self.cursorPoint.x, self.chartSetting.chartHeight);
                
                chartTextBoxInfo * yAxisInfo = [ChartDrawCommon GetTextRectFromPoint:yAxis pointDirection:ChartTextBoxPointDirectionFromLeft sizeLimit:CGSizeMake(self.chartConfig.yAxisWidth, CGFLOAT_MAX) text:[self formatValue:mainData.close] initialFont:[self axisFont] fontColor:self.chartConfig.colorConfig.selectDataColor bgColor:self.chartConfig.colorConfig.selectDataBGColor];
                
                chartTextBoxInfo * xAxisInfo = [ChartDrawCommon GetTextRectFromPoint:xAxis pointDirection:ChartTextBoxPointDirectionFromTop sizeLimit:CGSizeMake(CGFLOAT_MAX, self.chartConfig.xAxisHeight) text:[self formatSelectDate:mainData.date] initialFont:[self axisFont] fontColor:self.chartConfig.colorConfig.selectDataColor bgColor:self.chartConfig.colorConfig.selectDataBGColor];
                
                if (xAxisInfo.rect.origin.x < 0){
                    CGRect xRect = xAxisInfo.rect;
                    xRect.origin.x = 0;
                    xAxisInfo.rect = xRect;
                }
                
                if (CGRectGetMaxX(xAxisInfo.rect) > self.chartSetting.chartWidth){
                    CGRect xRect = xAxisInfo.rect;
                    xRect.origin.x = self.chartSetting.chartWidth - xRect.size.width;
                    xAxisInfo.rect = xRect;
                }
                
                if (![mainData isEmpty]){
//                    [ChartDrawCommon DrawLineOnContext:context pointA:left pointB:right color:cursorColor];
                    [ChartDrawCommon DrawDashLineOnContext:context pointA:left pointB:right color:cursorColor];
                    [ChartDrawCommon DrawRectOnContext:context rect:yAxisInfo.rect color:[UIColor blackColor] isFill:YES];
                    [ChartDrawCommon DrawTextOnContext:context textBoxInfo:yAxisInfo];
                    
//                    [ChartDrawCommon DrawLineOnContext:context pointA:top pointB:bottom color:cursorColor];
                    [ChartDrawCommon DrawDashLineOnContext:context pointA:top pointB:bottom color:cursorColor];
                    [ChartDrawCommon DrawRectOnContext:context rect:xAxisInfo.rect color:[UIColor blackColor] isFill:YES];
                    [ChartDrawCommon DrawTextOnContext:context textBoxInfo:xAxisInfo];
                }
            }
        }
    }
}

// ChartViewTouchDelegate
- (void)chartView:(ChartView *)chartView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self displayCursorAtTouch:[touches anyObject]];
}
- (void)chartView:(ChartView *)chartView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self displayCursorAtTouch:[touches anyObject]];
}
- (void)chartView:(ChartView *)chartView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endCursor];
}

//------------------------------------------------------------------------------
#pragma mark - Override
//------------------------------------------------------------------------------
- (instancetype)init {
    if (self = [super init]){
        self.prevClose = kEmptyDataValue;
    }
    return self;
}

- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config {
    if (self = [self init]){
        [view addSubview:self.view];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[view]-5-|" options:0 metrics:nil views:@{@"view":self.view}]];
        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[view]-5-|" options:0 metrics:nil views:@{@"view":self.view}]];
        
//        view.backgroundColor = [UIColor cyanColor];
        
        self.chartConfig = config;
//        self.chartConfig.configDelegate = self;
        //        _groupingKeyList = [NSMutableArray arrayWithArray:keyList];
        [self updateColor];
    }
    return self;
}
- (void)initView {
    [super initView];
    
    self.chartView.touchDelegate = self;
    self.chartView.scrollEnabled = NO;
    
    self.cursorView = [[CustomDrawView alloc] initWithDelegate:self];
    [self.view addSubview:self.cursorView];
    self.cursorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.chartView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cursorView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.tiConfig = nil;
    self.mainTi = ChartMainTINone;
    [self enableCursor:NO];
}
- (void)initMainChartData:(NSArray<ChartData *> *)dataList backgroundList:(NSArray *)backgroundList{
    [super initMainChartData:dataList backgroundList:backgroundList];
    
//    if (self.mainTi < ChartMainTITotalCount && self.tiConfig ){
        [self initMainTI];
//    }
//    [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
    if (self.fromDate && self.toDate){
        [self setShowingRangeFromDate:self.fromDate toDate:self.toDate];
    } else {
        [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
    }
    if (self.prevClose != kEmptyDataValue) {
        [[self.chartView.chartClass getCustYAxisLines] addObject:
         @{
             @"value" : [NSNumber numberWithFloat:self.prevClose],
             @"color" : [ChartColorConfig color255WithRed:249 green:56 blue:56 alpha:1],
         }];
    } else {
        [[self.chartView.chartClass getCustYAxisLines] removeAllObjects];
    }
    if (self.chartView && self.chartView.chartClass) {
        [self.chartView.chartClass setChartAxisLineType:self.chartConfig.axisLineType];
    }
}
- (void)addMainChartData:(ChartData *)data {
////    if (_groupingKeyList){
    if (!self.chartSetting || !self.chartView.chartClass){
        [self initMainChartData:@[data]];
        return;
    }
    if (![_groupingKeyList containsObject:data.groupingKey]){
        [_groupingKeyList addObject:data.groupingKey];
        
    }
    [self.chartView.chartClass updateChartData:data forRefKey:@"MainData"];
//    if (self.mainTi < ChartMainTITotalCount && self.tiConfig ){
        [self initMainTI];
//    }
////    [self.chartView setNeedsDisplay];
//    [self updateMainChartViewWithoutResize];
    if (self.fromDate && self.toDate){
        [self setShowingRangeFromDate:self.fromDate toDate:self.toDate];
    } else {
        [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
    }
}

- (void)clearChartData {
    self.prevClose = kEmptyDataValue;
    [super clearChartData];
}

- (void)updateColor {
    [super updateColor];
//    self.chartView.backgroundColor = [ChartColorConfig color255WithString:@"255,255,255"];
}

- (NSArray *)getXAxisKeyList {
    if (self.xAxisKeyList){
        return self.xAxisKeyList;
    }
    return @[];
//    NSMutableArray * array = [NSMutableArray array];
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"mm"];
//    if (self.chartDataList){
//        for (ChartData * data in self.chartDataList){
//            NSDate * date = data.date;
//            if ([[formatter stringFromDate:date] isEqualToString:@"00"]){
//                [array addObject:data.groupingKey];
//            }
//        }
//    }
//    return array;
}
- (YAxisInfo *)getYAxisInfoForChartClass:(ChartClass *)chartClass withDataMinValue:(CGFloat)dataMin maxValue:(CGFloat)dataMax {
    YAxisInfo * yAxisInfo = [[YAxisInfo alloc] init];
    
    
    if (self.prevClose != kEmptyDataValue) {
        dataMax = (self.prevClose > dataMax) ? self.prevClose : dataMax;
        dataMin = (self.prevClose < dataMin) ? self.prevClose : dataMin;
    }
    
    return [super getYAxisInfoForChartClass:chartClass withDataMinValue:dataMin maxValue:dataMax];
//    CGFloat diff = dataMax - dataMin;
//    CGFloat displayYMaxValue = dataMax + diff * self.chartSetting.mainChartYAxisRangeDiffGapScale;
//    CGFloat displayYMinValue = dataMin - diff * self.chartSetting.mainChartYAxisRangeDiffGapScale;
//
//    if (dataMax < 0 && displayYMaxValue > 0){
//        displayYMaxValue = 0;
//    }
//    if (dataMin > 0 && displayYMinValue < 0){
//        displayYMinValue = 0;
//    }
//
//    if (dataMin > dataMax){
//        displayYMinValue = 0;
//        displayYMaxValue = 0;
//    }
//    yAxisInfo.YValueMax = displayYMaxValue;
//    yAxisInfo.YValueMin = displayYMinValue;
//
////    yAxisInfo.YValueMax = dataMax;
////    yAxisInfo.YValueMin = dataMin;
//
////    CGFloat diff = dataMax - dataMin;
////    yAxisInfo.YValueMax = dataMax + diff* 0.05;
////    yAxisInfo.YValueMin = dataMin - diff* 0.05;
////    CGFloat YValueSpread01 = dataMax - diff * 2/3;
////    CGFloat YValueSpread02 = dataMax - diff * 1/3;
//
//    NSMutableArray * array = [NSMutableArray array];
//    if (diff > 0){
//        NSInteger lineNumber = self.chartSetting.mainChartYAxisLineNum;
//        for (NSInteger i = 0; i <= lineNumber; i++){
//            CGFloat yValue = yAxisInfo.YValueMin + i * diff/lineNumber;
//            [array addObject:@(yValue)];
//        }
//    }
//
////    yAxisInfo.yAxisList = @[@(dataMax), @(dataMin)];
////    yAxisInfo.yAxisList = @[@(dataMax), @(YValueSpread01), @(YValueSpread02), @(dataMin)];
//
//    yAxisInfo.yAxisList = [NSArray arrayWithArray:array];
//
//    return yAxisInfo;
}
- (void)setShowingRangeFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    self.fromDate = fromDate;
    self.toDate = toDate;
    
    [super setShowingRangeFromDate:fromDate toDate:toDate];
//
//    NSString * fromKey = nil;
//    NSString * toKey = nil;
////    NSInteger keyCount = 0;
//
//    for (ChartData * chartData in self.chartDataList){
//        if (!fromKey){
//            fromKey = chartData.groupingKey;
//        }
//        if (!toKey){
//            toKey = chartData.groupingKey;
//        }
//        if ([chartData.date timeIntervalSince1970] > [toDate timeIntervalSince1970]){
//            break;
//        }
//        if ([chartData.date timeIntervalSince1970] < [fromDate timeIntervalSince1970]){
//            fromKey = chartData.groupingKey;
//        }
//        toKey = chartData.groupingKey;
//    }
//    if (!fromKey || !toKey){
//        return;
//    }
//    NSInteger fromIndex = [self.groupingKeyList indexOfObject:fromKey];
//    NSInteger toIndex = [self.groupingKeyList indexOfObject:toKey];
//
//    if (fromIndex == NSNotFound || toIndex == NSNotFound){
//        return;
//    }
//
//    [self setShowingRangeFromIndex:fromIndex toIndex:toIndex];
//
}

- (NSDictionary *)exportAllChartData {
    return [ChartTICalculator getDictionaryFromChartConfig:self.tiConfig forChartData:self.chartDataList];
}
- (void)enableCursor:(BOOL)bDrawCursor {
    self.bDrawCursor = bDrawCursor;
}

- (void)updateChartViewDisplay {
    if (self.fromDate && self.toDate){
        [self setShowingRangeFromDate:self.fromDate toDate:self.toDate];
    } else {
        [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
    }
}
//------------------------------------------------------------------------------
#pragma mark - Public
//------------------------------------------------------------------------------
- (void)setChartTI:(ChartMainTIEnum)chartTi withTIConfig:(ChartTIConfig *)tiConfig {
    self.mainTi = chartTi;
    self.tiConfig = tiConfig;
    self.tiConfig.selectedMainTI = chartTi;
    self.tiConfig.selectedSubTI = nil;
    [self initMainTI];
}
- (void)setShowingXAxisKeyList:(NSArray *)xAxisKeyList {
    self.xAxisKeyList = xAxisKeyList;
}
- (void)setPrevClose:(float)prevClose {
    [[self.chartView.chartClass getCustYAxisLines] removeAllObjects];
    _prevClose = kEmptyDataValue;
    if (prevClose != kEmptyDataValue) {
        _prevClose = prevClose;
        
        [[self.chartView.chartClass getCustYAxisLines] addObject:
         @{
             @"value" : [NSNumber numberWithFloat:prevClose],
             @"color" : [ChartColorConfig color255WithRed:249 green:56 blue:56 alpha:1],
         }];
    }
//    [self.chartView setNeedsDisplay];
    [self updateChartViewDisplay];
}
//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------
- (void)initMainTI {
    [self.chartView.chartClass removeChartLineObjectOtherThanKey:@"MainData"];

    if (!self.chartConfig){
        [self updateChartViewDisplay];
        return;
    }
    
    switch (self.tiConfig.selectedMainTI){
        case ChartMainTIEnumSMA:
        {
            self.mainTI = [[MainTISMA alloc] init];
        }
            break;
        case ChartMainTIEnumWMA:
        {
            self.mainTI = [[MainTIWMA alloc] init];
        }
            break;
        case ChartMainTIEnumEMA:
        {
            self.mainTI = [[MainTIEMA alloc] init];
        }
            break;
        case ChartMainTIEnumBB:
        {
            self.mainTI = [[MainTIBB alloc] init];
        }
            break;
        case ChartMainTIEnumSAR:
        {
            self.mainTI = [[MainTISAR alloc] init];
        }
            break;
        case ChartMainTINone:
        {
            self.mainTI = nil;
        }
        case ChartMainTITotalCount:
        default:
            break;
    }
    if (self.mainTI){
        [self.mainTI createChartObjectListFromChartData:self.chartDataList withTIConfig:self.tiConfig colorConfig:self.colorConfig];
        [self.chartView.chartClass addChartLineObjects:self.mainTI.tiLineObjects];
    }
    [self updateChartViewDisplay];
    
}

- (void)displayCursorAtTouch:(UITouch *)touch {
    if (self.bDrawCursor == NO) {
        [self endCursor];
        return;
    }
    
    self.currentTouch = touch;
    CGPoint point = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.chartView.frame, point)){
//        CGPoint pointInOverlay = [touch locationInView:self.overlayView];
        
        CGPoint pointInMainView = [touch locationInView:self.chartView];
        
//        [self.cursorLayer setFrame:CGRectMake(0, 0, self.overlayView.frame.size.width, self.overlayView.frame.size.height)];
        [self.chartView getNearestChartPointFromPoint:pointInMainView nonEmptyData:YES completion:^(bool found, NSString * key, CGPoint point) {
//            self.cursorLayer.hidden = !found;
            self.cursorView.hidden = !found;
            if (found){
                self.cursorPoint = point;
                self.currentSelectedKey = key;
            }
            [self displaySelectedChartData:key];
//            [self.cursorLayer setNeedsDisplay];
            [self.cursorView setNeedsDisplay];
        }];
    }
}
- (void)displaySelectedChartData:(NSString *)key {
    if (!key){
        key = [self.chartDataList lastObject].groupingKey;
    }
    self.currentSelectedKey = key;
    NSArray * chartDataList = [self.chartView.chartClass getChartDataByGroupingKey:key];
//    for (ChartData * cData in chartDataList){
    NSMutableArray * mainTIArray = [NSMutableArray array];
    for (NSDictionary * dataDict in chartDataList){
//        ChartData * cData = [dataDict objectForKey:@"data"];
        NSString * name = [dataDict objectForKey:@"name"];
//        UIColor * color = [dataDict objectForKey:@"color"];
//        NSLog(@"Name:%@ Date:%@ Value:%@", name, [self formatDate:cData.date], [self formatValue:cData.close]);
        if (name && [name isEqualToString:@"MainData"]){
//            if (self.chartDelegate && [self.chartDelegate respondsToSelector:@selector(displaySelectedMainChartData:)]){
//                [self.chartDelegate displaySelectedMainChartData:[dataDict objectForKey:@"data"]];
//            }
        } else {
            [mainTIArray addObject:dataDict];
        }
        
    }
    if ([mainTIArray count] > 0){
//        NSLog(@"MainTI: %@", [mainTIArray valueForKey:@"data"]);
    }

}
- (void)endCursor {
    self.currentTouch = nil;
//    [self displaySelectedChartData:nil];
//    [self.cursorLayer setNeedsDisplay];
    [self.cursorView setNeedsDisplay];
}


//- (NSMutableArray *)groupingKeyList {
//    return _groupingKeyList;
//}

//- (UIFont *)axisFont {
//    return [UIFont fontWithName:@"Arial" size:12.f];
//}
//
//- (UIColor *)axisColor {
//    return [UIColor blackColor];
//}
//
//- (NSString *)formatValue:(CGFloat)value {
////    NSString * valueDisplayFormat = @"%.3f";
////    return [NSString stringWithFormat:valueDisplayFormat, value];
//    if (self.chartConfig){
//        return [self.chartConfig formatValue:value];
//    }
//    NSString * valueDisplayFormat = @"%.3f";
//    return [NSString stringWithFormat:valueDisplayFormat, value];
//}
//
//- (NSString *)formatDate:(NSDate *)date {
//    if (self.chartConfig){
//        return [self.chartConfig formatDate:date];
//    }
//    NSString * dateFormat = @"HH";
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:dateFormat];
//    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    return [formatter stringFromDate:date];
//}

//- (NSString *)formatSelectDate:(NSDate *)date {
//    if (self.selectDateFormat){
//        return [self.selectDateFormat stringFromDate:date];
//    }
//    NSString * dateFormat = @"HH:mm";
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:dateFormat];
////    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
//    [formatter setTimeZone:self.chartConfig.timeZone];
//    return [formatter stringFromDate:date];
//}


//- (ChartColorConfig *)colorConfig {
//    if (self.chartConfig.colorConfig){
//        return self.chartConfig.colorConfig;
//    }
//    return [ChartColorConfig defaultLightConfig];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)updateColor {
//    self.chartView.backgroundColor = self.colorConfig.axisBackgroundColor;
//}


//- (instancetype)initWithContainerView:(UIView *)view withConfig:(ChartConfig *)config{
//    if (self = [self init]){
//        [view addSubview:self.view];
//        self.view.translatesAutoresizingMaskIntoConstraints = NO;
//        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
//        [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.view}]];
//
//        self.chartConfig = config;
////        _groupingKeyList = [NSMutableArray arrayWithArray:keyList];
//        [self updateColor];
//    }
//    return self;
//}

//- (void)initBasicConfig {
//    ChartGlobalSetting * globalSetting = [[ChartGlobalSetting alloc] init];
//    globalSetting.startXOffset = 0.f;
//    globalSetting.endXOffset = 0.f;
//    globalSetting.YOffsetStart = 0.f;
//
////    CGRect frame = self.view.frame;
//    globalSetting.yAxisWidth = self.chartConfig.yAxisWidth;
//    globalSetting.chartWidth = self.chartConfig.chartWidth;
//    globalSetting.xAxisHeight = self.chartConfig.xAxisHeight;
//    globalSetting.chartHeight = self.chartConfig.chartHeight;
////    globalSetting.xAxisPerValue = globalSetting.chartWidth / [self.groupingKeyList count];
//
//    self.chartSetting = globalSetting;
//
//    self.chartView.chartClass = [[ChartClass alloc] init];
////    self.chartView.chartClass.displayDelegate = self;
////    [self.chartView.chartClass initWithChartObjectList:[NSMutableArray array] displayDelegate:self];
//}
//
//- (ChartLineObject *)createMainLineObject {
//    ChartLineObject * chartLineObject;
//    switch (self.chartConfig.mainChartLineType){
//        case ChartLineTypeBar:
//        {
//            chartLineObject = [[ChartLineObjectBar alloc] initWithMainColor:self.colorConfig.mainBarColor];
//        }
//            break;
//        case ChartLineTypeArea:
//        {
//            chartLineObject = [[ChartLineObjectArea alloc] initWithStrokeColor:self.colorConfig.mainAreaLineColor gradientColor:self.colorConfig.mainAreaFillColor];
//        }
//            break;
//        case ChartLineTypeLine:
//        {
//            chartLineObject = [[ChartLineObjectLine alloc] initWithMainColor:self.colorConfig.mainLineColor];
//        }
//            break;
//        case ChartLineTypeCandle:
//        {
//            chartLineObject = [[ChartLineObjectCandle alloc] initWithUpColor:self.colorConfig.mainCandleUpColor downColor:self.colorConfig.mainCandleDownColor];
//        }
//            break;
//        case ChartLineTypeHisto:
//        {
//            chartLineObject = [[ChartLineObjectHisto alloc] initWithUpColor:self.colorConfig.mainCandleUpColor downColor:self.colorConfig.mainCandleDownColor];
//        }
//            break;
//    }
//    [chartLineObject setChartDataByChartDataList:self.chartDataList];
//    chartLineObject.refKey = @"MainData";
//    return chartLineObject;
//}
//
//- (void)initMainChartData:(NSArray<ChartData *> *)dataList {
//    if (!self.chartSetting || !self.chartView.chartClass){
//        [self initBasicConfig];
//    }
//    self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/([dataList count]-1);
//
//    NSMutableArray * keyList = [NSMutableArray array];
//    NSMutableArray * lineObjectList = [NSMutableArray array];
//
//    self.chartDataList = [NSMutableArray arrayWithArray:dataList];
//
//    for (ChartData * chartData in dataList){
//        if (![keyList containsObject:chartData.groupingKey]){
//            [keyList addObject:chartData.groupingKey];
//        }
//    }
//
//    _groupingKeyList = keyList;
//
//    ChartLineObject * chartLineObject = [self createMainLineObject];
//
//    [lineObjectList addObject:chartLineObject];
//
//    [self.chartView.chartClass initWithChartObjectList:lineObjectList displayDelegate:self];
//
//    [self setShowingRangeFromIndex:0 toIndex:[self.chartDataList count]-1];
//}
//

//- (ChartGlobalSetting *)globalSettingForChartClass:(ChartClass *)chartClass {
//    return self.chartSetting;
//}

//
//- (void)updateChartContentSize {
//    self.chartView.contentSize = [self.chartView.chartClass getContentSize];
//}
//
//- (void)scrollToContentOffsetX:(CGFloat)x {
//    CGFloat maximumOffset = [self.chartView.chartClass maximumScrollOffsetX];
//    if (x > maximumOffset){
//        x = maximumOffset;
//    }
//    self.chartView.contentOffset = CGPointMake(x, self.chartView.contentOffset.y);
//}
//
//- (void)updateMainChartViewWithoutResize {
//    [self.chartView.chartClass updateChartDisplayInfoForContentOffset:self.chartView.contentOffset];
////    CGFloat minXAxis = [self.chartSetting GetXCoodinateForIndex:0];
////    CGFloat maxXAxis = [self.chartSetting GetXCoodinateForIndex:[self.chartDataList count] -1];
////    self.chartView.contentOffset = CGPointMake(minXAxis, self.chartView.contentOffset.y);
////    [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:minXAxis maxAxis:maxXAxis];
//
//    [self.chartView setNeedsDisplay];
//}

//- (void)setShowingRangeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    if (fromIndex > toIndex){
//        return;
//    }
//    if (fromIndex >= [self.chartDataList count]){
//        return;
//    }
//    if (toIndex >= [self.chartDataList count]){
//        return;
//    }
//
//    NSInteger keyCount = toIndex - fromIndex;
//    if (self.chartConfig.mainChartLineType == ChartLineTypeCandle || self.chartConfig.mainChartLineType == ChartLineTypeBar){
//        self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/(keyCount + 1);
//    } else {
//        self.chartSetting.xAxisPerValue = self.chartSetting.chartWidth/keyCount;
//    }
//    [self updateChartContentSize];
//
//    CGFloat minXAxis = [self.chartSetting GetXCoodinateForIndex:fromIndex];
//    CGFloat maxXAxis = [self.chartSetting GetXCoodinateForIndex:toIndex];
//    if (self.chartConfig.mainChartLineType == ChartLineTypeCandle || self.chartConfig.mainChartLineType == ChartLineTypeBar){
//        minXAxis -= self.chartSetting.xAxisPerValue/2;
//        maxXAxis += self.chartSetting.xAxisPerValue/2;
//    }
//    self.chartView.contentOffset = CGPointMake(minXAxis, self.chartView.contentOffset.y);
//    [self.chartView.chartClass updateChartDisplayInfoForMinXAxis:minXAxis maxAxis:maxXAxis];
//    [self.chartView setNeedsDisplay];
//}
//
//




@end
