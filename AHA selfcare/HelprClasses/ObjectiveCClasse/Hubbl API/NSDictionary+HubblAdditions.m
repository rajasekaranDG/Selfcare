//
//  NSDictionary+HubblAdditions.m
//  APIClient
//
//  Created by Karthikeyan on 25/11/13.
//  Copyright (c) 2013 Jarvis. All rights reserved.
//

#import "NSDictionary+HubblAdditions.h"
#import "HubblAPIClient.h"

@implementation NSDictionary (HubblAdditions)


-(NSString *)HAd_URLEncodedFormString {
    
    NSMutableArray *formelements = [NSMutableArray arrayWithCapacity:self.allKeys.count];
    for (NSString *key in self.allKeys) {
        NSString *value = [self objectForKey:key];
        [formelements addObject:
            [NSString stringWithFormat:@"%@=%@", [HubblAPIClient encodeForURL:key], [HubblAPIClient encodeForURL:value]]];
    }
    
    return [formelements componentsJoinedByString:@"&"];
    
}

+(NSDictionary *)Had_DictionaryFromURLFormString : (NSString *) formString {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSArray *formPieces = [formString componentsSeparatedByString:@"&"];
	for(NSString *formPiece in formPieces){
		NSArray *fieldPieces = [formPiece componentsSeparatedByString:@"="];
		if(fieldPieces.count == 2){
			NSString *fieldKey = [fieldPieces objectAtIndex:0];
			NSString *fieldValue = [fieldPieces objectAtIndex:1];
			[dictionary setObject:fieldValue
						   forKey:fieldKey];
		}
	}
	return [dictionary copy];
}

- (id)objectForKeyOrNil:(id)key {
    id val = [self objectForKey:key];
    if ([val isEqual:[NSNull null]]) {
        return nil;
    }
    return val;
}

@end
