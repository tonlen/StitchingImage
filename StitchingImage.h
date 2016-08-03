//
//  StitchImage.h
//  StitchingImage
//
//  Created by len on 10/9/15.
//  Copyright © 2015 len. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StitchingImage : UIImageView
- (UIImage *)stitchingWithSize:(CGSize)size images:(NSArray<UIImage *> *)images;

@end
