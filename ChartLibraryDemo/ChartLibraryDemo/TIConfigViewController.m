//
//  TIConfigViewController.m
//  ChartLibraryDemo
//
//  Created by william on 16/7/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "TIConfigViewController.h"


@interface TIConfigViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView * tiListTableView;
@property (weak, nonatomic) IBOutlet UIView * topView;
@property (weak, nonatomic) IBOutlet UILabel * tiTitleLabel;
@property (weak, nonatomic) IBOutlet UIView * tiMainView;
@property (weak, nonatomic) IBOutlet UIView * tiConfigView;
@property (weak, nonatomic) IBOutlet UIButton * resetButton;
@property (weak, nonatomic) IBOutlet UIButton * confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (assign, nonatomic) NSInteger selectedSection;
@property (assign, nonatomic) ChartMainTIEnum selectedMainTi;
@property (assign, nonatomic) ChartSubTIEnum selectedSubTi;
@property (strong, nonatomic) UIView *selectedBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *backLabel;
@property (weak, nonatomic) IBOutlet UILabel *argTitle01;
@property (weak, nonatomic) IBOutlet UILabel *argTitle02;
@property (weak, nonatomic) IBOutlet UILabel *argTitle03;
@property (weak, nonatomic) IBOutlet UILabel *argTitle04;
@property (weak, nonatomic) IBOutlet UITextField *argVal01;
@property (weak, nonatomic) IBOutlet UITextField *argVal02;
@property (weak, nonatomic) IBOutlet UITextField *argVal03;
@property (weak, nonatomic) IBOutlet UITextField *argVal04;
@property (weak, nonatomic) IBOutlet UISegmentedControl *argSegment01;
@property (weak, nonatomic) IBOutlet UIView *view_v01;
@property (weak, nonatomic) IBOutlet UIView *view_h01;
@property (weak, nonatomic) IBOutlet UISwitch *enabledSma;
@property (weak, nonatomic) IBOutlet UILabel *enabledSmaLbl;


@property (strong, nonatomic) NSArray *tiArray;
@property (strong, nonatomic) NSMutableDictionary *tiDict;
@property (strong, nonatomic) ChartTIConfig *latestTiConfig;

@end

@implementation TIConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateUI];
}

- (ChartTIConfig *)tiConfig {
    if (self.latestTiConfig) {
        //
    } else {
        self.latestTiConfig = [[ChartTIConfig alloc] initDefault];
    }
    
    return self.latestTiConfig;
}

- (instancetype)initWithTiConfig:(ChartTIConfig*)tiConfig {
    if (self = [self init]) {
        self = [[TIConfigViewController alloc] initWithNibName:@"TIConfigViewController" bundle:nil];

        self.latestTiConfig = tiConfig;
        [self initData];
    }
    return self;
}

