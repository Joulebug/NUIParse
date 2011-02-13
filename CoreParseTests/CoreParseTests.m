//
//  CoreParseTests.m
//  CoreParseTests
//
//  Created by Tom Davie on 10/02/2011.
//  Copyright 2011 In The Beginning... All rights reserved.
//

#import "CoreParseTests.h"

#import "CoreParse.h"

@implementation CoreParseTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testKeywordTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"{"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"}"]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"{}"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    CPToken *tok3 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPKeywordToken class]] || ![((CPKeywordToken *)tok1).keyword isEqualToString:@"{"] ||
        ![tok2 isKindOfClass:[CPKeywordToken class]] || ![((CPKeywordToken *)tok2).keyword isEqualToString:@"}"] ||
        ![tok3 isKindOfClass:[CPEOFToken class]])
    {
        STFail(@"Incorrect tokenisation of braces");
    }
}

- (void)testIntegerTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPNumberRecogniser integerRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"1234"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken class]] || ((CPNumberToken *)tok1).number.integerValue != 1234 ||
        ![tok2 isKindOfClass:[CPEOFToken class]])
    {
        STFail(@"Incorrect tokenisation of integers");
    }

    tokenStream = [tokeniser tokenise:@"1234abcd"];
    tok1 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken class]] || ((CPNumberToken *)tok1).number.integerValue != 1234)
    {
        STFail(@"Incorrect tokenisation of integers with additional cruft");
    }
}

- (void)testFloatTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPNumberRecogniser floatRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"1234.5678"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken class]] || ((CPNumberToken *)tok1).number.doubleValue != 1234.5678 ||
        ![tok2 isKindOfClass:[CPEOFToken class]])
    {
        STFail(@"Incorrect tokenisation of floats");
    }
    
    tokenStream = [tokeniser tokenise:@"1234"];
    if ([tokenStream hasToken])
    {
        STFail(@"Tokenising floats recognises integers as well");
    }
}

- (void)testNumberTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"1234.5678"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken class]] || ((CPNumberToken *)tok1).number.doubleValue != 1234.5678 ||
        ![tok2 isKindOfClass:[CPEOFToken class]])
    {
        STFail(@"Incorrect tokenisation of numbers");
    }
    
    tokenStream = [tokeniser tokenise:@"1234abcd"];
    tok1 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken class]] || ((CPNumberToken *)tok1).number.integerValue != 1234)
    {
        STFail(@"Incorrect tokenisation of numbers with additional cruft");
    }
}

- (void)testWhiteSpaceTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
    [tokeniser addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"12.34 56.78\t90"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    CPToken *tok3 = [tokenStream popToken];
    CPToken *tok4 = [tokenStream popToken];
    CPToken *tok5 = [tokenStream popToken];
    CPToken *tok6 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPNumberToken     class]] || ((CPNumberToken *)tok1).number.doubleValue != 12.34 ||
        ![tok2 isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok2).whiteSpace isEqualToString:@" "] ||
        ![tok3 isKindOfClass:[CPNumberToken     class]] || ((CPNumberToken *)tok3).number.doubleValue != 56.78 ||
        ![tok4 isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok4).whiteSpace isEqualToString:@"\t"] ||
        ![tok5 isKindOfClass:[CPNumberToken     class]] || ((CPNumberToken *)tok5).number.doubleValue != 90 ||
        ![tok6 isKindOfClass:[CPEOFToken        class]])
    {
        STFail(@"Failed to tokenise white space correctly");
    }
}

- (void)testIdentifierTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"long"]];
    [tokeniser addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
    [tokeniser addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"long jam _ham long _spam59e_53"];
    CPToken *tok1  = [tokenStream popToken];
    CPToken *tok2  = [tokenStream popToken];
    CPToken *tok3  = [tokenStream popToken];
    CPToken *tok4  = [tokenStream popToken];
    CPToken *tok5  = [tokenStream popToken];
    CPToken *tok6  = [tokenStream popToken];
    CPToken *tok7  = [tokenStream popToken];
    CPToken *tok8  = [tokenStream popToken];
    CPToken *tok9  = [tokenStream popToken];
    CPToken *tok10 = [tokenStream popToken];
    
    if (![tok1  isKindOfClass:[CPKeywordToken    class]] || ![((CPKeywordToken *)tok1).keyword       isEqualToString:@"long"       ] ||
        ![tok2  isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok2).whiteSpace isEqualToString:@" "          ] ||
        ![tok3  isKindOfClass:[CPIdentifierToken class]] || ![((CPIdentifierToken *)tok3).identifier isEqualToString:@"jam"        ] ||
        ![tok4  isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok4).whiteSpace isEqualToString:@" "          ] ||
        ![tok5  isKindOfClass:[CPIdentifierToken class]] || ![((CPIdentifierToken *)tok5).identifier isEqualToString:@"_ham"       ] ||
        ![tok6  isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok6).whiteSpace isEqualToString:@" "          ] ||
        ![tok7  isKindOfClass:[CPKeywordToken    class]] || ![((CPKeywordToken *)tok7).keyword       isEqualToString:@"long"       ] ||
        ![tok8  isKindOfClass:[CPWhiteSpaceToken class]] || ![((CPWhiteSpaceToken *)tok8).whiteSpace isEqualToString:@" "          ] ||
        ![tok9  isKindOfClass:[CPIdentifierToken class]] || ![((CPIdentifierToken *)tok9).identifier isEqualToString:@"_spam59e_53"] ||
        ![tok10 isKindOfClass:[CPEOFToken        class]])
    {
        STFail(@"Failed to tokenise identifiers space correctly");
    }
}

