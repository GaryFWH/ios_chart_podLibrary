//
//  ChartHeadViewController.m
//  ChartLibraryDemo
//
//  Created by william on 9/6/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <ChartFramework/ChartFramework.h>
#import "ChartHeadViewController.h"
//#import "ChartConst.h"

@interface ChartHeadViewController () <UITextFieldDelegate>

@property (nonatomic, assign) bool isSearching;

@end

@implementation ChartHeadViewController

@synthesize iSelectType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.codeTextField.delegate = self;
    
    self.iChartMinType = ChartMinTypeSelection5Min;
    self.iChartLineType = ChartLineTypeBar;
    self.iChartColorType = ChartColorTypeSelectionLight;
    self.iChartSessionType = ChartSessionTypePre;
    
    selectBtnArray = [[NSMutableArray alloc] init];
    selectView = [[UIView alloc] init];
    selectView.hidden = YES;
    [selectView.layer setMasksToBounds:YES];
    [selectView.layer setCornerRadius:4.0];
    
    [self initView];
    [self updateUILanguage];
    
    [self.refreshButton addTarget:self action:@selector(refreshChart:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self updateUI];
}

//------------------------------------------------------------------------------
#pragma mark - Delegate
//------------------------------------------------------------------------------
- (IBAction)closeChart
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeChart)]){
        [self.delegate closeChart];
    }
}
- (IBAction)refreshChart:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshChart)]){
        [self.delegate refreshChart];
    }
}

- (IBAction)triggerSearch:(id)sender
{
    [self setIsSearching:!self.isSearching];
}
- (void)setIsSearching:(bool)isSearching
{
    _isSearching = isSearching;
    if (_isSearching){
        self.codeView.hidden = YES;
        self.searchView.hidden = NO;
        
        [self.codeTextField becomeFirstResponder];
        
        self.codeTextField.returnKeyType = UIReturnKeyGo;
        
    } else {
        self.codeView.hidden = NO;
        self.searchView.hidden = YES;
        if (![self.codeTextField.text isEqualToString:@""]) {
            [self.codeTextField setText:@""];
        }
        
        [self.codeTextField resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.codeTextField){
        [self DoSearchCode];
    }
    return YES;
}
- (IBAction)onBtn_SearchBtn:(id)sender
{
    [self DoSearchCode];
}
- (IBAction)onClick_SettingView:(id)sender
{
//    if (!dimView.hidden) {
//        dimView.hidden = YES;
//        [dimView removeFromSuperview];
//    }
//    if (!self.tiSelectViewController.view.hidden) {
//        [self.tiSelectViewController.view removeFromSuperview];
//        self.tiSelectViewController.view.hidden = YES;
//    }
//    if (!self.tiSettingViewController.view.hidden) {
//        [self.tiSettingViewController.view removeFromSuperview];
//        self.tiSettingViewController.view.hidden = YES;
//    }
    [self.codeTextField resignFirstResponder];
    self.codeView.hidden = NO;
    self.searchView.hidden = YES;
    [self resetSettingView];
    
    UIColor *btnSelectColor = [ChartColorConfig color255WithString:@"30,57,107)"];
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton*)sender;
        iSelectType = btn.tag;
    }
    
    switch (iSelectType) {
            
        case ChartSettingViewMinType: {
            [self.timeSettingView setBackgroundColor:btnSelectColor];
            break;
        }
        case ChartSettingViewDisType: {
            [self.typeSettingView setBackgroundColor:btnSelectColor];
            break;
        }
            
           
        case ChartSettingViewColorType: {
            //
            break;
        }
            
        case ChartSettingViewSessionType: {
            [self.sessionSettingView setBackgroundColor:btnSelectColor];
            break;
        }
    }
    
