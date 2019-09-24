@interface SBApplication : NSObject

@property (nonatomic,readonly) NSString * bundleIdentifier;

@end

@interface SBMediaController : NSObject

@property (nonatomic,readonly) SBApplication * nowPlayingApplication;
-(id)_nowPlayingInfo;

@end

@interface MPUNowPlayingController : UIImageView

@property (nonatomic, retain) NSString *exoLastDigest;
@property (nonatomic, readonly) NSString *currentNowPlayingArtworkDigest;
@property (nonatomic) bool shouldUpdateNowPlayingArtwork;
@property (nonatomic, readonly) double currentDuration;
@property (nonatomic, readonly) double currentElapsed;

- (UIImage*)currentNowPlayingArtwork;

@end

@interface SBUIController : NSObject

+(instancetype)sharedInstanceIfExists;
-(BOOL)isOnAC;
-(int)batteryCapacityAsPercentage;

@end

@interface MRContentItem : NSObject

-(id)dictionaryRepresentation;

@end

@interface SBTelephonyManager : NSObject

+(id)sharedTelephonyManager;
-(BOOL)_pretendingToSearch;
-(BOOL)hasCellularTelephony;
-(int)dataConnectionType;
-(BOOL)isUsingVPNConnection;
-(int)signalStrengthBars;
-(id)operatorName;


@end

@interface SBWiFiManager : NSObject

-(BOOL)isPowered;
-(BOOL)isPrimaryInterface;
-(id)currentNetworkName;
-(void)_powerStateDidChange;
-(void)_linkDidChange;
-(void)updateDevicePresence;
-(void)_lock_spawnManagerCallbackThread;
-(void)_updateWiFiDevice;
-(void)_runManagerCallbackThread;
-(void)_updateCurrentNetwork;
-(void)updateSignalStrength;
-(void)_updateWiFiState;
-(void)updateSignalStrengthFromRawRSSI:(int)arg1 andScaledRSSI:(float)arg2 ;
-(int)signalStrengthRSSI;
-(void)setWiFiEnabled:(BOOL)arg1 ;
-(int)signalStrengthBars;
-(BOOL)wiFiEnabled;

@end

@interface WFLocation : NSObject

@property (assign) long long archiveVersion;                                   //@synthesize archiveVersion=_archiveVersion - In the implementation block
@property (nonatomic,copy) NSString * city;                                    //@synthesize city=_city - In the implementation block
@property (nonatomic,copy) NSString * county;                                  //@synthesize county=_county - In the implementation block
@property (nonatomic,copy) NSString * state;                                   //@synthesize state=_state - In the implementation block
@property (nonatomic,copy) NSString * stateAbbreviation;                       //@synthesize stateAbbreviation=_stateAbbreviation - In the implementation block
@property (nonatomic,copy) NSString * country;                                 //@synthesize country=_country - In the implementation block
@property (nonatomic,copy) NSString * countryAbbreviation;                     //@synthesize countryAbbreviation=_countryAbbreviation - In the implementation block
@property (nonatomic,copy) NSString * weatherDisplayName;                      //@synthesize weatherDisplayName=_weatherDisplayName - In the implementation block
@property (nonatomic,copy) NSString * locationID;                              //@synthesize locationID=_locationID - In the implementation block
@property (nonatomic,copy) NSTimeZone * timeZone;                              //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,copy) NSString * displayName;                             //@synthesize displayName=_displayName - In the implementation block
@property (nonatomic,copy) NSDate * creationDate;                              //@synthesize creationDate=_creationDate - In the implementation block
@property (nonatomic,readonly) BOOL shouldQueryForAirQualityData; 
+(BOOL)supportsSecureCoding;
+(long long)currentArchiveVersion;
+(id)knownKeys;
+(id)locationsByConsolidatingDuplicates:(id)arg1 originalOrder:(id)arg2 ;
+(id)locationsByConsolidatingDuplicatesInBucket:(id)arg1 ;
+(id)locationsByFilteringDuplicates:(id)arg1 ;
-(NSString *)country;
-(void)setCountry:(NSString *)arg1 ;
-(NSString *)city;
-(void)setCity:(NSString *)arg1 ;
-(NSString *)weatherDisplayName;
-(void)setDisplayName:(NSString *)arg1 ;
-(id)initWithMapItem:(id)arg1 ;
-(id)summary;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(NSString *)state;
-(void)setState:(NSString *)arg1 ;
-(void)setTimeZone:(NSTimeZone *)arg1 ;
-(id)copyWithZone:(NSZone*)arg1 ;
-(NSTimeZone *)timeZone;
-(NSString *)displayName;
-(NSDate *)creationDate;
-(void)setCreationDate:(NSDate *)arg1 ;
-(void)setWeatherDisplayName:(NSString *)arg1 ;
-(void)setCounty:(NSString *)arg1 ;
-(id)summaryThatIsCompact:(BOOL)arg1 ;
-(NSString *)county;
-(NSString *)stateAbbreviation;
-(long long)archiveVersion;
-(void)setStateAbbreviation:(NSString *)arg1 ;
-(void)setLocationID:(NSString *)arg1 ;
-(void)setArchiveVersion:(long long)arg1 ;
-(BOOL)isDayForDate:(id)arg1 ;
-(id)initWithSearchResponse:(id)arg1 ;
-(id)localDataRepresentation;
-(id)initWithLocalDataRepresentation:(id)arg1 ;
-(id)cloudDictionaryRepresentation;
-(id)initWithCloudDictionaryRepresentation:(id)arg1 ;
-(void)setCountryAbbreviation:(NSString *)arg1 ;
-(id)sunriseForDate:(id)arg1 ;
-(id)sunsetForDate:(id)arg1 ;
-(NSString *)locationID;
-(NSString *)countryAbbreviation;
-(BOOL)isDay;
-(BOOL)shouldQueryForAirQualityData;
-(id)initWithPlacemark:(id)arg1 ;
@end

