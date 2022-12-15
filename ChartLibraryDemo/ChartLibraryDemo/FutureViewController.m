//
//  FutureViewController.m
//  ChartLibraryDemo
//
//  Created by william on 17/8/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import <ChartFramework/ChartFramework.h>
#import "FutureViewController.h"
//#import "MultiDataChartViewController.h"
#import "ChartEtnetDataSource.h"
//#import "FullChartConfig.h"
#import "OpenCloseModel.h"

#define SCREENHEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREENWIDTH ([UIScreen mainScreen].bounds.size.width)

#define FUTURE_LIST self.futureList
//#define FUTURE_LIST @[\
//@{@"name":@"恒生指數期貨",@"shortName":@"恒生指數期貨",@"T+1":@"HS1",@"code":@"HSI"},\
//@{@"name":@"小型恒生指數期貨",@"shortName":@"小型恒指期貨",@"T+1":@"MH1",@"code":@"MHI"},\
//@{@"name":@"恒生中國企業指數期貨",@"shortName":@"恒生國指期貨",@"T+1":@"HH1",@"code":@"HHI"},\
//@{@"name":@"小型恒生中國企業指數期貨",@"shortName":@"小型國指期貨",@"T+1":@"MC1",@"code":@"MCH"},\
//@{@"name":@"科技指數期貨",@"shortName":@"科技指數期貨",@"T+1":@"HT2",@"code":@"HTI"},\
//@{@"name":@"恒生波幅指數期貨",@"shortName":@"恒指波幅指數期貨",@"T+1":@"",@"code":@"VHS"},\
//@{@"name":@"中華中國120指數期貨",@"shortName":@"中華120指數期貨",@"T+1":@"",@"code":@"CHH"},\
//@{@"name":@"美元兌人民幣期貨",@"shortName":@"美元兌人民幣期貨",@"T+1":@"CU1",@"code":@"CUS"}]
//#define FUTURE_UNDERLYING_DICT @{@"A50":@"2823",@"AAC":@"2018",@"ABC":@"1288",@"ACC":@"914",@"AIA":@"1299",@"ALB":@"9988",@"ALC":@"2600",@"ALH":@"241",@"AMC":@"3188",@"BCL":@"3988",@"BCM":@"3328",@"BEA":@"23",@"BIU":@"9888",@"BLI":@"9626",@"BOC":@"2388",@"BUD":@"1876",@"BYD":@"1211",@"BYE":@"285",@"CCB":@"939",@"CCC":@"1800",@"CCE":@"1898",@"CDA":@"1359",@"CGN":@"1816",@"CHH":@"CEC",@"CHT":@"941",@"CHU":@"762",@"CIT":@"267",@"CKH":@"1",@"CLI":@"2628",@"CLP":@"2",@"CMB":@"3968",@"CNC":@"883",@"COG":@"2007",@"COL":@"688",@"CPC":@"386",@"CPD":@"386",@"CPI":@"2601",@"CSA":@"2822",@"CSE":@"1088",@"CTB":@"998",@"CTC":@"728",@"CTS":@"6030",@"EVG":@"3333",@"GAC":@"2238",@"GAH":@"175",@"GLX":@"27",@"GWM":@"2333",@"HAI":@"6837",@"HCF":@"2828",@"HDO":@"6862",@"HEH":@"6",@"HEX":@"388",@"HHI":@"CEI",@"HKA":@"3",@"HKB":@"5",@"HKE":@"3",@"HKG":@"3",@"HLA":@"12",@"HLD":@"12",@"HNP":@"902",@"HSB":@"11",@"HSI":@"HSI",@"HTI":@"TEH",@"ICB":@"1398",@"JDC":@"9618",@"JDH":@"6618",@"KDS":@"268",@"KSO":@"3888",@"KST":@"1024",@"LAU":@"2015",@"LNK":@"823",@"MBI":@"MBN",@"MCH":@"CEI",@"MET":@"3690",@"MHI":@"HSI",@"MIU":@"1810",@"MOI":@"MOG",@"MPI":@"MPR",@"MSB":@"1988",@"MTR":@"66",@"NCL":@"1336",@"NFU":@"9633",@"NTE":@"9999",@"NWD":@"17",@"PAI":@"2318",@"PEC":@"857",@"PEN":@"9868",@"PHT":@"1833",@"PIC":@"2328",@"SAN":@"1928",@"SHK":@"16",@"SMC":@"981",@"SNO":@"2382",@"SUB":@"1918",@"SUN":@"1918",@"SWA":@"19",@"TCH":@"700",@"TRF":@"2800",@"TRP":@"9961",@"TWR":@"788",@"VHS":@"VHS",@"WHL":@"4",@"WXB":@"2269",@"YZA":@"1171",@"YZC":@"1171",@"ZAO":@"6060",@"ZJM":@"2899"}

