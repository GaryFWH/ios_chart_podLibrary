/*
 *  SmaClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "SmaClass.h"

void SmaClass::init()
{
	iDay1 = 10;
	iDay2 = 20;
	iDay3 = 30;
	iDay4 = 50;
	iDay5 = 250;
	type = 0;// 0--sma,1--ema,2--wma
	bSma1 = true;
	bSma2 = true;
	bSma3 = true;
	bSma4 = true;
	bSma5 = false;
}
void SmaClass::setDay1(NSInteger day)
{
	this->iDay1 = day;
}
void SmaClass::setDay2(NSInteger day)
{
	this->iDay2 = day;
}
void SmaClass::setDay3(NSInteger day)
{
	this->iDay3 = day;
}
void SmaClass::setDay4(NSInteger day)
{
	this->iDay4 = day;
}
void SmaClass::setDay5(NSInteger day)
{
	this->iDay5 = day;
}
NSInteger SmaClass::getDay1()
{
	return iDay1;
}
NSInteger SmaClass::getDay2()
{
	return iDay2;
}
NSInteger SmaClass::getDay3()
{
	return iDay3;
}
NSInteger SmaClass::getDay4()
{
	return iDay4;
}
NSInteger SmaClass::getDay5()
{
	return iDay5;
}
bool SmaClass::getSma1()
{
	return bSma1;
}
bool SmaClass::getSma2()
{
	return bSma2;
}
bool SmaClass::getSma3()
{
	return bSma3;
}
bool SmaClass::getSma4()
{
	return bSma4;
}
bool SmaClass::getSma5()
{
	return bSma5;
}
void SmaClass::setSma1(bool bSma)
{
	this->bSma1 = bSma;
}
void SmaClass::setSma2(bool bSma)
{
	this->bSma2 = bSma;
}
void SmaClass::setSma3(bool bSma)
{
	this->bSma3 = bSma;
}
void SmaClass::setSma4(bool bSma)
{
	this->bSma4 = bSma;
}
void SmaClass::setSma5(bool bSma)
{
	this->bSma5 = bSma;
}
void SmaClass::setType(NSInteger t)
{
    type = t;
}
//void* SmaClass::calculate(void* pMapofAllVoid) {
//	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
//	NSInteger size = pMapofAll->size();
//	if (size <= 0) {
//		return NULL;
//	}
//	/*
//	MapofAll::iterator iterofAll = pMapofAll->begin();
//	while (iterofAll != pMapofAll->end()) {
//		if (strcmp(iterofAll->first.c_str(), "MainData") == 0) {
//			iterofAll++;
//			continue;
//		}
//		MapofLine* pLineMap = iterofAll->second;
//		MapofLine::iterator iterofLine = pLineMap->begin();
//		while (iterofLine != pLineMap->end()) {
//			free(iterofLine->second);
//			pLineMap->erase(iterofLine++);
//		}
//		delete pLineMap;
//		pLineMap = NULL;
//		pMapofAll->erase(iterofAll++);
//	}
//	*/
//	NSInteger lineSize = 0;
//	MapofAll::iterator iter;
//	for (iter = pMapofAll->begin(); iter != pMapofAll->end(); iter ++) {
//		if (strcmp(iter->first.c_str(), "MainData") != 0) {
//			continue;
//		}
//		MapofLine* pMapofLine = iter->second;
//		MapofLine::iterator iterOfLine;
//		lineSize = pMapofLine->size();
//		float cList[lineSize];
//		NSMutableArray* dateList = [[NSMutableArray alloc] init];
//	//	string dateList[lineSize];
//		int i = 0;
//		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
//			chartData* oldData = iterOfLine->second;
//			cList[i++] = oldData->close;
//			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
//			[dateList addObject:str];
//		//	dateList[j++] = iterOfLine->first;
//		}
//		float pLine1[lineSize];
//		float pLine2[lineSize];
//		float pLine3[lineSize];
//		float pLine4[lineSize];
//		float pLine5[lineSize];
//		for (int m = 0; m < lineSize; m ++) {
//			pLine1[m] = -0.0001f;
//			pLine2[m] = -0.0001f;
//			pLine3[m] = -0.0001f;
//			pLine4[m] = -0.0001f;
//			pLine5[m] = -0.0001f;
//		}
//        if (type == 0) {
//            if (bSma1) {
//                if (CalcSMA(cList, pLine1, lineSize, 0, iDay1)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine1[k];
//                        insertData->close = pLine1[k];
//                        insertData->high = pLine1[k];
//                        insertData->low = pLine1[k];
//                        insertData->volume = pLine1[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("10-Sma",pMapofInsert));
//                }
//            }
//            if (bSma2) {
//                if (CalcSMA(cList, pLine2, lineSize, 0, iDay2)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine2[k];
//                        insertData->close = pLine2[k];
//                        insertData->high = pLine2[k];
//                        insertData->low = pLine2[k];
//                        insertData->volume = pLine2[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("20-Sma",pMapofInsert));
//                }
//            }
//            if (bSma3) {
//                if (CalcSMA(cList, pLine3, lineSize, 0, iDay3)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine3[k];
//                        insertData->close = pLine3[k];
//                        insertData->high = pLine3[k];
//                        insertData->low = pLine3[k];
//                        insertData->volume = pLine3[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("30-Sma",pMapofInsert));
//                }
//            }
//            if (bSma4) {
//                if (CalcSMA(cList, pLine4, lineSize, 0, iDay4)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine4[k];
//                        insertData->close = pLine4[k];
//                        insertData->high = pLine4[k];
//                        insertData->low = pLine4[k];
//                        insertData->volume = pLine4[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("50-Sma",pMapofInsert));
//                }
//            }
//            if (bSma5) {
//                if (CalcSMA(cList, pLine5, lineSize, 0, iDay5)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine5[k];
//                        insertData->close = pLine5[k];
//                        insertData->high = pLine5[k];
//                        insertData->low = pLine5[k];
//                        insertData->volume = pLine5[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("100-Sma",pMapofInsert));
//                }
//            }
//        }
//        else if(type == 1)
//        {
//            if (bSma1) {
//                if (CalcEMA(cList, pLine1, lineSize, 0, iDay1)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine1[k];
//                        insertData->close = pLine1[k];
//                        insertData->high = pLine1[k];
//                        insertData->low = pLine1[k];
//                        insertData->volume = pLine1[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("10-Ema",pMapofInsert));
//                }
//            }
//            if (bSma2) {
//                if (CalcEMA(cList, pLine2, lineSize, 0, iDay2)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine2[k];
//                        insertData->close = pLine2[k];
//                        insertData->high = pLine2[k];
//                        insertData->low = pLine2[k];
//                        insertData->volume = pLine2[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("20-Ema",pMapofInsert));
//                }
//            }
//            if (bSma3) {
//                if (CalcEMA(cList, pLine3, lineSize, 0, iDay3)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine3[k];
//                        insertData->close = pLine3[k];
//                        insertData->high = pLine3[k];
//                        insertData->low = pLine3[k];
//                        insertData->volume = pLine3[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("30-Ema",pMapofInsert));
//                }
//            }
//            if (bSma4) {
//                if (CalcEMA(cList, pLine4, lineSize, 0, iDay4)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine4[k];
//                        insertData->close = pLine4[k];
//                        insertData->high = pLine4[k];
//                        insertData->low = pLine4[k];
//                        insertData->volume = pLine4[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("50-Ema",pMapofInsert));
//                }
//            }
//            if (bSma5) {
//                if (CalcEMA(cList, pLine5, lineSize, 0, iDay5)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine5[k];
//                        insertData->close = pLine5[k];
//                        insertData->high = pLine5[k];
//                        insertData->low = pLine5[k];
//                        insertData->volume = pLine5[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("100-Ema",pMapofInsert));
//                }
//            }
//        }
//        else
//        {
//            if (bSma1) {
//                if (CalcWMA(cList, pLine1, lineSize, 0, iDay1)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine1[k];
//                        insertData->close = pLine1[k];
//                        insertData->high = pLine1[k];
//                        insertData->low = pLine1[k];
//                        insertData->volume = pLine1[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("10-Wma",pMapofInsert));
//                }
//            }
//            if (bSma2) {
//                if (CalcWMA(cList, pLine2, lineSize, 0, iDay2)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine2[k];
//                        insertData->close = pLine2[k];
//                        insertData->high = pLine2[k];
//                        insertData->low = pLine2[k];
//                        insertData->volume = pLine2[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("20-Wma",pMapofInsert));
//                }
//            }
//            if (bSma3) {
//                if (CalcWMA(cList, pLine3, lineSize, 0, iDay3)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine3[k];
//                        insertData->close = pLine3[k];
//                        insertData->high = pLine3[k];
//                        insertData->low = pLine3[k];
//                        insertData->volume = pLine3[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("30-Wma",pMapofInsert));
//                }
//            }
//            if (bSma4) {
//                if (CalcWMA(cList, pLine4, lineSize, 0, iDay4)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine4[k];
//                        insertData->close = pLine4[k];
//                        insertData->high = pLine4[k];
//                        insertData->low = pLine4[k];
//                        insertData->volume = pLine4[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("50-Wma",pMapofInsert));
//                }
//            }
//            if (bSma5) {
//                if (CalcWMA(cList, pLine5, lineSize, 0, iDay5)) {
//                    MapofLine* pMapofInsert = new MapofLine();
//                    for (int k = 0; k < lineSize; k ++) {
//                        chartData *insertData = new chartData();
//                        insertData->open = pLine5[k];
//                        insertData->close = pLine5[k];
//                        insertData->high = pLine5[k];
//                        insertData->low = pLine5[k];
//                        insertData->volume = pLine5[k];
//                        NSString* str = [dateList objectAtIndex:k];
//                        string datakey([str UTF8String]);
//                        pMapofInsert->insert(pair<string, chartData*>(datakey,insertData));
//                    }
//                    pMapofAll->insert(pair<string,MapofLine*>("100-Wma",pMapofInsert));
//                }
//            }
//        }
//		
//		[dateList removeAllObjects];
//		//[dateList release];
//        dateList = nil;
//	}
//	
//	return (void *)pMapofAll;	
//}
bool SmaClass::CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay) {
	// check if enough day to calc SMA
	if (size < iDay)
		return false;
	
	// check valid start point
	if (lStartPt < 0)
		return false;
	
	// check if enough valid data
	if (size - lStartPt < iDay)
		return false;
	float dTotal = 0.0;
	
	NSInteger lSMADataPos = lStartPt + iDay - 1;
	// calculate first day SMA
	for (NSInteger i = lStartPt; i < iDay + lStartPt; i++) {
		if (inputlist[i] == -0.0001f) {
			return false;
		} // end if
		// System.err.println("i="+i+"\tSma Close:"+inputlist[i]);
		dTotal += inputlist[i];
	} // end for
	outputlist[lSMADataPos] = (dTotal / iDay) / 1.0;
	
	++lSMADataPos;
	
	// calculate SMA from 2nd day
	NSInteger sDayDiff = iDay - 1;
	for (NSInteger i = lStartPt + 1; (size - 1 - i) >= sDayDiff; i++) {
		// get the oldest days's value of last MA range
		if (inputlist[i - 1] == -0.0001f) {
			return false;
		} // end if
		// subtract the oldest value
		dTotal -= inputlist[i - 1];
		
		// get the newest day's value of present MA range
		
		if (inputlist[i + sDayDiff] == -0.0001f) {
			return false;
		} // end if
		// add the newest value
		dTotal += inputlist[i + sDayDiff];
		
		outputlist[lSMADataPos] = (dTotal / iDay) / 1.0;
		++lSMADataPos;
	} // end for
	return true;
}
bool SmaClass::CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay) {
	
	// check if enough day to calc EMA
	if (size <= 0)
		return false;
	
	// check valid start point
	if (lStartPt < 0)
		return false;
	
	// check if enough valid data
	if (size - lStartPt <= 1)
		return false;
	
	// set invalid flag for the invalid data
	
	// start calculation
	float dTodayEMA = 0.0;
	float dSmoothingConst = (2.0 / (iDDay + 1)) / 1.0;
	
	// assign value to the array
	emalist1[lStartPt] = stclist1[lStartPt];
	
	// /////////////////////////////
	// TRACE("%ld,%.3lf\n",pTIOutDataArray[lStartPos].lDate,pTIOutDataArray[lStartPos].dTIValue);
	// /////////////////////////////
	
	float dPrevDayEMA = emalist1[lStartPt]; // prev. day EMA
	
	NSInteger i = 0;
	for (i = lStartPt + 1; i < size; i++) {
		// Calculate the EMA value
		dTodayEMA = (stclist1[i] - dPrevDayEMA) * dSmoothingConst + dPrevDayEMA;
		dPrevDayEMA = dTodayEMA;
		
		// assign value to the array
		emalist1[i] = dTodayEMA;
	} // end for
	
	return true;
}
bool SmaClass::CalcWMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDDay) {
    // check if enough day to calc WMA
    if (size < iDDay)
        return false;
    
    // check valid start point
    if (lStartPt < 0)
        return false;
    
    // check if enough valid data
    if (size - lStartPt < iDDay)
        return false;
    
    // calculate the dividend
    int lDividend = 0;
    for (int sCoeff = 1; sCoeff <= iDDay; sCoeff++) {
        lDividend += sCoeff;
    } // end for
    
    double dTotal = 0.0;
    NSInteger sDayDiff = iDDay - 1;
    int j;
    NSInteger i = 0;
    NSInteger lWMADataPos = lStartPt + iDDay - 1;
    
    NSInteger lEndPoint = size - sDayDiff - 1;
    // calculate the WMA
    for (i = lStartPt; i <= lEndPoint; i++) {
        dTotal = 0.0;
        for (j = 0; j < iDDay; j++) {
            if (inputlist[i + j] == -0.0001f) {
                return false;
            } // end if
            // add the new value
            dTotal += (j + 1) * (inputlist[i + j]);
        } // end for
        
        // assign value to the array
        outputlist[lWMADataPos] = (dTotal / lDividend) / 1.0;
        ++lWMADataPos;
    } // end for
    return true;
}
