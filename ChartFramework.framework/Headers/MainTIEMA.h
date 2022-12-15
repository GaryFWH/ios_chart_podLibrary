//
//  MainTIEMA.h
//  ChartLibraryDemo
//
//  Created by william on 3/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainTIEMAUnit : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) UIColor * color;
- (NSString *)objectKey;
@end

@interface MainTIEMA : ChartTI

@property (nonatomic, strong) NSArray<MainTIEMAUnit *> * dataList;

@end

NS_ASSUME_NONNULL_END
