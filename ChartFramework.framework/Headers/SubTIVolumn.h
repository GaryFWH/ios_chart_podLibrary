//
//  SubTIVolumn.h
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface SubTIVolumnUnit : NSObject

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) BOOL bShowSma;
@property (nonatomic, assign) NSInteger smaDay;
@property (nonatomic, strong) UIColor * volUpColor;
@property (nonatomic, strong) UIColor * volDownColor;
@property (nonatomic, strong) UIColor * smaColor;
- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTIVolumn : ChartTI

//@property (nonatomic, strong) NSArray<SubTIVolumnUnit *> * dataList;
@property (nonatomic, strong) SubTIVolumnUnit * unit;

@end

NS_ASSUME_NONNULL_END
