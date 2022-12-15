//
//  ChartBackground.h
//  ChartLibraryDemo
//
//  Created by william on 6/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ChartBackgroundColor : NSObject

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGFloat coverPecentage;

- (instancetype)initWithColor:(UIColor *)color percentage:(CGFloat)percentage;

@end


@interface ChartBackground : NSObject

@property (nonatomic, strong) NSString * groupingKey;
@property (nonatomic, strong) NSMutableArray<ChartBackgroundColor *> * colorList;

- (instancetype)initWithKey:(NSString *)key colors:(NSArray *)colors;

@end

NS_ASSUME_NONNULL_END
