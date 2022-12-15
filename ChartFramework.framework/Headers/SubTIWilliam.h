//
//  SubTIWilliam.h
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface SubTIWilliamUnit : NSObject

@property (nonatomic, assign) NSInteger diff;
@property (nonatomic, assign) BOOL bShowSma;
@property (nonatomic, assign) NSInteger smaDay;
@property (nonatomic, strong) UIColor * williamColor;
@property (nonatomic, strong) UIColor * smaColor;
- (NSString *)objectKey:(NSString*)lineKey ;
 
@end

@interface SubTIWilliam : ChartTI

//@property (nonatomic, strong) NSArray<SubTIWilliamUnit *> * dataList;
@property (nonatomic, strong) SubTIWilliamUnit * unit;

@end

NS_ASSUME_NONNULL_END