//#define FUTURE_DICT @"CLP:CLP.202109,2|CLP.202203,2|CLP.202112,2|CLP.202110,2|CLP.202108,2$HH1:HH1.202512,0|HH1.202412,0|HH1.202612,0|HH1.202112,0|HH1.202109,0|HH1.202108,0|HH1.202312,0|HH1.202203,0|HH1.202212,0$NCL:NCL.202110,2|NCL.202203,2|NCL.202112,2|NCL.202108,2|NCL.202109,2$CHT:CHT.202203,2|CHT.202109,2|CHT.202112,2|CHT.202108,2|CHT.202110,2$HLA:HLA.202109,2|HLA.202108,2|HLA.202203,2|HLA.202112,2|HLA.202110,2$CEU:CEU.202112,4|CEU.202110,4|CEU.202203,4|CEU.202109,4$MTR:MTR.202110,2|MTR.202108,2|MTR.202203,2|MTR.202109,2|MTR.202112,2$YZA:YZA.202108,2|YZA.202112,2|YZA.202203,2|YZA.202109,2|YZA.202110,2$CTS:CTS.202110,2|CTS.202203,2|CTS.202112,2|CTS.202109,2|CTS.202108,2$ZJM:ZJM.202203,2|ZJM.202108,2|ZJM.202112,2|ZJM.202109,2|ZJM.202110,2$CCE:CCE.202109,2|CCE.202203,2|CCE.202110,2|CCE.202112,2|CCE.202108,2$CLI:CLI.202109,2|CLI.202110,2|CLI.202108,2|CLI.202112,2|CLI.202203,2$HLD:HLD.202110,2|HLD.202109,2|HLD.202112,2|HLD.202203,2|HLD.202108,2$HSB:HSB.202203,2|HSB.202108,2|HSB.202109,2|HSB.202110,2|HSB.202112,2$MSG:MSG.202112,2|MSG.202206,2|MSG.202209,2|MSG.202108,2|MSG.202203,2|MSG.202109,2$HCF:HCF.202108,2|HCF.202110,2|HCF.202109,2|HCF.202203,2|HCF.202112,2$JDC:JDC.202203,2|JDC.202109,2|JDC.202108,2|JDC.202112,2|JDC.202110,2$SWA:SWA.202108,2|SWA.202109,2|SWA.202203,2|SWA.202110,2|SWA.202112,2$CMB:CMB.202110,2|CMB.202112,2|CMB.202109,2|CMB.202203,2|CMB.202108,2$HEH:HEH.202109,2|HEH.202108,2|HEH.202110,2|HEH.202203,2|HEH.202112,2$LIF:LIF.202108,2|LIF.202203,2|LIF.202110,2|LIF.202109,2|LIF.202112,2$HKB:HKB.202203,2|HKB.202110,2|HKB.202108,2|HKB.202109,2|HKB.202112,2$CJ1:CJ1.202109,4|CJ1.202110,4|CJ1.202203,4|CJ1.202112,4$GAH:GAH.202112,2|GAH.202109,2|GAH.202108,2|GAH.202110,2|GAH.202203,2$ACC:ACC.202112,2|ACC.202203,2|ACC.202108,2|ACC.202109,2|ACC.202110,2$KSO:KSO.202203,2|KSO.202108,2|KSO.202110,2|KSO.202109,2|KSO.202112,2$TCH:TCH.202110,2|TCH.202109,2|TCH.202112,2|TCH.202108,2|TCH.202203,2$MC3:MC3.202203,2|MC3.202209,2|MC3.202112,2|MC3.202108,2|MC3.202109,2|MC3.202206,2$HTI:HTI.202109,0|HTI.202108,0|HTI.202203,0|HTI.202112,0$CA1:CA1.202203,4|CA1.202110,4|CA1.202112,4|CA1.202109,4$CSA:CSA.202112,2|CSA.202110,2|CSA.202203,2|CSA.202109,2|CSA.202108,2$CUS:CUS.202111,4|CUS.202303,4|CUS.202206,4|CUS.202109,4|CUS.202306,4|CUS.202203,4|CUS.202112,4|CUS.202209,4|CUS.202110,4|CUS.202212,4$VHS:VHS.202109,2|VHS.202108,2|VHS.202110,2$BEA:BEA.202109,2|BEA.202203,2|BEA.202110,2|BEA.202112,2|BEA.202108,2$SHK:SHK.202203,2|SHK.202108,2|SHK.202112,2|SHK.202109,2|SHK.202110,2$MBI:MBI.202108,1|MBI.202203,1|MBI.202112,1|MBI.202109,1$YZC:YZC.202109,2|YZC.202110,2|YZC.202108,2|YZC.202203,2|YZC.202112,2$UCN:UCN.202109,4|UCN.202206,4|UCN.202209,4|UCN.202112,4|UCN.202110,4|UCN.202306,4|UCN.202212,4|UCN.202203,4|UCN.202111,4|UCN.202303,4$MPI:MPI.202108,1|MPI.202109,1|MPI.202203,1|MPI.202112,1$PIC:PIC.202203,2|PIC.202112,2|PIC.202110,2|PIC.202109,2|PIC.202108,2$GR1:GR1.202203,2|GR1.202112,2|GR1.202205,2|GR1.202208,2|GR1.202204,2|GR1.202202,2|GR1.202206,2|GR1.202109,2|GR1.202110,2|GR1.202207,2|GR1.202201,2|GR1.202111,2$M1G:M1G.202203,2|M1G.202109,2|M1G.202209,2|M1G.202108,2|M1G.202112,2|M1G.202206,2$GDU:GDU.202109,2|GDU.202201,2|GDU.202208,2|GDU.202205,2|GDU.202203,2|GDU.202110,2|GDU.202202,2|GDU.202207,2|GDU.202204,2|GDU.202206,2|GDU.202112,2|GDU.202111,2$CJP:CJP.202112,4|CJP.202109,4|CJP.202110,4|CJP.202203,4$CAU:CAU.202110,4|CAU.202203,4|CAU.202112,4|CAU.202109,4$SUB:SUB.202110,2|SUB.202109,2|SUB.202203,2|SUB.202108,2|SUB.202112,2$CPD:CPD.202203,2|CPD.202108,2|CPD.202109,2|CPD.202112,2|CPD.202110,2$ALB:ALB.202110,2|ALB.202108,2|ALB.202112,2|ALB.202203,2|ALB.202109,2$MOI:MOI.202108,1|MOI.202203,1|MOI.202112,1|MOI.202109,1$HT2:HT2.202112,0|HT2.202109,0|HT2.202203,0|HT2.202108,0$CNC:CNC.202110,2|CNC.202109,2|CNC.202203,2|CNC.202108,2|CNC.202112,2$HKE:HKE.202203,2|HKE.202108,2|HKE.202109,2|HKE.202112,2|HKE.202110,2$MCH:MCH.202108,0|MCH.202203,0|MCH.202112,0|MCH.202109,0$PHT:PHT.202109,2|PHT.202110,2|PHT.202112,2|PHT.202108,2|PHT.202203,2$TRP:TRP.202109,2|TRP.202110,2|TRP.202203,2|TRP.202112,2|TRP.202108,2$CU1:CU1.202109,4|CU1.202303,4|CU1.202206,4|CU1.202203,4|CU1.202209,4|CU1.202112,4|CU1.202212,4|CU1.202110,4|CU1.202306,4|CU1.202111,4$EM1:EM1.202206,3|EM1.202209,3|EM1.202203,3|EM1.202109,3|EM1.202110,3|EM1.202112,3$MHK:MHK.202203,1|MHK.202112,1|MHK.202209,1|MHK.202110,1|MHK.202206,1|MHK.202109,1$ALC:ALC.202109,2|ALC.202112,2|ALC.202110,2|ALC.202203,2|ALC.202108,2$NWD:NWD.202108,2|NWD.202110,2|NWD.202109,2|NWD.202112,2|NWD.202203,2$AMC:AMC.202112,2|AMC.202203,2|AMC.202109,2|AMC.202110,2|AMC.202108,2$COG:COG.202112,2|COG.202203,2|COG.202108,2|COG.202110,2|COG.202109,2$EA1:EA1.202110,3|EA1.202109,3|EA1.202203,3|EA1.202206,3|EA1.202209,3|EA1.202112,3$GWM:GWM.202203,2|GWM.202108,2|GWM.202110,2|GWM.202109,2|GWM.202112,2$CHU:CHU.202108,2|CHU.202203,2|CHU.202109,2|CHU.202110,2|CHU.202112,2$CDA:CDA.202108,2|CDA.202112,2|CDA.202110,2|CDA.202109,2|CDA.202203,2$MJP:MJP.202206,2|MJP.202110,2|MJP.202209,2|MJP.202109,2|MJP.202112,2|MJP.202203,2$HSI:HSI.202512,0|HSI.202312,0|HSI.202108,0|HSI.202412,0|HSI.202112,0|HSI.202212,0|HSI.202203,0|HSI.202109,0|HSI.202612,0$SMC:SMC.202108,2|SMC.202109,2|SMC.202112,2|SMC.202203,2|SMC.202110,2$CPC:CPC.202203,2|CPC.202110,2|CPC.202109,2|CPC.202108,2|CPC.202112,2$TRF:TRF.202112,2|TRF.202203,2|TRF.202108,2|TRF.202109,2|TRF.202110,2$ALH:ALH.202203,2|ALH.202112,2|ALH.202109,2|ALH.202108,2|ALH.202110,2$BCM:BCM.202112,2|BCM.202108,2|BCM.202110,2|BCM.202203,2|BCM.202109,2$PEN:PEN.202110,2|PEN.202112,2|PEN.202203,2|PEN.202109,2|PEN.202108,2$NFU:NFU.202109,2|NFU.202110,2|NFU.202112,2|NFU.202203,2|NFU.202108,2$CIT:CIT.202109,2|CIT.202110,2|CIT.202203,2|CIT.202108,2|CIT.202112,2$MC4:MC4.202212,4|MC4.202209,4|MC4.202203,4|MC4.202303,4|MC4.202306,4|MC4.202109,4|MC4.202206,4|MC4.202110,4|MC4.202111,4|MC4.202112,4$JDH:JDH.202112,2|JDH.202110,2|JDH.202109,2|JDH.202203,2|JDH.202108,2$CTC:CTC.202112,2|CTC.202110,2|CTC.202108,2|CTC.202203,2|CTC.202109,2$PEC:PEC.202203,2|PEC.202110,2|PEC.202112,2|PEC.202109,2|PEC.202108,2$M1P:M1P.202206,2|M1P.202112,2|M1P.202203,2|M1P.202209,2|M1P.202109,2|M1P.202110,2$UC1:UC1.202111,4|UC1.202110,4|UC1.202212,4|UC1.202306,4|UC1.202112,4|UC1.202206,4|UC1.202109,4|UC1.202203,4|UC1.202209,4|UC1.202303,4$BYE:BYE.202109,2|BYE.202112,2|BYE.202110,2|BYE.202108,2|BYE.202203,2$BCL:BCL.202108,2|BCL.202109,2|BCL.202110,2|BCL.202203,2|BCL.202112,2$EMN:EMN.202206,3|EMN.202112,3|EMN.202110,3|EMN.202109,3|EMN.202203,3|EMN.202209,3$HHI:HHI.202512,0|HHI.202212,0|HHI.202312,0|HHI.202109,0|HHI.202612,0|HHI.202203,0|HHI.202108,0|HHI.202112,0|HHI.202412,0$CCC:CCC.202109,2|CCC.202112,2|CCC.202108,2|CCC.202110,2|CCC.202203,2$AIA:AIA.202203,2|AIA.202109,2|AIA.202110,2|AIA.202108,2|AIA.202112,2$CKH:CKH.202110,2|CKH.202109,2|CKH.202203,2|CKH.202108,2|CKH.202112,2$HKG:HKG.202203,2|HKG.202110,2|HKG.202112,2|HKG.202108,2|HKG.202109,2$MCN:MCN.202109,3|MCN.202206,3|MCN.202209,3|MCN.202203,3|MCN.202110,3|MCN.202112,3$ABC:ABC.202109,2|ABC.202112,2|ABC.202203,2|ABC.202110,2|ABC.202108,2$M1W:M1W.202109,2|M1W.202108,2|M1W.202203,2|M1W.202209,2|M1W.202206,2|M1W.202112,2$WXB:WXB.202108,2|WXB.202109,2|WXB.202112,2|WXB.202203,2|WXB.202110,2$MHI:MHI.202109,0|MHI.202108,0|MHI.202112,0|MHI.202203,0$SNO:SNO.202109,2|SNO.202110,2|SNO.202108,2|SNO.202203,2|SNO.202112,2$TWR:TWR.202109,2|TWR.202108,2|TWR.202203,2|TWR.202110,2|TWR.202112,2$MIU:MIU.202110,2|MIU.202108,2|MIU.202203,2|MIU.202109,2|MIU.202112,2$CCB:CCB.202108,2|CCB.202112,2|CCB.202109,2|CCB.202110,2|CCB.202203,2$HS1:HS1.202109,0|HS1.202612,0|HS1.202512,0|HS1.202412,0|HS1.202312,0|HS1.202112,0|HS1.202203,0|HS1.202108,0|HS1.202212,0$EVG:EVG.202109,2|EVG.202108,2|EVG.202112,2|EVG.202203,2|EVG.202110,2$NTE:NTE.202112,2|NTE.202109,2|NTE.202203,2|NTE.202110,2|NTE.202108,2$M1C:M1C.202109,3|M1C.202112,3|M1C.202209,3|M1C.202110,3|M1C.202206,3|M1C.202203,3$LAU:LAU.202108,2|LAU.202109,2|LAU.202203,2|LAU.202110,2|LAU.202112,2$AAC:AAC.202109,2|AAC.202110,2|AAC.202203,2|AAC.202112,2|AAC.202108,2$MET:MET.202112,2|MET.202108,2|MET.202109,2|MET.202203,2|MET.202110,2$WHL:WHL.202110,2|WHL.202108,2|WHL.202203,2|WHL.202109,2|WHL.202112,2$BOC:BOC.202108,2|BOC.202109,2|BOC.202110,2|BOC.202112,2|BOC.202203,2$MTW:MTW.202108,2|MTW.202206,2|MTW.202112,2|MTW.202203,2|MTW.202109,2|MTW.202209,2$M1H:M1H.202203,1|M1H.202110,1|M1H.202206,1|M1H.202109,1|M1H.202112,1|M1H.202209,1$MCS:MCS.202206,4|MCS.202110,4|MCS.202209,4|MCS.202212,4|MCS.202112,4|MCS.202303,4|MCS.202111,4|MCS.202203,4|MCS.202306,4|MCS.202109,4$CHH:CHH.202112,1|CHH.202108,1|CHH.202203,1|CHH.202109,1$HDO:HDO.202108,2|HDO.202109,2|HDO.202112,2|HDO.202110,2|HDO.202203,2$HNP:HNP.202203,2|HNP.202108,2|HNP.202112,2|HNP.202109,2|HNP.202110,2$GLX:GLX.202203,2|GLX.202108,2|GLX.202109,2|GLX.202110,2|GLX.202112,2$A50:A50.202203,2|A50.202108,2|A50.202110,2|A50.202109,2|A50.202112,2$SAN:SAN.202108,2|SAN.202110,2|SAN.202203,2|SAN.202112,2|SAN.202109,2$MSB:MSB.202110,2|MSB.202112,2|MSB.202203,2|MSB.202108,2|MSB.202109,2$ZAO:ZAO.202112,2|ZAO.202109,2|ZAO.202108,2|ZAO.202110,2|ZAO.202203,2$MJ1:MJ1.202110,2|MJ1.202112,2|MJ1.202203,2|MJ1.202209,2|MJ1.202109,2|MJ1.202206,2$SUN:SUN.202112,2|SUN.202203,2|SUN.202108,2|SUN.202110,2|SUN.202109,2$PAI:PAI.202110,2|PAI.202108,2|PAI.202112,2|PAI.202203,2|PAI.202109,2$CPI:CPI.202108,2|CPI.202109,2|CPI.202112,2|CPI.202203,2|CPI.202110,2$BUD:BUD.202108,2|BUD.202203,2|BUD.202110,2|BUD.202109,2|BUD.202112,2$CGN:CGN.202109,2|CGN.202112,2|CGN.202108,2|CGN.202110,2|CGN.202203,2$HAI:HAI.202112,2|HAI.202110,2|HAI.202108,2|HAI.202109,2|HAI.202203,2$BYD:BYD.202109,2|BYD.202110,2|BYD.202108,2|BYD.202203,2|BYD.202112,2$GAC:GAC.202108,2|GAC.202109,2|GAC.202110,2|GAC.202112,2|GAC.202203,2$KST:KST.202203,2|KST.202109,2|KST.202110,2|KST.202112,2|KST.202108,2$COL:COL.202110,2|COL.202203,2|COL.202109,2|COL.202112,2|COL.202108,2$GU1:GU1.202204,2|GU1.202206,2|GU1.202205,2|GU1.202202,2|GU1.202208,2|GU1.202201,2|GU1.202111,2|GU1.202110,2|GU1.202203,2|GU1.202112,2|GU1.202109,2|GU1.202207,2$MJU:MJU.202112,2|MJU.202203,2|MJU.202110,2|MJU.202206,2|MJU.202109,2|MJU.202209,2$CSE:CSE.202112,2|CSE.202108,2|CSE.202110,2|CSE.202203,2|CSE.202109,2$BIU:BIU.202203,2|BIU.202109,2|BIU.202112,2|BIU.202110,2|BIU.202108,2$CE1:CE1.202203,4|CE1.202112,4|CE1.202110,4|CE1.202109,4$MCF:MCF.202108,2|MCF.202203,2|MCF.202109,2|MCF.202209,2|MCF.202112,2|MCF.202206,2$MC1:MC1.202203,0|MC1.202108,0|MC1.202112,0|MC1.202109,0$EAN:EAN.202109,3|EAN.202206,3|EAN.202112,3|EAN.202110,3|EAN.202203,3|EAN.202209,3$CTB:CTB.202110,2|CTB.202203,2|CTB.202109,2|CTB.202112,2|CTB.202108,2$ICB:ICB.202109,2|ICB.202110,2|ICB.202203,2|ICB.202112,2|ICB.202108,2$MEE:MEE.202109,3|MEE.202110,3|MEE.202112,3|MEE.202209,3|MEE.202203,3|MEE.202206,3$HKA:HKA.202108,2|HKA.202110,2|HKA.202112,2|HKA.202109,2|HKA.202203,2$LNK:LNK.202203,2|LNK.202108,2|LNK.202112,2|LNK.202109,2|LNK.202110,2$KDS:KDS.202110,2|KDS.202109,2|KDS.202108,2|KDS.202112,2|KDS.202203,2$HEX:HEX.202203,2|HEX.202110,2|HEX.202108,2|HEX.202109,2|HEX.202112,2$GDR:GDR.202203,2|GDR.202202,2|GDR.202204,2|GDR.202110,2|GDR.202208,2|GDR.202111,2|GDR.202205,2|GDR.202206,2|GDR.202109,2|GDR.202207,2|GDR.202112,2|GDR.202201,2$MH1:MH1.202109,0|MH1.202112,0|MH1.202203,0|MH1.202108,0$BLI:BLI.202112,2|BLI.202203,2|BLI.202110,2|BLI.202109,2|BLI.202108,2$M1E:M1E.202112,3|M1E.202203,3|M1E.202209,3|M1E.202109,3|M1E.202206,3|M1E.202110,3"

