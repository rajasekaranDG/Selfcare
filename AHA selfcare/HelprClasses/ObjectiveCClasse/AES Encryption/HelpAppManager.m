//
//  HelpAppManager.m
//  Harbour
//
//  Created by SivaChandran on 30/12/16.
//  Copyright © 2016 Sivachandiran. All rights reserved.
//

#import "HelpAppManager.h"
#import "NSData+AES128.h"
#import "CJSONDeserializer.h"
#import "UIColor+uiGradients.h"

#define kAppAES128_Encryption_Key @"NLP$#SMLPO36!~MN"
#define kAppAES128_Encryption_IV @"XZAQ@PGDSA36~~GS"
#define ISARRAY(X) (X && [X isKindOfClass:[NSArray class]] && [X count] > 0)
#define kAppDeviceID @"RAppDeviceID"
#define KTableDetailName @"TableDetail5.sqlite"
#define KDeleteTableName @"TableDetail4.sqlite"


@implementation HelpAppManager

+ (instancetype)shared
{
    static dispatch_once_t onceToken = 0;
    __strong static HelpAppManager* _sharedObject = nil;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[HelpAppManager alloc] init];
        _sharedObject.appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        [_sharedObject dateFormatterForStartTime];
        NSLog(@"shared instantiated");
    });
    return _sharedObject;
}
-(NSDateFormatter *)dateFormatterForStartTime {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}
-(NSData *)hexToBytes:(NSString *)hex {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hex.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hex substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
#pragma mark -
#pragma mark Gradient
-(CAGradientLayer *)gradientWithcolors:(NSArray *)colors {
    
    UIColor *colorTop = colors[0];
    UIColor *colorBottom = colors[1];
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)colorTop.CGColor,
                       (id)colorBottom.CGColor,
                       nil];
    return gradient;
}
-(CAGradientLayer *)gradientColor :(NSString *)TopString Bottom:(NSString *)BottmString {
    
    UIColor *ColorTop = [UIColor uig_colorWithHexString:TopString];
    UIColor *ColorBottm = [UIColor uig_colorWithHexString:BottmString];
    CAGradientLayer *gradientLayer = [self gradientWithcolors:@[ColorTop,ColorBottm]];
    return gradientLayer;
}
-(NSData *)keyData{
    NSData *DateKey = [@"NLP$#SMLPO36!~MN" dataUsingEncoding:NSUTF8StringEncoding];
    return DateKey;
}
-(NSData *)vLData  {
    NSData *DateKey = [@"XZAQ@PGDSA36~~GS" dataUsingEncoding:NSUTF8StringEncoding];
    return DateKey;
}
-(NSMutableDictionary *)convertJson :(NSData *)DataResponse {
    DataResponse = [DataResponse decryptCipher:DataResponse iv:[self vLData] key:[self keyData] error:nil];
    NSString *stringResponseFinal = [[NSString alloc] initWithData:DataResponse encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    CJSONDeserializer *jsonParser = [[CJSONDeserializer alloc] init];
    NSMutableDictionary *dictionaryResponseDecrypted = [jsonParser deserialize:[stringResponseFinal dataUsingEncoding:NSUTF8StringEncoding] error:&error];
    return dictionaryResponseDecrypted;
}
-(NSString *)jsonString :(NSMutableDictionary *)Params {
    
    NSData *postItemsdata = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil];
    NSString *postItemsJson = [[NSString alloc] initWithData:postItemsdata encoding:NSASCIIStringEncoding];
    return postItemsJson;
}
- (NSMutableDictionary*)sessionData
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dictionarySessionData = [userDefaults objectForKey:kAppDeviceID];
    return dictionarySessionData;
}
- (NSString*)deviceId
{
    NSMutableDictionary* dictionarySessionData = (NSMutableDictionary*)[self sessionData];
    if (dictionarySessionData && [dictionarySessionData valueForKey:@"uniqueIdentifier"] && ![[dictionarySessionData valueForKey:@"uniqueIdentifier"] isEqualToString:@""])
        return [dictionarySessionData valueForKey:@"uniqueIdentifier"];
    else {
        NSMutableDictionary* dictionarySessionDataTemp = [[NSMutableDictionary alloc] init];
        if (dictionarySessionData)
            [dictionarySessionDataTemp addEntriesFromDictionary:dictionarySessionData];
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString* str = (__bridge_transfer NSString*)(CFUUIDCreateString(kCFAllocatorDefault, uuid));
        CFRelease(uuid);
        [dictionarySessionDataTemp setValue:str
                                     forKey:@"uniqueIdentifier"];
        [[NSUserDefaults standardUserDefaults] setValue:dictionarySessionDataTemp
                                                 forKey:kAppDeviceID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return str;
    }
}
-(NSString *)dateConverFormat :(NSString *)Date Format:(NSString *)format DateFormat:(NSString *)DFormat{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DFormat;
    NSDate *yourDate = [dateFormatter dateFromString:Date];
    dateFormatter.dateFormat = format;
    NSString *ConvertDate = [dateFormatter stringFromDate:yourDate];
    
    return ConvertDate;
}
-(NSDictionary *)convertToDictionary :(NSString *)JsonString {
    
    NSError *jsonError;
    NSData *objectData = [JsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&jsonError];
    return jsonDictionary;
}
#pragma mark -
#pragma mark Push Notification
- (void)registerDeviceToken:(NSData*)token
{
    NSString* newToken = [token description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" "
                                                   withString:@""];
    
    NSUserDefaults* NotificationDeviceTokenDetails = [NSUserDefaults standardUserDefaults];
    [NotificationDeviceTokenDetails setValue:newToken
                                      forKey:@"PuskTokenString"];
    [NotificationDeviceTokenDetails synchronize];
    
}

-(int)checkArrayValue : (NSMutableArray *)arrayItems Key:(NSString *)key CheckValue :(NSString *)Value{
    int Count = 100000;
    NSUInteger index = [arrayItems indexOfObjectPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [[(NSDictionary *)obj objectForKey:key] isEqualToString:Value];
    }];
    if (index != NSNotFound) {
        return (int)index;
    }
    return Count;
}
-(BOOL)checkValue:(NSMutableArray *)arrayItems Key:(NSString *)key CheckValue :(NSString *)Value {
    NSString *ValueString = @"";
    NSUInteger index = [arrayItems indexOfObjectPassingTest:^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        return [[(NSDictionary *)obj objectForKey:key] isEqualToString:Value];
    }];
    if (index != NSNotFound) {
        NSMutableDictionary *DetailDic = arrayItems[index];
        ValueString = DetailDic[@"TagCount"];
    }
    return ([ValueString isEqualToString:@""]) ? false : true;
}
-(NSString * )writeImage :(NSString *)stringPathProfilePicture imageData:(NSData *)imageCropped Name:(NSString *)ImageName {
    
    stringPathProfilePicture = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    stringPathProfilePicture = [stringPathProfilePicture stringByAppendingPathComponent:ImageName];
    
    BOOL isSuccess = [imageCropped writeToFile:stringPathProfilePicture atomically:YES];
    return (isSuccess) ? stringPathProfilePicture : @"";
}
#pragma mark - iCloud backup
- (void)removeFileFromiCloudBackup:(NSString *)stringFilePath {
    NSURL *url = [NSURL fileURLWithPath:stringFilePath];
    [self removeFromiCloudBackupWithFileURL:url];
}
- (void)removeFromiCloudBackupWithFileURL:(NSURL *)url {
    NSError *error = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[url path]]) {
        BOOL success = [url setResourceValue:[NSNumber numberWithBool:YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(success){
            NSLog(@"Successful excluding %@ from backup", [url lastPathComponent]);
        }
        else {
            NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
        }
    }
    else {
        NSLog(@"There is not file with name '%@' for excluding from backup", [url lastPathComponent]);
    }
}
-(NSString *)checkDictionaryKey :(NSDictionary *)DetailDic Key:(NSString *)KeyValue {
    NSString *ValueString = @"";
    if ([[DetailDic allKeys] containsObject:KeyValue]) {
        ValueString = DetailDic[KeyValue];
    }
    return ValueString;
}
-(NSMutableDictionary *)checkNullValue :(NSMutableDictionary *)DictionaryDetail {
    NSMutableDictionary *dictionaryDetails = [NSMutableDictionary dictionary];
    NSArray *arrayOfKeys = [DictionaryDetail allKeys];
    for (int i = 0; i < arrayOfKeys.count; i++) {
        NSString *KeyString = arrayOfKeys[i];
        if((DictionaryDetail[KeyString] != [NSNull null]) && (DictionaryDetail[KeyString] != nil)){
            
            [dictionaryDetails setValue:DictionaryDetail[KeyString] forKey:KeyString];
        }
        else {
            [dictionaryDetails setValue:@"" forKey:KeyString];
        }
    }
    return dictionaryDetails;
}
-(NSString *) SubStringMessage : (NSString *)Message {
    NSString *MessageString = [NSString stringWithFormat:@"%@",[Message substringToIndex:[Message length]-1]];
    return MessageString;
}
#pragma SetColor
-(UIColor *)colorWithHexString:(NSString *)hexString withOptacity:(CGFloat )opacity{
    NSString *ColorString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([ColorString length] != 6) {
        return [UIColor colorWithRed:4.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0];
    }
    
    // Brutal and not-very elegant test for non hex-numeric characters
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:ColorString options:NSMatchingReportCompletion range:NSMakeRange(0, [ColorString length])];
    
    if (match != 0) {
        return [UIColor colorWithRed:4.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0];
    }
    
    NSRange rRange = NSMakeRange(0, 2);
    NSString *rComponent = [ColorString substringWithRange:rRange];
    unsigned int rVal = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:rComponent];
    [rScanner scanHexInt:&rVal];
    float rRetVal = (float)rVal / 254;
    
    NSRange gRange = NSMakeRange(2, 2);
    NSString *gComponent = [ColorString substringWithRange:gRange];
    unsigned int gVal = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:gComponent];
    [gScanner scanHexInt:&gVal];
    float gRetVal = (float)gVal / 254;
    
    NSRange bRange = NSMakeRange(4, 2);
    NSString *bComponent = [ColorString substringWithRange:bRange];
    unsigned int bVal = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:bComponent];
    [bScanner scanHexInt:&bVal];
    float bRetVal = (float)bVal / 254;
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:opacity];
}
-(NSString *)convertArrayToJsonString :(NSMutableArray *)ArrayJson {
    
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:ArrayJson options:0 error:nil];
    NSString *postJson = [[NSString alloc] initWithData:postdata encoding:NSUTF8StringEncoding];
    return postJson;
}
-(NSDictionary *)DataConvertToDictinary :(NSData *)data {
    NSError* error = nil;
    NSDictionary* dictionaryDetails = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data
                                                                                     options:0
                                                                                       error:&error];
    return dictionaryDetails;
}
-(NSMutableArray *)InsertBloodPressureDictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"High Pressure(systolic)*",@"Title",@"Number",@"Type",@"systolic",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"systolic",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Low Pressure(Diastolic)*",@"Title",@"Number",@"Type",@"Diastolic",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"diastolic",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Heart Rate*",@"Title",@"Number",@"Type",@"Heart Rate",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"heartRate",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Measurement Date*",@"Title",@"Date",@"Type",@"Measurement Date",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"measurementDate",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Notes",@"Title",@"TextArea",@"Type",@"Notes",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"note",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertBloodGlucoseDictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Blood Glucose*",@"Title",@"Number",@"Type",@"Blood Glucose",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"bloodGlucoseValue",@"addParams", nil],
            
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Blood Glucose Unit",@"Title",@"Dialog_single",@"Type",@"Blood Glucose Unit",@"Hint",@"0",@"RequiredFlag",@"mmol/L",@"Answer",@"bloodGlucoseUnit",@"addParams", nil],

            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Context*",@"Title",@"Dialog_single",@"Type",@"Select",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"context",@"addParams", nil],
            
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Last Meal",@"Title",@"TextEdit",@"Type",@"Pasta,Pizza,Rice with Curry, etc..,",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"beforeMeal",@"addParams", nil],
            
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Medication",@"Title",@"Yes_No",@"Type",@"",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"medication",@"addParams", nil],
            
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Medication Time",@"Title",@"Dialog_single",@"Type",@"Medication Time",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"medicationTime",@"addParams", nil],
            
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Measurement Date*",@"Title",@"Date",@"Type",@"Measurement Date",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"measurementDate",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertWeigtDictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Weight*",@"Title",@"Number",@"Type",@"Weight",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"wgt",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Height(Cms)*",@"Title",@"Number",@"Type",@"Height",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"height",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"BMI",@"Title",@"Number",@"Type",@"BMI",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"bmi",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Measurement Date*",@"Title",@"Date",@"Type",@"Measurement Date",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"measurementDate",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Notes",@"Title",@"TextArea",@"Type",@"Notes",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"note",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertSleepDictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Awaken*",@"Title",@"Number",@"Type",@"No.of times awaken",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"awaken",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Hours Slept*",@"Title",@"Number",@"Type",@"No.of hours slept",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"hoursSlept",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Measurement Date*",@"Title",@"Date",@"Type",@"Measurement Date",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"measurementDate",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertActiviDtyictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Steps*",@"Title",@"Number",@"Type",@"No.of steps during the day",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"steps",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Distance Travelled	",@"Title",@"Number",@"Type",@"Distance Travelled(KM or Miles)",@"Hint",@"0",@"RequiredFlag",@"",@"Answer",@"distanceTraveled",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Measurement Date*",@"Title",@"Date",@"Type",@"Measurement Date",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"measurementDate",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertSportsDictionary {
    
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Sport Name*",@"Title",@"TextEdit",@"Type",@"Sport Name",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"sportName",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Calories*",@"Title",@"Number",@"Type",@"Enter if you know",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"calories",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Sport Start Time*",@"Title",@"Date",@"Type",@"Sport Start Time",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"sportEndTime",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Sport End Time*",@"Title",@"Date",@"Type",@"Sport End Time",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"sportStartTime",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertBloodPressureMonitoringParameters {

    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target High Pressure",@"Title",@"Number",@"Type",@"Target High Pressure (Systolic)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetHighPress",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Low Pressure",@"Title",@"Number",@"Type",@"Target Low Pressure (Diastolic)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetLowPress",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold High Pressure",@"Title",@"Number",@"Type",@"Threshold High Pressure (Systolic)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdHighPress",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Low Pressure",@"Title",@"Number",@"Type",@"Threshold Low Pressure (Diastolic)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdLowPress",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Heart Rate",@"Title",@"Number",@"Type",@"Target Heart Rate",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetHeartRate",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Heart Rate",@"Title",@"Number",@"Type",@"Threshold Heart Rate",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdHeartRate",@"addParams", nil],
            nil];

}
-(NSMutableArray *)InsertBloodGlucoseMonitoringParameters {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Blood Glucose",@"Title",@"Number",@"Type",@"Target Blood Glucose",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetBloodGlucose",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Blood Glucose",@"Title",@"Number",@"Type",@"Threshold Blood Glucose",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdBloodGlucose",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertWeightMonitoringParameters {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target weight Value",@"Title",@"Number",@"Type",@"Target weight Value",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetWeightValue",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold BMI",@"Title",@"Number",@"Type",@"Threshold BMI",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdBMI",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold weight Value",@"Title",@"Number",@"Type",@"Threshold weight Value",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdWeightValue",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertSleepMonitoringParameters {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Awaken",@"Title",@"Number",@"Type",@"Target Awaken",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetAwaken",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target HoursSlept",@"Title",@"Number",@"Type",@"Target HoursSlept",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetHoursSlept",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Awaken",@"Title",@"Number",@"Type",@"Threshold Awaken",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdAwaken",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold HoursSlept",@"Title",@"Number",@"Type",@"Threshold HoursSlept",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdHoursSlept",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertActivityMonitoringParameters {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Distance Travelled",@"Title",@"Number",@"Type",@"Target Distance Travelled",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetDistanceTraveled",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Steps",@"Title",@"Number",@"Type",@"Target Steps",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetSteps",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Distance Travelled",@"Title",@"Number",@"Type",@"Threshold Distance Travelled",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdDistanceTraveled",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Steps",@"Title",@"Number",@"Type",@"Threshold Steps",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdSteps",@"addParams", nil],
            nil];
}
-(NSMutableArray *)InsertSportsMonitoringParameters {

    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Target Calories Burnt",@"Title",@"Number",@"Type",@"Target Calories Burnt",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"targetCaloriesBurn",@"addParams", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Threshold Calories Burnt",@"Title",@"Number",@"Type",@"Threshold Calories Burnt",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"thresholdCaloriesBurnt",@"addParams", nil],
            nil];
}

