/*
 *  DmiClass.cpp
 *  ETNetChart
 *
 *  Created by Poey Sit on 11年6月24日.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */
#include "golbal.h"
#import "DmiClass.h"

void DmiClass::init()
{
	bShowADXR = true;
	iDMIDay = 14;
}
void DmiClass::setShowADXR(bool bShow)
{
	bShowADXR = bShow;
}
bool DmiClass::getShowADXR()
{
	return bShowADXR;
}
void DmiClass::setDayInterval(int iDay)
{
	iDMIDay = iDay;
}
int  DmiClass::getDayInterval()
{
	return iDMIDay;
}
float DmiClass::FindMax(float value1, float value2) {
	if (value1 > value2)
		return value1;
	else
		return value2;
}
float DmiClass::FindMax(float value1, float value2, float value3) {
	if (value1 >= value2 && value1 >= value3) {
		return value1;
	} else if (value2 >= value3 && value2 >= value1) {
		return value2;
	} else {
		return value3;
	}
}
void* DmiClass::calculate(void* pMapofAllVoid)
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
		if (lineSize <= 0 || lineSize < iDMIDay)
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
		
		
        float pPosDI14List1[lineSize];
        float pNegDI14List1[lineSize];
        float pADXList1[lineSize];
        float pADXRList1[lineSize];
		
        float TR1[lineSize]; // max of (Today Hi - Today Low),(Today HI - Prev Cl),(Prev Cl - Today Low)
        float PosDM1[lineSize]; // max of (Today Hi - Prev Hi),(0)
        float NegDM1[lineSize]; // max of (Prev Low - Today Low),(0)
		
        float TR14[lineSize]; // sum of TR1 (last 14 days) // use 14 as example, i.e. m_sDMIDay=14
        float PosDM14[lineSize]; // sum of PosDM1 (last 14 days)
        float NegDM14[lineSize]; // sum of NegDM1 (last 14 days)
		
        float DIDiff[lineSize]; // absolute value of (PosDI14 - NegDI14)
        float DISum[lineSize]; // (PosDI14 + NegDI14)
        float DX[lineSize]; // DIDiff / DISum * 100
		
        for (int i = 0; i < lineSize; i++) {
            TR14[i] = -0.0001f;
            PosDM14[i] = -0.0001f;
            NegDM14[i] = -0.0001f;
            DIDiff[i] = -0.0001f;
            DISum[i] = -0.0001f;
            DX[i] = -0.0001f;
			pPosDI14List1[i] = -0.0001f;
			pNegDI14List1[i] = -0.0001f;
			pADXList1[i] = -0.0001f;
			pADXRList1[i] = -0.0001f;
        }
		
        for (int i = 1; i < lineSize; i++) {
            TR1[i] = FindMax((hList[i] - lList[i]), (hList[i] - cList[i - 1]),
                             (cList[i - 1] - lList[i]));
			
            PosDM1[i] = FindMax((hList[i] - hList[i - 1]), 0);
            NegDM1[i] = FindMax((lList[i - 1] - lList[i]), 0);
        }
        for (int i = iDMIDay; i < lineSize; i++) {
            // for TR14, +DM14, -DM14
            // summation of last m_sDMIDay days (default 14 days)
            TR14[i] = TR1[i];
            PosDM14[i] = PosDM1[i];
            NegDM14[i] = NegDM1[i];
            for (int j = 1; j < iDMIDay; j++) {
                TR14[i] += TR1[i - j];
                PosDM14[i] += PosDM1[i - j];
                NegDM14[i] += NegDM1[i - j];
            }// end for
            // for +DI14, -DI14
            if (TR14[i] == -0.0001f || TR14[i] == 0.0) { // handle the denominator equal to zero, special case
                if (pPosDI14List1[i - 1] != -0.0001f && pNegDI14List1[i - 1] != -0.0001f) {
                    pPosDI14List1[i] = pPosDI14List1[i - 1];
                    pNegDI14List1[i] = pNegDI14List1[i - 1];
                }
            } else {
                pPosDI14List1[i] = (PosDM14[i] / TR14[i] * 100) / 1.0;
                pNegDI14List1[i] = (NegDM14[i] / TR14[i] * 100) / 1.0;
				
            }// end else
            // DIDiff, DISum, DX
            if (pPosDI14List1[i] != -0.0001f && pNegDI14List1[i] != -0.0001f) {
                DIDiff[i] = fabs(pPosDI14List1[i] - pNegDI14List1[i]);
                DISum[i] = pPosDI14List1[i] + pNegDI14List1[i];
                if (DISum[i] != -0.0001f && DISum[i] != 0.0) {
                    DX[i] = (DIDiff[i] / DISum[i] * 100) / 1.0;
                } else {
                    if (DX[i - 1] != -0.0001f) {
                        DX[i] = DX[i - 1];
                    }
                }
                // System.err.println(i+" TR14:"+TR14[i]+"  DX:"+DX[i]+"PosDM14:"+PosDM14[i]+"NegDM14:"+NegDM14[i]);
                // end else
            }// endif
        }
        // finding m_pADX
        // m_pADX // mean of DX for last m_sDMIDay days // use 14 as example, i.e. m_sDMIDay=14
        int lStartPt = -1;
        for (int i = 0; i < lineSize; i++) {
            if (DX[i] != -0.0001f) {
                lStartPt = i;
                break;
            }
        }
        if (lStartPt != -1) {
            lStartPt = lStartPt + iDMIDay - 1;
            for (int i = lStartPt; i < lineSize; i++) {
                pADXList1[i] = DX[i];
                for (int j = 1; j < iDMIDay; j++) {
                    pADXList1[i] += DX[i - j];
                }
                pADXList1[i] = (pADXList1[i] / iDMIDay) / 1.0;
            }// end for
        }// end if
        // finding m_pADXR
        // m_pADXR // mean of ADX of today and the m_sDMIDay day before
        lStartPt = -1;
        for (int i = 0; i < lineSize; i++) {
            if (pADXList1[i] != -0.0001f) {
                lStartPt = i;
                break;
            }
        }
		
        if (lStartPt != -1) {
            lStartPt = lStartPt + iDMIDay - 1;
            for (int i = lStartPt; i < lineSize; i++) {
                pADXRList1[i] = (pADXList1[i] + pADXList1[i - iDMIDay + 1]) / 2.0;
				
            }// end for
        }// endif
		
		
		
		MapofLine* pMapofInsertPosDI = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = pPosDI14List1[i];
			insertData->close = pPosDI14List1[i];
			insertData->high = pPosDI14List1[i];
			insertData->low = pPosDI14List1[i];
			insertData->volume = pPosDI14List1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertPosDI->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMap->insert(pair<string,MapofLine*>("+DI",pMapofInsertPosDI));
		
		MapofLine* pMapofInsertNegDI = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = pNegDI14List1[i];
			insertData->close = pNegDI14List1[i];
			insertData->high = pNegDI14List1[i];
			insertData->low = pNegDI14List1[i];
			insertData->volume = pNegDI14List1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertNegDI->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMap->insert(pair<string,MapofLine*>("-DI",pMapofInsertNegDI));
		
		MapofLine* pMapofInsertADXDI = new MapofLine();
        for (i = lineSize - 1; i >= 0; i --) {
			chartData *insertData = new chartData();
			insertData->open = pADXList1[i];
			insertData->close = pADXList1[i];
			insertData->high = pADXList1[i];
			insertData->low = pADXList1[i];
			insertData->volume = pADXList1[i];
			NSString* str = [dateList objectAtIndex:i];
			string datakey([str UTF8String]);
			pMapofInsertADXDI->insert(pair<string, chartData*>(datakey,insertData));
		}
		pMap->insert(pair<string,MapofLine*>("ADX",pMapofInsertADXDI));
		
		if (bShowADXR) {
			MapofLine* pMapofInsertADXRDI = new MapofLine();
			for (i = lineSize - 1; i >= 0; i --) {
				chartData *insertData = new chartData();
				insertData->open = pADXRList1[i];
				insertData->close = pADXRList1[i];
				insertData->high = pADXRList1[i];
				insertData->low = pADXRList1[i];
				insertData->volume = pADXRList1[i];
				NSString* str = [dateList objectAtIndex:i];
				string datakey([str UTF8String]);
				pMapofInsertADXRDI->insert(pair<string, chartData*>(datakey,insertData));
			}
			pMap->insert(pair<string,MapofLine*>("ADXR",pMapofInsertADXRDI));
		}
		[dateList removeAllObjects];
        dateList = nil;
		//[dateList release];
	}	
	return (void *)pMap;
}