//
//  SubTIMACD.h
//  ChartLibraryDemo
//
//  Created by Gary on 4/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import "ChartTI.h"

NS_ASSUME_NONNULL_BEGIN
@interface SubTIMACDUnit : NSObject

@property (nonatomic, assign) NSInteger iMacd1;
@property (nonatomic, assign) NSInteger iMacd2;
@property (nonatomic, assign) NSInteger iDiff;

@property (nonatomic, strong) UIColor * iMacd1Color;
@property (nonatomic, strong) UIColor * iMacd2Color;
@property (nonatomic, strong) UIColor * iAboveDiffColor;
@property (nonatomic, strong) UIColor * iBelowDiffColor;
@property (nonatomic, strong) UIColor * zeroColor;
- (NSString *)objectKey:(NSString*)lineKey;

@end

@interface SubTIMACD : ChartTI

//@property (nonatomic, strong) NSArray<SubTIMACDUnit *> * dataList;
@property (nonatomic, strong) SubTIMACDUnit * unit;

@end

NS_ASSUME_NONNULL_END
