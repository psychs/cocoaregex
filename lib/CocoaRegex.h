// CocoaRegex is copyrighted free software by Satoshi Nakagawa <psychs AT limechat DOT net>.
// You can redistribute it and/or modify it under the new BSD license.

#import <Foundation/Foundation.h>

typedef enum { 
    CocoaRegexCaseInsensitive                       = 1 << 1,
    CocoaRegexAllowCommentsAndWhitespace            = 1 << 2,
    CocoaRegexAnchorsMatchLines                     = 1 << 3,
    CocoaRegexDotMatchesLineSeparators              = 1 << 5,
    CocoaRegexUseUnicodeWordBoundaries              = 1 << 8,
} CocoaRegexOptions;

typedef enum {
    // Specifies that matches are limited to those at the start of the search range.
    CocoaRegexMatchingAnchored                      = 1 << 1,
    // Specifies that matching may examine parts of the string beyond the bounds of the search range, for purposes such as word
    // boundary detection, lookahead, etc. This constant has no effect if the search range contains the entire string.
    CocoaRegexMatchingWithTransparentBounds         = 1 << 2,
    // Specifies that ^ and $ will not automatically match the beginning and end of the search range, but will still match the
    // beginning and end of the entire string. This constant has no effect if the search range contains the entire string.
    CocoaRegexMatchingWithoutAnchoringBounds        = 1 << 3,
} CocoaRegexMatchingOptions;

@interface CocoaRegex : NSObject <NSCopying>

+ (CocoaRegex*)regexWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options;

- (id)initWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options;

- (BOOL)matchesInString:(NSString*)string;
- (BOOL)matchesInString:(NSString*)string range:(NSRange)range;
- (BOOL)matchesInString:(NSString*)string options:(CocoaRegexMatchingOptions)options range:(NSRange)range;

- (NSRange)rangeOfFirstMatchInString:(NSString*)string;
- (NSRange)rangeOfFirstMatchInString:(NSString*)string range:(NSRange)range;
- (NSRange)rangeOfFirstMatchInString:(NSString*)string options:(CocoaRegexMatchingOptions)options range:(NSRange)range;

- (NSUInteger)numberOfMatchingRanges;
- (NSRange)matchingRangeAt:(NSUInteger)index;

- (void)reset;

@end
