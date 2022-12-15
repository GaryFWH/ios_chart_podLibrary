//
//  ChartDrawCommon.m
//  ChartLibraryDemo
//
//  Created by william on 28/5/2021.
//  Copyright © 2021 william. All rights reserved.
//

#import "ChartDrawCommon.h"
@implementation chartTextBoxInfo

@end


@implementation ChartDrawCommon



+ (NSDictionary *)getDataDictForChartData:(ChartData *)chartData forChartLineType:(ChartLineType)lineType chartDataDisplayType:(ChartDataDisplayType)displayType forDisplayInfo:(ChartDisplayInfo *)displayInfo{
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
//    [dictionary setObject:chartData.groupingKey forKey:@"key"];
    CGFloat openValue = [displayInfo GetYCoodinateForValue:chartData.open];
    CGFloat highValue = [displayInfo GetYCoodinateForValue:chartData.high];
    CGFloat lowValue = [displayInfo GetYCoodinateForValue:chartData.low];
    CGFloat closeValue = [displayInfo GetYCoodinateForValue:chartData.close];
    CGFloat volumeValue = [displayInfo GetYCoodinateForValue:chartData.volume];
        
    NSNumber * indexNum = [displayInfo.timestampToIndex objectForKey:chartData.groupingKey];
    if (indexNum){
        CGFloat xValue = [displayInfo.chartSetting GetXCoodinateForIndex:[indexNum integerValue]];
        [dictionary setObject:@(xValue) forKey:@"xValue"];
        
        CGFloat value = 0.0001f;
        switch (displayType){
            case ChartDataDisplayTypeOpen:
            {
                value = openValue;
                break;
            }
            case ChartDataDisplayTypeHigh:
            {
                value = highValue;
                break;
            }
            case ChartDataDisplayTypeLow:
            {
                value = lowValue;
                break;
            }
            case ChartDataDisplayTypeVolume:
            {
                value = volumeValue;
                break;
            }
            case ChartDataDisplayTypeClose:
            default:
            {
                value = closeValue;
                break;
            }
        }
        
        switch(lineType)
        {
            case ChartLineTypeCandle:
            {
                [dictionary setObject:@(highValue) forKey:@"high"];
                [dictionary setObject:@(lowValue) forKey:@"low"];
//                [dictionary setObject:@(openValue) forKey:@"open"];
//                [dictionary setObject:@(closeValue) forKey:@"close"];
                if (chartData.close >= chartData.open){
                    [dictionary setObject:@(YES) forKey:@"isUp"];
                    [dictionary setObject:@(openValue) forKey:@"candleLow"];
                    [dictionary setObject:@(closeValue) forKey:@"candleHigh"];
                } else {
                    [dictionary setObject:@(NO) forKey:@"isUp"];
                    [dictionary setObject:@(openValue) forKey:@"candleHigh"];
                    [dictionary setObject:@(closeValue) forKey:@"candleLow"];
                }
                break;
            }
            case ChartLineTypeLine:
            {
                [dictionary setObject:@(value) forKey:@"value"];
                break;
            }
            case ChartLineTypeArea:
            {
                [dictionary setObject:@(value) forKey:@"value"];
                break;
            }
            case ChartLineTypeBar:
            {
                [dictionary setObject:@(highValue) forKey:@"high"];
                [dictionary setObject:@(lowValue) forKey:@"low"];
                [dictionary setObject:@(openValue) forKey:@"open"];
                [dictionary setObject:@(closeValue) forKey:@"close"];
                break;
            }
            case ChartLineTypeHisto:
            {
                [dictionary setObject:@(value) forKey:@"value"];
                break;
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (void)DrawRectOnContext:(CGContextRef) context rect:(CGRect)rect color:(UIColor *)color isFill:(bool)isFill {
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    if (isFill){
        CGContextFillRect(context, rect);
    } else {
        CGContextStrokeRect(context, rect);
    }
    CGContextRestoreGState(context);
}

+ (void)DrawLineOnContext:(CGContextRef) context pointA:(CGPoint)pointA pointB:(CGPoint)pointB color:(UIColor *)color{
//    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, pointA.x, pointA.y);
    CGContextAddLineToPoint(context, pointB.x, pointB.y);
    CGContextStrokePath(context);
//    CGContextRestoreGState(context);
}

+ (void)DrawDashLineOnContext:(CGContextRef)context pointA:(CGPoint)pointA pointB:(CGPoint)pointB color:(UIColor *)color {
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1);
    const static CGFloat lengths[]={1,3};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, pointA.x, pointA.y);
    CGContextAddLineToPoint(context, pointB.x, pointB.y);
    CGContextStrokePath(context);
}







+ (CGRect)getRectFromPoint:(CGPoint)refPoint pointDirection:(ChartTextBoxPointDirection)pointDirection size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //For origin X
    switch (pointDirection) {
        case ChartTextBoxPointDirectionFromTopLeft:
        case ChartTextBoxPointDirectionFromLeft:
        case ChartTextBoxPointDirectionFromBottomLeft:
        {
            rect.origin.x = refPoint.x;
            break;
        }
        case ChartTextBoxPointDirectionFromTop:
        case ChartTextBoxPointDirectionFromCenter:
        case ChartTextBoxPointDirectionFromBottom:
        {
            rect.origin.x = refPoint.x - size.width/2;
            break;
        }
        case ChartTextBoxPointDirectionFromTopRight:
        case ChartTextBoxPointDirectionFromRight:
        case ChartTextBoxPointDirectionFromBottomRight:
        {
            rect.origin.x = refPoint.x - size.width;
            break;
        }
        default:
            break;
    }
    
    //For origin Y
    switch (pointDirection) {
        case ChartTextBoxPointDirectionFromTopLeft:
        case ChartTextBoxPointDirectionFromTop:
        case ChartTextBoxPointDirectionFromTopRight:
        {
            rect.origin.y = refPoint.y;
            break;
        }
            
        case ChartTextBoxPointDirectionFromLeft:
        case ChartTextBoxPointDirectionFromCenter:
        case ChartTextBoxPointDirectionFromRight:
        {
            rect.origin.y = refPoint.y - size.height/2;
            break;
        }
        case ChartTextBoxPointDirectionFromBottomLeft:
        case ChartTextBoxPointDirectionFromBottom:
        case ChartTextBoxPointDirectionFromBottomRight:
        {
            rect.origin.y = refPoint.y - size.height;
            break;
        }
        default:
            break;
    }
    
    return rect;
}

+ (chartTextBoxInfo *)GetTextRectFromPoint:(CGPoint)refPoint pointDirection:(ChartTextBoxPointDirection)pointDirection sizeLimit:(CGSize)sizeLimit text:(NSString *)text initialFont:(UIFont *)initialFont fontColor:(UIColor *)fontColor {
    
    return [self GetTextRectFromPoint:refPoint pointDirection:pointDirection sizeLimit:sizeLimit text:text initialFont:initialFont fontColor:fontColor bgColor:[UIColor clearColor]];
}

+ (chartTextBoxInfo *)GetTextRectFromPoint:(CGPoint)refPoint pointDirection:(ChartTextBoxPointDirection)pointDirection sizeLimit:(CGSize)sizeLimit text:(NSString *)text initialFont:(UIFont *)initialFont fontColor:(UIColor *)fontColor bgColor:(UIColor *)bgColor {
    
    if (!text){
        text = @"";
    }
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, attributeString.string.length);
    UIFont * font = initialFont;
    [attributeString addAttribute:NSFontAttributeName value:font range:range];
    CGSize stringSize = attributeString.size;
    CGFloat scale = 1;
    if (stringSize.width > sizeLimit.width){
        if (sizeLimit.width/stringSize.width < scale){
            scale = sizeLimit.width/stringSize.width;
        }
    }
    if (stringSize.height > sizeLimit.height){
        if (sizeLimit.height/stringSize.height < scale){
            scale = sizeLimit.height/stringSize.height;
        }
    }
//    font.pointSize = 12 * scale;
    font = [UIFont fontWithName:initialFont.fontName size:initialFont.pointSize*scale];
    [attributeString addAttribute:NSFontAttributeName value:font range:range];
    stringSize = attributeString.size;
    CGRect rect = [self getRectFromPoint:refPoint pointDirection:pointDirection size:stringSize];
    chartTextBoxInfo * info = [[chartTextBoxInfo alloc] init];
    info.font = font;
    info.rect = rect;
    info.text = text;
    info.fontColor = fontColor;
    info.bgColor = bgColor;
    return info;

}

+ (void)DrawTextOnContext:(CGContextRef)context textBoxInfo:(chartTextBoxInfo *)textBoxInfo {
    CGContextSaveGState(context);
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc] initWithString:textBoxInfo.text /*@"12345.678999"*/];
    NSRange range = NSMakeRange(0, attributeString.string.length);
    
    [attributeString addAttribute:NSFontAttributeName value:textBoxInfo.font range:range];
    [attributeString addAttribute:NSForegroundColorAttributeName value:textBoxInfo.fontColor range:range];
    [attributeString addAttribute:NSBackgroundColorAttributeName value:textBoxInfo.bgColor range:range];

    UIGraphicsPushContext(context);
    [attributeString drawInRect:textBoxInfo.rect];
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}
@end