//    if(iSelectType == ChartSettingViewColorType)
//    {
//        //
//    }else {
//        if (iSelectType == ChartSettingViewMinType) {
//            [self.timeSettingView setBackgroundColor:btnSelectColor];
//        } else {
//            [self.typeSettingView setBackgroundColor:btnSelectColor];
//        }
//    }
    [_delegate didClickSettingView:self SelectType:iSelectType];
}
/*
- (void)onClick_SelectButton:(id)sender
{
    NSLog(@"onClick_SelectButton");
    UIButton* btn = (UIButton*)sender;
    long iSelected = btn.tag - 10;
    if (iSelectType == ChartSettingViewMinType) {
        iChartMinType = (int)iSelected;
        
        //
        
        NSString* strTime = [[[CommonUtil instance] timeSelectionArray] objectAtIndex:iChartMinType];
        [self.timeBelowLabel setText:strTime];
    } else if (iSelectType == ChartSettingViewDisType) {
        iChartDisType = (int)iSelected;
        
        //
        
        NSString* strType = [[[CommonUtil instance] typeSelectionArray] objectAtIndex:iChartDisType];
        [self.typeBelowLabel setText:strType];
    } else if (iSelectType == ChartSettingViewColorType) {
        
    }
    
    if (!selectView.hidden) {
        [selectView removeFromSuperview];
        selectView.hidden = YES;
        [self resetSettingView];
    }
}
 */
