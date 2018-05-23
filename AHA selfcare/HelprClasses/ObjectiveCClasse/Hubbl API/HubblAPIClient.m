//
//  APIBlocks.m
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import "HubblAPIClient.h"
#import "HAPIOperation.h"

@interface HubblAPIClient ()
@property (nonatomic,strong) NSOperationQueue *queue;
@end

@implementation HubblAPIClient

+ (instancetype)shared {
    
    static HubblAPIClient *_apiBlocks = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiBlocks = [[HubblAPIClient alloc] init];
    });
    return _apiBlocks;
}

-(void) cancelAPIOperation {
    for (NSOperation* o in [self.queue operations]) {
        if ([o isKindOfClass:[HAPIOperation class]]) {
            [o cancel];
        }
    }
}


-(id) init {
    
    self = [super init];
    if (self) {
//        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

-(NSOperationQueue *) queue {
    
    return [[NSOperationQueue alloc] init];
}


-(void)postPath:(NSString *) path  params : (NSDictionary *) args completionBlock : (HAPIResponseHandler) block {
    
    if (self.queue) {
        [self.queue addOperation:[self operationForCall:path
                                                 method:HAPIHTTPMethodPOST
                                                   args:args
                                               delegate:[HAPIBlockDelegate delegateWithResponseHandler:block]]];
    }
    
}
-(void)getPath :(NSString *) path  params : (NSDictionary *) args completionBlock : (HAPIResponseHandler) block {
    if (self.queue) {
        [self.queue addOperation:[self operationForCall:path
                                                 method:HAPIHTTPMethodGET
                                                   args:args
                                               delegate:[HAPIBlockDelegate delegateWithResponseHandler:block]]];
    }
}

-(void) ImageFilePostAtPath : (NSString *) filePath
               forAPIMethod : (HAPIHttpMethod) apimethod
                 RequestURL : (NSString *) apiURL
                      params: (NSDictionary *) args
                        Name: (NSString *) ImageName
                        Type: (NSString *) ImageType
             completionBlock:(HAPIResponseHandler) block; {
    
    if (self.queue) {
        [self.queue addOperation:[self operationForImageUpload:filePath
                                                  forAPIMethod:apimethod
                                                    RequestURL:apiURL
                                                        params:args
                                                          Name:ImageName
                                                          Type:ImageType
                                                      delegate:[HAPIBlockDelegate delegateWithResponseHandler:block]]];
    }
    
}

-(void) MultiImageFilePostAtPath : (NSString *) filePath
               forAPIMethod : (HAPIHttpMethod) apimethod
                 RequestURL : (NSString *) apiURL
                      params: (NSDictionary *) args
                        ImageList: (NSMutableArray *) ImageArray
             completionBlock:(HAPIResponseHandler) block; {
    
    if (self.queue) {
        [self.queue addOperation:[self operationForMultiImageUpload:filePath
                                                  forAPIMethod:apimethod
                                                    RequestURL:apiURL
                                                        params:args
                                                          ImageList:ImageArray
                                                      delegate:[HAPIBlockDelegate delegateWithResponseHandler:block]]];
    }
    
}

-(NSOperation *) operationForCall : (NSString *) apiurl
                           method : (HAPIHttpMethod) type
                             args : (NSDictionary *) arguments
                 delegate : (id<HubblAPIDelegate>) mdelegate {
    
    
    HAPIOperation *operation = [[HAPIOperation alloc] initWithHubblOperation:apiurl
                                                             APIMethod:type
                                                             arguments:arguments];
    
    operation.delegate = mdelegate;
    return operation;
    
}

-(NSOperation *) operationForImageUpload : (NSString *) fileURL
                            forAPIMethod : (HAPIHttpMethod) apimethod
                              RequestURL : (NSString *) apiURL
                                  params : (NSDictionary *) args
                                    Name : (NSString *) ImageName
                                    Type : (NSString *) ImageType
                                delegate : (id<HubblAPIDelegate>)mDelegate {
    
    HAPIOperation *operation = [[HAPIOperation alloc] initWithImageUploadOperation:fileURL
                                                                     apiRequestURL:apiURL
                                                                        imageName :ImageName
                                                                        imageType :ImageType
                                                                         APIMethod:apimethod
                                                                         arguments:args];
    operation.delegate = mDelegate;
    return operation;
    
}

-(NSOperation *) operationForMultiImageUpload : (NSString *) fileURL
                            forAPIMethod : (HAPIHttpMethod) apimethod
                              RequestURL : (NSString *) apiURL
                                  params : (NSDictionary *) args
                                    ImageList : (NSMutableArray *) ImageArray
                                delegate : (id<HubblAPIDelegate>)mDelegate {
    
    HAPIOperation *operation = [[HAPIOperation alloc] initWithMultiImageUploadOperation:fileURL
                                                                     apiRequestURL:apiURL
                                                                        ImageList :ImageArray
                                                                         APIMethod:apimethod
                                                                         arguments:args];
    operation.delegate = mDelegate;
    return operation;
    
}

+(NSString *) encodeForURL:(NSString *)urlStr {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)urlStr,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

+(NSString *) decodeForURL:(NSString *)urlStr {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)urlStr,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
	return result;
}
- (NSMutableDictionary*)sessionData
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dictionarySessionData = [userDefaults objectForKey:@"RAppDeviceID"];
    return dictionarySessionData;
}
- (NSString*)DeviceId
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
                                                 forKey:@"RAppDeviceID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return str;
    }
}

- (BOOL)isDictionary:(id)response
{
    return (response && [response isKindOfClass:[NSDictionary class]] && [[response allKeys] count] > 0);
}

@end


@implementation HAPIBlockDelegate


+(id) delegateWithResponseHandler : (HAPIResponseHandler) handler {
    HAPIBlockDelegate *delegate = [[self alloc] init];
    delegate.responseHandler = [handler copy];
    return delegate;
}

-(void)HubblAPI:(NSString *)api receivedResponse:(NSDictionary *)response
   forAPIMethod:(HAPIHttpMethod)APIMethod
          error:(NSError *)error {
    if (self.responseHandler) {
        self.responseHandler(response,error);
    }
}


@end

