/*
 *  SarClass.cpp
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年7月21日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "SarClass.h"

void SarClass::init()
{
	minSpeed = 0.02f;
	maxSpeed = 0.2f;
}
void SarClass::setMaxSpeed(float maxspeed)
{
	maxSpeed = maxspeed;
}
float SarClass::getMaxSpeed()
{
	return maxSpeed;
}
void SarClass::setMinSpeed(float minspeed)
{
	minSpeed = minspeed;
}
float SarClass::getMinSpeed()
{
	return minSpeed;
}
void* SarClass::calculate(void* pMapofAllVoid)
{
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	NSInteger size = pMapofAll->size();
	if (size <= 0) {
		return NULL;
	}
	/*
	MapofAll::iterator iterofAll = pMapofAll->begin();
	while (iterofAll != pMapofAll->end()) {
		if (strcmp(iterofAll->first.c_str(), "MainData") == 0) {
			iterofAll++;
			continue;
		}
		MapofLine* pLineMap = iterofAll->second;
		MapofLine::iterator iterofLine = pLineMap->begin();
		while (iterofLine != pLineMap->end()) {
			free(iterofLine->second);
			pLineMap->erase(iterofLine++);
		}
		delete pLineMap;
		pLineMap = NULL;
		pMapofAll->erase(iterofAll++);
	}
	*/
	NSInteger lineSize = 0;
	MapofAll::iterator iter;
	for (iter = pMapofAll->begin(); iter != pMapofAll->end(); iter ++) {
		if (strcmp(iter->first.c_str(), "MainData") != 0) {
			continue;
		}
		MapofLine* pMapofLine = iter->second;
		MapofLine::iterator iterOfLine;
		lineSize = pMapofLine->size();
		float cList[lineSize];
		float hList[lineSize];
		float lList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		NSInteger i = 0;
		int iHigh = 0;
		int iLow = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			hList[iHigh++] = oldData->high;
			lList[iLow++] = oldData->low;
			cList[i++] = oldData->close;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
		//	dateList[j++] = iterOfLine->first;
		}
		NSInteger arrLen = lineSize;
		float stockData[arrLen][2];
        float sar[arrLen];
		
        for (int i = 0; i < arrLen; i++) {
            stockData[i][0] = hList[i];
            stockData[i][1] = lList[i];
			sar[i] = -0.0001f;
        }
        int HL = 0; // High price
		int LL = 1; // Low price
		
		if (arrLen < 2) {
            //[dateList release];
            dateList = nil;
			return NULL;
		}
		
		float dSarToday = 0.0f;
		float dSarYesterday = 0.0f;
		float dAf = minSpeed;
		float dEpToday = 0.0f;
		float dEpYesterday = 0.0f;
		
		int iOffset = 0;
		
		int iAspect = 0; // the sar of tend of change
		
		float* data4Today = stockData[iOffset];
		float* data4Yesterday = NULL;// stockData[iOffset - 1];
		float* data4DayBefYesterday = NULL;
		
		// Step 0: Ignore the first data with the same high price.
		
		while (iAspect == 0 && ++iOffset < arrLen - 2) {
			data4Yesterday = data4Today;
			data4Today = stockData[iOffset];
			
			if (data4Today[HL] - data4Yesterday[HL] > 0.0f) {
				iAspect = 1;
			} else if (data4Today[HL] - data4Yesterday[HL] < -0.0f) {
				iAspect = -1;
			} else {
				iAspect = 0;
			}
			
		}// end of while
		
		if (iOffset == arrLen - 2) {
            //[dateList release];
            dateList = nil;
			return NULL;
		}
		
		if (data4Yesterday == NULL) {
            //[dateList release];
            dateList = nil;
			return NULL;
        }
		// Step1: calculate the first the SAR with the first two data.
		double dMaxHigh = max(data4Today[HL], data4Yesterday[HL]);
		double dMinLow = min(data4Today[LL], data4Yesterday[LL]);
		if (iAspect > 0) // (go up)
		{
			// Step 1.1 choose the less one for dSarToday from Low price
			dSarYesterday = dSarToday = dMinLow;
			
			// step 1.2 choose the grater one for dPeToday from High price
			dEpYesterday = dEpToday = dMaxHigh;
		} else if (iAspect < 0) // (go down)
		{
			// Step 1.1 choose the less one for dSarToday from High price
			dSarYesterday = dSarToday = dMaxHigh;
			
			// step 1.2 choose the grater one for dPeToday from Low price
			dEpYesterday = dEpToday = dMinLow;
		} else {
			dSarYesterday = dSarToday = dMaxHigh;
			dEpYesterday = dEpToday = dMinLow;
			// return; //this case will be addrssed later.
		}
		
		// Step 1.3 put the Sar value into Array
		sar[iOffset] = dSarToday; // This is the first value for SAR
		
		// step2: computer the next sar basen on the first sar.
		
		while (++iOffset < arrLen) {
			data4DayBefYesterday = data4Yesterday;
			data4Yesterday = data4Today;
			data4Today = stockData[iOffset];
			
			// According to yesterday's data to calculate the Today's SAR
			dSarToday = dSarYesterday + dAf * (dEpYesterday - dSarYesterday);
			
			if (iAspect < 0) // (go down yesterday)
			{
				if (dSarToday < data4Today[HL]) // (go up today) (This is a turnpoint)
				{
					dAf = minSpeed;
					dSarToday = dEpYesterday;
					dEpToday = data4Today[HL];
					iAspect = -iAspect;
				} else {
					if (data4Yesterday == NULL || data4DayBefYesterday == NULL)
						return NULL;
					dSarToday = fmax(fmax(dSarToday, data4Yesterday[HL]), data4DayBefYesterday[HL]);// ,ZERO);
					dEpToday = fmin(dEpYesterday, data4Today[LL]);// ,ZERO);
					
					if (dEpToday != dEpYesterday)// ,ZERO))
					{
						// dAf += fMin;// fMin =0.02
						dAf += 0.02;
					}
					if (dAf > maxSpeed) {
						dAf = maxSpeed;
					}
					
				}
			} else // iAspect >=0 (Went up yesterday)
			{
				if (dSarToday > data4Today[LL]) // (goes down today) (This is a turnpoint)
				{
					dAf = minSpeed;
					dSarToday = dEpYesterday;
					dEpToday = data4Today[LL];
					iAspect = -iAspect;
				} else// //(goes up today)
				{
					dSarToday = fmin(fmin(dSarToday, data4Yesterday[LL]), data4DayBefYesterday[LL]);// ,ZERO);
					dEpToday = fmax(dEpYesterday, data4Today[HL]);// ,ZERO);
					
					if (dEpToday != dEpYesterday)// ,ZERO))
					{
						// dAf += fMin;// fMin =0.02
						dAf += 0.02;
					}
					if (dAf > maxSpeed) {
						dAf = maxSpeed;
					}
				}
			}// end of if(iAspect)
			
			sar[iOffset] = dSarToday;
			dSarYesterday = dSarToday;
			dEpYesterday = dEpToday;
		}// End of While
		
		// Adjust it according to my own understanding. Maybe it is wrong.
		int ZeroIndex = 0;
		while (sar[ZeroIndex] == 0.00f) {
			ZeroIndex++;
		}
		
		for (int i = 0; i < ZeroIndex; i++) {
			sar[i] = sar[ZeroIndex];
		}
		MapofLine* pMapofInsertSar = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = sar[i];
			insertData->close = sar[i];
			insertData->high = sar[i];
			insertData->low = sar[i];
			insertData->volume = sar[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertSar->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMapofAll->insert(pair<string,MapofLine*>("SAR",pMapofInsertSar));
		[dateList removeAllObjects];
		//[dateList release];
        dateList = nil;
	}
	
	return (void *)pMapofAll;	
}
