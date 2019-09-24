#import <Foundation/NSDistributedNotificationCenter.h>
#import <notify.h>
#import <mach/mach_init.h>
#import <mach/mach_host.h>
#import <MediaRemote/MediaRemote.h>
#import <sys/utsname.h>
#import "Tweak.h"

@interface EXOObserver : NSObject

@property (nonatomic, retain) NSMutableDictionary *data;
@property (nonatomic, retain) NSTimer *every10MinutesTimer;
@property (nonatomic, retain) NSTimer *everyMinuteTimer;
@property (nonatomic, retain) NSTimer *every30SecondsTimer;

+(instancetype)sharedInstance;
-(id)init;
-(void)update:(NSDictionary *)updateData;

-(void)once;
-(void)dataRequested;
-(void)postNotification:(NSDictionary *)data;

-(void)startUpdating;
-(void)stopUpdating;

-(void)every30Seconds;
-(void)everyMinute;
-(void)every10Minutes;

-(void)updateBattery;
-(void)updateMemory;
-(void)updateDevice;
-(void)updateWeather;
//...

@end

@implementation EXOObserver

/* Main stuff */

+(instancetype)sharedInstance
{
    static EXOObserver *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [EXOObserver alloc];
        sharedInstance.data = [NSMutableDictionary new];
        sharedInstance.data[@"media.playing"] = @(false);
        sharedInstance.data[@"weather.available"] = @(false);
        [sharedInstance once];
    });
    return sharedInstance;
}

-(id)init {
    return [EXOObserver sharedInstance];
}

-(void)once {
    [self updateDevice];
}

-(void)update:(NSDictionary *)updateData {
    for (NSString *key in updateData) {
        self.data[key] = updateData[key];
    }

    [self postNotification:updateData];
}

-(void)dataRequested {
    [self postNotification:self.data];
}

-(void)postNotification:(NSDictionary *)data {
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"me.nepeta.exo/update" object:nil userInfo:data];
}

/* Timer stuff */

-(void)startUpdating {
    [self stopUpdating];

    [self everyMinute];
    self.everyMinuteTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(everyMinute) userInfo:nil repeats:YES];

    [self every30Seconds];
    self.every30SecondsTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(every30Seconds) userInfo:nil repeats:YES];

    [self every10Minutes];
    self.every10MinutesTimer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(every10Minutes) userInfo:nil repeats:YES];
}

-(void)stopUpdating {
    if (self.everyMinuteTimer) [self.everyMinuteTimer invalidate];
    if (self.every30SecondsTimer) [self.every30SecondsTimer invalidate];
    if (self.every10MinutesTimer) [self.every10MinutesTimer invalidate];
}

-(void)every30Seconds {
    
}

-(void)everyMinute {
    [self updateBattery];
    [self updateMemory];
}

-(void)every10Minutes {
    [self updateWeather];
}

/* Update stuff */

-(void)updateBattery {
    SBUIController *controller = [%c(SBUIController) sharedInstanceIfExists];

    if (!controller) return;

    [self update:@{
        @"battery.charging": @([controller isOnAC]),
        @"battery.percentage": @([controller batteryCapacityAsPercentage])
    }];
}

-(void)updateMemory {
    /* Based on: https://stackoverflow.com/questions/5012886/determining-the-available-amount-of-ram-on-an-ios-device/8540665#8540665 */

    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;

    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        

    vm_statistics_data_t vm_stat;

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return;
    }

    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    natural_t mem_physical = [NSProcessInfo processInfo].physicalMemory;
 
    [self update:@{
        @"memory.physical": @(mem_physical),
        @"memory.used": @(mem_used),
        @"memory.free": @(mem_free),
        @"memory.total": @(mem_total),
    }];
}

-(void)updateDevice {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *type = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    [self update:@{
        @"device.type": type,
        @"device.name": [[UIDevice currentDevice] name],
        @"system.version": [UIDevice currentDevice].systemVersion
    }];
}