@interface WFTemperature : NSObject

@property (assign,nonatomic) double celsius; 
@property (assign,nonatomic) double fahrenheit; 
@property (assign,nonatomic) double kelvin; 
+(BOOL)supportsSecureCoding;
-(double)celsius;
-(double)fahrenheit;
-(double)kelvin;
-(id)init;
-(id)initWithCoder:(id)arg1 ;
-(void)encodeWithCoder:(id)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)_setValue:(double)arg1 forUnit:(int)arg2 ;
-(void)_resetTemperatureValues;
-(BOOL)_unitIsHydrated:(int)arg1 outputValue:(out double*)arg2 ;
-(double)temperatureForUnit:(int)arg1 ;
-(id)initWithTemperatureUnit:(int)arg1 value:(double)arg2 ;
-(void)setCelsius:(double)arg1 ;
-(void)setKelvin:(double)arg1 ;
-(void)setFahrenheit:(double)arg1 ;
-(BOOL)isEqualToTemperature:(id)arg1 ;

@end

@interface WADayForecast : NSObject

@property (nonatomic,copy) WFTemperature * high;                        //@synthesize high=_high - In the implementation block
@property (nonatomic,copy) WFTemperature * low;                         //@synthesize low=_low - In the implementation block
@property (assign,nonatomic) unsigned long long icon;                   //@synthesize icon=_icon - In the implementation block
@property (assign,nonatomic) unsigned long long dayOfWeek;              //@synthesize dayOfWeek=_dayOfWeek - In the implementation block
@property (assign,nonatomic) unsigned long long dayNumber;              //@synthesize dayNumber=_dayNumber - In the implementation block
+(id)dayForecastForLocation:(id)arg1 conditions:(id)arg2 ;
-(void)setDayOfWeek:(unsigned long long)arg1 ;
-(unsigned long long)dayOfWeek;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(id)copyWithZone:(NSZone*)arg1 ;
-(void)setIcon:(unsigned long long)arg1 ;
-(unsigned long long)icon;
-(WFTemperature *)high;
-(void)setHigh:(WFTemperature *)arg1 ;
-(WFTemperature *)low;
-(void)setLow:(WFTemperature *)arg1 ;
-(long long)compareDayNumberToDayForecast:(id)arg1 ;
-(void)setDayNumber:(unsigned long long)arg1 ;
-(unsigned long long)dayNumber;

@end

@interface WAHourlyForecast : NSObject

