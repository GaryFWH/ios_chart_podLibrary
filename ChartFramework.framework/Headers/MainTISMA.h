//
//  MainTISMA.h
//  ChartLibraryDemo
//
//  Created by william on 1/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface MainTISMAUnit : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) UIColor * color;
- (NSString *)objectKey;

@end

@interface MainTISMA : ChartTI

@property (nonatomic, strong) NSArray<MainTISMAUnit *> * dataList;

@end

NS_ASSUME_NONNULL_END
