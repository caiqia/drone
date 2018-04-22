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

+ (NSArray*)getDeviceList{
    return deviceList;
}
+ (ARService*)getARService{
    return service;
}
+ (ARCONTROLLER_Device_t*)getDeviceControllerOfApp
{
    return _deviceController;
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
}

+ (void) DroneControllerInit
{
    @try {
        [self startDiscovery];
        [self registerReceivers];
        ARDISCOVERY_Device_t *discoveryDevice = [self createDiscoveryDeviceWithService:service];
        eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
        deviceController = ARCONTROLLER_Device_New (discoveryDevice, &error);
        error = ARCONTROLLER_Device_AddStateChangedCallback(deviceController, stateChanged, (__bridge void *)(self));
        error = ARCONTROLLER_Device_AddCommandReceivedCallback(deviceController, onCommandReceived, (__bridge void *)(self));
        error = ARCONTROLLER_Device_Start (deviceController);
        if (error == ARCONTROLLER_OK)
        {
            _deviceController = deviceController;
        }
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

- (void)takeoff
{
    if ([self getFlyingState] == ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED)
    {
        _deviceController->aRDrone3->sendPilotingTakeOff(_deviceController->aRDrone3);
    }
}

// called when a command has been received from the drone
void onCommandReceived (eARCONTROLLER_DICTIONARY_KEY commandKey, ARCONTROLLER_DICTIONARY_ELEMENT_t *elementDictionary, void *customData)
{
    // if the command received is a flying state changed
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
}

- (void)land
{
    eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE flyingState = [self getFlyingState];
    if (flyingState == ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING || flyingState == ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING)
    {
        _deviceController->aRDrone3->sendPilotingLanding(_deviceController->aRDrone3);
    }
}


+ (void) send_pilot_data:(int)flag :(int)roll :(int)pitch :(int)yaw :(int)gas {
    /*
    _deviceController->aRDrone3->setPilotingPCMDFlag(_deviceController->aRDrone3, flag);
    _deviceController->aRDrone3->setPilotingPCMDRoll(_deviceController->aRDrone3, roll);
    _deviceController->aRDrone3->setPilotingPCMDPitch(_deviceController->aRDrone3, pitch);
    _deviceController->aRDrone3->setPilotingPCMDYaw(_deviceController->aRDrone3, yaw);
    _deviceController->aRDrone3->setPilotingPCMDGaz(_deviceController->aRDrone3, gas);
   */
   // if(distance < 0){
   //     distance *= -1;
   // }
   // float time = (float) distance/(VMAX*0.5);
    eARCONTROLLER_ERROR error = ARCONTROLLER_OK;
    if(flag != nil){
    error = _deviceController->aRDrone3->setPilotingPCMDFlag(deviceController->aRDrone3, 1);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"send flag data failed");
        return;
    }
    }
    if(pitch > 0){
    error = _deviceController->aRDrone3->setPilotingPCMDPitch(deviceController->aRDrone3, 50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"going forward failed");
        return;
    }
    }
    if(pitch < 0){
    error = _deviceController->aRDrone3->setPilotingPCMDPitch(deviceController->aRDrone3, -50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"going backward failed");
        return;
    }
    }
    if(roll > 0){
    error = _deviceController->aRDrone3->setPilotingPCMDRoll(deviceController->aRDrone3, 50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"turning right failed");
        return;
    }
    }
    if(roll < 0){
    error = _deviceController->aRDrone3->setPilotingPCMDRoll(deviceController->aRDrone3, -50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"turning left failed");
        return;
    }
    }
    if(gas > 0){
    error = _deviceController->aRDrone3->setPilotingPCMDGaz(deviceController->aRDrone3, 50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"turning up failed");
        return;
    }
    }
    if(gas < 0){
    error = _deviceController->aRDrone3->setPilotingPCMDGaz(deviceController->aRDrone3, -50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"turning down failed");
        return;
    }
    }
    if(yaw > 0){
    error = _deviceController->aRDrone3->setPilotingPCMDYaw(deviceController->aRDrone3, 50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"clockwise rotation failed");
        return;
    }
    }
    if(yaw < 0){
    error = _deviceController->aRDrone3->setPilotingPCMDYaw(deviceController->aRDrone3, -50);
    if(error != ARCONTROLLER_OK) {
        NSLog(@"counter clockwise rotation failed");
        return;
    }
    }
    sleep(3);
    // distance has been traveled, now we need to stop the movement, send order until it is correctly done
    error = !error;
    while(error != ARCONTROLLER_OK) {
        error = _deviceController->aRDrone3->setPilotingPCMD(deviceController->aRDrone3, 0, 0, 0, 0, 0, 0);
    }
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
