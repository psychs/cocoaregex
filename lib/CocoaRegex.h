// CocoaRegex is copyrighted free software by Satoshi Nakagawa <psychs AT limechat DOT net>.
// You can redistribute it and/or modify it under the new BSD license.

#import <Foundation/Foundation.h>

typedef enum { 
    CocoaRegexCaseInsensitive               = 1 << 1,
    CocoaRegexAllowCommentsAndWhitespace    = 1 << 2,
    CocoaRegexAnchorsMatchLines             = 1 << 3,
    CocoaRegexDotMatchesLineSeparators      = 1 << 5,
    CocoaRegexUseUnicodeWordBoundaries      = 1 << 8,
} CocoaRegexOptions;

@interface CocoaRegex : NSObject <NSCopying>

+ (CocoaRegex*)regexWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options;

- (id)initWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options;

- (BOOL)matchesInString:(NSString*)string;
- (BOOL)matchesInString:(NSString*)string start:(NSUInteger)start;
- (BOOL)matchesInString:(NSString*)string start:(NSUInteger)start end:(NSUInteger)end;

- (NSRange)rangeOfFirstMatchInString:(NSString*)string;
- (NSRange)rangeOfFirstMatchInString:(NSString*)string start:(NSUInteger)start;
- (NSRange)rangeOfFirstMatchInString:(NSString*)string start:(NSUInteger)start end:(NSUInteger)end;

- (NSUInteger)numberOfMatchingRanges;
- (NSRange)matchingRangeAt:(NSUInteger)index;

- (void)reset;

@end
