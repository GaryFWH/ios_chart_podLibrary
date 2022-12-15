/*
 *  RocClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "RocClass.h"

void RocClass::init()
{
	iDayInterval = 10;
}
void RocClass::setDayInterval(int day)
{
	this->iDayInterval = day;
}
int RocClass::getDayInterval()
{
	return iDayInterval;
}
void* RocClass::calculate(void* pMapofAllVoid) {
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
		float cList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		NSInteger i = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			cList[i++] = oldData->close;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		
        if (lineSize <= 0) {
            //[dateList release];
            dateList = nil;
            return NULL;
        }
        if (lineSize <= iDayInterval) {
            //[dateList release];
            dateList = nil;
            return NULL;
        }
		MapofLine* pMapofInsertRoc = new MapofLine();
		MapofLine* pMapofInsertRVag = new MapofLine();
        for (i = lineSize - 1; i >= 0 ; i--) {
            float pDataToday = cList[i];
            float pDataLast = cList[i - iDayInterval];
            float pResult = pDataToday / pDataLast * 100 - 100;
			if (i <= iDayInterval - 1) {
				pResult = -0.0001f;
			}
			chartData *insertData = new chartData();
			insertData->open = pResult;
			insertData->close = pResult;
			insertData->high = pResult;
			insertData->low = pResult;
			insertData->volume = pResult;
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertRoc->insert(pair<string, chartData*>(datakey,insertData));
			
			chartData *insertZeroData = new chartData();
			if (i <= iDayInterval - 1)
			{
				insertZeroData->open = -0.0001f;
				insertZeroData->close = -0.0001f;
				insertZeroData->high = -0.0001f;
				insertZeroData->low = -0.0001f;
				insertZeroData->volume = -0.0001f;
			}
			else {
				insertZeroData->open = 0.0;
				insertZeroData->close = 0.0;
				insertZeroData->high = 0.0;
				insertZeroData->low = 0.0;
				insertZeroData->volume = 0.0;
			}

			
			pMapofInsertRVag->insert(pair<string, chartData*>(datakey,insertZeroData));
        }
		pMap->insert(pair<string,MapofLine*>("ROC",pMapofInsertRoc));
		pMap->insert(pair<string,MapofLine*>("RAvg",pMapofInsertRVag));
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}	
	return (void *)pMap;	
}