@property (assign,nonatomic) unsigned long long eventType;              //@synthesize eventType=_eventType - In the implementation block
@property (nonatomic,copy) NSString * time;                             //@synthesize time=_time - In the implementation block
@property (assign,nonatomic) long long hourIndex;                       //@synthesize hourIndex=_hourIndex - In the implementation block
@property (nonatomic,retain) WFTemperature * temperature;               //@synthesize temperature=_temperature - In the implementation block
@property (nonatomic,copy) NSString * forecastDetail;                   //@synthesize forecastDetail=_forecastDetail - In the implementation block
@property (assign,nonatomic) long long conditionCode;                   //@synthesize conditionCode=_conditionCode - In the implementation block
@property (assign,nonatomic) float percentPrecipitation;                //@synthesize percentPrecipitation=_percentPrecipitation - In the implementation block
+(long long)TimeValueFromString:(id)arg1 ;
+(id)hourlyForecastForLocation:(id)arg1 conditions:(id)arg2 sunriseDateComponents:(id)arg3 sunsetDateComponents:(id)arg4 ;
-(void)setTemperature:(WFTemperature *)arg1 ;
-(NSString *)time;
-(void)setTime:(NSString *)arg1 ;
-(void)setEventType:(unsigned long long)arg1 ;
-(BOOL)isEqual:(id)arg1 ;
-(unsigned long long)hash;
-(id)description;
-(id)copyWithZone:(NSZone*)arg1 ;
-(unsigned long long)eventType;
-(long long)conditionCode;
-(void)setConditionCode:(long long)arg1 ;
-(void)setForecastDetail:(NSString *)arg1 ;
-(void)setPercentPrecipitation:(float)arg1 ;
-(float)percentPrecipitation;
-(NSString *)forecastDetail;
-(void)setHourIndex:(long long)arg1 ;
-(long long)hourIndex;
-(WFTemperature *)temperature;
@end

@interface City : NSObject

