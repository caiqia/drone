//
//  UIWheelSector.m
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.

//

#import "UIWheelSector.h"

@implementation UIWheelSector

@synthesize minValue, maxValue, midValue, value;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.value, self.minValue, self.midValue, self.maxValue];
    
}

@end