- (IBAction)onClick_SelectTi:(id)sender
{
    [self.delegate didClickTiSetting:self];
}
//------------------------------------------------------------------------------
#pragma mark - Public
//------------------------------------------------------------------------------
- (void)resetFrame
{
//    self.settingViewPerWidth_H.constant = (self.settingView01.frame.size.width - 30 * 2) / 5 ;
//    self.settingViewPerWidth_V.constant = (self.settingView02_V.frame.size.width) / 4;
    
}
- (void)updateUI
{
    [self resetFrame];
    [self updateColor:[[CommonUtil instance] getColorConfig:self.iChartColorType]];
//    [self updateUILanguage];
}
- (void)updateSettingConfig:(ChartMinTypeSelection)minType ChartLineType:(ChartLineType)lineType ChartColorType:(ChartColorTypeSelection)colorType ChartSessionType:(ChartSessionType)session
{
    self.iChartMinType = minType;
    self.iChartLineType = lineType;
    self.iChartColorType = colorType;
    self.iChartSessionType = session;
    
    [self updateSettingLabel];
    [self resetSettingView];
}
- (void)updateSettingLabel
{
    if (self.timeBelowLabel) {
        NSString *strTime = [[CommonUtil instance] getStrTimeSelection:self.iChartMinType];
        [self.timeBelowLabel setText:strTime];
    }
    if (self.typeBelowLabel) {
        NSString *strType = [[CommonUtil instance] getStrLineTypeSelection:self.iChartLineType];
        [self.typeBelowLabel setText:strType];
    }
    if (self.colorBelowLabel) {
        NSString *strColor = [[CommonUtil instance] getStrColorSelection:self.iChartColorType];
        [self.colorBelowLabel setText:strColor];
    }
    if (self.sessionBelowLabel) {
        NSString *strColor = [[CommonUtil instance] getStrSessionSelection:self.iChartSessionType];
        [self.sessionBelowLabel setText:strColor];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------
-(void)initView
{
    UIFont *titleFont   = [UIFont boldSystemFontOfSize:12];
    UIFont *valFont     = [UIFont boldSystemFontOfSize:12];
    UIFont *settingFontSize = [UIFont systemFontOfSize:12];

    // date & OHLC
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    self.dateLabel.font = valFont;
    self.dateLabel.textColor = RGBCOLOR(14, 69, 108);
    self.dateLabel.backgroundColor = [UIColor clearColor];
    
    self.openLabelTitle.adjustsFontSizeToFitWidth = YES;
    self.openLabelTitle.font = titleFont;
    self.openLabelTitle.text = @"O:";
    self.closeLabelTitle.adjustsFontSizeToFitWidth = YES;
    self.closeLabelTitle.font = titleFont;
    self.closeLabelTitle.text = @"C:";
    self.highLabelTitle.adjustsFontSizeToFitWidth = YES;
    self.highLabelTitle.font = titleFont;
    self.highLabelTitle.text = @"H:";
    self.lowLabelTitle.adjustsFontSizeToFitWidth = YES;
    self.lowLabelTitle.font = titleFont;
    self.lowLabelTitle.text = @"L:";
    
    self.openLabelVal.adjustsFontSizeToFitWidth = YES;
    self.openLabelVal.font = valFont;
    self.closeLabelVal.adjustsFontSizeToFitWidth = YES;
    self.closeLabelVal.font = valFont;
    self.highLabelVal.adjustsFontSizeToFitWidth = YES;
    self.highLabelVal.font = valFont;
    self.lowLabelVal.adjustsFontSizeToFitWidth = YES;
    self.lowLabelVal.font = valFont;
    
    
    // Setting Label
    self.timeAboveLabel.adjustsFontSizeToFitWidth = YES;
    [self.timeAboveLabel setFont:settingFontSize];
    [self.timeAboveLabel setTextAlignment:NSTextAlignmentLeft];
    self.timeBelowLabel.adjustsFontSizeToFitWidth = YES;
    [self.timeBelowLabel setFont:settingFontSize];
    [self.timeBelowLabel setTextAlignment:NSTextAlignmentLeft];
    self.typeAboveLabel.adjustsFontSizeToFitWidth = YES;
    [self.typeAboveLabel setFont:settingFontSize];
    [self.typeAboveLabel setTextAlignment:NSTextAlignmentLeft];
    self.typeBelowLabel.adjustsFontSizeToFitWidth = YES;
    [self.typeBelowLabel setFont:settingFontSize];
    [self.typeBelowLabel setTextAlignment:NSTextAlignmentLeft];
    self.colorAboveLabel.adjustsFontSizeToFitWidth = YES;
    [self.colorAboveLabel setFont:settingFontSize];
    [self.colorAboveLabel setTextAlignment:NSTextAlignmentLeft];
    self.colorBelowLabel.adjustsFontSizeToFitWidth = YES;
    [self.colorBelowLabel setFont:settingFontSize];
    [self.colorBelowLabel setTextAlignment:NSTextAlignmentLeft];
    self.tiAboveLabel.adjustsFontSizeToFitWidth = YES;
    [self.tiAboveLabel setFont:settingFontSize];
    [self.tiAboveLabel setTextAlignment:NSTextAlignmentLeft];
    self.tiBelowLabel.adjustsFontSizeToFitWidth = YES;
    [self.tiBelowLabel setFont:settingFontSize];
    [self.tiBelowLabel setTextAlignment:NSTextAlignmentLeft];
    self.sessionAboveLabel.adjustsFontSizeToFitWidth = YES;
    [self.sessionAboveLabel setFont:settingFontSize];
    [self.sessionAboveLabel setTextAlignment:NSTextAlignmentLeft];
    self.sessionBelowLabel.adjustsFontSizeToFitWidth = YES;
    [self.sessionBelowLabel setFont:settingFontSize];
    [self.sessionBelowLabel setTextAlignment:NSTextAlignmentLeft];
    
    self.timeSettingView.userInteractionEnabled = NO;
    self.typeSettingView.userInteractionEnabled = NO;
    self.colorSettingView.userInteractionEnabled = NO;
    self.tiSettingView.userInteractionEnabled = NO;
    self.sessionSettingView.userInteractionEnabled = NO;


    // Code View
    self.codeLabel.adjustsFontSizeToFitWidth = YES;
    [self.codeLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.codeLabel setText:@"--"];
    [self.codeLabel setTextAlignment:NSTextAlignmentLeft];
    
    self.codeNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.codeNameLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.codeNameLabel setTextAlignment:NSTextAlignmentLeft];
    
    // Btn
    [self.timeSettingBtn setTag:0];
    [self.timeSettingBtn addTarget:self action:@selector(onClick_SettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.typeSettingBtn setTag:1];
    [self.typeSettingBtn addTarget:self action:@selector(onClick_SettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorSettingBtn setTag:2];
    [self.colorSettingBtn addTarget:self action:@selector(onClick_SettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.tiSettingBtn addTarget:self action:@selector(onClick_SelectTi:) forControlEvents:UIControlEventTouchUpInside];
    [self.sessionSettingBtn addTarget:self action:@selector(onClick_SettingView:) forControlEvents:UIControlEventTouchUpInside];
    [self.sessionSettingBtn setTag:3];
    self.refreshButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.closeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

//    self.settingViewPerWidth_H.constant = (self.settingView01.frame.size.width - 30 * 2) / 5 ;
    
    [self updateUI];
}
-(void)updateColor:(ChartColorConfig*)chartColorConfig
{
    UIColor *settingLabelBGColor    = [UIColor clearColor];
    UIColor *settingAboveLabelColor = [ChartColorConfig color255WithString:@"41,171,226)"];
    UIColor *settingBelowLabelColor = [ChartColorConfig color255WithString:@"255,255,255)"];
    UIColor *btnUnselectColor       = [ChartColorConfig color255WithString:@"20,38,71)"];
    UIColor *searchCodeBGColor      = [ChartColorConfig color255WithString:@"35,85,121"];
    
    // Label
    self.openLabelTitle.textColor = chartColorConfig.ohlcTitle;
    self.openLabelTitle.backgroundColor = [UIColor clearColor];
    self.closeLabelTitle.textColor = chartColorConfig.ohlcTitle;
    self.closeLabelTitle.backgroundColor = [UIColor clearColor];
    self.highLabelTitle.textColor = chartColorConfig.ohlcTitle;
    self.highLabelTitle.backgroundColor = [UIColor clearColor];
    self.lowLabelTitle.textColor = chartColorConfig.ohlcTitle;
    self.lowLabelTitle.backgroundColor = [UIColor clearColor];
    self.openLabelVal.textColor = chartColorConfig.ohlcVal;
    self.openLabelVal.backgroundColor = [UIColor clearColor];
    self.closeLabelVal.textColor = chartColorConfig.ohlcVal;
    self.closeLabelVal.backgroundColor = [UIColor clearColor];
    self.highLabelVal.textColor = chartColorConfig.ohlcVal;
    self.highLabelVal.backgroundColor = [UIColor clearColor];
    self.lowLabelVal.textColor = chartColorConfig.ohlcVal;
    self.lowLabelVal.backgroundColor = [UIColor clearColor];
    self.dateLabel.textColor = chartColorConfig.dateColor;
    self.dateLabel.backgroundColor = [UIColor clearColor];
    
    [self.timeBelowLabel setBackgroundColor:settingLabelBGColor];
    [self.timeBelowLabel setTextColor:settingBelowLabelColor];
    [self.typeAboveLabel setBackgroundColor:settingLabelBGColor];
    [self.typeAboveLabel setTextColor:settingAboveLabelColor];
    [self.typeBelowLabel setBackgroundColor:settingLabelBGColor];
    [self.typeBelowLabel setTextColor:settingBelowLabelColor];
    [self.colorAboveLabel setBackgroundColor:settingLabelBGColor];
    [self.colorAboveLabel setTextColor:settingAboveLabelColor];
    [self.colorBelowLabel setBackgroundColor:settingLabelBGColor];
    [self.colorBelowLabel setTextColor:settingBelowLabelColor];
    [self.tiAboveLabel setBackgroundColor:settingLabelBGColor];
    [self.tiAboveLabel setTextColor:settingAboveLabelColor];
    [self.tiBelowLabel setBackgroundColor:settingLabelBGColor];
    [self.tiBelowLabel setTextColor:settingBelowLabelColor];
    [self.sessionAboveLabel setBackgroundColor:settingLabelBGColor];
    [self.sessionAboveLabel setTextColor:settingAboveLabelColor];
    [self.sessionBelowLabel setBackgroundColor:settingLabelBGColor];
    [self.sessionBelowLabel setTextColor:settingBelowLabelColor];
    
    [self.codeLabel setTextColor:settingBelowLabelColor];
    [self.codeLabel setBackgroundColor:settingLabelBGColor];
    [self.codeNameLabel setTextColor:settingBelowLabelColor];
    [self.codeNameLabel setBackgroundColor:settingLabelBGColor];
    [self.codeTextField setTextColor:settingBelowLabelColor];
    
    // View
    [self.timeSettingView setBackgroundColor:btnUnselectColor];
    [self.typeSettingView setBackgroundColor:btnUnselectColor];
    [self.colorSettingView setBackgroundColor:btnUnselectColor];
    [self.tiSettingView setBackgroundColor:btnUnselectColor];
    [self.sessionSettingView setBackgroundColor:btnUnselectColor];
    [self.refreshView setBackgroundColor:btnUnselectColor];
    [self.closeView setBackgroundColor:btnUnselectColor];
    [self.codeView setBackgroundColor:searchCodeBGColor];
    [self.searchView setBackgroundColor:searchCodeBGColor];
    [self.ohlcView setBackgroundColor:chartColorConfig.chartBackgroundColor];

    // Btn
    [self.refreshButton setBackgroundColor:btnUnselectColor];
    [self.closeButton   setBackgroundColor:btnUnselectColor];
    
}
-(void)updateUILanguage
{
    [self.codeNameLabel     setText:@"--"];
    [self.timeAboveLabel    setText:@"Time"];
    // [self.timeBelowLabel    setText:@"5 Min"];
    [self.typeAboveLabel    setText:@"Type"];
    // [self.typeBelowLabel    setText:@"CandleSticks"];
    [self.colorAboveLabel   setText:@"Color"];
    // [self.colorBelowLabel   setText:[CommonUtil instance].colorSelectionArray[0]];
    [self.sessionAboveLabel setText:@"Session"];
    [self.tiAboveLabel      setText:@"TIs"];
    [self.tiBelowLabel      setText:@"Options"];
    
    [self.dateLabel     setText:@""];
    [self.openLabelVal  setText:@""];
    [self.highLabelVal  setText:@""];
    [self.lowLabelVal   setText:@""];
    [self.closeLabelVal setText:@""];
    
    [self.searchBtn     setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchBtn02   setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.closeButton   setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
}

- (void)updateOHLCdate:(NSString *)date open:(NSString *)open high:(NSString *)high low:(NSString *)low close:(NSString *)close {
    [self.dateLabel setText:date];
    [self.openLabelVal setText:open];
    [self.highLabelVal setText:high];
    [self.lowLabelVal setText:low];
    [self.closeLabelVal setText:close];
}

/*
-(void)initSelectView
{
//    if (!dimView.hidden) {
//        dimView.hidden = YES;
//        [dimView removeFromSuperview];
//    }
    for (int i = 0; i < [selectBtnArray count]; i++) {
        UIButton* btn = [selectBtnArray objectAtIndex:i];
        [btn removeFromSuperview];
    }

    UIColor* txtColor           = RGBCOLOR(20,38,71);
    UIColor* selectedTxtColor   = RGBCOLOR(20,38,71);
    UIColor* selectedColor      = RGBCOLOR(255,255,255);
    UIColor* unSelectedColor    = RGBCOLOR(208,208,208);
    
    [selectView removeFromSuperview];
    [selectBtnArray removeAllObjects];
    [selectView setBackgroundColor:unSelectedColor];
    
    [selectView setAlpha:0.9];
    int iBtnWidth;
    int iBtnHeight;
    int iGap = 4;
//    int iLableHeight = 1;
    int iBtnCount;
    if (iSelectType == ChartSettingViewMinType) {
        iBtnCount = 8;
//        if (codeType == 2) {
//            if (isAHFT || isNextMonth)
//                iBtnCount = 5;
//        }
        iBtnWidth = 100;
        iBtnHeight = 30;
        CGRect tFrame = self.timeSettingBtn.frame;
        [selectView setFrame:CGRectMake(self.settingView01.frame.origin.x, tFrame.origin.y + tFrame.size.height-3, iBtnWidth, iBtnHeight * iBtnCount+10)];
        iBtnWidth -= iGap;
        for(int i = 0; i < iBtnCount; i++)
        {
            NSString* str = [[[CommonUtil instance] timeSelectionArray] objectAtIndex:i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:CGRectMake(iGap/2, 5+iBtnHeight * i, iBtnWidth, iBtnHeight)];
            [btn setTag:10+i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            [btn setTitleColor:txtColor forState:UIControlStateNormal];
            if (i == iChartMinType) {
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btn setBackgroundColor:selectedColor];
                [btn setTitleColor:selectedTxtColor forState:UIControlStateNormal];
//                [btn setTitle:[NSString stringWithFormat:@"    %@  ✔",[[CommonUtil instance] getMessage:str]] forState:UIControlStateNormal];
            }else
            {
                [btn setBackgroundColor:unSelectedColor];
                //[btn setTitle:[[CommonUtil instance] getMessage:str] forState:UIControlStateNormal];
            }
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick_SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];

            [selectView addSubview:btn];
            [selectBtnArray addObject:btn];
        }
    } else if (iSelectType == ChartSettingViewDisType) {
        iBtnCount = 4;
        iBtnWidth = 100;
        iBtnHeight = 30;
        
        CGRect tFrame = self.typeSettingView.frame;
        if (SCREENWIDTH > SCREENHEIGHT) {
            [selectView setFrame:CGRectMake(tFrame.origin.x, tFrame.origin.y + tFrame.size.height, iBtnWidth, (iBtnHeight) * iBtnCount+10)];
        } else {
            [selectView setFrame:CGRectMake(self.settingView02_V.frame.origin.x, self.view.frame.size.height-3, iBtnWidth, (iBtnHeight) * iBtnCount+10)];
        }
        
        iBtnWidth -= iGap;
        for(int i = 0; i < iBtnCount;i++)
        {
            NSString* str = [[[CommonUtil instance] typeSelectionArray] objectAtIndex:i];
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn setFrame:CGRectMake(iGap/2, 5+(iBtnHeight) * i, iBtnWidth, iBtnHeight)];
            [btn setTag:10+i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setTitleColor:txtColor forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
            if (i == iChartDisType) {
                [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btn setBackgroundColor:selectedColor];
                [btn setTitleColor:selectedTxtColor forState:UIControlStateNormal];
            }else
                [btn setBackgroundColor:unSelectedColor];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onClick_SelectButton:) forControlEvents:UIControlEventTouchUpInside];
            [btn.layer setMasksToBounds:YES];
            [btn.layer setCornerRadius:4.0];

            [selectView addSubview:btn];
            [selectBtnArray addObject:btn];
        }
    } else if (iSelectType == ChartSettingViewColorType) {
        
    }
    selectView.hidden = NO;
    [self.view addSubview:selectView];
}
*/
-(void)DoSearchCode
{
    NSString * codeText = self.codeTextField.text;
    if (codeText){
        [self.delegate searchCode:codeText];
    }
    [self setIsSearching:NO];
}
-(void)resetSettingView
{
    UIColor *btnUnselectColor = [ChartColorConfig color255WithString:@"20,38,71"];
    
    [self.timeSettingView       setBackgroundColor:btnUnselectColor];
    [self.typeSettingView       setBackgroundColor:btnUnselectColor];
    [self.colorSettingView      setBackgroundColor:btnUnselectColor];
    [self.tiSettingView         setBackgroundColor:btnUnselectColor];
    [self.sessionSettingView    setBackgroundColor:btnUnselectColor];
}

 
@end
