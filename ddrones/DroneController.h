//
//  DroneController.h
//  drones
//
//  Created by Shawky on 08/04/2018.
//  Copyright © 2018 PSAR. All rights reserved.
//

#ifndef DroneController_h
#define DroneController_h

#include <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#include <libARController/ARCONTROLLER_Error.h>
#include <libARController/ARCONTROLLER_Device.h>

@interface DroneController : NSObject
- (void) takeoff;
@end

#endif /* DroneController_h */
