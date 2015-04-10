#import <Foundation/Foundation.h>
#import "CCXmlElement.h"
#import "CCXmlNode.h"

/**
 * Welcome to CCXml.
 * 
 * The project page has documentation if you have questions.
 * https://github.com/wbitos/CCXml
 * 
 * If you're new to the project you may wish to read the "Getting Started" wiki.
 * https://github.com/wbitos/CCXml/wiki/GettingStarted
 * 
 * CCXml provides a drop-in replacement for Apple's NSXML class cluster.
 * The goal is to get the exact same behavior as the NSXML classes.
 * 
 * For API Reference, see Apple's excellent documentation,
 * either via Xcode's Mac OS X documentation, or via the web:
 * 
 * https://github.com/wbitos/CCXml/wiki/Reference
**/

enum {
	CCXmlDocumentXMLKind = 0,
	CCXmlDocumentXHTMLKind,
	CCXmlDocumentHTMLKind,
	CCXmlDocumentTextKind
};
typedef NSUInteger CCXmlDocumentContentKind;

@interface CCXmlDocument : CCXmlNode
{
}

- (id)initWithXMLString:(NSString *)string options:(NSUInteger)mask error:(NSError **)error;
//- (id)initWithContentsOfURL:(NSURL *)url options:(NSUInteger)mask error:(NSError **)error;
- (id)initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError **)error;
//- (id)initWithRootElement:(CCXmlElement *)element;

//+ (Class)replacementClassForClass:(Class)cls;

//- (void)setCharacterEncoding:(NSString *)encoding; //primitive
//- (NSString *)characterEncoding; //primitive

//- (void)setVersion:(NSString *)version;
//- (NSString *)version;

//- (void)setStandalone:(BOOL)standalone;
//- (BOOL)isStandalone;

//- (void)setDocumentContentKind:(CCXmlDocumentContentKind)kind;
//- (CCXmlDocumentContentKind)documentContentKind;

//- (void)setMIMEType:(NSString *)MIMEType;
//- (NSString *)MIMEType;

//- (void)setDTD:(CCXmlDTD *)documentTypeDeclaration;
//- (CCXmlDTD *)DTD;

//- (void)setRootElement:(CCXmlNode *)root;
- (CCXmlElement *)rootElement;

//- (void)insertChild:(CCXmlNode *)child atIndex:(NSUInteger)index;

//- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;

//- (void)removeChildAtIndex:(NSUInteger)index;

//- (void)setChildren:(NSArray *)children;

//- (void)addChild:(CCXmlNode *)child;

//- (void)replaceChildAtIndex:(NSUInteger)index withNode:(CCXmlNode *)node;

- (NSData *)XMLData;
- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

//- (BOOL)validateAndReturnError:(NSError **)error;

@end
