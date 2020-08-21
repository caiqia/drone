//
//  UIWheelDelegate.m
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.

//

#import <Foundation/Foundation.h>
#import "UIWheel.h"

@protocol UIWheelDelegate <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue withwheel:(NSObject *)wheel ;

@end