- (void)testQuotedTokeniser
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"/*" endQuote:@"*/"]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"/* abcde ghi */"];
    CPToken *tok1 = [tokenStream popToken];
    CPToken *tok2 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok1).quoteType isEqualToString:@"/*"] || ![((CPQuotedToken *)tok1).content isEqualToString:@" abcde ghi "] ||
        ![tok2 isKindOfClass:[CPEOFToken    class]])
    {
        STFail(@"Failed to tokenise comment");
    }
    
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\"" endQuote:@"\"" escapedEndQuote:@"\\\"" escapedEscape:@"\\\\"]];
    tokenStream = [tokeniser tokenise:@"/* abc */\"def\""];
    tok1 = [tokenStream popToken];
    tok2 = [tokenStream popToken];
    CPToken *tok3 = [tokenStream popToken];
    
    if (![tok1 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok1).quoteType isEqualToString:@"/*"] || ![((CPQuotedToken *)tok1).content isEqualToString:@" abc "] ||
        ![tok2 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok2).quoteType isEqualToString:@"\""] || ![((CPQuotedToken *)tok2).content isEqualToString:@"def"  ] ||
        ![tok3 isKindOfClass:[CPEOFToken    class]])
    {
        STFail(@"Failed to tokenise comment and string");
    }
    
    tokenStream = [tokeniser tokenise:@"\"def\\\"\""];
    tok1 = [tokenStream popToken];
    tok2 = [tokenStream popToken];
    if (![tok1 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok1).quoteType isEqualToString:@"\""] || ![((CPQuotedToken *)tok1).content isEqualToString:@"def\\\""] ||
        ![tok2 isKindOfClass:[CPEOFToken    class]])
    {
        STFail(@"Failed to tokenise string with quote in it");
    }
    
    tokenStream = [tokeniser tokenise:@"\"def\\\\\""];
    tok1 = [tokenStream popToken];
    tok2 = [tokenStream popToken];
    if (![tok1 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok1).quoteType isEqualToString:@"\""] || ![((CPQuotedToken *)tok1).content isEqualToString:@"def\\\\"] ||
        ![tok2 isKindOfClass:[CPEOFToken    class]])
    {
        STFail(@"Failed to tokenise string with backslash in it");
    }
    
    tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"'" endQuote:@"'" escapedEndQuote:nil escapedEscape:nil maximumLength:1]];
    tokenStream = [tokeniser tokenise:@"'a''bc'"];
    tok1 = [tokenStream popToken];
    if (![tok1 isKindOfClass:[CPQuotedToken class]] || ![((CPQuotedToken *)tok1).quoteType isEqualToString:@"'"] || ![((CPQuotedToken *)tok1).content isEqualToString:@"a"] ||
        [tokenStream hasToken])
    {
        STFail(@"Failed to correctly tokenise characters");
    }
}

- (void)testMapCSSTokenisation
{
    CPTokeniser *tokeniser = [[[CPTokeniser alloc] init] autorelease];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"node"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"way"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"relation"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"["]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"]"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"{"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"}"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"("]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@")"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"."]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@";"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"@import"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"|z"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"-"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"!="]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"=~"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"<"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@">"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"<="]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@">="]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"="]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@":"]];
    [tokeniser addTokenRecogniser:[CPKeywordRecogniser recogniserForKeyword:@"eval"]];
    [tokeniser addTokenRecogniser:[CPWhiteSpaceRecogniser whiteSpaceRecogniser]];
    [tokeniser addTokenRecogniser:[CPNumberRecogniser numberRecogniser]];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"/*" endQuote:@"*/"]];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"//" endQuote:@"\n"]];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"'" endQuote:@"'" escapedEndQuote:@"\\'" escapedEscape:@"\\\\"]];
    [tokeniser addTokenRecogniser:[CPQuotedRecogniser quotedRecogniserWithStartQuote:@"\"" endQuote:@"\"" escapedEndQuote:@"\\\"" escapedEscape:@"\\\\"]];
    [tokeniser addTokenRecogniser:[CPIdentifierRecogniser identifierRecogniser]];
    CPTokenStream *tokenStream = [tokeniser tokenise:@"node[highway=trunk] { line-width: 5.0; label: \"jam\"; }"];
    
    NSLog(@"%@", tokenStream);
}

@end