#pragma mark Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section){
        case 0:
            return ChartMainTITotalCount;
        case 1:
            return ChartSubTITotalCount;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = self.selectedBackgroundView;
    cell.textLabel.text = @"";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumScaleFactor = 0.8;
    NSInteger section = indexPath.section;
    switch (section){
        case 0:
            cell.textLabel.text = [self nameForMainChartTI:(ChartMainTIEnum)indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [self nameForSubChartTI:(ChartSubTIEnum)indexPath.row];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.selectedSection = indexPath.section;
    switch (indexPath.section) {
        case 0:
            self.selectedMainTi = indexPath.row;
            [self updateUI];
            break;
        case 1:
            self.selectedSubTi = indexPath.row;
            [self updateUI];
            break;
        default:
            break;
    }
}

- (IBAction)textFieldValueChanged:(id)sender {
    NSString * selectedTi;
    NSString * value;

    if (self.selectedSection == 0) {
        selectedTi = [self nameForMainChartTI:self.selectedMainTi];
    } else if (self.selectedSection == 1){
        selectedTi = [self nameForSubChartTI:self.selectedSubTi];
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    for (NSString * tiKey in self.tiArray) {
        if ([selectedTi isEqualToString:tiKey]) {
            dict = [self.tiDict objectForKey:tiKey];
            break;
        }
    }
    
    NSString *key = @"";
    if (sender == self.argVal01) {
        key = @"argVal01.text";
        value = self.argVal01.text;
    } else if (sender == self.argVal02) {
        key = @"argVal02.text";
        value = self.argVal02.text;
    } else if (sender == self.argVal03) {
        key = @"argVal03.text";
        value = self.argVal03.text;
    } else if (sender == self.argVal04) {
        key = @"argVal04.text";
        value = self.argVal04.text;
    }
    [dict setValue:value forKey:key];
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    if (self.selectedSection == 1 &&
        (self.selectedSubTi == ChartSubTIEnumRSI || self.selectedSubTi == ChartSubTIEnumVOL || self.selectedSubTi == ChartSubTIEnumWill || self.selectedSubTi == ChartSubTIEnumDMI)) {
        NSMutableDictionary * dict = [self.tiDict objectForKey:[self nameForSubChartTI:self.selectedSubTi]];
        if (dict){
            [dict setValue:@(self.enabledSma.isOn) forKey:@"smaEnabled"];
        }
        
    }
}

- (IBAction)segmentValueChanged:(id)sender {
    NSInteger selectedIdx = self.argSegment01.selectedSegmentIndex;
    if (self.selectedSection == 1 && self.selectedSubTi == ChartSubTIEnumOBV) {
        NSMutableDictionary * dict = [self.tiDict objectForKey:@"OBV"];
        
        if (selectedIdx == 0) {
            [dict setValue:@"Weighted Closing Price" forKey:@"segment01.selectedSegmentIndex"];
        } else if (selectedIdx == 1) {
            [dict setValue:@"Closing Price" forKey:@"segment01.selectedSegmentIndex"];

        }
    }
    
}

- (IBAction)onBtn_ConfirmBtn:(id)sender {
    if (self.tiDict && self.tiDict.count > 0) {
        ChartTIConfig *newTiConfig = [self convertDictToTiConfig:self.tiDict];
        
        if (newTiConfig) {
            self.latestTiConfig = newTiConfig;
            [_delegate didClickConfirmBtn:self ChartTIConfig:newTiConfig];
        }
    }
}

- (IBAction)onBtn_ResetBtn:(id)sender {
    self.tiDict = [self convertTiConfigToDict:[[ChartTIConfig alloc] initDefault]];
    [self reloadConfigArg];
}

- (IBAction)onBtn_BackBtn:(id)sender {
    [self.delegate didClickBackBtn:self];
}

#pragma mark Private
- (void)initData {

    self.selectedSection = 0;
    self.selectedMainTi = ChartMainTINone;
 
    self.tiArray = [[NSArray alloc] initWithObjects: @"SMA",@"EMA",@"WMA",@"BB",@"SAR",@"DMI",@"MACD",@"OBV",@"ROC",@"RSI",@"STC-Fast",@"STC-Slow",@"VOL",@"WILL",nil];
    
    self.tiDict = [NSMutableDictionary dictionary];
    self.tiDict = [self convertTiConfigToDict:[self tiConfig]];
}

- (void)initView {
    self.view.layer.cornerRadius = 3.0;
    self.view.clipsToBounds = YES;
    
    self.selectedBackgroundView = [[UIView alloc] init];
    
    [self.tiListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    if (self.confirmButton) {
        [self.confirmButton addTarget:self action:@selector(onBtn_ConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.resetButton) {
        [self.resetButton addTarget:self action:@selector(onBtn_ResetBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.backButton) {
        [self.backButton addTarget:self action:@selector(onBtn_BackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.argVal01 addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.argVal02 addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.argVal03 addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.argVal04 addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

    
}

- (void)updateUI {
    switch (self.selectedSection) {
        case 0: {
            self.tiTitleLabel.text = [self nameForMainChartTI:self.selectedMainTi];
            break;
        }
        case 1: {
            self.tiTitleLabel.text = [self nameForSubChartTI:self.selectedSubTi];
            break;
        }
        default:
            break;
    }
    
    
    // Update UI
    [self updateConfigView];
    [self updateColor];
    
    // Update textfield
    [self reloadConfigArg];
}

- (void)updateConfigView {
    self.argTitle01.hidden = YES;
    self.argTitle02.hidden = YES;
    self.argTitle03.hidden = YES;
    self.argTitle04.hidden = YES;
    self.argVal01.hidden = YES;
    self.argVal02.hidden = YES;
    self.argVal03.hidden = YES;
    self.argVal04.hidden = YES;
    self.argSegment01.hidden = YES;
    self.enabledSma.hidden = YES;
    self.enabledSmaLbl.hidden = YES;
    
    self.enabledSmaLbl.text = @"SMA Enabled";
    
    switch (self.selectedSection) {
        case 0: {
            switch (self.selectedMainTi) {
                case ChartMainTIEnumSMA:
                case ChartMainTIEnumEMA:
                case ChartMainTIEnumWMA: {
                    self.argTitle01.text = @"1st MA line";
                    self.argTitle02.text = @"2nd MA line";
                    self.argTitle03.text = @"3rd MA line";
                    self.argTitle04.text = @"4th MA line";
                    
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argTitle03.hidden = NO;
                    self.argTitle04.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    self.argVal03.hidden = NO;
                    self.argVal04.hidden = NO;
            
                    break;
                }
                case ChartMainTIEnumBB: {
                    self.argTitle01.text = @"Intervals";
                    self.argTitle02.text = @"No. of Std. Dev";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    break;
                }
                case ChartMainTIEnumSAR: {
                    self.argTitle01.text = @"Acceleration Factor";
                    self.argTitle02.text = @"Max Acceleration Factor";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
        case 1: {
            switch (self.selectedSubTi) {
                case ChartSubTIEnumDMI: {
                    self.argTitle01.text = @"Intervals";
                    self.argTitle01.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.enabledSmaLbl.text = @"ADXR Enable";
                    self.enabledSma.hidden = NO;
                    self.enabledSmaLbl.hidden = NO;
                    break;
                }
                case ChartSubTIEnumMACD: {
                    self.argTitle01.text = @"MACD1";
                    self.argTitle02.text = @"MACD2";
                    self.argTitle03.text = @"Diff";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argTitle03.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    self.argVal03.hidden = NO;
                    break;
                }
                case ChartSubTIEnumOBV: {
                    //
                    [self.argSegment01 setTitle:@"Weighted Closing Price" forSegmentAtIndex:0];
                    [self.argSegment01 setTitle:@"Closing Price" forSegmentAtIndex:1];
                    self.argSegment01.hidden = NO;
                    break;
                }
                case ChartSubTIEnumROC: {
                    self.argTitle01.text = @"Intervals";
                    self.argTitle01.hidden = NO;
                    self.argVal01.hidden = NO;
                    break;
                }
                case ChartSubTIEnumRSI: {
                    self.argTitle01.text = @"Intervals";
                    self.argTitle02.text = @"SMA for RSI";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    self.enabledSma.hidden = NO;
                    self.enabledSmaLbl.hidden = NO;
                    break;
                }
                case ChartSubTIEnumSTCFast: {
                    self.argTitle01.text = @"%K";
                    self.argTitle02.text = @"%D";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    break;
                }
                case ChartSubTIEnumSTCSlow: {
                    self.argTitle01.text = @"%SK";
                    self.argTitle02.text = @"%SD";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    break;
                }
                case ChartSubTIEnumVOL: {
                    self.argTitle01.text = @"SMA for VOL";
                    self.argTitle01.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.enabledSma.hidden = NO;
                    self.enabledSmaLbl.hidden = NO;
                    break;
                }
                case ChartSubTIEnumWill: {
                    self.argTitle01.text = @"Intervals";
                    self.argTitle02.text = @"SMA for WILL %R";
                    self.argTitle01.hidden = NO;
                    self.argTitle02.hidden = NO;
                    self.argVal01.hidden = NO;
                    self.argVal02.hidden = NO;
                    self.enabledSma.hidden = NO;
                    self.enabledSmaLbl.hidden = NO;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }

}

- (void)updateColor {
    self.view.backgroundColor                   = [UIColor whiteColor];
    self.tiListTableView.backgroundColor        = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
    self.topView.backgroundColor                = [UIColor whiteColor];
    self.tiMainView.backgroundColor             = [UIColor whiteColor];
    self.tiConfigView.backgroundColor           = [UIColor whiteColor];
    self.view_h01.backgroundColor               = [UIColor blackColor];
    self.view_v01.backgroundColor               = [UIColor blackColor];
    
    self.backLabel.textColor    = [UIColor blackColor];
    self.tiTitleLabel.textColor = [UIColor blackColor];

    self.backButton.backgroundColor = [UIColor clearColor];
    self.backButton.titleLabel.textColor = [UIColor blackColor];
    
    self.argVal01.backgroundColor   = [UIColor whiteColor];
    self.argVal01.layer.borderWidth = 1.0;
    self.argVal01.layer.borderColor = [[ChartColorConfig color255WithRed:224 green:224 blue:224 alpha:1] CGColor];
    self.argVal01.textColor         = [UIColor blackColor];
    self.argVal02.backgroundColor   = [UIColor whiteColor];
    self.argVal02.layer.borderWidth = 1.0;
    self.argVal02.layer.borderColor = [[ChartColorConfig color255WithRed:224 green:224 blue:224 alpha:1] CGColor];
    self.argVal02.textColor         = [UIColor blackColor];
    self.argVal03.backgroundColor   = [UIColor whiteColor];
    self.argVal03.layer.borderWidth = 1.0;
    self.argVal03.layer.borderColor = [[ChartColorConfig color255WithRed:224 green:224 blue:224 alpha:1] CGColor];
    self.argVal03.textColor         = [UIColor blackColor];
    self.argVal04.backgroundColor   = [UIColor whiteColor];
    self.argVal04.layer.borderWidth = 1.0;
    self.argVal04.layer.borderColor = [[ChartColorConfig color255WithRed:224 green:224 blue:224 alpha:1] CGColor];
    self.argVal04.textColor         = [UIColor blackColor];
    
    [self.argSegment01 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [self.argSegment01 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
}

- (void)reloadConfigArg {
    NSString * selectedTi;
    
    if (self.selectedSection == 0) {
        selectedTi = [self nameForMainChartTI:self.selectedMainTi];
    } else if (self.selectedSection == 1){
        selectedTi = [self nameForSubChartTI:self.selectedSubTi];
    }
    
    NSMutableDictionary * dict = [self.tiDict objectForKey:selectedTi];
    
    if ([selectedTi isEqualToString:@"SMA"] || [selectedTi isEqualToString:@"EMA"] || [selectedTi isEqualToString:@"WMA"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
        self.argVal03.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal03.text"] integerValue]];
        self.argVal04.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal04.text"] integerValue]];
    } else if ([selectedTi isEqualToString:@"BB"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"argVal02.text"] floatValue]];

    } else if ([selectedTi isEqualToString:@"SAR"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%.3f", [[dict objectForKey:@"argVal02.text"] floatValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%.2f", [[dict objectForKey:@"argVal02.text"] floatValue]];
    } else if ([selectedTi isEqualToString:@"DMI"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.enabledSma.on = [[dict objectForKey:@"smaEnabled"] boolValue];
    } else if ([selectedTi isEqualToString:@"MACD"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
        self.argVal03.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal03.text"] integerValue]];
        
    } else if ([selectedTi isEqualToString:@"OBV"]) {
        NSInteger selectedSegmentIndex = 0;
        NSString *segmentVal = [dict objectForKey:@"segment01.selectedSegmentIndex"];
        
        if ([segmentVal isEqualToString:@"Weighted Closing Price"]) {
            selectedSegmentIndex = 0;
        } else if ([segmentVal isEqualToString:@"Closing Price"]) {
            selectedSegmentIndex = 1;
        }
        [self.argSegment01 setSelectedSegmentIndex:selectedSegmentIndex];
    } else if ([selectedTi isEqualToString:@"ROC"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
    } else if ([selectedTi isEqualToString:@"RSI"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
        self.enabledSma.on = [[dict objectForKey:@"smaEnabled"] boolValue];
    } else if ([selectedTi isEqualToString:@"STC-Fast"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
    } else if ([selectedTi isEqualToString:@"STC-Slow"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
    } else if ([selectedTi isEqualToString:@"VOL"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.enabledSma.on = [[dict objectForKey:@"smaEnabled"] boolValue];
    } else if ([selectedTi isEqualToString:@"WILL"]) {
        self.argVal01.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal01.text"] integerValue]];
        self.argVal02.text = [NSString stringWithFormat:@"%ld", [[dict objectForKey:@"argVal02.text"] integerValue]];
        self.enabledSma.on = [[dict objectForKey:@"smaEnabled"] boolValue];
    }
}

- (NSMutableDictionary*)convertTiConfigToDict:(ChartTIConfig*)tiConfig {
    NSMutableDictionary * tiDict = [NSMutableDictionary dictionary];
    
    for (NSString *tiKey in self.tiArray) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        if ([tiKey isEqualToString:@"SMA"]) {
            [dict setValue:tiConfig.tiSMADayList[0] forKey:@"argVal01.text"];
            [dict setValue:tiConfig.tiSMADayList[1] forKey:@"argVal02.text"];
            [dict setValue:tiConfig.tiSMADayList[2] forKey:@"argVal03.text"];
            [dict setValue:tiConfig.tiSMADayList[3] forKey:@"argVal04.text"];
        }
        else if ([tiKey isEqualToString:@"WMA"]) {
            [dict setValue:tiConfig.tiWMADayList[0] forKey:@"argVal01.text"];
            [dict setValue:tiConfig.tiWMADayList[1] forKey:@"argVal02.text"];
            [dict setValue:tiConfig.tiWMADayList[2] forKey:@"argVal03.text"];
            [dict setValue:tiConfig.tiWMADayList[3] forKey:@"argVal04.text"];
        }
        else if ([tiKey isEqualToString:@"EMA"]) {
            [dict setValue:tiConfig.tiEMADayList[0] forKey:@"argVal01.text"];
            [dict setValue:tiConfig.tiEMADayList[1] forKey:@"argVal02.text"];
            [dict setValue:tiConfig.tiEMADayList[2] forKey:@"argVal03.text"];
            [dict setValue:tiConfig.tiEMADayList[3] forKey:@"argVal04.text"];
        } else if ([tiKey isEqualToString:@"BB"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiBBIntervals]      forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithFloat:tiConfig.tiBBStdDev]           forKey:@"argVal02.text"];
        } else if ([tiKey isEqualToString:@"SAR"]) {
            [dict setValue:[NSNumber numberWithFloat:tiConfig.tiSARaccFactor]       forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithFloat:tiConfig.tiSARmaxAccFactor]    forKey:@"argVal02.text"];
        } else if ([tiKey isEqualToString:@"DMI"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiDMIInterval]      forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithBool:tiConfig.tiDMIADXRShow] forKey:@"smaEnabled"];
        } else if ([tiKey isEqualToString:@"MACD"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiMACDMACD1]        forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiMACDMACD2]        forKey:@"argVal02.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiMACDDiff]         forKey:@"argVal03.text"];
        } else if ([tiKey isEqualToString:@"OBV"]) {
            if (tiConfig.tiOBVisWeighted) {
                [dict setValue:@"Weighted Closing Price"    forKey:@"segment01.selectedSegmentIndex"];
            } else {
                [dict setValue:@"Closing Price"             forKey:@"segment01.selectedSegmentIndex"];
            }
        } else if ([tiKey isEqualToString:@"ROC"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiROCIntervals]     forKey:@"argVal01.text"];
        } else if ([tiKey isEqualToString:@"RSI"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiRSIIntervals]     forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiRSISMA]           forKey:@"argVal02.text"];
            [dict setValue:[NSNumber numberWithBool:tiConfig.tiRSISMAShow] forKey:@"smaEnabled"];
        } else if ([tiKey isEqualToString:@"STC-Fast"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiSTCFastK]         forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiSTCFastD]         forKey:@"argVal02.text"];
        } else if ([tiKey isEqualToString:@"STC-Slow"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiSTCSlowSK]        forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiSTCSlowSD]        forKey:@"argVal02.text"];
        } else if ([tiKey isEqualToString:@"VOL"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiVOLSMA]           forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithBool:tiConfig.tiVOLSMAShow] forKey:@"smaEnabled"];
        } else if ([tiKey isEqualToString:@"WILL"]) {
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiWillInterval]     forKey:@"argVal01.text"];
            [dict setValue:[NSNumber numberWithInteger:tiConfig.tiWillSma]          forKey:@"argVal02.text"];
            [dict setValue:[NSNumber numberWithBool:tiConfig.tiWillSmaShow] forKey:@"smaEnabled"];
        }
            
        [tiDict setValue:dict forKey:tiKey];
    }
    
    return tiDict;
}

- (ChartTIConfig*)convertDictToTiConfig:(NSMutableDictionary*)tiDict {
    if (!tiDict && tiDict.count == 0) {
        return nil;
    }
    
    ChartTIConfig *tiConfig = [[ChartTIConfig alloc] init];
    
    for (NSString *tiKey in self.tiArray) {
        NSMutableDictionary * dict = [tiDict objectForKey:tiKey];
        if ([tiKey isEqualToString:@"SMA"]) {
            NSArray *tiSMADayList = [[NSArray alloc] initWithObjects:
                                     [dict objectForKey:@"argVal01.text"],
                                     [dict objectForKey:@"argVal02.text"],
                                     [dict objectForKey:@"argVal03.text"],
                                     [dict objectForKey:@"argVal04.text"], nil];
            tiConfig.tiSMADayList = tiSMADayList;
        } else if ([tiKey isEqualToString:@"WMA"]) {
            NSArray *tiWMADayList = [[NSArray alloc] initWithObjects:
                                     [dict objectForKey:@"argVal01.text"],
                                     [dict objectForKey:@"argVal02.text"],
                                     [dict objectForKey:@"argVal03.text"],
                                     [dict objectForKey:@"argVal04.text"], nil];
            tiConfig.tiWMADayList = tiWMADayList;
        } else if ([tiKey isEqualToString:@"EMA"]) {
            NSArray *tiEMADayList = [[NSArray alloc] initWithObjects:
                                     [dict objectForKey:@"argVal01.text"],
                                     [dict objectForKey:@"argVal02.text"],
                                     [dict objectForKey:@"argVal03.text"],
                                     [dict objectForKey:@"argVal04.text"], nil];
            tiConfig.tiEMADayList = tiEMADayList;
        } else if ([tiKey isEqualToString:@"BB"]) {
            NSInteger tiBBIntervals = [[dict objectForKey:@"argVal01.text"] integerValue];
            CGFloat tiBBStdDev      = [[dict objectForKey:@"argVal02.text"] floatValue];
            
            tiConfig.tiBBIntervals = tiBBIntervals;
            tiConfig.tiBBStdDev = tiBBStdDev;
        } else if ([tiKey isEqualToString:@"SAR"]) {
            CGFloat tiSARaccFactor      = [[dict objectForKey:@"argVal01.text"] floatValue];
            CGFloat tiSARmaxAccFactor   = [[dict objectForKey:@"argVal02.text"] floatValue];

            tiConfig.tiSARaccFactor     = tiSARaccFactor;
            tiConfig.tiSARmaxAccFactor  = tiSARmaxAccFactor;
        } else if ([tiKey isEqualToString:@"DMI"]) {
            NSInteger tiDMIInterval = [[dict objectForKey:@"argVal01.text"] integerValue];

            tiConfig.tiDMIInterval = tiDMIInterval;
            tiConfig.tiDMIADXRShow = [[dict objectForKey:@"smaEnabled"] boolValue];
        } else if ([tiKey isEqualToString:@"MACD"]) {
            NSInteger tiMACDMACD1   = [[dict objectForKey:@"argVal01.text"] integerValue];
            NSInteger tiMACDMACD2   = [[dict objectForKey:@"argVal02.text"] integerValue];
            NSInteger tiMACDDiff    = [[dict objectForKey:@"argVal03.text"] integerValue];

            tiConfig.tiMACDMACD1    = tiMACDMACD1;
            tiConfig.tiMACDMACD2    = tiMACDMACD2;
            tiConfig.tiMACDDiff     = tiMACDDiff;
        } else if ([tiKey isEqualToString:@"OBV"]) {
            BOOL tiOBVisWeighted = YES;
            NSString *segmentVal = [dict objectForKey:@"segment01.selectedSegmentIndex"];
            if ([segmentVal isEqualToString:@"Weighted Closing Price"]) {
                tiOBVisWeighted = YES;
            } else if ([segmentVal isEqualToString:@"Closing Price"]) {
                tiOBVisWeighted = NO;
            }
            
            tiConfig.tiOBVisWeighted = tiOBVisWeighted;
        } else if ([tiKey isEqualToString:@"ROC"]) {
            NSInteger tiROCIntervals    = [[dict objectForKey:@"argVal01.text"] integerValue];

            tiConfig.tiROCIntervals     = tiROCIntervals;
        } else if ([tiKey isEqualToString:@"RSI"]) {
            NSInteger tiRSIIntervals    = [[dict objectForKey:@"argVal01.text"] integerValue];
            NSInteger tiRSISMA          = [[dict objectForKey:@"argVal02.text"] integerValue];

            tiConfig.tiRSIIntervals     = tiRSIIntervals;
            tiConfig.tiRSISMA = tiRSISMA;
            tiConfig.tiRSISMAShow = [[dict objectForKey:@"smaEnabled"] boolValue];
        } else if ([tiKey isEqualToString:@"STC-Fast"]) {
            NSInteger tiSTCFastK    = [[dict objectForKey:@"argVal01.text"] integerValue];
            NSInteger tiSTCFastD    = [[dict objectForKey:@"argVal02.text"] integerValue];
            
            tiConfig.tiSTCFastK = tiSTCFastK;
            tiConfig.tiSTCFastD = tiSTCFastD;
        } else if ([tiKey isEqualToString:@"STC-Slow"]) {
            NSInteger tiSTCSlowSK    = [[dict objectForKey:@"argVal01.text"] integerValue];
            NSInteger tiSTCSlowSD    = [[dict objectForKey:@"argVal02.text"] integerValue];
            
            tiConfig.tiSTCSlowSK = tiSTCSlowSK;
            tiConfig.tiSTCSlowSD = tiSTCSlowSD;
        } else if ([tiKey isEqualToString:@"VOL"]) {
            NSInteger tiVOLSMA    = [[dict objectForKey:@"argVal01.text"] integerValue];

            tiConfig.tiVOLSMA = tiVOLSMA;
            tiConfig.tiVOLSMAShow = [[dict objectForKey:@"smaEnabled"] boolValue];
        } else if ([tiKey isEqualToString:@"WILL"]) {
            NSInteger tiWillInterval    = [[dict objectForKey:@"argVal01.text"] integerValue];
            NSInteger tiWillSma         = [[dict objectForKey:@"argVal02.text"] integerValue];
            
            tiConfig.tiWillInterval = tiWillInterval;
            tiConfig.tiWillSma      = tiWillSma;
            tiConfig.tiWillSmaShow = [[dict objectForKey:@"smaEnabled"] boolValue];
        }
    }
    
    tiConfig.selectedMainTI = self.latestTiConfig.selectedMainTI;
    tiConfig.selectedSubTI = self.latestTiConfig.selectedSubTI;
    
    return tiConfig;
}

- (NSString *)nameForMainChartTI:(ChartMainTIEnum)tiEnum {
    switch(tiEnum){
        case ChartMainTINone:
            return @"None";
        case ChartMainTIEnumSMA:
            return @"SMA";
            break;
        case ChartMainTIEnumWMA:
            return @"WMA";
            break;
        case ChartMainTIEnumEMA:
            return @"EMA";
            break;
        case ChartMainTIEnumBB:
            return @"BB";
            break;
        case ChartMainTIEnumSAR:
            return @"SAR";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)nameForSubChartTI:(ChartSubTIEnum)tiEnum {
    switch (tiEnum){
        case ChartSubTIEnumDMI:
            return @"DMI";
            break;
        case ChartSubTIEnumMACD:
            return @"MACD";
            break;
        case ChartSubTIEnumOBV:
            return @"OBV";
            break;
        case ChartSubTIEnumROC:
            return @"ROC";
            break;
        case ChartSubTIEnumRSI:
            return @"RSI";
            break;
        case ChartSubTIEnumSTCFast:
            return @"STC-Fast";
            break;
        case ChartSubTIEnumSTCSlow:
            return @"STC-Slow";
            break;
        case ChartSubTIEnumVOL:
            return @"VOL";
            break;
        case ChartSubTIEnumWill:
            return @"WILL";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)getSelectedTI {
    NSString *rStr = @"";
    switch (self.selectedSection) {
        case 0:
            rStr = [self nameForMainChartTI:self.selectedMainTi];
            break;
        case 1:
            rStr = [self nameForSubChartTI:self.selectedSubTi];
            break;
        default:
            break;
    }
    return rStr;
}

@end
