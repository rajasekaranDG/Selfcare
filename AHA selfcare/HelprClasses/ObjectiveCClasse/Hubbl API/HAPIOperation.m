//
//  HOperation.m
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import "HAPIOperation.h"
#import "NSDictionary+HubblAdditions.h"
#import <UIKit/UIKit.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define KDEBUG 1

const NSString* HAPIErrorDomain = @"HAPIErrorDomain";

@interface HAPIOperation () {
    NSURLConnection* connection;
}
@property (nonatomic, copy) NSString* apiurl;
@property (nonatomic, assign) HAPIHttpMethod httpType;
@property (nonatomic, strong) NSDictionary* dictionaryArgs;
@property (nonatomic, strong) NSHTTPURLResponse* response;
@property (nonatomic, strong) NSMutableData* data;
@property (nonatomic, copy) NSString* ImageName;
@property (nonatomic, copy) NSString* ImageType;

@property (nonatomic, strong) NSString* fileURLPath;
@property (nonatomic) BOOL isImageUpload;
@property (nonatomic) BOOL isMultiImageUpload;
@property (strong, nonatomic) NSString *stringLat;
@property (strong, nonatomic) NSString *stringLong;
@property (nonatomic, strong) NSMutableArray* arrayOfImages;

@end

@implementation HAPIOperation

- (id)initWithHubblOperation:(NSString*)url
                   APIMethod:(HAPIHttpMethod)type
                   arguments:(NSDictionary*)args
{
    self = [super init];
    if (self) {
        self.stringLat = @"";
        self.stringLong = @"";
        self.apiurl = url;
        self.httpType = type;
        self.dictionaryArgs = args;
        
    }
    return self;
}

- (id)initWithImageUploadOperation:(NSString*)fileURLPath
                     apiRequestURL:(NSString*)apiurl
                         imageName:(NSString*)Name
                         imageType:(NSString*)Type
                         APIMethod:(HAPIHttpMethod)type
                         arguments:(NSDictionary*)args
{

    self = [super init];
    if (self) {
        self.stringLat = @"";
        self.stringLong = @"";
        self.apiurl = apiurl;
        self.httpType = type;
        self.dictionaryArgs = args;
        self.fileURLPath = fileURLPath;
        self.isImageUpload = YES;
        self.ImageName = Name;
        self.ImageType = Type;

    }
    return self;
}
- (id)initWithMultiImageUploadOperation:(NSString*)fileURLPath
                     apiRequestURL:(NSString*)apiurl
                         ImageList:(NSMutableArray*)ImageArray
                         APIMethod:(HAPIHttpMethod)type
                         arguments:(NSDictionary*)args
{
    
    self = [super init];
    if (self) {
        self.stringLat = @"";
        self.stringLong = @"";
        self.apiurl = apiurl;
        self.httpType = type;
        self.dictionaryArgs = args;
        self.arrayOfImages = ImageArray;
        self.isMultiImageUpload = YES;
        self.isImageUpload = NO;
    }
    return self;
}

- (NSString*)stringFromHttpMethod:(HAPIHttpMethod)method
{

    NSString* val = (method == HAPIHTTPMethodPOST) ? @"POST" : @"GET";
    return val;
}

- (void)start
{

    NSMutableURLRequest* request = (self.isMultiImageUpload) ? [self HA_MultiImageURLRequest] : (self.isImageUpload) ? [self HA_ImageURLRequest] : [self HA_URLRequest];
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                          forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)inData
{
    [self.data appendData:inData];
}