#define FUTURE_COMMONLIST @"http://202.62.215.188/content/trade/commonList.php?code=37,41"
#define FUTURE_JSON @"http://202.62.215.188/etnetApp/futures.json"

@interface FutureViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) MultiDataChartViewController * multiChartViewController;
@property (nonatomic, strong) NSString * futureCode;
@property (nonatomic, strong) NSString * underlyingCode;

@property (nonatomic, strong) UIView * viewContainer;
@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong ) NSArray * futureList;

@property (nonatomic, strong ) NSDictionary * futureDict;
@property (nonatomic, strong ) NSDictionary * futureUnderlyingDict;
@property (nonatomic, strong ) NSDictionary * futureOCModel;

@property (nonatomic, strong) UISwitch * nightSwitch;
@property (nonatomic, strong) UIPickerView * futurePicker;
@property (nonatomic, strong) UIButton * requestButton;

@end

@implementation FutureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.indexCode = @"HSI";
//    self.underlyingCode = @"HSI.202108";
    
//    self.futureCode = @"HS1.202108";
//    self.underlyingCode = @"HSIS.HSI";
//    self.underlyingCode = [self underlyingCode:self.futureCode];
    
    self.viewContainer = [[UIView alloc] init];
    [self.view addSubview:self.viewContainer];
    self.closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    
    self.nightSwitch = [[UISwitch alloc] init];
    [self.nightSwitch setOn:NO];
    [self.nightSwitch addTarget:self action:@selector(updatePicker) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.nightSwitch];
    
    self.futurePicker = [[UIPickerView alloc] init];
    self.futurePicker.dataSource = self;
    self.futurePicker.delegate = self;
    [self.view addSubview:self.futurePicker];
    
    self.requestButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.requestButton setTitle:@"Req" forState:UIControlStateNormal];
    [self.requestButton addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.requestButton];
    
    [self initFutureDict];
