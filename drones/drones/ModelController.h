//
//  ModelController.h
//  drones
//
//  Created by MASRI CHOUKI on 24/02/2018.
//  Copyright © 2018 MASRI CHOUKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

