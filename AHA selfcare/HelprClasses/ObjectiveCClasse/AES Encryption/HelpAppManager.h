//
//  HelpAppManager.h
//  Harbour
//
//  Created by SivaChandran on 30/12/16.
//  Copyright © 2016 Sivachandiran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <UIKit/UIKit.h>

typedef void(^CreateBlock)(BOOL status);
typedef void(^CompletionBlock)(BOOL status, int RefId);
typedef void(^ArrayList)(NSMutableArray* arrayOfItems);
typedef void(^CompleteBlock)(BOOL Status);

@interface HelpAppManager : NSObject {
    
    sqlite3	*database;
    
}
@property (strong, nonatomic) NSString* appVersion;
@property (strong, nonatomic) NSString * databasepath;
@property (strong, nonatomic) NSString* FormTypeId;

+ (instancetype)shared;
-(NSDateFormatter *)dateFormatterForStartTime;
-(NSData *)hexToBytes:(NSString *)hex;
-(CAGradientLayer *)gradientWithcolors:(NSArray *)colors;
-(CAGradientLayer *)gradientColor :(NSString *)TopString Bottom:(NSString *)BottomString;
-(NSData *)keyData;
-(NSData *)vLData;
-(NSMutableDictionary *)convertJson :(NSData *)DataResponse;
-(NSString *)jsonString :(NSMutableDictionary *)Params;
- (NSMutableDictionary*)sessionData;
- (NSString*)deviceId;
-(NSString *)dateConverFormat :(NSString *)Date Format:(NSString *)format DateFormat:(NSString *)DFormat;
-(NSDictionary *)convertToDictionary :(NSString *)JsonString;
- (void)registerDeviceToken:(NSData*)token;
-(int)checkArrayValue : (NSMutableArray *)arrayItems Key:(NSString *)key CheckValue :(NSString *)Value;
-(BOOL)checkValue:(NSMutableArray *)arrayItems Key:(NSString *)key CheckValue :(NSString *)Value;
-(NSString * )writeImage :(NSString *)stringPathProfilePicture imageData:(NSData *)imageCropped Name:(NSString *)ImageName;
- (void)removeFileFromiCloudBackup:(NSString *)stringFilePath;
- (void)removeFromiCloudBackupWithFileURL:(NSURL *)url;
-(NSString *)checkDictionaryKey :(NSDictionary *)DetailDic Key:(NSString *)KeyValue;
-(NSMutableDictionary *)checkNullValue :(NSMutableDictionary *)DictionaryDetail;
-(UIColor *)colorWithHexString:(NSString *)hexString withOptacity:(CGFloat )opacity;
-(NSString *)convertArrayToJsonString :(NSMutableArray *)ArrayJson;
-(NSDictionary *)DataConvertToDictinary :(NSData *)data;
-(NSMutableArray *)InsertAssessmentDictionary;
-(NSString *) SubStringMessage : (NSString *)Message;
-(NSMutableArray *)InsertBloodPressureDictionary;
-(NSMutableArray *)InsertBloodGlucoseDictionary;
-(NSMutableArray *)InsertWeigtDictionary;
-(NSMutableArray *)InsertSleepDictionary;
-(NSMutableArray *)InsertActiviDtyictionary;
-(NSMutableArray *)InsertSportsDictionary;

-(NSMutableArray *)InsertBloodPressureMonitoringParameters;
-(NSMutableArray *)InsertBloodGlucoseMonitoringParameters;
-(NSMutableArray *)InsertWeightMonitoringParameters;
-(NSMutableArray *)InsertSleepMonitoringParameters;
-(NSMutableArray *)InsertActivityMonitoringParameters;
-(NSMutableArray *)InsertSportsMonitoringParameters;

-(NSMutableArray *)ObesityQuestions;
-(NSMutableArray *)CardiovascularQuestions;

-(NSMutableArray *)DiabetesQuestions;
-(NSMutableDictionary *)diabetesDic;

-(NSMutableArray *)whoAnsweringarray;
-(NSMutableArray *)yesNoAnsweringarray;
-(NSMutableArray *)genderarray;
-(NSMutableArray *)ethnicityarray;
-(NSMutableArray *)smokingarray;
-(NSMutableArray *)numberarray;
-(NSMutableArray *)answeringQuestionarray;
-(NSMutableDictionary *)AddQuestions;

-(NSMutableArray *)GetLast7Days;
-(NSMutableArray *)GetTwoWeeksDays;
-(NSDate *)ThisMonthStartdate;
-(NSDate *)ThisMonthLastdate ;
-(NSDate *)LastMonthStartDate;
-(NSDate *)LastMonthLastDate;
-(NSDate *)ThisYearStartdate;
-(double)ConvertMilliSeconds :(NSString *)MeasurementDate;
-(double)ConvertMilliSeconds2 :(NSString *)MeasurementDate;
-(CGFloat)checkMaximumNumber :(NSArray *)arrayItems;
-(NSMutableArray *)MonitoringArray;

@end
