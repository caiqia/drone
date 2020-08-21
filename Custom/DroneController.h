//
//  DroneController.h
//  drones
//
//  Created by Shawky on 08/04/2018.

//

#ifndef DroneController_h
#define DroneController_h

#include <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#include <libARController/ARCONTROLLER_Error.h>
#include <libARController/ARCONTROLLER_Device.h>

@interface DroneController : NSObject
+ (NSArray*)getDeviceList;
+ (ARService*)getARService;
+ (ARCONTROLLER_FEATURE_ARDrone3_t*)getDeviceControllerOfApp;
+ (void) startDiscovery;
+ (void) registerReceivers;
+ (ARDISCOVERY_Device_t *)createDiscoveryDeviceWithService:(ARService*)service;
+ (void) unregisterReceivers;
+ (void) stopDiscovery;
+ (void) discoveryDidUpdateServices:(NSNotification *)notification;
+ (void) DroneControllerInit;
void stateChanged (eARCONTROLLER_DEVICE_STATE newState, eARCONTROLLER_ERROR error, void *customData);
-(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)getFlyingState;
+ (void) takeoff;
void onCommandReceived (eARCONTROLLER_DICTIONARY_KEY commandKey, ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary, void *customData);
+ (void) land;
+ (void) deleteDeviceController;
+ (void) send_pilot_data:(int)flag :(int8_t)pitch :(int8_t)roll :(int8_t)yaw :(int8_t)gas :(int)duringmsecs;
+ (void) emergency_land;
+ (bool) isReady;
+ (int) getBatt;
@end

#endif /* DroneController_h */