-(NSMutableArray *)ObesityQuestions {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Who is answering the questions ?",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"answeringQuestion",@"addParams",@"Whos",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Age",@"Title",@"Age",@"Type",@"Age",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"age",@"addParams",@"",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Height(Cms) ?",@"Title",@"Number",@"Type",@"Height (Cms)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"height",@"addParams",@"",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Weight (KG)",@"Title",@"Number",@"Type",@"Weight (KG)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"weight",@"addParams",@"",@"arrayType", nil],
            nil];
}
-(NSMutableArray *)CardiovascularQuestions {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Who is answering the questions ?",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"Me",@"Answer",@"answeringQuestion",@"addParams",@"Whos",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Smoking Status ?",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"smokingStatus",@"addParams",@"YesNo",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"How many cigarettes do you smoke in a day?",@"Title",@"Number",@"Type",@"Cigarettes",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"cigarettes",@"addParams",@"",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Diabetes ?",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"diabetes",@"addParams",@"YesNo",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Systolic (mmHg) ?",@"Title",@"Number",@"Type",@"Systolic (mmHg)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"systolic",@"addParams",@"",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Left ventricular hypertrophy (LVH) is a condition in which the muscle wall of heart's left pumping chamber (ventricle) becomes thickened (hypertrophy). Other conditions, such as heart attack, valve disease and dilated cardiomyopathy, can cause the heart (or the heart cavity) to get bigger.",@"InfoMessage",@"Y",@"Alert",@"LVH",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"lvh",@"addParams",@"YesNo",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Do you have a first-degree relative (father, mother, brother, sister) who had heart disease before age 60",@"InfoMessage",@"Y",@"Alert",@"Family History ",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"familyHistory",@"addParams",@"YesNo",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Total Cholesterol(mmol/L) ?",@"Title",@"Decimal",@"Type",@"Total Cholesterol (mmol/L)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"totalCholastrol",@"addParams",@"",@"arrayType", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"HDL Cholesterol ?",@"Title",@"Decimal",@"Type",@"HDL Cholesterol (mmol/L)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"hdlCholastrol",@"addParams",@"",@"arrayType", nil],
            nil];
}
-(NSMutableArray *)DiabetesQuestions {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Have you been diagnosed with diabetes ?",@"Title",@"Dialog_single",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"N0",@"Answer",@"answeringQuestion",@"addParams",@"answeringQuestionarray",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Age (25-84): ?",@"Title",@"Age",@"Type",@"Please select",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"age",@"addParams",@"",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Sex: ?",@"Title",@"Dialog_single",@"Type",@"Sex",@"Hint",@"1",@"RequiredFlag",@"Male",@"Answer",@"sex",@"addParams",@"gender",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Ethnicity ?",@"Title",@"Dialog_single",@"Type",@"Height(Cms) ?",@"Hint",@"1",@"RequiredFlag",@"White or not stated",@"Answer",@"ethnicity",@"addParams",@"ethnicity",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Smoking status ?",@"Title",@"Number",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"smokingStatus",@"addParams",@"number",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Do Immediate family(mother,father,brother or sister) have diabetes ?",@"Title",@"Dialog_single",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"familyHistory",@"addParams",@"YesNo",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Have you had a heart attack, angina, stroke or TIA ?",@"Title",@"Dialog_single",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"diseaseHistory",@"addParams",@"YesNo",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Do you have high blood pressure requiring treatment ?",@"Title",@"Dialog_single",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"highBpHistory",@"addParams",@"YesNo",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Are you on regular steroid tablets ?",@"Title",@"Dialog_single",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"0",@"Answer",@"steroidQuestion",@"addParams",@"YesNo",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Height(Cms) ?",@"Title",@"Number",@"Type",@"Height(Cms)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"heightQuestion",@"addParams",@"",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Weight(KG) ?",@"Title",@"Number",@"Type",@"Weight (KG)",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"weightQuestion",@"addParams",@"",@"arrayType", @"Y",@"nextButton", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"Calculate risk over(in Years) ?",@"Title",@"Dialog_single",@"Type",@"",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"timePeriod",@"addParams",@"number",@"arrayType", @"Y",@"nextButton", nil],
            nil];
}
-(NSMutableArray *)genderarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Male",@"Title",@"Y",@"Selected", @"Male",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Female",@"Title",@"N",@"Selected", @"Female",@"Answer", nil],
            nil];
}
-(NSMutableArray *)ethnicityarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"White or not stated",@"Title",@"Y",@"Selected", @"1",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Indian",@"Title",@"N",@"Selected", @"2",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Pakistani",@"Title",@"N",@"Selected", @"3",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Bangladeshi",@"Title",@"N",@"Selected", @"4",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Other Indian",@"Title",@"N",@"Selected", @"5",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Black Caribbean",@"Title",@"N",@"Selected", @"6",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Black African",@"Title",@"N",@"Selected", @"7",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Chinese",@"Title",@"N",@"Selected", @"8",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Other ethnic group",@"Title",@"N",@"Selected", @"9",@"Answer", nil],
            nil];
}
-(NSMutableArray *)smokingarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"non-smoker",@"Title",@"Y",@"Selected", @"1",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"ex-smoker",@"Title",@"N",@"Selected", @"2",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"light smoker(less than 10)",@"Title",@"N",@"Selected", @"3",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Moderate smoker(10 to 19)",@"Title",@"N",@"Selected", @"4",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Heavy smoker(20 or over)",@"Title",@"N",@"Selected", @"5 Healthcare personnel",@"Answer", nil],
            nil];
}
-(NSMutableArray *)numberarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"Title",@"Y",@"Selected", @"0",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"Title",@"N",@"Selected", @"1",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2",@"Title",@"N",@"Selected", @"2",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3",@"Title",@"N",@"Selected", @"3",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"4",@"Title",@"N",@"Selected", @"4",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5",@"Title",@"N",@"Selected", @"5",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"6",@"Title",@"Y",@"Selected", @"6",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"7",@"Title",@"N",@"Selected", @"7",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"8",@"Title",@"N",@"Selected", @"8",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"9",@"Title",@"N",@"Selected", @"9",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"10",@"Title",@"N",@"Selected", @"10",@"Answer", nil],
            nil];
}
-(NSMutableArray *)whoAnsweringarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Me",@"Title",@"Y",@"Selected", @"Me",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Relative",@"Title",@"N",@"Selected", @"Relative",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Doctor",@"Title",@"N",@"Selected", @"Doctor",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Nurse",@"Title",@"N",@"Selected", @"Nurse",@"Answer", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Other Healthcare personnel",@"Title",@"N",@"Selected", @"Other Healthcare personnel",@"Answer", nil],
            nil];
}
-(NSMutableArray *)yesNoAnsweringarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"No",@"Title",@"N",@"Selected", @"0",@"Answer",nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Yes",@"Title",@"Y",@"Selected", @"1",@"Answer",nil],
            nil];
}
-(NSMutableArray *)answeringQuestionarray {
    return [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"No",@"Title",@"Y",@"Selected", @"No",@"Answer",nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Yes",@"Title",@"N",@"Selected", @"Yes",@"Answer",nil],
            nil];
}
-(NSMutableDictionary *)AddQuestions {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"InfoMessage",@"N",@"Alert",@"How many cigarettes do you smoke in a day?",@"Title",@"Number",@"Type",@"Cigarettes",@"Hint",@"1",@"RequiredFlag",@"",@"Answer",@"cigarettes",@"addParams",@"",@"arrayType", nil];
}
-(NSMutableArray *)GetLast7Days {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 7; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:-(i * (60 * 60 * 24)) sinceDate:now];
        [results addObject:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]]];
    }
    return results;
}
-(NSMutableArray *)GetTwoWeeksDays {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *now = [NSDate date];
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 0; i < 14; i++)
    {
        NSDate *date = [NSDate dateWithTimeInterval:-(i * (60 * 60 * 24)) sinceDate:now];
        [results addObject:[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]]];
    }
    
    return results;
}

