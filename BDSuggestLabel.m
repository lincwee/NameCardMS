//
//  BDSuggestLabel.m
//  BingDic
//
//  Created by 854072335 yxlong on 13-1-3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BDSuggestLabel.h"
//#import "NSAttributedString+Attributes.h"

@implementation BDSuggestLabel
@synthesize keyWord = _keyword;
@synthesize keyWordColor = _keywordColor;
@synthesize keyWordFont = _keyWordFont;

//- (void)dealloc{
////    if(_keyWordFont)
////    {
////        [_keyWordFont release];
////    }
//    
//    [_keywordColor release];
//    [_keyword release];
//    [super dealloc];
//}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _keywordColor = [UIColor blackColor];
        _keyWordFont = [UIFont systemFontOfSize:19.0f];
        
    }
    return self;
}

- (void) setText:(NSString *) _text
{
    [super setText:_text];
    [self setNeedsDisplay];
}
- (NSString *) keyWord
{
    return _keyword;
}
- (void) setKeyWord:(NSString *) keyWord_
{
    
    if(_keyword != keyWord_)
    {
        [_keyword release];
    }
    _keyword = [keyWord_ copy];
    [self setNeedsDisplay];
}

- (UIColor *) keyWordColor
{
    return _keywordColor;
}
- (void) setKeyWordColor:(UIColor *)keyWordColor_
{
    if(_keywordColor != keyWordColor_)
    {
        [_keywordColor release];
    }
    _keywordColor = [keyWordColor_ copy];
    [self setNeedsDisplay];
}
- (void) setKeyWordFont:(UIFont *)keyWordFont_
{
    if(_keyWordFont != keyWordFont_)
    {
        [_keyWordFont release];
    }
    _keyWordFont = [keyWordFont_ copy];
    
    [self setNeedsDisplay];
}


- (void)drawTextInRect:(CGRect) aRect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableAttributedString *attrString = [[[NSMutableAttributedString alloc] initWithString:self.text] autorelease];
    [attrString setFont:self.font range:NSMakeRange(0, [self.text length])];
    
    [attrString setTextColor:self.textColor range:NSMakeRange(0, [self.text length])];
    [attrString setTextAlignment:kCTLeftTextAlignment lineBreakMode:kCTLineBreakByCharWrapping range:NSMakeRange(0, [self.text length])];
    // set keyword' attribute
    if(_keyword&&self.text)
    {
        NSRange keyWordRange = [self.text rangeOfString:_keyword];
        if(keyWordRange.location != NSNotFound)
        {
            [attrString setFont:_keyWordFont range:keyWordRange];//执行完set后，font即被释放掉，所以在dealloc里面不在releaseß
            [attrString setTextColor:_keywordColor range:keyWordRange];
        }
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, aRect);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);
    CFRelease(framesetter);
    //CFRelease(attrString);
    
    if (frame) 
    {
        CGContextSaveGState(context);
        // Core Text wants to draw our text upside-down!  This flips it the 
        // right way.
        CGContextTranslateCTM(context, 0, aRect.origin.y);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -(aRect.origin.y + aRect.size.height));
//        CGContextConcatCTM(context, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
        CTFrameDraw(frame, context);
        
        CGContextRestoreGState(context);
        
        CFRelease(frame);
    }
}



@end


@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

-(void)setFont:(UIFont*)font {
    [self setFontName:font.fontName size:font.pointSize];
}
-(void)setFont:(UIFont*)font range:(NSRange)range {
    [self setFontName:font.fontName size:font.pointSize range:range];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size {
    [self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range {
    // kCTFontAttributeName
    CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, size, NULL);
    if (!aFont) return;
    [self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
    CFRelease(aFont);
}
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range {
    // kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
    CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
    NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
    NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          fontFamily,kCTFontFamilyNameAttribute,
                          trait,kCTFontTraitsAttribute,nil];
    
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attr);
    if (!desc) return;
    CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
    CFRelease(desc);
    if (!aFont) return;
    
    [self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
    CFRelease(aFont);
}

-(void)setTextColor:(UIColor*)color {
    [self setTextColor:color range:NSMakeRange(0,[self length])];
}
-(void)setTextColor:(UIColor*)color range:(NSRange)range {
    // kCTForegroundColorAttributeName
    [self removeAttribute:(NSString*)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

-(void)setTextIsUnderlined:(BOOL)underlined {
    [self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range {
    int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
    [self setTextUnderlineStyle:style range:range];
}
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range {
    [self removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

-(void)setTextBold:(BOOL)isBold range:(NSRange)range {
    NSUInteger startPoint = range.location;
    NSRange effectiveRange;
    do {
        // Get font at startPoint
        CTFontRef currentFont = (CTFontRef)[self attribute:(NSString*)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
        // The range for which this font is effective
        NSRange fontRange = NSIntersectionRange(range, effectiveRange);
        // Create bold/unbold font variant for this font and apply
        CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (isBold?kCTFontBoldTrait:0), kCTFontBoldTrait);
        if (newFont) {
            [self removeAttribute:(NSString*)kCTFontAttributeName range:fontRange]; // Work around for Apple leak
            [self addAttribute:(NSString*)kCTFontAttributeName value:(id)newFont range:fontRange];
            CFRelease(newFont);
        } else {
            NSString* fontName = [(NSString*)CTFontCopyFullName(currentFont) autorelease];
            NSLog(@"[OHAttributedLabel] Warning: can't find a bold font variant for font %@. Try another font family (like Helvetica) instead.",fontName);
        }
        ////[self removeAttribute:(NSString*)kCTFontWeightTrait range:fontRange]; // Work around for Apple leak
        ////[self addAttribute:(NSString*)kCTFontWeightTrait value:(id)[NSNumber numberWithInt:1.0f] range:fontRange];
        
        // If the fontRange was not covering the whole range, continue with next run
        startPoint = NSMaxRange(effectiveRange);
    } while(startPoint<NSMaxRange(range));
}

-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode {
    [self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range {
    // kCTParagraphStyleAttributeName > kCTParagraphStyleSpecifierAlignment
    CTParagraphStyleSetting paraStyles[2] = {
        {.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
        {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
    };
    CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 2);
    [self removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:range];
    CFRelease(aStyle);
}

@end

