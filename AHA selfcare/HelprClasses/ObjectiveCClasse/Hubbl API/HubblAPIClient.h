//
//  APIBlocks.h
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+HubblAdditions.h"

typedef void(^HAPIResponseHandler)(NSDictionary *response,NSError *error);

@protocol HubblAPIDelegate;

typedef NS_ENUM(NSInteger,HAPIHttpMethod) {
    HAPIHTTPMethodGET,
	HAPIHTTPMethodPOST,
};

@interface HubblAPIClient : NSObject

+ (instancetype)shared;;

-(void)postPath:(NSString *) path  params : (NSDictionary *) args completionBlock : (HAPIResponseHandler) block;
-(void)getPath :(NSString *) path  params : (NSDictionary *) args completionBlock : (HAPIResponseHandler) block;

-(void) ImageFilePostAtPath : (NSString *) filePath
               forAPIMethod : (HAPIHttpMethod) apimethod
                 RequestURL : (NSString *) apiURL
                      params: (NSDictionary *) args
                        Name: (NSString *) ImageName
                        Type: (NSString *) ImageType
             completionBlock:(HAPIResponseHandler) block;

-(void) MultiImageFilePostAtPath : (NSString *) filePath
                    forAPIMethod : (HAPIHttpMethod) apimethod
                      RequestURL : (NSString *) apiURL
                           params: (NSDictionary *) args
                        ImageList: (NSMutableArray *) ImageArray
                  completionBlock:(HAPIResponseHandler) block;

-(void) cancelAPIOperation;

+(NSString *) encodeForURL:(NSString *)urlStr;
+(NSString *) decodeForURL:(NSString *)urlStr;
- (NSString*)DeviceId;
- (BOOL)isDictionary:(id)response;

@end


@protocol HubblAPIDelegate <NSObject>

-(void)HubblAPI:(NSString *)api receivedResponse:(NSDictionary *)response
   forAPIMethod:(HAPIHttpMethod)APIMethod
          error:(NSError *)error;

-(void)HubblAPI:(NSString *)api receivedData:(NSData *)response
   forAPIMethod:(HAPIHttpMethod)APIMethod
          error:(NSError *)error;

@end


@interface HAPIBlockDelegate : NSObject

@property (nonatomic,copy) HAPIResponseHandler responseHandler;

+(id) delegateWithResponseHandler : (HAPIResponseHandler) handler;

@end
