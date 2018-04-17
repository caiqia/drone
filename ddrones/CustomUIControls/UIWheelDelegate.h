//
//  UIWheelDelegate.m
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIWheelDelegate <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@end