-(NSDate *)ThisMonthStartdate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    components.day = 1;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    return firstDayOfMonthDate;
}
-(NSDate *)ThisMonthLastdate {
    
    NSDate *curDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday fromDate:curDate];
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *tDateMonth = [calendar dateFromComponents:comps];
    return tDateMonth;
}
-(NSDate *)LastMonthStartDate {
    
    NSCalendar *cal         = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                     fromDate:[NSDate date]];
    comps.month             -= 1;
    comps.day             = 1;
    return [cal dateFromComponents:comps];
}
-(NSDate *)LastMonthLastDate {
    
    NSCalendar *cal         = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                     fromDate:[NSDate date]];
    [comps setMonth:[comps month]];
    comps.day             = 0;
    return [cal dateFromComponents:comps];
}
-(NSDate *)ThisYearStartdate {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:[NSDate date]];
    components.day = -365;
    NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];
    return firstDayOfMonthDate;
}
-(double)ConvertMilliSeconds :(NSString *)MeasurementDate {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:MeasurementDate];
    
    //// 1419151980000 -- milli seconds
    NSTimeInterval timeInMiliseconds = [date timeIntervalSince1970]*1000;
    return timeInMiliseconds;
}
-(double)ConvertMilliSeconds2 :(NSString *)MeasurementDate {
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:MeasurementDate];
    
    //// 1419151980000 -- milli seconds
    NSTimeInterval timeInMiliseconds = [date timeIntervalSince1970]*1000;
    return timeInMiliseconds;
}
-(CGFloat)checkMaximumNumber :(NSArray *)arrayItems {
    arrayItems = [arrayItems sortedArrayUsingSelector:@selector(compare:)];
    return [[arrayItems lastObject] doubleValue];
}
-(NSMutableArray *)MonitoringArray {
    NSMutableArray *monitoringArray = [NSMutableArray init];
    
    NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
    [detailDic setObject:@"blood-pressure.png" forKey:@"Image"];
    [detailDic setObject:@"Blood Pressure" forKey:@"Title"];
    [monitoringArray addObject:detailDic];
    
    NSMutableDictionary *detailDic2 = [NSMutableDictionary dictionary];
    [detailDic2 setObject:@"blood-glucose.png"forKey:@"Image"];
    [detailDic2 setObject:@"Blood Glucose" forKey:@"Title"];
    [monitoringArray addObject:detailDic2];
    
    NSMutableDictionary *detailDic3 = [NSMutableDictionary dictionary];
    [detailDic3 setObject:@"weight.png" forKey:@"Image"];
    [detailDic3 setObject:@"Weight" forKey:@"Title"];
    [monitoringArray addObject:detailDic3];
    
    NSMutableDictionary *detailDic4 = [NSMutableDictionary dictionary];
    [detailDic4 setObject:@"sleep.png" forKey:@"Image"];
    [detailDic4 setObject:@"Sleep" forKey:@"Title"];
    [monitoringArray addObject:detailDic4];
    
    NSMutableDictionary *detailDic5 = [NSMutableDictionary dictionary];
    [detailDic5 setObject:@"activity.png" forKey:@"Image"];
    [detailDic5 setObject:@"Activity" forKey:@"Title"];
    [monitoringArray addObject:detailDic5];
    
    NSMutableDictionary *detailDic6 = [NSMutableDictionary dictionary];
    [detailDic6 setObject:@"sports.png" forKey:@"Image"];
    [detailDic6 setObject:@"Sports" forKey:@"Title"];
    [monitoringArray addObject:detailDic6];
    
    return monitoringArray;
}

@end
