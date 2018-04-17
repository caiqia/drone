//
//  UIWheel.h
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWheelDelegate.h"

@interface UIWheel : UIControl

@property (weak) id <UIWheelDelegate> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;
@property NSString* background_img_name;
@property NSString* resource_icons_name_prefix;
@property NSString* center_icon;
@property (nonatomic, strong) NSArray *options_list;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber withBackground:(NSString*)bg_name withIconsPrefix:(NSString*)icons_prefix withCenterIcon:(NSString*)center_button;
- (NSString *) getCloveName:(int)position;
- (UIImageView *) getCloveByValue:(int)value;
@end
