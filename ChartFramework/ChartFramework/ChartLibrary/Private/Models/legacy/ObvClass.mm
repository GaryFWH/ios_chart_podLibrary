/*
 *  ObvClass.cpp
 *  Test6
 *
 *  Created by Poey Sit on 11年3月25日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#include "ObvClass.h"

void ObvClass::init()
{
	bWc = true;
}
void ObvClass::setbWc(bool bc)
{
	this->bWc = bc;
}
bool ObvClass::getbWc()
{
	return bWc;
}
void* ObvClass::calculate(void* pMapofAllVoid) {
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
		float hList[lineSize];
		float lList[lineSize];
		float vList[lineSize];
		NSMutableArray* dateList = [[NSMutableArray alloc] init];
		//string dateList[lineSize];
		NSInteger i = 0;
		int j = 0;
		int iHigh = 0;
		int iLow = 0;
		int iVolume = 0;
		for (iterOfLine = pMapofLine->begin(); iterOfLine != pMapofLine->end(); iterOfLine ++) {
			chartData* oldData = iterOfLine->second;
			hList[iHigh++] = oldData->high;
			lList[iLow++] = oldData->low;
			cList[i++] = oldData->close;
			vList[iVolume++] = oldData->volume;
			NSString* str = [NSString stringWithFormat:@"%s",iterOfLine->first.c_str()];
			[dateList addObject:str];
			//dateList[j++] = iterOfLine->first;
		}
		
        if (lineSize <= 1) {
            //[dateList release];
            dateList = nil;
            return NULL;
        }
        float obvList1[lineSize];
		obvList1[0] = 0.0;
        NSInteger lStartPt = 1;
        NSInteger lEndPt = lineSize - 1;
        j = 1;
        
        float dTodayVol;
        float dPrevCls;
        float dTodayCls;
        float dDiff;
        for (i = lStartPt; i <= lEndPt; i++) {
            //if (cList[i] == NULL || hList[i] == NULL || lList[i] == NULL || vList[i] == NULL) {
//                return NULL;
//            }
//            if (cList[i - 1] == NULL || hList[i - 1] == NULL || lList[i - 1] == NULL
//				|| vList[i - 1] == NULL) {
//                return NULL;
//            }
            dTodayVol = vList[i];
            if (!bWc) {
                dPrevCls = cList[i - 1];
                dTodayCls = cList[i];
            } else {
                dPrevCls = hList[i - 1] * 10000 + lList[i - 1] * 10000 + cList[i - 1] * 10000 * 2;
                dTodayCls = hList[i] * 10000 + lList[i] * 10000 + cList[i] * 10000 * 2;
			}
			
            dDiff = dTodayCls - dPrevCls;
            
            if (dDiff > 0.0) {
                obvList1[j] = obvList1[j - 1] + dTodayVol;
            } else if (dDiff < 0.0) {
                obvList1[j] = obvList1[j - 1] - dTodayVol;
            } else { // equal zero
                obvList1[j] = obvList1[j - 1];
            }
            j++;
			
        } // end for
		MapofLine* pMapofInsertObv = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = obvList1[i];
			insertData->close = obvList1[i];
			insertData->high = obvList1[i];
			insertData->low = obvList1[i];
			insertData->volume = obvList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertObv->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMap->insert(pair<string,MapofLine*>("OBV",pMapofInsertObv));
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}	
	return (void *)pMap;	
}