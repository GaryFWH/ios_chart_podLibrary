/*
 *  MacdClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "MacdClass.h"

void MacdClass::init()
{
	iMacd1 = 12;
	iMacd2 = 26;
	iDiff = 9;
}
NSInteger MacdClass::getMacd1()
{
	return iMacd1;
}
NSInteger MacdClass::getMacd2()
{
	return iMacd2;
}
NSInteger MacdClass::getDiff()
{
	return iDiff;
}
void MacdClass::setMacd1(int iMacd)
{
	this->iMacd1 = iMacd;
}
void MacdClass::setMacd2(int iMacd)
{
	this->iMacd2 = iMacd;
}
void MacdClass::setDiff(int diff)
{
	this->iDiff = diff;
}
void* MacdClass::calculate(void* pMapofAllVoid)
{
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	MapofAll* pMap = new MapofAll;
//	int size = pMapofAll->size();
	
	NSInteger lineSize = 0;
	MapofAll::iterator iter;
	for (iter = pMapofAll->begin(); iter != pMapofAll->end(); iter ++) {
		if (strcmp(iter->first.c_str(), "MainData") != 0) {
			continue;
		}
		MapofLine* pMapofLine = iter->second;
		MapofLine::iterator iterOfLine;
		lineSize = pMapofLine->size();
        if (lineSize <= 1) {
            return NULL;
        }
		float cList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		int i = 0;
//		int j = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			cList[i++] = oldData->close;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		float pMacd1List[lineSize];
		float pMacd2List[lineSize];
		float pDiffList[lineSize];
		float pTemp1[lineSize];
		float pTemp2[lineSize];
		for (int m = 0; m < lineSize; m ++) {
			pMacd1List[m] = -0.0001f;
			pMacd2List[m] = -0.0001f;
			pDiffList[m] = -0.0001f;
			pTemp1[m] = -0.0001f;
			pTemp2[m] = -0.0001f;
		}
		if (!CalcEMA(cList, pTemp1, lineSize, 0, iMacd1)) {
            dateList = nil;
            //[dateList release];
			return NULL;
		}
		if (!CalcEMA(cList, pTemp2, lineSize, 0, iMacd2)) {
            dateList = nil;
            //[dateList release];
			return NULL;
		}
		MapofLine* pMapofInsertMacd1 = new MapofLine();
		for (int iIndex = 1; iIndex < lineSize; iIndex++) {
			pMacd1List[iIndex] = pTemp1[iIndex] - pTemp2[iIndex];
			chartData *insertData = new chartData();
			insertData->open = pMacd1List[iIndex];
			insertData->close = pMacd1List[iIndex];
			insertData->high = pMacd1List[iIndex];
			insertData->low = pMacd1List[iIndex];
			insertData->volume = pMacd1List[iIndex];
			NSString* str = [dateList objectAtIndex:iIndex];
			string datakey([str UTF8String]);
			pMapofInsertMacd1->insert(pair<string, chartData*>(datakey,insertData));				
		}
		pMap->insert(pair<string,MapofLine*>("Macd1",pMapofInsertMacd1));
		
		NSInteger lStartPt = 1;
        NSInteger lEndPt = lineSize - 1;
        if (lStartPt <= lEndPt) {
            if (!CalcEMA(pMacd1List, pMacd2List, lineSize, lStartPt, iDiff)) { // 1 is the starting point
                dateList = nil;
               // [dateList release];
                return (void *)pMap;
            } // end if
        }
		
		MapofLine* pMapofInsertMacd2 = new MapofLine();
		for (int iIndex = 1; iIndex < lineSize; iIndex++) {
			pMacd1List[iIndex] = pTemp1[iIndex] - pTemp2[iIndex];
			chartData *insertData = new chartData();
			insertData->open = pMacd2List[iIndex];
			insertData->close = pMacd2List[iIndex];
			insertData->high = pMacd2List[iIndex];
			insertData->low = pMacd2List[iIndex];
			insertData->volume = pMacd2List[iIndex];
			NSString* str = [dateList objectAtIndex:iIndex];
			string datakey([str UTF8String]);
			pMapofInsertMacd2->insert(pair<string, chartData*>(datakey,insertData));				
		}
		pMap->insert(pair<string,MapofLine*>("Macd2",pMapofInsertMacd2));
        // calc DIFF
        lStartPt = 2;
        lEndPt = lineSize - 1;
		MapofLine* pMapofInsertDiff = new MapofLine();
        for (NSInteger iIndex = lStartPt; iIndex <= lEndPt; iIndex++) {
            pDiffList[iIndex] = pMacd1List[iIndex] - pMacd2List[iIndex];
			chartData *insertData = new chartData();
			insertData->open = 0.0f;
			insertData->close = pDiffList[iIndex];
			insertData->high = pDiffList[iIndex];
			insertData->low = pDiffList[iIndex];
			insertData->volume = pDiffList[iIndex];
			NSString* str = [dateList objectAtIndex:iIndex];
			string datakey([str UTF8String]);
			pMapofInsertDiff->insert(pair<string, chartData*>(datakey,insertData));
        } // end for
		pMap->insert(pair<string,MapofLine*>("Diff",pMapofInsertDiff));
		
		//[dateList release];
		
		MapofLine* pMapofInsertZero = new MapofLine();
		for (int iIndex = 0; iIndex < lineSize; iIndex++) {			
			chartData *insertData = new chartData();
			insertData->open = 0.0f;
			insertData->close = 0.0f;
			insertData->high = 0.0f;
			insertData->low = 0.0f;
			insertData->volume = 0.0f;
			NSString* str = [dateList objectAtIndex:iIndex];
			string datakey([str UTF8String]);
			pMapofInsertZero->insert(pair<string, chartData*>(datakey,insertData));				
		}
		pMap->insert(pair<string,MapofLine*>("Zero",pMapofInsertZero));
        [dateList removeAllObjects];
        dateList = nil;
	}
	return (void *)pMap;
}
bool MacdClass::CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay) {
	
	// check if enough day to calc EMA
	if (size <= 0)
		return false;
	
	// check valid start point
	if (lStartPt < 0)
		return false;
	
	// check if enough valid data
	if (size - lStartPt <= 0)
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
