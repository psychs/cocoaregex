// CocoaRegex is copyrighted free software by Satoshi Nakagawa <psychs AT limechat DOT net>.
// You can redistribute it and/or modify it under the new BSD license.

#import "CocoaRegexTests.h"
#import "CocoaRegex.h"

@implementation CocoaRegexTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testBasicMatch
{
    NSString *pattern = @"[a-z]{1,6}";
    CocoaRegex *masterRegex = [[CocoaRegex alloc] initWithPattern:pattern options:0];
#if !__has_feature(objc_arc)
    [masterRegex autorelease];
#endif
    CocoaRegex *regex;
    NSRange r, expected;
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    r = [regex rangeOfFirstMatchInString:@"123 azZaVG 987"];
    expected = NSMakeRange(4, 2);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    r = [regex rangeOfFirstMatchInString:@"123 azjajklzffsadfkl 987"];
    expected = NSMakeRange(4, 6);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
}

- (void)testStartAnchor
{
    NSString *pattern = @"^[A-Z0-9]{2}";
    CocoaRegex *masterRegex = [[CocoaRegex alloc] initWithPattern:pattern options:0];
#if !__has_feature(objc_arc)
    [masterRegex autorelease];
#endif
    CocoaRegex *regex;
    NSRange r, expected;
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    r = [regex rangeOfFirstMatchInString:@"aa0ZVA"];
    expected = NSMakeRange(NSNotFound, 0);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    r = [regex rangeOfFirstMatchInString:@"A1abZZ"];
    expected = NSMakeRange(0, 2);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
}

- (void)testStart
{
    NSString *pattern = @"[a-z0-9]+";
    CocoaRegex *masterRegex = [[CocoaRegex alloc] initWithPattern:pattern options:0];
#if !__has_feature(objc_arc)
    [masterRegex autorelease];
#endif
    CocoaRegex *regex;
    NSString *s;
    NSRange r, expected;
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    s = @"a8s9daf87daf79Sd7fa";
    r = [regex rangeOfFirstMatchInString:s range:NSMakeRange(7, s.length - 7)];
    expected = NSMakeRange(7, 7);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    s = @"";
    r = [regex rangeOfFirstMatchInString:s range:NSMakeRange(0, 0)];
    expected = NSMakeRange(NSNotFound, 0);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
}

- (void)testLooseURL
{
    NSString *pattern = @"http://((?:[a-z]+\\.)+[a-z]{1,3})(?:(/[a-z_\\-~!@$%^&*\\(\\)=+{}\\[\\];:'\",./]+)(\\?[a-z_\\-~!@$%^&*\\(\\)=+{}\\[\\];:'\",./]*)?(#[a-z_\\-~!@$%^&*\\(\\)=+{}\\[\\];:'\",./]*))?";
    CocoaRegex *masterRegex = [[CocoaRegex alloc] initWithPattern:pattern options:CocoaRegexCaseInsensitive];
#if !__has_feature(objc_arc)
    [masterRegex autorelease];
#endif
    CocoaRegex *regex;
    NSString *s;
    NSRange r, expected;
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    s = @"asf ABZ http://www.example.com/<";
    r = [regex rangeOfFirstMatchInString:s];
    expected = NSMakeRange(8, 22);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    regex = [masterRegex copy];
#if !__has_feature(objc_arc)
    [regex autorelease];
#endif
    s = @"asf asdfa http://www.example.com/Path/To/Page?param=value&param=value#fragment< ";
    r = [regex rangeOfFirstMatchInString:s];
    expected = NSMakeRange(10, 68);
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    STAssertTrue(4 == regex.numberOfMatchingRanges, @"numberOfMatchingRanges %d != 4", regex.numberOfMatchingRanges);
    
    expected = NSMakeRange(17, 15);
    r = [regex matchingRangeAt:1];
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    expected = NSMakeRange(32, 13);
    r = [regex matchingRangeAt:2];
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    expected = NSMakeRange(45, 24);
    r = [regex matchingRangeAt:3];
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
    
    expected = NSMakeRange(69, 9);
    r = [regex matchingRangeAt:4];
    STAssertTrue(NSEqualRanges(expected, r), @"%@ != %@", NSStringFromRange(expected), NSStringFromRange(r));
}

@end
