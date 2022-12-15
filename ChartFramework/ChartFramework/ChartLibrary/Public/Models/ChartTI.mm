//
//  ChartTI.m
//  ChartLibraryDemo
//
//  Created by william on 2/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

@implementation ChartTI

+ (NSString *)refKeyForChart
{
    return NSStringFromClass([self class]);
}

- (NSString *)refKeyForChart
{
    return NSStringFromClass([self class]);
}

- (NSArray *)calculateChartObjectListFromChartData:(NSArray *)dataList {
    return @[];
}

- (void)initChartObjectListFromChartData:(NSArray *)dataList {
    self.tiLineObjects = [self calculateChartObjectListFromChartData:dataList];
}

- (void)createChartObjectListFromChartData:(NSArray *)dataList withTIConfig:(ChartTIConfig *)tiConfig colorConfig:(ChartColorConfig *)colorConfig {
    //Implement in Sub Class
}

- (void)createDefaultDataList
{
    //Implement in Sub Class
}

- (NSArray *)dataDictsForGroupingKey:(NSString *)groupKey {
    //Default
//    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    if (self.tiLineObjects){
        for (ChartLineObject * obj in self.tiLineObjects){
            ChartData * data = [obj.chartDataDict objectForKey:groupKey];
            if (data){
                //if (![obj.dataName isEqualToString:@""]) {
                    if ([data isEmpty]){
                        [array addObject:
                            @{
                                @"color": [obj colorWithChartData:data],
                                // @"name": obj.refKey,
                                @"name": obj.dataName,
                                @"date" : data.date,
                            }];
                    } else if ([obj isKindOfClass:[ChartLineObjectSingleValue class]]){
                        CGFloat value = [obj getValueForKey:groupKey forDisplayType:((ChartLineObjectSingleValue *)obj).displayType];
                        if (obj.tail != nil && ![obj.tail isEqualToString:@""]) {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [self formatValue:value],
                                    @"tail"     : obj.tail,
                                }];
                        } else {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [self formatValue:value],
                                }];
                        }
                        
                    } else {
                        CGFloat value = [obj getValueForKey:groupKey forDisplayType:ChartDataDisplayTypeClose];
                        if (obj.tail != nil && [obj.tail isEqualToString:@""]) {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [self formatValue:value],
                                    @"tail"     : obj.tail,
                                }];
                        } else {
                            [array addObject:
                                @{
                                    @"color"    : [obj colorWithChartData:data],
                                    // @"name": obj.refKey,
                                    @"name"     : obj.dataName,
                                    @"date"     : data.date,
                                    @"value"    : [self formatValue:value],
                                }];
                        }
                        

                    }
                    
//                    NSLog(@"Ti.dataDict name %@ value %@", obj.refKey, [self formatValue:data.close]);
               // }
            }
        }
    }
    return array;
}

- (NSString *)formatValue:(CGFloat)value {
    //Default
//    NSString * valueFormat = @"0.000";
//    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterNoStyle];
//    [formatter setPositiveFormat:valueFormat];
//    NSNumber * number = [NSNumber numberWithDouble:value];
//    return [formatter stringFromNumber:number];
    return [ChartCommonUtil formatFloatValue:value byFormat:@"0.00" groupKMB:NO];
}

- (void)updateLineObjectColorByChartColorConfig:(ChartColorConfig *)colorConfig {
    //Define in Each TI
}

@end