-(void)updateWeather {
    if (!%c(WeatherPreferences)) return;

    WeatherPreferences *weatherPrefs = [%c(WeatherPreferences) sharedPreferences];
    NSArray *savedCities = [weatherPrefs loadSavedCities];
    NSArray *defaultCities = [weatherPrefs _defaultCities];

    City *city;
    if (savedCities && [savedCities count] > 0) city = savedCities[0];
    if (!city && defaultCities && [defaultCities count] > 0) city = defaultCities[0];
    if (!city) return;

    BOOL useCelsius = [weatherPrefs isCelsius];
    WFTemperature *temperature = [city temperature];
    WFTemperature *feelsLike = [city feelsLike];
    WFLocation *location = [city wfLocation];
    NSMutableDictionary *weatherInfo = [@{
        @"weather.available": @(true),
        @"weather.city.name": [city name] ?: @"",
        @"weather.city.county": [location county] ?: @"",
        @"weather.city.state": [location state] ?: @"",
        @"weather.city.stateAbbreviation": [location stateAbbreviation] ?: @"",
        @"weather.city.country": [location county] ?: @"",
        @"weather.city.countryAbbreviation": [location countryAbbreviation] ?: @"",
        @"weather.windChill": @([city windChill]),
        @"weather.windDirection": @([city windDirection]),
        @"weather.windSpeed": @([city windSpeed]),
        @"weather.humidity": @([city humidity]),
        @"weather.visibility": @([city visibility]),
        @"weather.pressure": @([city pressure]),
        @"weather.dewPoint": @([city dewPoint]),
        @"weather.heatIndex": @([city heatIndex]),
        @"weather.precipitationPast24Hours": @([city precipitationPast24Hours]),
        @"weather.uvIndex": @([city uvIndex]),
        @"weather.conditionCode": @([city conditionCode]),
        @"weather.condition": [city naturalLanguageDescription],
        @"weather.sunsetTime": @([city sunsetTime]),
        @"weather.sunriseTime": @([city sunriseTime]),
        @"weather.moonPhase": @([city moonPhase]),
        @"weather.temperature.current": useCelsius ? @([temperature celsius]) : @([temperature fahrenheit]),
        @"weather.temperature.feelsLike": useCelsius ? @([feelsLike celsius]) : @([feelsLike fahrenheit]),
        @"weather.temperature.unit": useCelsius ? @"C" : @"F"
    } mutableCopy];

    WAHourlyForecast *currentHourlyForecast = ([city hourlyForecasts] && [[city hourlyForecasts] count] > 0) ? [city hourlyForecasts][0] : nil;
    WADayForecast *currentDayForecast = ([city dayForecasts] && [[city dayForecasts] count] > 0) ? [city dayForecasts][0] : nil;

    if (currentDayForecast) {
        weatherInfo[@"weather.temperature.high"] = useCelsius ? @([[currentDayForecast high] celsius]) : @([[currentDayForecast high] fahrenheit]);
        weatherInfo[@"weather.temperature.low"] = useCelsius ? @([[currentDayForecast low] celsius]) : @([[currentDayForecast low] fahrenheit]);
    }

    if (currentHourlyForecast) {
        weatherInfo[@"weather.chanceOfRain"] = @([currentHourlyForecast percentPrecipitation]);
    }

    if ([city dayForecasts] && [[city dayForecasts] count] > 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (WADayForecast *forecast in [city dayForecasts]) {
            [array addObject:@{
                @"day": @([forecast dayNumber]),
                @"dayOfTheWeek": @([forecast dayOfWeek]),
                @"icon": @([forecast icon]),
                @"temperature.high": useCelsius ? @([[forecast high] celsius]) : @([[forecast high] fahrenheit]),
                @"temperature.low": useCelsius ? @([[forecast low] celsius]) : @([[forecast low] fahrenheit]),
            }];
        }

        weatherInfo[@"weather.dayForecasts"] = array;
    }

    if ([city hourlyForecasts] && [[city hourlyForecasts] count] > 0) {
        NSMutableArray *array = [NSMutableArray new];
        for (WAHourlyForecast *forecast in [city hourlyForecasts]) {
            [array addObject:@{
                @"time": [forecast time] ?: @"",
                @"conditionCode": @([forecast conditionCode]),
                @"percentPrecipitation": @([forecast percentPrecipitation]),
                @"detail": [forecast forecastDetail] ?: @"",
                @"temperature": useCelsius ? @([[forecast temperature] celsius]) : @([[forecast temperature] fahrenheit]),
            }];
        }

        weatherInfo[@"weather.hourlyForecasts"] = array;
    }

    [self update:weatherInfo];
}

@end

void dataRequested() {
    [[EXOObserver sharedInstance] dataRequested];
}

void updateChargingStatus(CFNotificationCenterRef center, void *o, CFStringRef name, id object, NSDictionary *userInfo) {
    [[EXOObserver sharedInstance] update:@{
        @"battery.charging": userInfo[@"IsCharging"] ?: @(false)
    }];
}

unsigned long wifiSignalUpdateTime = 0;
bool wifiInitialized = false;

%hook SBWiFiManager

-(void)_powerStateDidChange {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"wifi.enabled": @([self isPowered]),
        @"wifi.strength.current": @([self isPowered] ? [self signalStrengthBars] : 0),
        @"wifi.strength.rssi": @([self isPowered] ? [self signalStrengthRSSI] : 0),
    }];
}

-(void)_updateCurrentNetwork {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"wifi.network": [self currentNetworkName] ?: @"",
        @"wifi.strength.current": @([self currentNetworkName] ? [self signalStrengthBars] : 0),
        @"wifi.strength.rssi": @([self currentNetworkName] ? [self signalStrengthRSSI] : 0),
    }];
}