//    [self initFutureDictHC];
    
    self.futureList = [[NSArray alloc] init];
    
}

- (void)updatePicker{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.futurePicker reloadAllComponents];
    });
}

- (void)request {
    BOOL isNight = [self.nightSwitch isOn];
    NSInteger futureIndex = [self.futurePicker selectedRowInComponent:0];
    NSInteger monthIndex = [self.futurePicker selectedRowInComponent:1];
    
    NSString * futCode = [self futureCodeAtIndex:futureIndex isNight:isNight];
    NSString * month = [[[self.futureDict objectForKey:futCode] objectForKey:@"FUTURES_MONTHS_KEY"] objectAtIndex:monthIndex];
    
    self.futureCode = [NSString stringWithFormat:@"%@.%@", futCode, month];
    
    if (isNight){
        self.underlyingCode = [NSString stringWithFormat:@"HSIS.%@", [self underlyingCode:[self futureCodeAtIndex:futureIndex isNight:NO]]];
        [self requestNightData];
    } else {
        self.underlyingCode = [self underlyingCode:self.futureCode];
        [self requestData];
    }
}

//- (NSString *)ocTime:(NSString *)time {
//    if (!time){
//        return @"";
//    }
//    int timeInt = [time intValue];
//    if (timeInt > 2400){
//        timeInt -= 2400;
//        return [NSString stringWithFormat:@"%d", timeInt];
//    }
//    return [NSString stringWithFormat:@"%d", timeInt];
//}

