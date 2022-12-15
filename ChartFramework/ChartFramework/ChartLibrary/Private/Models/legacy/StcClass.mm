/*
 *  StcClass.cpp
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#import "StcClass.h"

void StcClass::init()
{
	iPC_K_Day = 18;
	iPC_D_Day = 5;
	iType = 0;// 0--slow,1--fast
	iPC_pK_Day = 18;
	iPC_pD_Day = 5;
}

NSInteger StcClass::getKDay() {
	return iPC_K_Day;
}

NSInteger StcClass::getDDay() {
	return iPC_D_Day;
}

NSInteger StcClass::getpKDay() {
	return iPC_pK_Day;
}

NSInteger StcClass::getpDDay() {
	return iPC_pD_Day;
}

NSInteger StcClass::getType() {
	return iType;
}

void StcClass::setKDay(NSInteger iDay) {
	iPC_K_Day = iDay;
}

void StcClass::setDDay(NSInteger iDay) {
	iPC_D_Day = iDay;
}

void StcClass::setpKDay(NSInteger iDay) {
	iPC_pK_Day = iDay;
}

void StcClass::setpDDay(NSInteger iDay) {
	iPC_pD_Day = iDay;
}

void StcClass::setType(NSInteger type) {
	iType = type;
}
bool StcClass::calculateSto(float* cList, float* hList, float* lList,
								   float* stclist, float* emalist, NSInteger iKDay, NSInteger iDDay,NSInteger size) {
	if (size <= 0)
		return false;
	float stclist1[size];
	float emalist1[size];
	for (int i = 0; i < size; i++) {
		stclist1[i] = -0.0001f;
		emalist1[i] = -0.0001f;
	}
	float dHighest = 0.0;
	float dLowest = 0.0;
	NSInteger lWMADataPos = iKDay - 1;
	int j = 0;
	for (int i = 0; i <= size - iKDay; i++) {
		for (j = 0; j < iKDay; j++) {
			if (cList[i + j] == -0.0001f)
				return false;
			// find the highest and lowest values
			if (j == 0) {
				dHighest = hList[i + j];
				dLowest = lList[i + j];
			} else {
				if (hList[i + j] > dHighest)
					dHighest = hList[i + j];
				if (dLowest > lList[i + j])
					dLowest = lList[i + j];
			}
		}
		// assign value to the array
		if (dHighest == dLowest || cList[i + j - 1] < dLowest)
			stclist1[lWMADataPos] = 0.0;
		else
			stclist1[lWMADataPos] = (float) (cList[i + j - 1] - dLowest) * 100 / (dHighest - dLowest);
		if (stclist1[lWMADataPos] > 100)
			stclist1[lWMADataPos] = 100.0;
		if (stclist1[lWMADataPos] < 0)
			stclist1[lWMADataPos] = 0.0;
		
		++lWMADataPos;
	}
	int lStartPt = -1;
	for (int i = 0; i < size; i++) {
		if (stclist1[i] != -0.0001f) {
			lStartPt = i;
			break;
		}
	}
	if (lStartPt != -1) {
		if (!CalcEMA(stclist1, emalist1, size, lStartPt, iDDay)) {
			return false;
		} // end if
	}
	for (int i = 0; i < size; i++) {
		stclist[i] = stclist1[i];
		emalist[i] = emalist1[i];
	}
	return true;
}
void* StcClass::calculate(void* pMapofAllVoid)
{
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	MapofAll* pMap = new MapofAll;
	NSInteger size = pMapofAll->size();
	if (size <= 0) {
		return NULL;
	}
	NSInteger lineSize = 0;
	MapofAll::iterator iter;
	for (iter = pMapofAll->begin(); iter != pMapofAll->end(); iter ++) {
		if (strcmp(iter->first.c_str(), "MainData") != 0) {
			continue;
		}
		MapofLine* pMapofLine = iter->second;
		MapofLine::iterator iterOfLine;
		lineSize = pMapofLine->size();
		if (lineSize <= 0)
            return NULL;
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
			//dateList[j++] = iterOfLine->first;
		}
		
		
        float srcemalist[lineSize];
        float srcemalist1[lineSize];
		float stclist[lineSize];
		float emalist[lineSize];
		for (i = 0; i < lineSize; i++) {
			srcemalist[i] = -0.0001f;
			srcemalist1[i] = -0.0001f;
			stclist[i] = -0.0001f;
			emalist[i] = -0.0001f;
		}
		if (iType == 1) {
            if(!calculateSto(cList, hList, lList, stclist, emalist, iPC_K_Day, iPC_D_Day,lineSize))
            {
               // [dateList release];
                dateList = nil;
                return NULL;
            }
        }
        else
        {
            if (calculateSto(cList, hList, lList, stclist, emalist, iPC_pK_Day, iPC_pD_Day,lineSize)) {
                // find the start pos
                int lStartPt = -1;
                for (int i = 0; i < lineSize; i++) {
                    if (emalist[i] != -0.0001f) {
                        lStartPt = i;
                        break;
                    }
                }// end for
                
                // calc m_pEMAData2
                if (lStartPt != -1) {
                    for (int i = 0; i < lineSize; i++) {
                        srcemalist[i] = emalist[i];
                    }
                    if (!CalcEMA(&srcemalist[0], &srcemalist1[0], lineSize, lStartPt, iPC_pD_Day)) {
                        //[dateList release];
                        dateList = nil;
                        return NULL;
                    } // end if
                } else {
                    //[dateList release];
                    dateList = nil;
                    return NULL;
                }
            } else {
                //[dateList release];
                dateList = nil;
                return NULL;
            }
        }

		
		
		
		MapofLine* pMapofInsertPK = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
            if (iType == 1) {
                insertData->open = stclist[i];
                insertData->close = stclist[i];
                insertData->high = stclist[i];
                insertData->low = stclist[i];
                insertData->volume = stclist[i];
            }
            else
            {
                insertData->open = emalist[i];
                insertData->close = emalist[i];
                insertData->high = emalist[i];
                insertData->low = emalist[i];
                insertData->volume = emalist[i];
            }
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertPK->insert(pair<string, chartData*>(datakey,insertData));
		}
        if (iType == 1) {
            pMap->insert(pair<string,MapofLine*>("%K",pMapofInsertPK));
        }
        else
            pMap->insert(pair<string,MapofLine*>("%SK",pMapofInsertPK));
		
		
		MapofLine* pMapofInsertPD = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
            if (iType == 1) {
                insertData->open = emalist[i];
                insertData->close = emalist[i];
                insertData->high = emalist[i];
                insertData->low = emalist[i];
                insertData->volume = emalist[i];
            }
			else
            {
                insertData->open = srcemalist1[i];
                insertData->close = srcemalist1[i];
                insertData->high = srcemalist1[i];
                insertData->low = srcemalist1[i];
                insertData->volume = srcemalist1[i];
            }
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertPD->insert(pair<string, chartData*>(datakey,insertData));
		}
        if (iType == 1) {
            pMap->insert(pair<string,MapofLine*>("%D",pMapofInsertPD));
        }
		else
            pMap->insert(pair<string,MapofLine*>("%SD",pMapofInsertPD));
		[dateList removeAllObjects];
		//[dateList release];
        dateList = nil;
	}	
	return (void *)pMap;
}
bool StcClass::CalcEMA(float* stclist1, float* emalist1, NSInteger size, NSInteger lStartPt, NSInteger iDDay) {
	
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