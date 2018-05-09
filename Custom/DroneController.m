//
//  DroneController.m
//  For PSAR Drones
//
//  Created by Chouki & Qiaoshan.
//  Copyright © 2018 PSAR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DroneController.h"

@implementation DroneController
static  ARCONTROLLER_Device_t *deviceController;
static  ARCONTROLLER_Device_t *_deviceController;
static  ARService *service;
static  NSArray *deviceList;
static  uint8_t *battLevel;
static  bool ready = false;


+ (bool)isReady{
    return ready;
}
+ (NSArray*)getDeviceList{
    return deviceList;
}
+ (ARService*)getARService{
    return service;
}
+ (uint8_t*)getBattlevel{
    return battLevel;
}
+ (ARCONTROLLER_FEATURE_ARDrone3_t*)getDeviceControllerOfApp
{
    ARCONTROLLER_FEATURE_ARDrone3_t *ar;
    ar = _deviceController->aRDrone3;
    return ar;
}

+ (void)startDiscovery
{
    [[ARDiscovery sharedInstance] start];
}

+ (void)registerReceivers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoveryDidUpdateServices:) name:kARDiscoveryNotificationServicesDevicesListUpdated object:nil];
}

+ (ARDISCOVERY_Device_t *)createDiscoveryDeviceWithService:(ARService*)service
{
    ARDISCOVERY_Device_t *device = NULL;
    eARDISCOVERY_ERROR errorDiscovery = ARDISCOVERY_OK;
    
    device = [service createDevice:&errorDiscovery];
    
    if (errorDiscovery != ARDISCOVERY_OK)
        NSLog(@"Discovery error :%s", ARDISCOVERY_Error_ToString(errorDiscovery));
    
    return device;
}

+ (void)unregisterReceivers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kARDiscoveryNotificationServicesDevicesListUpdated object:nil];
}

+ (void)stopDiscovery
{
    [[ARDiscovery sharedInstance] stop];
}

+ (void)discoveryDidUpdateServices:(NSNotification *)notification
{
    deviceList = [[notification userInfo] objectForKey:kARDiscoveryServicesList];
    service = deviceList[0];
    // Do what you want with the device list (deviceList is an array of ARService*)
    NSLog(@"Got Service");
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(q, ^{
        ARDISCOVERY_Device_t *discoveryDevice = [self createDiscoveryDeviceWithService:service];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [DroneController continueregister:discoveryDevice];
        });
    });
}

+ (void) continueregister:(ARDISCOVERY_Device_t*)device
{
    NSLog(@"created with servcie");
    eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
    deviceController = ARCONTROLLER_Device_New (device, &error);
    NSLog(@"Passed Device of discovery");
    NSLog(@"%@",error);
    //NSLog(@"%@",deviceController);
    //error =    ARCONTROLLER_Device_AddStateChangedCallback(deviceController, stateChanged, (__bridge void *)(self));
    NSLog(@"%@",error);
    //error = ARCONTROLLER_Device_AddCommandReceivedCallback(deviceController, onCommandReceived, (__bridge void *)(self));
    error = ARCONTROLLER_Device_Start (deviceController);
    
    NSLog(@"%@",error);
    if (error == ARCONTROLLER_OK)
    {
        NSLog(@"error is ok, should fly");
        _deviceController = deviceController;
    }
    //[self unregisterReceivers];
    // [self stopDiscovery];
    ready = true;
}

+ (void) DroneControllerInit
{
    @try {
        [self startDiscovery];
        NSLog(@"passed discovery");
        [self registerReceivers];
        NSLog(@"passed register");
    }
    @catch (NSException *exception){
        NSLog(@"%@",exception.reason);
    }
}

void stateChanged (eARCONTROLLER_DEVICE_STATE newState, eARCONTROLLER_ERROR error, void *customData)
{
    // SELF_TYPE is the class name of self
    DroneController *selfCpy = (__bridge DroneController *)customData;
    
    switch (newState)
    {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            break;
        case ARCONTROLLER_DEVICE_STATE_STARTING:
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPING:
            break;
        default:
            break;
    }
}

-(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)getFlyingState {
    
    eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE flyingState = ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_MAX;
    
    eARCONTROLLER_ERROR error;
    // get the current flying state description
    ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary = ARCONTROLLER_ARDrone3_GetCommandElements(_deviceController->aRDrone3, ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED, &error);
    if (error == ARCONTROLLER_OK && elementDictionary != NULL)
    {
        ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
        ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
        HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
        if (element != NULL)
        {
            // get the value
            HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE, arg);
            
            if (arg != NULL)
            {
                // Enums are I32
                flyingState = arg->value.I32;
            }
        }
    }
    
    return flyingState;
}