- (OpenCloseModel *)openCloseByDict:(NSArray *)ocAry
{
//    OpenCloseModel * model = [[OpenCloseModel alloc] init];
    if (ocAry){
        NSString * mopen = @"";
        NSString * mclose = @"";
        NSString * cutoff = @"";
        NSString * aopen = @"";
        NSString * aclose = @"";
        BOOL overnight = NO;
        for (int i = 0; i < [ocAry count]; i++){
            NSDictionary * mt = [ocAry objectAtIndex:i];
            switch (i){
                case 0:
                {
                    NSString * open = [mt objectForKey:@"open"];
                    NSString * close = [mt objectForKey:@"close"];
                    NSString * cutOff = [mt objectForKey:@"cutOff"];
                    if (open){
                        int value = [open intValue];
                        if (value > 2400){
                            value -= 2400;
                            overnight = YES;
                        }
                        mopen = [NSString stringWithFormat:@"%d", value];
                    }
                    if (close){
                        int value = [close intValue];
                        if (value > 2400){
                            value -= 2400;
                            overnight = YES;
                        }
                        if ([ocAry count] == 1){
                            aclose = [NSString stringWithFormat:@"%d", value];
                        } else {
                            mclose = [NSString stringWithFormat:@"%d", value];
                        }
                    }
                    if (cutOff){
                        int value = [cutOff intValue];
                        if (value > 2400){
                            value -= 2400;
                            overnight = YES;
                        }
                        cutoff = [NSString stringWithFormat:@"%d", value];
                    }
                    break;
                }
                case 1:
                {
                    NSString * open = [mt objectForKey:@"open"];
                    NSString * close = [mt objectForKey:@"close"];
                    if (open){
                        int value = [open intValue];
                        if (value > 2400){
                            value -= 2400;
                            overnight = YES;
                        }
                        aopen = [NSString stringWithFormat:@"%d", value];
                    }
                    if (close){
                        int value = [close intValue];
                        if (value > 2400){
                            value -= 2400;
                            overnight = YES;
                        }
                        aclose = [NSString stringWithFormat:@"%d", value];
                    }
                    break;
                }
            }
        }
        if ([mclose length] > 0){
            
        }
        NSString * timeAry = [NSString stringWithFormat:@",,%@,%@,%@,%@,%@", mopen, mclose, cutoff, aopen, aclose];
        OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:timeAry];
        model.overnight = overnight;
        return model;
    }
    return nil;
}


- (void)initFutureOCModel:(NSArray *)futureList {
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    for (NSDictionary * dict in futureList){
        //Day Market
        NSString * code = [dict objectForKey:@"code"];
        NSArray * marketTime = [dict objectForKey:@"marketTime"];
        NSString * t1 = [dict objectForKey:@"T+1"];
        NSArray * t1MarketTime = [dict objectForKey:@"marketTimeAfterHour"];
        if (code && [code length] > 0){
            [mutDict setObject:[self openCloseByDict:marketTime] forKey:code];
        }
        if (t1 && [t1 length] > 0){
            [mutDict setObject:[self openCloseByDict:t1MarketTime] forKey:t1];
        }
    }
    self.futureOCModel = [NSDictionary dictionaryWithDictionary:mutDict];
}

- (void)initFutureDict {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:FUTURE_JSON] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data){
//            NSLog(@"FUTURE_JSON: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
            NSArray * futureJson = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.futureList = futureJson;
                [self.futurePicker reloadAllComponents];
                [self initFutureOCModel:futureJson];
            });
            
        }
        }] resume];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:FUTURE_COMMONLIST] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"FUTURE_COMMONLIST: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
        if (data){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * csvString = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
                NSArray * csvAry = [csvString componentsSeparatedByString:@"\n"];
                if ([csvAry count] > 3){
                    for (int i = 3; i < [csvAry count]; i++){
                        NSString * row = [csvAry objectAtIndex:i];
                        NSArray * column = [self separatedByString:@"," targetString:row expectString:@"\""];
                        if ([column count] == 2){
                            if ([[column firstObject] isEqualToString:@"37"]){
                                NSString * futureDict = [column objectAtIndex:1];
                                [self initFutureDictHC:futureDict];
                            }
                            if ([[column firstObject] isEqualToString:@"41"]){
                                NSString * underDict = [column objectAtIndex:1];
                                [self initFutureUnderlyingDict:underDict];
                            }
                        }
                    }
                }
                [self.futurePicker reloadAllComponents];
            });
        }
        }] resume];
}

- (NSArray *)separatedByString:(NSString *)separator targetString:(NSString *)targetString expectString:(NSString *)expector
{
    NSUInteger lastSeparatorPos = 0;
    NSUInteger lastExpectorPos = 0;
    NSString *tempString;
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i <= (int)([targetString length] - [separator length]);)
    {
        tempString = [targetString substringWithRange:NSMakeRange(i, [expector length])];
        if ([tempString isEqualToString:expector])
        {
            for (i += [expector length]; i <= (int)([targetString length] - [expector length]);) {
                if ([[targetString substringWithRange:NSMakeRange(i, [expector length])] isEqualToString:expector])
                {
                    if (i + 1 <= (int)([targetString length] - [expector length])) {
                        if ([[targetString substringWithRange:NSMakeRange(i + 1, [expector length])] isEqualToString:expector]) {
                            targetString = [targetString stringByReplacingCharactersInRange:NSMakeRange(i, 2) withString:expector];
                            i++;
                            continue;
                        }
                    }
                    tempString = [targetString substringWithRange:NSMakeRange(lastExpectorPos + [expector length], i - [expector length] - lastExpectorPos)];
                    i += [expector length];
                    lastExpectorPos = lastSeparatorPos = i;
                    [tempArray addObject:tempString];
                    i++;
                    break;
                }
                else
                {
                    i++;
                }
            }
        }
        else
        {
            if ([tempString isEqualToString:separator])
            {
                tempString = [targetString substringWithRange:NSMakeRange(lastSeparatorPos, i - lastSeparatorPos)];
                i += [separator length];
                lastSeparatorPos = lastExpectorPos = i;
                
                [tempArray addObject:tempString];
                
                if (i == [targetString length] )
                {
                    [tempArray addObject:@""];
                }
            }
            else
            {
                if (i == [targetString length] - 1)
                {
                    tempString = [targetString substringWithRange:NSMakeRange(lastSeparatorPos, i + [separator length] - lastSeparatorPos)];
                    [tempArray addObject:tempString];
                }
                i++;
            }
        }
    }
    
    return tempArray;
}