-(void)updateSignalStrengthFromRawRSSI:(int)arg1 andScaledRSSI:(float)arg2 {
    %orig;
    if (![self isPowered]) return;
    if (time(NULL) - wifiSignalUpdateTime > 10 || (!wifiInitialized && time(NULL) - wifiSignalUpdateTime > 1)) {
        if ([self signalStrengthRSSI] != 0) wifiInitialized = true;
        wifiSignalUpdateTime = time(NULL);
        [[EXOObserver sharedInstance] update:@{
            @"wifi.strength.current": @([self signalStrengthBars]),
            @"wifi.strength.rssi": @([self signalStrengthRSSI]),
        }];
    }
}

-(void)updateSignalStrength {
    %orig;
    if (![self isPowered]) return;
    if (time(NULL) - wifiSignalUpdateTime > 10) {
        if ([self signalStrengthRSSI] != 0) wifiInitialized = true;
        wifiSignalUpdateTime = time(NULL);
        [[EXOObserver sharedInstance] update:@{
            @"wifi.strength.current": @([self signalStrengthBars]),
            @"wifi.strength.rssi": @([self signalStrengthRSSI]),
        }];
    }
}

%end

%hook MPUNowPlayingController

%property (nonatomic, retain) NSString *exoLastDigest;

- (void)_updateTimeInformationAndCallDelegate:(bool)arg1 {
    %orig;

    NSString *data = @"";

    if (self.shouldUpdateNowPlayingArtwork) {
        if ([self.currentNowPlayingArtworkDigest isEqualToString:self.exoLastDigest]) return;

        self.exoLastDigest = [self.currentNowPlayingArtworkDigest copy];
        UIImage *image = [[self currentNowPlayingArtwork] copy];
        if (image) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            data = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        }
    }

    [[EXOObserver sharedInstance] update:@{
        @"media.image": data
    }];
}

%end

%hook SBTelephonyManager

-(void)_setSignalStrengthBars:(unsigned long long)arg1 maxBars:(unsigned long long)arg2 inSubscriptionContext:(id)arg3 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.strength.current": @(arg1),
        @"mobile.strength.max": @(arg2)
    }];
}

-(void)_setSignalStrengthBars:(unsigned long long)arg1 maxBars:(unsigned long long)arg2 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.strength.current": @(arg1),
        @"mobile.strength.max": @(arg2)
    }];
}

-(void)_setOperatorName:(NSString *)arg1 inSubscriptionContext:(id)arg2 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.network": arg1 ?: @""
    }];
}

-(void)_setOperatorName:(NSString *)arg1 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.network": arg1 ?: @""
    }];
}

-(void)_reallySetOperatorName:(NSString *)arg1 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.network": arg1 ?: @""
    }];
}

-(void)setOperatorName:(NSString *)arg1 {
    %orig;
    [[EXOObserver sharedInstance] update:@{
        @"mobile.network": arg1 ?: @""
    }];
}

%end

%hook SBMediaController

-(void)setNowPlayingInfo:(id)arg1 {
    %orig;
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict = (__bridge NSDictionary *)information;

        if (dict) {
            NSMutableDictionary *updateData = [NSMutableDictionary new];

            if ([self nowPlayingApplication]) {
                updateData[@"media.application"] = [[self nowPlayingApplication] bundleIdentifier];
            }

            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate]) {
                updateData[@"media.playing"] = @([dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate] intValue] > 0);
            }
            
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum]) {
                updateData[@"media.album"] = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum] copy];
            }

            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]) {
                updateData[@"media.artist"] = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] copy];
            }
            
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]) {
                updateData[@"media.title"] = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] copy];
            }
            
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime]) {
                updateData[@"media.elapsed"] = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] copy];
            }
            
            if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration]) {
                updateData[@"media.duration"] = [dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] copy];
            }
            
            [[EXOObserver sharedInstance] update:updateData];
        }
    });
}

%end

%hook SBDashBoardViewController

-(void)viewWillAppear:(BOOL)animated {
    %orig;

    [[EXOObserver sharedInstance] startUpdating];
}

%end

static void screenDisplayStatus(CFNotificationCenterRef center, void* o, CFStringRef name, const void* object, CFDictionaryRef userInfo) {
    uint64_t state;
    int token;
    notify_register_check("com.apple.iokit.hid.displayStatus", &token);
    notify_get_state(token, &state);
    notify_cancel(token);
    if (state) {
        [[EXOObserver sharedInstance] startUpdating];
    } else {
        [[EXOObserver sharedInstance] stopUpdating];
    }
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, (CFNotificationCallback)updateChargingStatus, (CFStringRef)@"SBUIACStatusChangedNotification", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)dataRequested, (CFStringRef)@"me.nepeta.exo/request", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)screenDisplayStatus, (CFStringRef)@"com.apple.iokit.hid.displayStatus", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}