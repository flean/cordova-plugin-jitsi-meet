#import "JitsiPlugin.h"



@implementation JitsiPlugin

CDVPluginResult *pluginResult = nil;

- (void)loadURL:(CDVInvokedUrlCommand *)command {
    NSString* url = [command.arguments objectAtIndex:0];
    NSString* key = [command.arguments objectAtIndex:1];
    NSString* displayName = [command.arguments objectAtIndex:2];
    Boolean isInvisible = [[command.arguments objectAtIndex:3] boolValue];
    commandBack = command;
    jitsiMeetView = [[JitsiMeetView alloc] initWithFrame:self.viewController.view.frame];
    jitsiMeetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    jitsiMeetView.delegate = self;
    JitsiMeetConferenceOptions *options
        = [JitsiMeetConferenceOptions fromBuilder:^(JitsiMeetConferenceOptionsBuilder *builder) {
            builder.room = key;
            builder.subject = @"Modulus";
            builder.userInfo.displayName = displayName;
            builder.serverURL = [NSURL URLWithString:url];
            builder.welcomePageEnabled = NO;
            [builder setFeatureFlag:@"add-people.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"live-streaming.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"meeting-name.enabled" withBoolean:YES];
            [builder setFeatureFlag:@"meeting-password.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"chat.enabled" withBoolean:YES];
            [builder setFeatureFlag:@"invite.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"calendar.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"call-integration.enabled" withBoolean:YES];
            [builder setFeatureFlag:@"close-captions.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"ios.recording.enabled" withBoolean:NO];
            [builder setFeatureFlag:@"pip.enabled" withBoolean:NO];
            
    }];
    [jitsiMeetView join:options];
    if (!isInvisible) {
       [self.viewController.view addSubview:jitsiMeetView];
    }
}

- (void)destroy:(CDVInvokedUrlCommand *)command {
    [jitsiMeetView leave];
    [jitsiMeetView removeFromSuperview];
    jitsiMeetView = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"DESTROYED"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

void _onJitsiMeetViewDelegateEvent(NSString *name, NSDictionary *data) {
    NSLog(
        @"[%s:%d] JitsiMeetViewDelegate %@ %@",
        __FILE__, __LINE__, name, data);

}

- (void)conferenceFailed:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_FAILED", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_FAILED"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceJoined:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_JOINED", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_JOINED"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceTerminated:(NSDictionary *)data {
    [jitsiMeetView leave];
    [jitsiMeetView removeFromSuperview];
    jitsiMeetView = nil;
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_TERMINATED", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_TERMINATED"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}


- (void)conferenceLeft:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_LEFT", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_LEFT"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];

}

- (void)conferenceWillJoin:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_WILL_JOIN", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_WILL_JOIN"];
    
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}

- (void)conferenceWillLeave:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"CONFERENCE_WILL_LEAVE", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"CONFERENCE_WILL_LEAVE"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}

- (void)loadConfigError:(NSDictionary *)data {
    _onJitsiMeetViewDelegateEvent(@"LOAD_CONFIG_ERROR", data);
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"LOAD_CONFIG_ERROR"];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:commandBack.callbackId];
}


@end
