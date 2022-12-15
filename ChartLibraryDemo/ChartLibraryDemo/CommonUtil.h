//
//  CommonUtil.h
//  ChartLibraryDemo
//
//  Created by Gary on 16/6/2021.
//  Copyright Â© 2021 william. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChartFramework/ChartFramework.h>
//#import "ChartConst.h"
//#import "ChartColorConfig.h"
#import "ChartDataRequest.h"

//#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
//#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

typedef NS_ENUM(NSInteger, ChartMinTypeSelection)
{
    ChartMinTypeSelection1Min     = 0,
    ChartMinTypeSelection5Min     = 1,
    ChartMinTypeSelection15Min    = 2,
    ChartMinTypeSelection30Min    = 3,
    ChartMinTypeSelectionHourly   = 4,
    ChartMinTypeSelectionDaily    = 5,
    ChartMinTypeSelectionWeekly   = 6,
    ChartMinTypeSelectionMonthly  = 7
};

//typedef NS_ENUM(NSInteger, ChartDisTypeSelection)
//{
//    ChartDisTypeSelectionCandlesticks   = 0,
//    ChartDisTypeSelectionLine           = 1,
//    ChartDisTypeSelectionArea           = 2,
//    ChartDisTypeSelectionBar            = 3
//};

//typedef NS_ENUM(NSInteger, ChartColorTypeSelection)
//{
//    ChartColorTypeSelectionLight   = 0,
//    ChartColorTypeSelectionDark    = 1
//};

typedef NS_ENUM(NSInteger, ChartSettingView)
{
    ChartSettingViewMinType   = 0,
    ChartSettingViewDisType   = 1,
    ChartSettingViewColorType = 2,
    ChartSettingViewSessionType = 3
};

@interface CommonUtil : NSObject {

}

@property (nonatomic, strong) NSArray* timeSelectionArray;
@property (nonatomic, strong) NSArray* typeSelectionArray;
@property (nonatomic, strong) NSArray* colorSelectionArray;
@property (nonatomic, strong) NSArray* sessionSelectionArray;

+ (CommonUtil*)instance;
- (NSString*)getStrTimeSelection:(ChartMinTypeSelection)minType;
//- (NSString*)getStrTypeSelection:(ChartDisTypeSelection)disType;
- (NSString*)getStrColorSelection:(ChartColorTypeSelection)colorType;
- (NSString*)getStrLineTypeSelection:(ChartLineType)lineType;
- (NSString*)getStrSessionSelection:(ChartSessionType)session;
- (ChartColorConfig*)getColorConfig:(ChartColorTypeSelection)colorType;

#pragma mark - Safe Area
+(CGFloat)safeAreaInsetTop;
+(CGFloat)safeAreaInsetBottom;
+(CGFloat)safeAreaInsetLeft;
+(CGFloat)safeAreaInsetRight;
@end