- (void)connection:(NSURLConnection*)aConnection didReceiveResponse:(NSURLResponse*)receivedResponse
{
    self.response = (NSHTTPURLResponse*)receivedResponse;
    self.data = [[NSMutableData alloc] initWithCapacity:0];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //
    NSInteger errorCode = [[self.response.allHeaderFields objectForKey:@"X-Error-Code"] intValue];
    NSString* errorDescription = [self.response.allHeaderFields objectForKey:@"X-Error"];

    if (error) {
        error = [NSError errorWithDomain:@"HAPIErrorDomain"
                                    code:errorCode
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           errorDescription, @"localizedDescription",
                                                           error, @"HTTPError",
                                                           nil]];

        if ([self.delegate respondsToSelector:@selector(HubblAPI:
                                                    receivedData:
                                                    forAPIMethod:
                                                           error:)]) {
            [self.delegate HubblAPI:self.apiurl
                       receivedData:nil
                       forAPIMethod:self.httpType
                              error:error];
        } else if ([self.delegate respondsToSelector:@selector(HubblAPI:
                                                         receivedResponse:
                                                             forAPIMethod:
                                                                    error:)]) {
            [self.delegate HubblAPI:self.apiurl
                   receivedResponse:nil
                       forAPIMethod:self.httpType
                              error:error];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
    NSError* error = nil;
    NSDictionary* dictionaryDetails = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.data
                                                                                     options:0
                                                                                       error:&error];

    if (self.fileURLPath && [[NSFileManager defaultManager] fileExistsAtPath:self.fileURLPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.fileURLPath
                                                   error:nil];
    }

    NSInteger errorCode = [[self.response.allHeaderFields objectForKey:@"X-Error-Code"] intValue];
    NSString* errorDescription = [self.response.allHeaderFields objectForKey:@"X-Error"];

    if (error) {
        error = [NSError errorWithDomain:@"HAPIErrorDomain"
                                    code:errorCode
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           errorDescription, @"localizedDescription",
                                                           error, @"HTTPError",
                                                           nil]];
    }

    if ([self.delegate respondsToSelector:@selector(HubblAPI:
                                                receivedData:
                                                forAPIMethod:
                                                       error:)]) {
        [self.delegate HubblAPI:self.apiurl
                   receivedData:(error) ? nil : self.data
                   forAPIMethod:self.httpType
                          error:error];
    } else if ([self.delegate respondsToSelector:@selector(HubblAPI:
                                                     receivedResponse:
                                                         forAPIMethod:
                                                                error:)]) {
        [self.delegate HubblAPI:self.apiurl
               receivedResponse:(error) ? nil : dictionaryDetails
                   forAPIMethod:self.httpType
                          error:error];
    }
}

- (void)dealloc
{

    connection = nil;
    _delegate = nil;
}

- (BOOL)checkIfValidResponse:(NSDictionary*)dictionarydetails
{
    return (dictionarydetails && [[dictionarydetails allKeys] count] > 0 && [dictionarydetails isKindOfClass:[NSDictionary class]]);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: %p https://%@ %@>", [self class], self, self.apiurl, self.dictionaryArgs];
}

- (NSString*)encodeForURL:(NSString*)urlStr
{
    NSString* result = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            (CFStringRef)urlStr,
                                                                                            NULL,
                                                                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                            kCFStringEncodingUTF8));
    return result;
}

- (NSString*)decodeForURL:(NSString*)urlStr
{
    NSString* result = (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                            (CFStringRef)urlStr,
                                                                                                            CFSTR(""),
                                                                                                            kCFStringEncodingUTF8));
    return result;
}

- (NSDictionary*)defaultParams
{
    
    NSMutableDictionary* dictionaryDefaultParameters = [NSMutableDictionary dictionary];
    [dictionaryDefaultParameters addEntriesFromDictionary:
                                                     @{
                                                       @"Platform" : @"ios",
                                                       }];
    return [NSDictionary dictionaryWithDictionary:dictionaryDefaultParameters];
}
- (NSString*)fileName
{
    return [self.fileURLPath lastPathComponent];
}

