/*
 *  BbClass.cpp
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年7月22日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "BbClass.h"
#include "golbal.h"

void BbClass::init()
{
	bollDays = 20;
	noStdDev = 2.0f;
}
void BbClass::setBollDays(int day)
{
	bollDays = day;
}
int BbClass::getBollDays()
{
	return bollDays;
}
void BbClass::setnoStdDev(float noDev)
{
	noStdDev = noDev;
}
float BbClass::getnoStdDev()
{
	return noStdDev;
}
void* BbClass::calculate(void* pMapofAllVoid)
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
//		int j = 0;
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
		
		NSInteger lNoOfData = lineSize;
        if (lNoOfData < bollDays) {
            dateList = nil;
            //[dateList release];
            return NULL;
        }
        lNoOfData = fmin(lNoOfData, iHigh);
        lNoOfData = fmin(lNoOfData, iLow);
		
        float p_WeightedCl[lNoOfData];
        float dp_StdDev[lNoOfData];// Standard Deviation
        float middleDataList1[lNoOfData];
        float lowerDataList1[lNoOfData];
        float upperDataList1[lNoOfData];
        float pcbList1[lNoOfData];
        float pcbLandList1[lNoOfData];
		for (int k = 0; k < lNoOfData; k++) {
			p_WeightedCl[k] = -0.0001f;
			dp_StdDev[k] = -0.0001f;
			middleDataList1[k] = -0.0001f;
			lowerDataList1[k] = -0.0001f;
			upperDataList1[k] = -0.0001f;
			pcbList1[k] = -0.0001f;
			pcbLandList1[k] = -0.0001f;
		}
        NSInteger lStartPt = 0;
        NSInteger lEndPt = lNoOfData - 1;
        for (NSInteger i = lStartPt; i <= lEndPt; i++) {
            if (hList[i] == -0.0001f || cList[i] == -0.0001f || lList[i] == -0.0001f) {
                return NULL;
            }
			if (cList[i] > 1000) {
				long lClose = (long) (cList[i] * 10);
				long lHigh = (long) (hList[i] * 10);
				long lLow = (long) (lList[i] * 10);
				float fTemp = (float)(((lHigh + lLow + lClose * 2) / 4.0)) / 10.0;
				p_WeightedCl[i] = fTemp;
			}
			else {
				long lClose = (long) (cList[i] * 1000);
				long lHigh = (long) (hList[i] * 1000);
				long lLow = (long) (lList[i] * 1000);
				float fTemp = (float)(((lHigh + lLow + lClose * 2) / 4.0)) / 1000.0;
				p_WeightedCl[i] = fTemp;
			}
        }
		
        float dSumOfSquareOfWCl = 0.0f;
        float dSumOfWCl = 0.0f;
		
        lStartPt = bollDays - 1; // first StdDev
        for (int i = 0; i < bollDays; i++) {
            dSumOfSquareOfWCl += pow(p_WeightedCl[i], 2);
            dSumOfWCl += p_WeightedCl[i];
        }
        float lTemp =pow(((dSumOfSquareOfWCl * bollDays - pow(dSumOfWCl, 2)) / pow(bollDays, 2)), 0.5);
		
		dp_StdDev[lStartPt] = lTemp;
        lStartPt = bollDays; // second StdDev and so on
        lEndPt = lNoOfData - 1;
        for (NSInteger i = lStartPt; i <= lEndPt; i++) {
            dSumOfSquareOfWCl -= pow(p_WeightedCl[i - bollDays], 2);
            dSumOfSquareOfWCl += pow(p_WeightedCl[i], 2);
			
            dSumOfWCl -= p_WeightedCl[i - bollDays];
            dSumOfWCl += p_WeightedCl[i];
			
			float t1 = dSumOfSquareOfWCl * bollDays - pow(dSumOfWCl, 2);
			float t2 = pow(bollDays, 2);
			float t3 = t1 / t2;
			float t4 = pow(fabs(t3), 0.5);
		//	NSLog(@"t1:%f,t2:%f,t3:%f,t4:%f",t1,t2,t3,t4);
			
            dp_StdDev[i] = t4;
        }
        // finding Middle Band
        lStartPt = 0;
        if (!CalcSMA(p_WeightedCl, middleDataList1, lNoOfData, lStartPt, bollDays)) {
            dateList = nil;
            //[dateList release];
            return NULL;
        } // end if
        // finding UpperBand, LowerBand
        lStartPt = -1;
        for (int i = 0; i < lNoOfData; i++) {
            if (middleDataList1[i] != -0.0001f) {
                lStartPt = i;
                break;
            }
        }
        if (lStartPt != -1) {
            lEndPt = lNoOfData - 1;
            for (NSInteger i = lStartPt; i <= lEndPt; i++) {
                upperDataList1[i] = middleDataList1[i] + noStdDev * dp_StdDev[i];
                lowerDataList1[i] = middleDataList1[i] - noStdDev * dp_StdDev[i];
			//	NSLog(@"middle:%.3f dp_std:%.3f",middleDataList1[i],dp_StdDev[i]);
			//	NSLog(@"up:%.3f lower:%.3f middle:%.3f",upperDataList1[i],lowerDataList1[i],middleDataList1[i]);
            }// end for
        }// end if
        // finding %B, %Band
        float dDenominator = 0.0;
        lStartPt = -1;
        for (int i = 0; i < lNoOfData; i++) {
            if (middleDataList1[i] != -0.0001f) {
                lStartPt = i;
                break;
            }
        }
        if (lStartPt != -1) {
            lEndPt = lNoOfData - 1;
            for (NSInteger i = lStartPt; i <= lEndPt; i++) {
                if (cList[i] == -0.0001f) {
                    return NULL;
                }
				
                dDenominator = upperDataList1[i] - lowerDataList1[i];
                if (0 != dDenominator) {
                    pcbList1[i] = (cList[i] - lowerDataList1[i]) * 100 / dDenominator;
                } else {
                    pcbList1[i] = -0.0001f;
                }
				
                if (0 != middleDataList1[i] && 0 != dDenominator) {
                    pcbLandList1[i] = dDenominator * 100 / middleDataList1[i];
                } else {
                    pcbLandList1[i] = -0.0001f;
                }
				
            }// end for
        }// end if
       
		MapofLine* pMapofInsertLower = new MapofLine();
        for (i = lNoOfData - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = lowerDataList1[i];
			insertData->close = lowerDataList1[i];
			insertData->high = lowerDataList1[i];
			insertData->low = lowerDataList1[i];
			insertData->volume = lowerDataList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertLower->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMapofAll->insert(pair<string,MapofLine*>("Lower",pMapofInsertLower));
		
		MapofLine* pMapofInsertUpper = new MapofLine();
        for (i = lNoOfData - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = upperDataList1[i];
			insertData->close = upperDataList1[i];
			insertData->high = upperDataList1[i];
			insertData->low = upperDataList1[i];
			insertData->volume = upperDataList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertUpper->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMapofAll->insert(pair<string,MapofLine*>("Upper",pMapofInsertUpper));
		
		MapofLine* pMapofInsertMidder = new MapofLine();
        for (i = lNoOfData - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = middleDataList1[i];
			insertData->close = middleDataList1[i];
			insertData->high = middleDataList1[i];
			insertData->low = middleDataList1[i];
			insertData->volume = middleDataList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertMidder->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMapofAll->insert(pair<string,MapofLine*>("Middle",pMapofInsertMidder));
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}
	
	return (void *)pMapofAll;	
}
bool BbClass::CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay) {
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
//		NSLog(@"input:%.3f",inputlist[i]);
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