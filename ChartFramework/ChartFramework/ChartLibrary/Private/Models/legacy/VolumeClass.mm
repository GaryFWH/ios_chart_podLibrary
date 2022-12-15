/*
 *  VolumeClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "VolumeClass.h"

void VolumeClass::init()
{
	day = 14;
	bShowSma = true;
	sma = 5;
}
void VolumeClass::setDay(NSInteger day)
{
	this->day = day;
}
NSInteger VolumeClass::getDay()
{
	return day;
}
void VolumeClass::setbShowSma(bool bShow)
{
	this->bShowSma = bShow;
}
bool VolumeClass::getbShowSma()
{
	return bShowSma;
}
void VolumeClass::setSma(NSInteger sma)
{
	this->sma = sma;
}
NSInteger VolumeClass::getSma()
{
	return sma;
}
void* VolumeClass::calculate(void* pMapofAllVoid) {
	MapofAll* pMapofAll = (MapofAll *)pMapofAllVoid;
	MapofAll* pMap = new MapofAll;
	if (pMapofAll->size() <= 0) {
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
		MapofLine* pMapofInsert = new MapofLine();
        
        lineSize = pMapofLine->size();
		if (lineSize <= 0)
            return NULL;
        
        NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		NSInteger i = 0;
		
        float volList1[lineSize];
        float smaList1[lineSize];
		for (int i = 0; i < lineSize; i++) {
			volList1[i] = -0.0001f;
			smaList1[i] = -0.0001f;
		}
        int mPos = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* data = new chartData();
			chartData* oldData = iterOfLine->second;
			string date = iterOfLine->first;
			data->open = oldData->open;
			data->close = oldData->close;
			data->high = oldData->high;
			data->low = oldData->low;
			data->volume = oldData->volume;			
			pMapofInsert->insert(pair<string, chartData*>(date,data));
            NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
            volList1[mPos] = oldData->volume;
            mPos++;
		}
		pMap->insert(pair<string,MapofLine*>("VOL",pMapofInsert));
        
        int lStartPt = 0;
        if (bShowSma) {
            lStartPt = -1;
            for (int i = 0; i < lineSize; i++) {
                if (volList1[i] != -0.0001f) {
                    lStartPt = i;
                    break;
                }
            }
			
            if (lStartPt != -1) {
                if (!CalcSMA(volList1, smaList1, lineSize, lStartPt, sma)) {
                    // return false;
                } // end if
            }
        }
        
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
			pMap->insert(pair<string,MapofLine*>("VOLSMA",pMapofInsertSma));
			[dateList removeAllObjects];
		}
        dateList = nil;
	}
	return (void *)pMap;	
}
bool VolumeClass::CalcSMA(float* inputlist, float* outputlist, NSInteger size, NSInteger lStartPt, NSInteger iDay) {
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
