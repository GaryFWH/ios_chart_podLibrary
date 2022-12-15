//
//  chartData.h
//  ChartLibraryDemo
//
//  Created by william on 7/4/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//Data for point on chart

#define kEmptyDataValue -0.0001f

NS_ASSUME_NONNULL_BEGIN

@interface ChartData : NSObject

@property (nonatomic, strong) NSString * groupingKey;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, assign) CGFloat open;
@property (nonatomic, assign) CGFloat high;
@property (nonatomic, assign) CGFloat low;
@property (nonatomic, assign) CGFloat close;
@property (nonatomic, assign) CGFloat volume;

//
- (instancetype)initEmptyDataWithGroupingKey:(NSString *)key date:(NSDate *)date;
- (instancetype)initSimpleDataWithGroupingKey:(NSString *)key date:(NSDate *)date value:(CGFloat)value;

- (BOOL)isEmpty;
- (NSComparisonResult)compareByKey:(NSString *)key;

- (void)mergeWithData:(ChartData *)data;

@end

NS_ASSUME_NONNULL_END
