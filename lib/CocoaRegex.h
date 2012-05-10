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
- (BOOL)matchesInString:(NSString*)string range:(NSRange)range;

- (NSRange)rangeOfFirstMatchInString:(NSString*)string;
- (NSRange)rangeOfFirstMatchInString:(NSString*)string range:(NSRange)range;

- (NSUInteger)numberOfMatchingRanges;
- (NSRange)matchingRangeAt:(NSUInteger)index;

- (void)reset;

@end
