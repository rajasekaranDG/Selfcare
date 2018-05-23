//
//  NSDictionary+HubblAdditions.h
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HubblAPIClient.h"

@interface NSDictionary (HubblAdditions)


-(NSString *)HAd_URLEncodedFormString;

+(NSDictionary *)Had_DictionaryFromURLFormString : (NSString *) formString;

- (id)objectForKeyOrNil:(id)key;

@end
