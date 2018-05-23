//
//  HOperation.h
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubblAPIClient.h"

typedef void(^CompletionBlock)(BOOL status);

@interface HAPIOperation : NSOperation <NSURLConnectionDelegate>


-(id) initWithHubblOperation : (NSString *) url
                   APIMethod : (HAPIHttpMethod) type
                   arguments : (NSDictionary *) args;

- (id)initWithImageUploadOperation:(NSString*)fileURLPath
                     apiRequestURL:(NSString*)apiurl
                         imageName:(NSString*)Name
                         imageType:(NSString*)Type
                         APIMethod:(HAPIHttpMethod)type
                         arguments:(NSDictionary*)args;

- (id)initWithMultiImageUploadOperation:(NSString*)fileURLPath
                          apiRequestURL:(NSString*)apiurl
                              ImageList:(NSMutableArray*)ImageArray
                              APIMethod:(HAPIHttpMethod)type
                              arguments:(NSDictionary*)args;

@property (nonatomic,strong)id <HubblAPIDelegate> delegate;


@end


