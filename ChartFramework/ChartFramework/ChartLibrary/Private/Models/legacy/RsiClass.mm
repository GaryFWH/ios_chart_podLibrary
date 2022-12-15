/*
 *  RsiClass.cpp
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#import "RsiClass.h"

void RsiClass::init()
{
	day = 14;
	bShowSma = true;
	smaDay = 5;
}

void RsiClass::setDay(NSInteger tday) {
	day = tday;
}

NSInteger RsiClass::getDay() {
	return day;
}

void RsiClass::setSmaDay(NSInteger smaday) {
	smaDay = smaday;
}

NSInteger RsiClass::getSmaDay() {
	return smaDay;
}

void RsiClass::setShowSma(bool bShow) {
	bShowSma = bShow;
}

bool RsiClass::getShowSma() {
	return bShowSma;
}

void* RsiClass::calculate(void* pMapofAllVoid)
{
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	MapofAll* pMap = new MapofAll;
	NSInteger size = pMapofAll->size();
//    NSLog(@"RsiClass::calculate pMapofAll.size %ld", size);
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
		if (lineSize <= 0 || lineSize < day + 1)
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
            // NSLog(@"RsiClass cal: first %@", str);
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		
		

        float rsiList1[lineSize];
        float smaList1[lineSize];
		for (int i = 0; i < lineSize; i++) {
			rsiList1[i] = -0.0001f;
			smaList1[i] = -0.0001f;
		}

        NSInteger lRSIDataPos;
        float lLastClose = 0.0, lTodayClose = 0.0;
        float dPos = 0.0;
        float dNeg = 0.0;
        // calculdate the first data only, expected to enter the for loop once,
        // but if the denominator is equal to zero, loop again until find the first valid result for RSI
        NSInteger lStartPt = 0;
        NSInteger lEndPt = lineSize - day;

		NSInteger k = 0;
        for (k = lStartPt; k < lEndPt; k++) {
            if (cList[k] == -0.0001f) {
                return NULL;
            }
            lLastClose = cList[k];
			
            for (int j = 1; j <= day; j++) {
                if (cList[k + j] == -0.0001f) {
                    //[dateList release];
                    dateList = nil;
                    return NULL;
                }
                lTodayClose = cList[k + j];
                if (lTodayClose >= lLastClose)
                    dPos += lTodayClose - lLastClose;
                else
                    dNeg += lLastClose - lTodayClose;
                lLastClose = lTodayClose;
            } // end for
			
            if (dNeg != 0) // denominator cannot be zero
                break; // calculdate the first data only
        } // end for
        if (k >= lineSize - day) {
			// [dateList release];
             dateList = nil;
             return NULL;
        }
        lRSIDataPos = k + day;
		
        dPos /= (day);
        dNeg /= (day);
        rsiList1[lRSIDataPos] = 100 - (100 / (1 + (dPos / dNeg))); // since after the for loop,
        lStartPt = lRSIDataPos + 1;
        lEndPt = lineSize - 1;
        // calculate RSI from 2nd day
        for (lRSIDataPos = lStartPt; lRSIDataPos <= lEndPt; lRSIDataPos++) {
            // get the oldest days's value of last RSI range
            if (cList[lRSIDataPos] == -0.0001f) {
                //[dateList release];
                dateList = nil;
                return NULL;
            }
            lTodayClose = cList[lRSIDataPos];
			
            dPos *= (day - 1);
            dNeg *= (day - 1);
			
            // subtract the last range different
            if (lTodayClose >= lLastClose)
                dPos += lTodayClose - lLastClose;
            else
                dNeg += lLastClose - lTodayClose;
			
            dPos /= (double) day;
            dNeg /= (double) day;
			
            if (dPos != 0 && dNeg != 0)
                rsiList1[lRSIDataPos] = 100 - (100 / (1 + (dPos / dNeg)));
            else
                rsiList1[lRSIDataPos] = 0.0;
			
            lLastClose = lTodayClose;
        } // end for
		
        // calculate SMA
        if (bShowSma) {
            lStartPt = -1;
            for (int i = 0; i < lineSize; i++) {
                if (rsiList1[i] != -0.0001f) {
                    lStartPt = i;
                    break;
                }
            }
			
            if (lStartPt != -1) {
                if (!CalcSMA(rsiList1, smaList1, lineSize, lStartPt, smaDay)) {
                    // return false;
                } // end if
            }
        }
       		
		
		
		MapofLine* pMapofInsertRsi = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = rsiList1[i];
			insertData->close = rsiList1[i];
			insertData->high = rsiList1[i];
			insertData->low = rsiList1[i];
			insertData->volume = rsiList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertRsi->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMap->insert(pair<string,MapofLine*>("RSI",pMapofInsertRsi));
			
		
		if (bShowSma) {
			MapofLine* pMapofInsertSma = new MapofLine();
			for (i = lineSize - 1; i >= 0; i --) {
				chartData *insertData = new chartData();
				insertData->open = smaList1[i];
				insertData->close = smaList1[i];
				insertData->high = smaList1[i];
				insertData->low = smaList1[i];
				insertData->volume = smaList1[i];
				NSString* str = [dateList objectAtIndex:i];
				string datakey([str UTF8String]);
				pMapofInsertSma->insert(pair<string, chartData*>(datakey,insertData));
			}
			pMap->insert(pair<string,MapofLine*>("SMA",pMapofInsertSma));
			[dateList removeAllObjects];
		}
        //[dateList release];
        dateList = nil;
	}	
	return (void *)pMap;
}
bool RsiClass::CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay) {
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
