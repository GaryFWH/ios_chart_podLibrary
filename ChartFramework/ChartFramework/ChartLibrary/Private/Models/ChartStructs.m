//
//  ChartStructs.m
//  ChartLibraryDemo
//
//  Created by william on 27/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartStructs.h"
@implementation ChartGlobalSetting

- (CGFloat)GetXCoodinateForIndex:(NSInteger) index
{
    return ((index+1) * self.xAxisPerValue + self.startXOffset);
}

@end

@implementation YAxisInfo

@end

@implementation YMinMaxInfo

@end

@implementation ChartDisplayInfo

- (CGFloat)GetYCoodinateForValue:(CGFloat) value
{
    CGFloat yHeight = self.chartSetting.chartHeight;
    CGFloat yCoorPerValue = self.yAxisPerValue;
    CGFloat coor = yHeight - (value - self.yAxisInfo.YValueMin) * yCoorPerValue + self.chartSetting.YOffsetStart;
    return coor;
}

- (CGFloat)GetXCoodinateForTimestamp:(NSString *) key
{
    if (![self.timestampToIndex objectForKey:key]) {
        return NSNotFound;
    }
    
    NSInteger index = [[self.timestampToIndex objectForKey:key] integerValue];
    return [self.chartSetting GetXCoodinateForIndex:index];
}

- (NSInteger)GetClosestIndexForXCoordinate:(CGFloat)x frameOnly:(BOOL)frameOnly{
    CGFloat contentX = x - self.chartSetting.startXOffset;
    if (frameOnly){
        contentX = self.minXAxis + x - self.chartSetting.startXOffset;
    }
    CGFloat xAxisPerValue = self.chartSetting.xAxisPerValue;
    if (contentX < 0){
        return 0;
    }
    NSInteger index = round(contentX/xAxisPerValue);
    
    return (index-1);
}

@end