- (void)initFutureUnderlyingDict:(NSString *)underlyingDict {
    NSArray * list = [underlyingDict componentsSeparatedByString:@"$"];
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    for (NSString * str in list){
        NSArray * under = [str componentsSeparatedByString:@":"];
        if (under){
            NSString * value = [under objectAtIndex:0];
            NSString * key = [under objectAtIndex:1];
            for (NSString * k in [key componentsSeparatedByString:@"|"]){
                [mutDict setObject:value forKey:k];
            }
            
        }
    }
    self.futureUnderlyingDict = [NSDictionary dictionaryWithDictionary:mutDict];
}

- (void)initFutureDictHC:(NSString *)futureDict {
    NSArray * futureList = [futureDict componentsSeparatedByString:@"$"];
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
    for (NSString *str in futureList) {
        // Extract key and value from each key:value
        NSArray *futureCodeData = [str componentsSeparatedByString:@":"];
        if (futureCodeData) {
            NSString *key = [futureCodeData objectAtIndex:0];
            NSString *data = [futureCodeData objectAtIndex:1];
            if (key && data) {
                // Extract each data
                NSArray *resultData = [data componentsSeparatedByString:@"|"];
                if (resultData) {
                    NSMutableArray *arr = [NSMutableArray array];
                    
                    NSString *type = nil;
                    for (NSString *s in resultData) {
                        if (!type) {
                            // Extract date and type
                            NSArray *dataCodes = [s componentsSeparatedByString:@","];
                            if (dataCodes && dataCodes.count > 1) {
                                type = [dataCodes objectAtIndex:1];
                            }
                        }
                        
                        // Remove key from the date data
                        NSString *prefix = [key stringByAppendingString:@"."];
                        NSRange needleRange = NSMakeRange(prefix.length, s.length - prefix.length - @",".length - 1);
                        NSString *extractedString = [s substringWithRange:needleRange];
                        [arr addObject:extractedString];
                    }
                    
                    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self.intValue" ascending:YES];
                    NSArray *sortedArr = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]];
                    
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          sortedArr, @"FUTURES_MONTHS_KEY",
                                          type, @"FUTURES_DECIMALTYPE_KEY",
                                          nil];
                    
                    [mutDict setObject:dict forKey:key];
                }
            }
        }
    }
    self.futureDict = [NSDictionary dictionaryWithDictionary:mutDict];
}

- (NSString*)underlyingCode:(NSString*)code
{
    if ([code length] >= 3)
    {
        NSString *tCode = [code substringToIndex:3];
        
        if (self.futureUnderlyingDict){
            NSString * uCode = [self.futureUnderlyingDict objectForKey:tCode];
            
            return uCode;
        }
    }
    return nil;
}

- (NSString *)futureNameAtIndex:(NSInteger)index {
    if (FUTURE_LIST && [FUTURE_LIST count] > 0){
        NSDictionary * selectedDict = [FUTURE_LIST objectAtIndex:index];
        return [selectedDict objectForKey:@"shortName"];
    }
    return @"";
}

- (NSString *)futureCodeAtIndex:(NSInteger )index isNight:(BOOL)isNight{
    if (FUTURE_LIST && [FUTURE_LIST count] > 0){
        NSDictionary * selectedDict = [FUTURE_LIST objectAtIndex:index];
        if (isNight){
            return [selectedDict objectForKey:@"T+1"];
        } else {
            return [selectedDict objectForKey:@"code"];
        }
    }
    return @"";
}

- (NSInteger )decimalNumberForFutCode:(NSString *)code {
    if ([code length] >= 3)
    {
        NSString *tCode = [code substringToIndex:3];
        
        if (self.futureDict){
            if ([self.futureDict objectForKey:tCode]){
                return [[[self.futureDict objectForKey:tCode] objectForKey:@"FUTURES_DECIMALTYPE_KEY"] integerValue];
            }
        }
        
    }
    return 0;
}

- (NSString * )valueDisplayFormatForFutCode:(NSString *)code {
    NSString * format = @"0";
    NSInteger number = [self decimalNumberForFutCode:code];
    if (number >0){
        format = [format stringByAppendingString:@"."];
        for (NSInteger i = 0; i < number; i++){
            format = [format stringByAppendingString:@"0"];
        }
    }
    return format;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat top = 0;
    if (@available(iOS 11, *)){
        top = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.top;
    }
    
    CGFloat bottom = 0;
    if (@available(iOS 11, *)){
        bottom = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.bottom;
    }
    
    CGFloat left = 0;
    if (@available(iOS 11, *)){
        left = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.left;
    }
    
    CGFloat right = 0;
    if (@available(iOS 11, *)){
        right = [[UIApplication sharedApplication].windows firstObject].safeAreaInsets.right;
    }
    
    [self.viewContainer setFrame:CGRectMake(left, 50 + top, SCREENWIDTH - left - right, SCREENHEIGHT - 50 - top - bottom)];
    [self.closeButton setFrame:CGRectMake(SCREENWIDTH - 50 - left - right, top, 50, 50)];
    
    [self.requestButton setFrame:CGRectMake(CGRectGetMinX(self.closeButton.frame) - 50, CGRectGetMinY(self.closeButton.frame), 50, 50)];
    
    [self.nightSwitch setFrame:CGRectMake(left, top, 50, 50)];
    [self.futurePicker setFrame:CGRectMake(CGRectGetMaxX(self.nightSwitch.frame) + 2, CGRectGetMinY(self.nightSwitch.frame), CGRectGetMinX(self.requestButton.frame) - (CGRectGetMaxX(self.nightSwitch.frame) + 2) , 50)];
    
    [self.futurePicker reloadAllComponents];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
//    [self requestData];
//    [self requestNightData];
}