- (NSMutableURLRequest*)HA_ImageURLRequest
{

    NSString* urlString = self.apiurl;

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[self defaultParams]];
    [params addEntriesFromDictionary:self.dictionaryArgs];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:[self stringFromHttpMethod:self.httpType]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];

    //    if (self.httpType == HAPIHTTPMethodPOST) {
    //        [request setHTTPBody:[[params HAd_URLEncodedFormString] dataUsingEncoding:NSUTF8StringEncoding]];
    //    }

    if (self.fileURLPath && [[NSFileManager defaultManager] fileExistsAtPath:self.fileURLPath]) {

        /* Adding HTTP Request Headers. */
        NSString* boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT5647647575";
        // set Content-Type in HTTP header
        NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType
            forHTTPHeaderField:@"Content-Type"];

        NSMutableData* body = [NSMutableData data];

        // add params (all params are strings)
        for (NSString* param in params) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        // add image data
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.fileURLPath]];
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", self.ImageName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }

        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        // adding the body we've created to the request
        [request setHTTPBody:body];

        // set the content-length
        NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength
            forHTTPHeaderField:@"Content-Length"];
    }
    return request;
}

- (NSMutableURLRequest*)HA_MultiImageURLRequest
{
    NSMutableDictionary *aImageDic = [NSMutableDictionary dictionary]; // It's contains multiple image data as value and a image name as key
    for (NSMutableDictionary *DetailDictionary in self.arrayOfImages) {
        
        NSData* imageData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:DetailDictionary[@"PathName"]]];
        if (imageData) {
            [aImageDic setObject:imageData forKey:[NSString stringWithFormat:@"%@~~%@",DetailDictionary[@"FormFieldKey"],DetailDictionary[@"FormValueId"]]];
        }
    }
    return [self uploadMultipleImageInSingleRequest:aImageDic url:self.apiurl];
}


- (NSMutableURLRequest*)uploadMultipleImageInSingleRequest : (NSMutableDictionary *) aImageDic url : (NSString *)urlString
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[self defaultParams]];
    [params addEntriesFromDictionary:self.dictionaryArgs];

    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"50"        forHTTPHeaderField:@"multi"];
    
    NSMutableData *postbody = [NSMutableData data];
    NSString *postData = [self getHTTPBodyParamsFromDictionary:self.dictionaryArgs boundary:boundary];
    NSLog(@"%@",postData);
    [postbody appendData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    [aImageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if(obj != nil) {
            //
            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaddocument\"; filetype=\"image/png\"; filename=\"%@.png\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[NSData dataWithData:obj]];
        }
    }];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    return request;
}
-(NSString *) getHTTPBodyParamsFromDictionary: (NSDictionary *)params boundary:(NSString *)boundary
{
    NSMutableString *tempVal = [[NSMutableString alloc] init];
    for(NSString * key in params)
    {
        [tempVal appendFormat:@"\r\n--%@\r\n", boundary];
        [tempVal appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[params objectForKey:key]];
    }
    return [tempVal description];
}
- (NSMutableURLRequest*)HA_URLRequest
{

    NSString* urlString = self.apiurl;

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:[self defaultParams]];
    [params addEntriesFromDictionary:self.dictionaryArgs];

    if (self.httpType == HAPIHTTPMethodGET) {
        NSMutableArray* pairs = [NSMutableArray array];
        for (NSString* key in [_dictionaryArgs allKeys]) {
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [self encodeForURL:[_dictionaryArgs objectForKey:key]]]];
        }

        if (pairs.count > 0) {
            urlString = [urlString stringByAppendingFormat:@"?%@", [pairs componentsJoinedByString:@"&"]];
        }
    }

    NSLog(@"path : %@?%@", self.apiurl, [params HAd_URLEncodedFormString]);

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:[self stringFromHttpMethod:self.httpType]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];

    if (self.httpType == HAPIHTTPMethodPOST) {
        [request setHTTPBody:[[params HAd_URLEncodedFormString] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return request;
}
- (BOOL)isSimulator
{
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end
