// CocoaRegex is copyrighted free software by Satoshi Nakagawa <psychs AT limechat DOT net>.
// You can redistribute it and/or modify it under the new BSD license.

#import "CocoaRegex.h"

//
// The following part is extracted from uregex.h in ICU library.
//

/*
 **********************************************************************
 *   Copyright (C) 2004-2012, International Business Machines
 *   Corporation and others.  All Rights Reserved.
 **********************************************************************
 *   file name:  uregex.h
 *   encoding:   US-ASCII
 *   indentation:4
 *
 *   created on: 2004mar09
 *   created by: Andy Heninger
 *
 *   ICU Regular Expressions, API for C
 */

#define U_PARSE_CONTEXT_LEN 16

typedef struct URegularExpression URegularExpression;

typedef struct UParseError {
    int32_t line;
    int32_t offset;
    UniChar preContext[U_PARSE_CONTEXT_LEN];
    UniChar postContext[U_PARSE_CONTEXT_LEN];
} UParseError;

typedef int32_t UErrorCode;

URegularExpression* uregex_open(const UniChar* pattern, int32_t patternLength, uint32_t flags, UParseError* pe, UErrorCode* status);
void uregex_close(URegularExpression* regexp);
URegularExpression* uregex_clone(const URegularExpression* regexp, UErrorCode* status);
void uregex_reset(URegularExpression* regexp, int32_t index, UErrorCode* status);
void uregex_setText(URegularExpression* regexp, const UniChar* text, int32_t textLength, UErrorCode* status);
BOOL uregex_find(URegularExpression* regexp, int32_t startIndex, UErrorCode* status);
BOOL uregex_findNext(URegularExpression* regexp, UErrorCode* status);
int32_t uregex_replaceAll(URegularExpression* regexp, const UniChar *replacementText, int32_t replacementLength, UniChar * destBuf, int32_t destCapacity, UErrorCode * status);
int32_t uregex_appendReplacement(URegularExpression* regexp, const UniChar* replacementText, int32_t replacementLength, UniChar** destBuf, int32_t* destCapacity, UErrorCode* status);
int32_t uregex_appendTail(URegularExpression* regexp, UniChar** destBuf, int32_t* destCapacity, UErrorCode* status);
int32_t uregex_groupCount(URegularExpression* regexp, UErrorCode* status);
int32_t uregex_start(URegularExpression* regexp, int32_t groupNum, UErrorCode* status);
int32_t uregex_end(URegularExpression* regexp, int32_t groupNum, UErrorCode* status);
const char* u_errorName(UErrorCode status);

//
// End of uregex.h.
//

@implementation CocoaRegex
{
    URegularExpression* regex;
    NSUInteger startOffset;
}

+ (CocoaRegex*)regexWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options
{
    CocoaRegex *regex = [[CocoaRegex alloc] initWithPattern:pattern options:options];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    return regex;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithPattern:(NSString*)pattern options:(CocoaRegexOptions)options
{
    self = [self init];
    if (self) {
        int len = pattern.length;
        UniChar buf[len];
        [pattern getCharacters:buf];
        
        UErrorCode status = 0;
        regex = uregex_open(buf, len, options, NULL, &status);
    }
    return self;
}

- (id)initWithHandle:(URegularExpression*)handle
{
    self = [self init];
    if (self) {
        UErrorCode status = 0;
        regex = uregex_clone(handle, &status);
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    return [[CocoaRegex alloc] initWithHandle:regex];
}

- (void)dealloc
{
    if (regex) {
        uregex_close(regex);
    }
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (BOOL)matchesInString:(NSString *)string
{
    return [self matchesInString:string range:NSMakeRange(0, string.length)];
}

- (BOOL)matchesInString:(NSString*)string range:(NSRange)range
{
    return [self rangeOfFirstMatchInString:string range:range].location != NSNotFound;
}

- (NSRange)rangeOfFirstMatchInString:(NSString*)string
{
    return [self rangeOfFirstMatchInString:string range:NSMakeRange(0, string.length)];
}

- (NSRange)rangeOfFirstMatchInString:(NSString*)string range:(NSRange)range
{
    int len = string.length;
    if (!len || !range.length || len <= range.location || len < NSMaxRange(range)) {
        return NSMakeRange(NSNotFound, 0);
    }
    
    startOffset = range.location;
    
    UniChar buf[len];
    [string getCharacters:buf range:NSMakeRange(0, len)];
    
    UErrorCode status = 0;
    uregex_reset(regex, 0, &status);
    
    status = 0;
    uregex_setText(regex, buf + startOffset, range.length, &status);
    
    status = 0;
    BOOL res = uregex_find(regex, 0, &status);
    if (res) {
        return [self matchingRangeAt:0];
    }
    
    return NSMakeRange(NSNotFound, 0);
}

- (NSUInteger)numberOfMatchingRanges
{
    UErrorCode status = 0;
    return uregex_groupCount(regex, &status);
}

- (NSRange)matchingRangeAt:(NSUInteger)index
{
    UErrorCode status = 0;
    int32_t location = uregex_start(regex, index, &status);
    status = 0;
    int32_t end = uregex_end(regex, index, &status);
    if (location != -1) {
        return NSMakeRange(location + startOffset, end - location);
    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}

- (void)reset
{
    UErrorCode status = 0;
    uregex_reset(regex, 0, &status);
}

@end