- (NSArray *) getXAxisListFromChartData:(NSArray<ChartData *> *)chartData {
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSMutableArray * array = [NSMutableArray array];
    
//    [formatter setDateFormat:@"HHmm"];
    
//    NSArray * hhmmList = @[@"1000", @"1100", @"1200", @"1400", @"1500", @"1600"];
    
    NSString * hh = @"";
    
    for (ChartData * data in chartData){
//        NSDate * date = data.date;
        NSString * groupKey = [data.groupingKey substringFromIndex:8];
        if ([hh isEqualToString:@""] && [[groupKey substringFromIndex:2] isEqualToString:@"00"]){
            [array addObject:data.groupingKey];
        }
        NSString * tempHH = [groupKey substringToIndex:2];
        if (![hh isEqualToString:@""] && ![tempHH isEqualToString:hh]){
            [array addObject:data.groupingKey];
        }
        hh = tempHH;
//        if ([hhmmList containsObject:groupKey]){
//            [array addObject:data.groupingKey];
//        }
    }
    return array;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)fillFuture:(NSMutableArray **)fList index:(NSMutableArray  **)iList {
    NSMutableArray * futureList = *fList;
    NSMutableArray * indexList = *iList;
    
    NSMutableArray * iDataList = futureList;
    NSMutableArray * jDataList = indexList;
    
    NSInteger i = 0;
    NSInteger j = 0;
    if ([iDataList count] == 0){
        return;
    }
    if ([jDataList count] == 0){
        return;
    }
    while (!(i >= [iDataList count] && j >= [jDataList count])){
//    while (i < [iDataList count] && j < [jDataList count]){
//        if (i >= [iDataList count] && j >= [jDataList count]){
//            break;
//        }
        ChartData * iData = [iDataList objectAtIndex:(i>=[iDataList count]?[iDataList count]-1:i)];
        ChartData * jData = [jDataList objectAtIndex:(j>=[jDataList count]?[jDataList count]-1:j)];
        if (i >= [iDataList count]){
            ChartData * cData = [[ChartData alloc] initSimpleDataWithGroupingKey:jData.groupingKey date:jData.date value:iData.close];
            [iDataList addObject:cData];
            i++;
            j++;
            continue;
        }
        if (j >= [jDataList count]){
            ChartData * cData = [[ChartData alloc] initSimpleDataWithGroupingKey:iData.groupingKey date:iData.date value:jData.close];
            [jDataList addObject:cData];
            i++;
            j++;
            continue;
        }
        if ([iData.groupingKey isEqualToString:jData.groupingKey]){
            i++;
            j++;
            continue;
        }
        if ([iData.groupingKey integerValue] > [jData.groupingKey integerValue]){
            j++;
            continue;
        } else {
            i++;
            continue;
        }
    }
    
}

- (void)requestNightData {
    [self.multiChartViewController.view removeFromSuperview];
    
    FullChartConfig * chartConfig = [[FullChartConfig alloc] initDefault];
    chartConfig.mainChartHeight = SCREENHEIGHT/2;
    chartConfig.tiChartHeight = self.viewContainer.frame.size.height - chartConfig.mainChartHeight - 50;
    chartConfig.mainChartLineType = ChartLineTypeLine;
    chartConfig.dateDisplayFormat = @"HH";
    chartConfig.selectDateFormat = @"HH:mm";
    chartConfig.mainChartValueDisplayFormat = [self valueDisplayFormatForFutCode:self.futureCode];
    chartConfig.subChartValueDisplayFormat = @"0.000";
    chartConfig.tiConfig.selectedSubTI = @[];
    
    ChartDataRequest * futRequest = [[ChartDataRequest alloc] initWithCode:self.futureCode interval:ChartDataInterval5Min dataType:ChartDataTypeToday codeType:ChartCodeTypeHKNightFuture];
    futRequest.limit = 400;
    
    self.multiChartViewController = [[MultiDataChartViewController alloc] initWithContainerView:self.viewContainer withConfig:chartConfig];
    
    [[ChartEtnetDataSource sharedInstance] requestTNominal:self.underlyingCode completion:^(NSString * _Nonnull value) {
        CGFloat prevClose = [value floatValue];
        [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:futRequest completion:^(NSArray<ChartData *> * _Nonnull futDataList) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                ChartData * firstData = [futDataList firstObject];
                
                ChartData * prevCloseData = [[ChartData alloc] initSimpleDataWithGroupingKey:firstData.groupingKey date:firstData.date value:prevClose];
                
                
                NSMutableArray * mutIndexList = [NSMutableArray arrayWithArray:@[prevCloseData]];
                NSMutableArray * mutFutureList = [NSMutableArray arrayWithArray:futDataList];
                
                [self fillFuture:&mutFutureList index:&mutIndexList];
                
                MultiDataChartList * indexList = [[MultiDataChartList alloc] init];
                indexList.name = self.underlyingCode;
                indexList.chartLineType = ChartLineTypeLine;
                indexList.dataList = mutIndexList;
                indexList.mainColor = [UIColor blueColor];
                
                MultiDataChartList * futureList = [[MultiDataChartList alloc] init];
                futureList.name = self.futureCode;
                futureList.chartLineType = ChartLineTypeLine;
                futureList.dataList = mutFutureList;
                futureList.mainColor = [UIColor redColor];
                
//                NSMutableArray * keyList = [NSMutableArray array];
//                for (ChartData * data in futDataList){
//
//                    [keyList addObject:data.groupingKey];
//                }
//                OpenCloseModel * model = [OpenCloseModel hkNightFutureMarketWithCode:self.futureCode];
                NSString * code = [NSString stringWithFormat:@"%@", self.futureCode];
                if ([code length] > 3){
                    code = [code substringToIndex:3];
                }
                OpenCloseModel * model = [self.futureOCModel objectForKey:code];
                
                NSDate * date = firstData.date;
                NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyyMMdd"];
                [dateFormat setTimeZone:model.timezone];
                NSString * dateStr = [dateFormat stringFromDate:date];
                
                NSArray * emptyKeyList = [model groupingKeyListForDate:dateStr forInterval:ChartDataInterval5Min];
                
                NSMutableArray<ChartData *> * emptyDataList = [NSMutableArray array];
                NSMutableArray * keyList = [NSMutableArray array];
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setTimeZone:model.timezone];
                [formatter setDateFormat:@"yyyyMMddHHmm"];
                for (NSString * key in emptyKeyList){
                    NSDate * date = [formatter dateFromString:key];
                    ChartData * data = [[ChartData alloc] initEmptyDataWithGroupingKey:key date:date];
                    [emptyDataList addObject:data];
                    
                    [keyList addObject:key];
                }
                MultiDataChartList * emptyList = [[MultiDataChartList alloc] init];
                emptyList.name = @"Empty";
                emptyList.dataList = emptyDataList;
                
                
//                [self.multiChartViewController initChartDataLists:@[emptyList, indexList, futureList] keyList:keyList];
                [self.multiChartViewController initChartDataLists:@[indexList, futureList] refList:emptyDataList];
                
                if (emptyDataList && [emptyDataList count]){
                    NSDate * fromDate = emptyDataList.firstObject.date;
                    NSDate * toDate = emptyDataList.lastObject.date;
                    [self.multiChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                }
                
                NSArray * axiskeyList = [self getXAxisListFromChartData:emptyDataList];
                [self.multiChartViewController setShowingXAxisKeyList:axiskeyList];
                
                [self.multiChartViewController updateMainChartHeight:SCREENHEIGHT/2];
            });
        }];
    }];
}

