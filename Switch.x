// match in music flipswitch toggle
// by brandon sachs (c) 2014
// modified by PoomSmart

#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "notify.h"

CFStringRef kMobileiPod = CFSTR("com.apple.mobileipod");
CFStringRef key = CFSTR("MusicShowCloudMediaEnabledSetting");

@interface MatchInMusicSwitch : NSObject <FSSwitchDataSource>
@end

@interface CPAggregateDictionary : NSObject
+ (CPAggregateDictionary *)sharedAggregateDictionary;
- (void)incrementKey:(NSString *)key;
@end

@implementation MatchInMusicSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	Boolean keyExist;
	Boolean enabled = CFPreferencesGetAppBooleanValue(key, kMobileiPod, &keyExist);
	if (!keyExist)
		return FSSwitchStateOn;
	return enabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	CFBooleanRef enabled = newState == FSSwitchStateOn ? kCFBooleanTrue : kCFBooleanFalse;
	CFPreferencesSetAppValue(key, enabled, kMobileiPod);
	CFPreferencesAppSynchronize(kMobileiPod);
	notify_post("com.apple.mobileipod-prefsChanged");
	CPAggregateDictionary *aggd = [[CPAggregateDictionary sharedAggregateDictionary] retain];
	[aggd incrementKey:@"com.apple.mobileipod.Settings.ShowAllMusicToggled"];
	[aggd release];
}

@end

static void PreferencesChanged()
{
	[[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:@"com.cbcoding.matchinmusic-flipswitch"];
}

__attribute__((constructor)) static void init()
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChanged, CFSTR("com.apple.mobileipod-prefsChanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}