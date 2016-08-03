//
//  StitchImage.m
//  StitchingImage
//
//  Created by len on 10/9/15.
//  Copyright © 2015 len. All rights reserved.
//
#define kScreenScale [UIScreen mainScreen].scale
#import "StitchingImage.h"

const CGFloat marginSpaceRatio = 27.0;

@interface StitchingImage ()
{
   CGFloat _cellImageViewchrSideLength;
   CGFloat _margin;
}
@end

@implementation StitchingImage
- (void)generatorMatrix:(CGRect *)frames count:(NSInteger)count beginOriginY:(CGFloat)beginOriginY {
    
    int cellCount;
    int maxRow;
    int maxColumn;
    int ignoreCountOfBegining;
    
    if (count <= 4)
    {
        maxRow = 2;
        maxColumn = 2;
        ignoreCountOfBegining = count % 2;
        cellCount = 4;
    }
    else
    {
        maxRow = 3;
        maxColumn = 3;
        ignoreCountOfBegining = count % 3;
        cellCount = 9;
    }
    
    for (int i = 0; i < cellCount; i++) {
        if (i > count - 1) break;
        if (i < ignoreCountOfBegining) continue;
        
        int row = floor((float)(i - ignoreCountOfBegining) / maxRow);
        int column = (i - ignoreCountOfBegining) % maxColumn;
        
        CGFloat origin_x = _margin + _cellImageViewchrSideLength * column + _margin * column;
        CGFloat origin_y = beginOriginY + _cellImageViewchrSideLength * row + _margin * row;
        frames[i] = CGRectMake(origin_x, origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
        
    }
}

- (UIImage *)stitchingWithSize:(CGSize)size images:(NSArray<UIImage *> *)images
{
    NSInteger count = images.count;
    if (count == 0) return nil;
    // 计算边距
    _margin = size.width / marginSpaceRatio;
    CGFloat sideLength = 0.0f;
        if (count == 1) {
        sideLength = size.width;
    } else if (count >=2 && count <=4) {
        sideLength = (size.width - _margin * 3) / 2;
    } else {
        sideLength = (size.width - _margin * 4) / 3;
    }
    _cellImageViewchrSideLength = sideLength;
    CGRect *frames = new CGRect[count];
    
    switch (count) {
        case 1:
        {
            frames[0] = CGRectMake(0, 0, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
        }
            break;
        case 2:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength) / 2;
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y];
        }
            break;
        case 3:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 2) / 3;
            
            frames[0] = CGRectMake((size.width - _cellImageViewchrSideLength) / 2, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y + _cellImageViewchrSideLength + _margin];
        }
            break;
        case 4:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 2) / 3;
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y];
        }
            break;
        case 5:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 2 - _margin) / 2;
            
            CGRect zero = CGRectMake((size.width - 2 * _cellImageViewchrSideLength - _margin) / 2, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            frames[0] = zero;
            frames[1] = CGRectMake(zero.origin.x + zero.size.width + _margin, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y + _cellImageViewchrSideLength + _margin];
        }
            break;
        case 6:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 2 - _margin) / 2;
            
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y];
        }
            break;
        case 7:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 3) / 4;
            
            frames[0] = CGRectMake((size.width - _cellImageViewchrSideLength) / 2, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y + _cellImageViewchrSideLength + _margin];
        }
            break;
        case 8:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 3) / 4;
            
            CGRect zero = CGRectMake((size.width - 2 * _cellImageViewchrSideLength - _margin) / 2, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            frames[0] = zero;
            
            frames[1] = CGRectMake(zero.origin.x + zero.size.width + _margin, row_1_origin_y, _cellImageViewchrSideLength, _cellImageViewchrSideLength);
            
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y + _cellImageViewchrSideLength + _margin];
        }
            break;
        case 9:
        {
            CGFloat row_1_origin_y = (size.height - _cellImageViewchrSideLength * 3) / 4;
            [self generatorMatrix:frames count:count beginOriginY:row_1_origin_y];
        }
            break;
        default:
            break;
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, kScreenScale);

    for (unsigned int i = 0; i < count; i++) {
        [images[i] drawInRect:frames[i]];
    }
    
    delete [] frames;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

/*
 //添加圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
 */
@end