@property (readonly) NSDictionary * urlComponents; 
@property (nonatomic,retain) WFLocation * wfLocation;                                    //@synthesize wfLocation=_wfLocation - In the implementation block
@property (nonatomic,retain) NSTimeZone * timeZone;                                      //@synthesize timeZone=_timeZone - In the implementation block
@property (nonatomic,retain) NSError * lastUpdateError;                                  //@synthesize lastUpdateError=_lastUpdateError - In the implementation block
@property (assign,nonatomic) unsigned long long lastUpdateStatus;                        //@synthesize lastUpdateStatus=_lastUpdateStatus - In the implementation block
@property (assign,nonatomic) BOOL isUpdating;                                            //@synthesize isUpdating=_isUpdating - In the implementation block
@property (assign,nonatomic) BOOL isRequestedByFrameworkClient;                          //@synthesize isRequestedByFrameworkClient=_isRequestedByFrameworkClient - In the implementation block
@property (assign,nonatomic) BOOL lockedForDemoMode;                                     //@synthesize lockedForDemoMode=_lockedForDemoMode - In the implementation block
@property (assign,nonatomic) long long updateInterval;                                   //@synthesize updateInterval=_updateInterval - In the implementation block
@property (nonatomic,retain) NSTimer * autoUpdateTimer;                                  //@synthesize autoUpdateTimer=_autoUpdateTimer - In the implementation block
@property (nonatomic,copy) NSString * updateTimeString;                                  //@synthesize updateTimeString=_updateTimeString - In the implementation block
@property (nonatomic,retain) NSHashTable * cityUpdateObservers;                          //@synthesize cityUpdateObservers=_cityUpdateObservers - In the implementation block
@property (nonatomic,readonly) BOOL timeZoneIsFresh; 
@property (nonatomic,copy) NSString * fullName;                                          //@synthesize fullName=_fullName - In the implementation block
@property (assign,nonatomic) BOOL isLocalWeatherCity;                                    //@synthesize isLocalWeatherCity=_isLocalWeatherCity - In the implementation block
@property (assign,nonatomic) BOOL transient;                          //@synthesize transient=_transient - In the implementation block
@property (nonatomic,copy) NSString * woeid;                                             //@synthesize woeid=_woeid - In the implementation block
@property (nonatomic,copy) NSString * name;                                              //@synthesize name=_name - In the implementation block
@property (nonatomic,readonly) NSString * locationID; 
@property (nonatomic,copy) NSString * state;                                             //@synthesize state=_state - In the implementation block
@property (nonatomic,copy) NSString * ISO3166CountryAbbreviation;                        //@synthesize ISO3166CountryAbbreviation=_ISO3166CountryAbbreviation - In the implementation block
@property (nonatomic,retain) WFTemperature * temperature;                                //@synthesize temperature=_temperature - In the implementation block
@property (nonatomic,retain) WFTemperature * feelsLike;                                  //@synthesize feelsLike=_feelsLike - In the implementation block
@property (assign,nonatomic) long long conditionCode;                                    //@synthesize conditionCode=_conditionCode - In the implementation block
@property (assign,nonatomic) unsigned long long observationTime;                         //@synthesize observationTime=_observationTime - In the implementation block
@property (assign,nonatomic) unsigned long long sunsetTime;                              //@synthesize sunsetTime=_sunsetTime - In the implementation block
@property (assign,nonatomic) unsigned long long sunriseTime;                             //@synthesize sunriseTime=_sunriseTime - In the implementation block
@property (assign,nonatomic) unsigned long long moonPhase;                               //@synthesize moonPhase=_moonPhase - In the implementation block
@property (assign,nonatomic) unsigned long long uvIndex;              //@synthesize uvIndex=_uvIndex - In the implementation block
@property (assign,nonatomic) double precipitationPast24Hours;                            //@synthesize precipitationPast24Hours=_precipitationPast24Hours - In the implementation block
@property (nonatomic,copy) NSURL * link;                                                 //@synthesize link=_link - In the implementation block
@property (nonatomic,copy) NSURL * deeplink;                                             //@synthesize deeplink=_deeplink - In the implementation block
@property (assign,nonatomic) double longitude; 
@property (assign,nonatomic) double latitude; 
@property (nonatomic,retain) NSDate * timeZoneUpdateDate;                                //@synthesize timeZoneUpdateDate=_timeZoneUpdateDate - In the implementation block
@property (nonatomic,retain) NSDate * updateTime;                                        //@synthesize updateTime=_updateTime - In the implementation block
@property (assign,nonatomic) float windChill;                                            //@synthesize windChill=_windChill - In the implementation block
@property (assign,nonatomic) float windDirection;                                        //@synthesize windDirection=_windDirection - In the implementation block
@property (assign,nonatomic) float windSpeed;                                            //@synthesize windSpeed=_windSpeed - In the implementation block
@property (assign,nonatomic) float humidity;                                             //@synthesize humidity=_humidity - In the implementation block
@property (assign,nonatomic) float visibility;                                           //@synthesize visibility=_visibility - In the implementation block
@property (assign,nonatomic) float pressure;                                             //@synthesize pressure=_pressure - In the implementation block
@property (assign,nonatomic) unsigned long long pressureRising;                          //@synthesize pressureRising=_pressureRising - In the implementation block
@property (assign,nonatomic) float dewPoint;                                             //@synthesize dewPoint=_dewPoint - In the implementation block
@property (assign,nonatomic) float heatIndex;                                            //@synthesize heatIndex=_heatIndex - In the implementation block
@property (nonatomic,retain) NSNumber * airQualityIdx;                                   //@synthesize airQualityIdx=_airQualityIdx - In the implementation block
@property (nonatomic,retain) NSNumber * airQualityCategory;                              //@synthesize airQualityCategory=_airQualityCategory - In the implementation block
@property (assign,nonatomic) BOOL isDay;                                                 //@synthesize isDay=_isDay - In the implementation block
@property (assign,nonatomic) BOOL autoUpdate;                                            //@synthesize autoUpdate=_autoUpdate - In the implementation block
@property (nonatomic,copy) NSArray * hourlyForecasts;                                    //@synthesize hourlyForecasts=_hourlyForecasts - In the implementation block
@property (nonatomic,copy) NSArray * dayForecasts;                                       //@synthesize dayForecasts=_dayForecasts - In the implementation block
-(id)naturalLanguageDescription;

@end

@interface WeatherPreferences : NSObject
-(int)loadDefaultSelectedCity;
-(id)loadDefaultSelectedCityID;
-(int)loadActiveCity;
+(id)sharedPreferences;
-(City *)localWeatherCity;
-(BOOL)isCelsius;
-(id)loadSavedCities;
-(id)_defaultCities;

@end