+ (void)takeoff
{
    NSLog(@"Taking Off :) ");
    _deviceController->aRDrone3->sendPilotingTakeOff(_deviceController->aRDrone3);
}

+ (void) myFunction{
    eARCONTROLLER_ERROR error;
    error = ARCONTROLLER_Device_AddCommandReceivedCallback(deviceController, onCommandReceived, (__bridge void *)(self));
}

// called when a command has been received from the drone
void onCommandReceived (eARCONTROLLER_DICTIONARY_KEY commandKey, ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary, void *customData)
{
    //SELF_TYPE *selfCpy = (__bridge SELF_TYPE *)customData;
    
    if (elementDictionary != NULL)
    {
        // if the command received is a battery state changed
        if (commandKey == ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED)
        {
            ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
            ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
            
            // get the command received in the device controller
            HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
            if (element != NULL)
            {
                // get the value
                HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_COMMON_COMMONSTATE_BATTERYSTATECHANGED_PERCENT, arg);
                
                if (arg != NULL)
                {
                    uint8_t batteryLevel = arg->value.U8;
                    battLevel = batteryLevel;
                    // do what you want with the battery level
                    // batLevel = batteryLevel;
                    //  NSLog(batLevel);
                }
            }
        }
        if ((commandKey == ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED) && (elementDictionary != NULL))
        {
            ARCONTROLLER_DICTIONARY_ARG_t *arg = NULL;
            ARCONTROLLER_DICTIONARY_ELEMENT_t *element = NULL;
            
            // get the command received in the device controller
            HASH_FIND_STR (elementDictionary, ARCONTROLLER_DICTIONARY_SINGLE_KEY, element);
            if (element != NULL)
            {
                // get the value
                HASH_FIND_STR (element->arguments, ARCONTROLLER_DICTIONARY_KEY_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE, arg);
                
                if (arg != NULL)
                {
                    eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE flyingState = arg->value.I32;
                }
            }
        }
        // else if (commandKey == THE COMMAND YOU ARE INTERESTED IN)
    }
}

+ (void)land
{
    
    eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
    
    // if the device controller is not stopped, stop it
    eARCONTROLLER_DEVICE_STATE state = ARCONTROLLER_Device_GetState(_deviceController, &error);
    
    if(!error != ARCONTROLLER_OK ){
        NSLog(@"Landing");
        _deviceController->aRDrone3->sendPilotingLanding(_deviceController->aRDrone3);
    }
}

+ (void) send_pilot_data:(int)flag :(int8_t)roll :(int8_t)pitch :(int8_t)yaw :(int8_t)gas :(int)duringmsecs {
    _deviceController->aRDrone3->setPilotingPCMDFlag(_deviceController->aRDrone3, (roll || pitch )?1:0);
    _deviceController->aRDrone3->setPilotingPCMDRoll(_deviceController->aRDrone3, roll);
    _deviceController->aRDrone3->setPilotingPCMDPitch(_deviceController->aRDrone3, pitch);
    _deviceController->aRDrone3->setPilotingPCMDYaw(_deviceController->aRDrone3, yaw);
    _deviceController->aRDrone3->setPilotingPCMDGaz(_deviceController->aRDrone3, gas);
    [NSThread sleepForTimeInterval:duringmsecs];
    eARCONTROLLER_ERROR error = ARCONTROLLER_ERROR;
    while(error != ARCONTROLLER_OK) {
        error = _deviceController->aRDrone3->setPilotingPCMD(deviceController->aRDrone3, 0, 0, 0, 0, 0, 0);
    }
}


+ (void)emergency_land
{
    NSLog(@"emergency landing");
    _deviceController->aRDrone3->sendPilotingEmergency(_deviceController->aRDrone3);
}

- (void)deleteDeviceController
{
    // in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
        
        // if the device controller is not stopped, stop it
        eARCONTROLLER_DEVICE_STATE state = ARCONTROLLER_Device_GetState(_deviceController, &error);
        if ((error == ARCONTROLLER_OK) && (state != ARCONTROLLER_DEVICE_STATE_STOPPED))
        {
            // after that, stateChanged should be called soon
            error = ARCONTROLLER_Device_Stop (_deviceController);
            
            if (error == ARCONTROLLER_OK)
            {
                // dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            }
            else
            {
                NSLog(@"- error:%s", ARCONTROLLER_Error_ToString(error));
            }
        }
        
        // once the device controller is stopped, we can delete it
        if (_deviceController != NULL)
        {
            ARCONTROLLER_Device_Delete(&_deviceController);
        }
    });
}
@end
