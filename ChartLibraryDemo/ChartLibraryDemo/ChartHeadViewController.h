//
//  ChartHeadViewController.h
//  ChartLibraryDemo
//
//  Created by william on 9/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChartFramework/ChartFramework.h>
#import "CommonUtil.h"
//#import "ChartColorConfig.h"
//#import "ChartData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChartHeadViewControllerDelegate;

@interface ChartHeadViewController : UIViewController {
    NSMutableArray *selectBtnArray;
    UIView *selectView;
}

@property (nonatomic, assign) id<ChartHeadViewControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton * closeButton;
@property (nonatomic, strong) IBOutlet UIButton * refreshButton;

@property (nonatomic, strong) IBOutlet UILabel * codeLabel;
@property (nonatomic, strong) IBOutlet UILabel * codeNameLabel;
@property (nonatomic, strong) IBOutlet UIButton * searchFieldButton;
@property (nonatomic, strong) IBOutlet UITextField * codeTextField;
@property (nonatomic, strong) IBOutlet UIView * codeView;
@property (nonatomic, strong) IBOutlet UIView * searchView;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn02;

@property (weak, nonatomic) IBOutlet UIView *holcBGView;

// ==============

@property (weak, nonatomic) IBOutlet UIView *timeSettingView;
@property (weak, nonatomic) IBOutlet UIView *typeSettingView;
@property (weak, nonatomic) IBOutlet UIView *colorSettingView;
@property (weak, nonatomic) IBOutlet UIView *tiSettingView;
@property (weak, nonatomic) IBOutlet UIView *sessionSettingView;
@property (weak, nonatomic) IBOutlet UIView *refreshView;
@property (weak, nonatomic) IBOutlet UIView *closeView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *openLabelVal;
@property (weak, nonatomic) IBOutlet UILabel *highLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *highLabelVal;
@property (weak, nonatomic) IBOutlet UILabel *lowLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *lowLabelVal;
@property (weak, nonatomic) IBOutlet UILabel *closeLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *closeLabelVal;
@property (weak, nonatomic) IBOutlet UIView *splitView01;


@property (weak, nonatomic) IBOutlet UILabel *timeAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeBelowLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeBelowLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorBelowLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *tiBelowLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionAboveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sessionBelowLabel;

@property (nonatomic, strong) IBOutlet UIButton *timeSettingBtn;
@property (nonatomic, strong) IBOutlet UIButton *typeSettingBtn;
@property (nonatomic, strong) IBOutlet UIButton *colorSettingBtn;
@property (nonatomic, strong) IBOutlet UIButton *tiSettingBtn;
@property (weak, nonatomic) IBOutlet UIButton *sessionSettingBtn;

@property (weak, nonatomic) IBOutlet UIView *settingView01;
@property (weak, nonatomic) IBOutlet UIView *settingView02_V;

@property (weak, nonatomic) IBOutlet UIView *ohlcView;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewPerWidth_H;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewPerWidth_V;

@property ChartMinTypeSelection iChartMinType;
@property ChartLineType iChartLineType;
@property ChartColorTypeSelection iChartColorType;
@property ChartSessionType iChartSessionType;
@property ChartSettingView iSelectType;

- (void)resetFrame;
- (void)updateUI;
- (void)updateColor:(ChartColorConfig*)chartColorConfig;
- (void)updateSettingConfig:(ChartMinTypeSelection)minType ChartLineType:(ChartLineType)lineType ChartColorType:(ChartColorTypeSelection)colorType ChartSessionType:(ChartSessionType)session;
- (void)updateSettingLabel;

- (void)updateOHLCdate:(NSString *)date open:(NSString *)open high:(NSString *)high low:(NSString *)low close:(NSString *)close;

@end

@protocol ChartHeadViewControllerDelegate <NSObject>

- (void)closeChart;
- (void)refreshChart;
- (void)searchCode:(NSString *)code;
//- (void)clickedButton:(UIButton *)button;
- (void)didClickSettingView:(ChartHeadViewController*)chartHeadViewController SelectType:(ChartSettingView)iSelectType;
- (void)didClickTiSetting:(ChartHeadViewController*)chartHeadViewController;


@end

NS_ASSUME_NONNULL_END
