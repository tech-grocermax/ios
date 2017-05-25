//
//  NSString+Extension.h
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 13/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)base64String;
- (BOOL)containString:(NSString*)targettedString;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString*) removeMultipleExtraSpaces;
- (NSString *) stringByStrippingHTML;
//- (NSString *)convertStringIntoMD5:(NSString *)inputString;
+ (NSString *)getJsonStringFromObject:(id)parameterObject;
@end