- (void)requestData {
    [self.multiChartViewController.view removeFromSuperview];
    
    FullChartConfig * chartConfig = [[FullChartConfig alloc] initDefault];
    chartConfig.mainChartHeight = SCREENHEIGHT/2;
    chartConfig.tiChartHeight = self.viewContainer.frame.size.height - chartConfig.mainChartHeight - 50;
    chartConfig.mainChartLineType = ChartLineTypeLine;
    chartConfig.dateDisplayFormat = @"HH";
    chartConfig.selectDateFormat = @"HH:mm";
    chartConfig.mainChartValueDisplayFormat = [self valueDisplayFormatForFutCode:self.futureCode];
    chartConfig.subChartValueDisplayFormat = @"0.000";
    chartConfig.tiConfig.selectedSubTI = @[];
    
    ChartDataRequest * futRequest = [[ChartDataRequest alloc] initWithCode:self.futureCode interval:ChartDataInterval5Min dataType:ChartDataTypeToday codeType:ChartCodeTypeHKFuture];
    futRequest.limit = 100;
    
    ChartDataRequest * indexRequest = [[ChartDataRequest alloc] initWithCode:self.underlyingCode interval:ChartDataInterval5Min dataType:ChartDataTypeToday codeType:ChartCodeTypeHKIndex];
    indexRequest.limit = 100;
    
    self.multiChartViewController = [[MultiDataChartViewController alloc] initWithContainerView:self.viewContainer withConfig:chartConfig];
    
    
    [[ChartEtnetDataSource sharedInstance] requestTNominal:[NSString stringWithFormat:@"HSIS.%@",self.underlyingCode] completion:^(NSString * _Nonnull value) {
        CGFloat prevClose = [value floatValue];
        if ([value isEqualToString:@""]){
            prevClose = kEmptyDataValue;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:indexRequest completion:^(NSArray<ChartData *> * _Nonnull indexDataList) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[ChartEtnetDataSource sharedInstance] requestChartDataForStockInfo:futRequest completion:^(NSArray<ChartData *> * _Nonnull futDataList) {
                        dispatch_async(dispatch_get_main_queue(), ^{
        //                    OpenCloseModel * model = [[OpenCloseModel alloc] initWithString:@"HSI,DEFAULT,915,1200,1230,1300,1630,"];
                            
                            
                            NSMutableArray * mutIndexList = [NSMutableArray arrayWithArray:indexDataList];
                            NSMutableArray * mutFutureList = [NSMutableArray arrayWithArray:futDataList];
                            
                            [self fillFuture:&mutFutureList index:&mutIndexList];
                            
                            MultiDataChartList * indexList = [[MultiDataChartList alloc] init];
                            indexList.name = self.underlyingCode;
                            indexList.chartLineType = ChartLineTypeLine;
                            indexList.dataList = mutIndexList;
                            indexList.prevData = prevClose;
                            indexList.mainColor = [UIColor blueColor];
                            
                            MultiDataChartList * futureList = [[MultiDataChartList alloc] init];
                            futureList.name = self.futureCode;
                            futureList.chartLineType = ChartLineTypeLine;
                            futureList.dataList = mutFutureList;
                            futureList.mainColor = [UIColor redColor];
                            
        //                    OpenCloseModel * model = [OpenCloseModel hkFutureMarketWithCode:self.futureCode];
                            NSString * code = [NSString stringWithFormat:@"%@", self.futureCode];
                            if ([code length] > 3){
                                code = [code substringToIndex:3];
                            }
                            OpenCloseModel * model = [self.futureOCModel objectForKey:code];
                            
                            ChartData * firstData = [futDataList firstObject];
                            if (!firstData){
                                firstData = [indexDataList firstObject];
                            }
                            NSDate * date = firstData.date;
                            NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
                            [dateFormat setDateFormat:@"yyyyMMdd"];
                            [dateFormat setTimeZone:model.timezone];
                            NSString * dateStr = [dateFormat stringFromDate:date];
                            
                            NSArray * emptyKeyList = [model groupingKeyListForDate:dateStr forInterval:ChartDataInterval5Min];
                            
                            NSMutableArray<ChartData *> * emptyDataList = [NSMutableArray array];
                            NSMutableArray * keyList = [NSMutableArray array];
                            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                            [formatter setTimeZone:model.timezone];
                            [formatter setDateFormat:@"yyyyMMddHHmm"];
                            for (NSString * key in emptyKeyList){
                                NSDate * date = [formatter dateFromString:key];
                                ChartData * data = [[ChartData alloc] initEmptyDataWithGroupingKey:key date:date];
                                [emptyDataList addObject:data];
                                
                                [keyList addObject:key];
                            }
                            MultiDataChartList * emptyList = [[MultiDataChartList alloc] init];
                            emptyList.name = @"Empty";
                            emptyList.dataList = emptyDataList;
        //                    [self.multiChartViewController initChartDataLists:@[emptyList, indexList, futureList] keyList:keyList];
                            [self.multiChartViewController initChartDataLists:@[indexList, futureList] refList:emptyDataList];
                            
                            if (emptyDataList && [emptyDataList count]){
                                NSDate * fromDate = emptyDataList.firstObject.date;
                                NSDate * toDate = emptyDataList.lastObject.date;
                                [self.multiChartViewController setShowingRangeFromDate:fromDate toDate:toDate];
                            }
                            
                            NSArray * axiskeyList = [self getXAxisListFromChartData:emptyDataList];
                            [self.multiChartViewController setShowingXAxisKeyList:axiskeyList];
                            
                            [self.multiChartViewController updateMainChartHeight:SCREENHEIGHT/2];
                        });
                    } fillEmpty:NO];
                });
            } fillEmpty:NO];
        });
    }];
    
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component){
        case 0:
        {
            return [FUTURE_LIST count];
        }
        case 1:
        {
            NSString * futureCode = [self futureCodeAtIndex:[pickerView selectedRowInComponent:0] isNight:[self.nightSwitch isOn]];
            NSDictionary * futureDict = [self.futureDict objectForKey:futureCode];
            if (futureDict){
                NSArray * keys = [futureDict objectForKey:@"FUTURES_MONTHS_KEY"];
                if (keys && [keys isKindOfClass:[NSArray class]]){
                    return [keys count];
                }
            }
            return 0;
        }
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component){
        case 0:
        {
            return [self futureNameAtIndex:row];
        }
        case 1:
        {
            NSString * futureCode = [self futureCodeAtIndex:[pickerView selectedRowInComponent:0] isNight:[self.nightSwitch isOn]];
            NSDictionary * futureDict = [self.futureDict objectForKey:futureCode];
            if (futureDict){
                NSArray * keys = [futureDict objectForKey:@"FUTURES_MONTHS_KEY"];
                if (keys && [keys isKindOfClass:[NSArray class]]){
                    return [keys objectAtIndex:row];
                }
            }
            return @"";
        }
        default:
            return @"";
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 25;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component){
        case 0:
        {
            return pickerView.frame.size.width - 100;
        }
        case 1:
        {
            return 100;
        }
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0){
        [pickerView reloadComponent:1];
    }
}

@end
