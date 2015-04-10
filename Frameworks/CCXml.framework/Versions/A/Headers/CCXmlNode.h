#import <Foundation/Foundation.h>
#import <libxml/tree.h>

@class CCXmlDocument;

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
	CCXmlInvalidKind                = 0,
	CCXmlDocumentKind               = XML_DOCUMENT_NODE,
	CCXmlElementKind                = XML_ELEMENT_NODE,
	CCXmlAttributeKind              = XML_ATTRIBUTE_NODE,
	CCXmlNamespaceKind              = XML_NAMESPACE_DECL,
	CCXmlProcessingInstructionKind  = XML_PI_NODE,
	CCXmlCommentKind                = XML_COMMENT_NODE,
	CCXmlTextKind                   = XML_TEXT_NODE,
	CCXmlDTDKind                    = XML_DTD_NODE,
	CCXmlEntityDeclarationKind      = XML_ENTITY_DECL,
	CCXmlAttributeDeclarationKind   = XML_ATTRIBUTE_DECL,
	CCXmlElementDeclarationKind     = XML_ELEMENT_DECL,
	CCXmlNotationDeclarationKind    = XML_NOTATION_NODE
};
typedef NSUInteger CCXmlNodeKind;

enum {
	CCXmlNodeOptionsNone            = 0,
	CCXmlNodeExpandEmptyElement     = 1 << 1,
	CCXmlNodeCompactEmptyElement    = 1 << 2,
	CCXmlNodePrettyPrint            = 1 << 17,
};


//extern struct _xmlKind;


@interface CCXmlNode : NSObject <NSCopying>
{
	// Every CCXml object is simply a wrapper around an underlying libxml node
	struct _xmlKind *genericPtr;
	
	// Every libxml node resides somewhere within an xml tree heirarchy.
	// We cannot free the tree heirarchy until all referencing nodes have been released.
	// So all nodes retain a reference to the node that created them,
	// and when the last reference is released the tree gets freed.
	CCXmlNode *owner;
}

//- (id)initWithKind:(CCXmlNodeKind)kind;

//- (id)initWithKind:(CCXmlNodeKind)kind options:(NSUInteger)options;

//+ (id)document;

//+ (id)documentWithRootElement:(CCXmlElement *)element;

+ (id)elementWithName:(NSString *)name;

+ (id)elementWithName:(NSString *)name URI:(NSString *)URI;

+ (id)elementWithName:(NSString *)name stringValue:(NSString *)string;

+ (id)elementWithName:(NSString *)name children:(NSArray *)children attributes:(NSArray *)attributes;

+ (id)attributeWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)attributeWithName:(NSString *)name URI:(NSString *)URI stringValue:(NSString *)stringValue;

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)processingInstructionWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)commentWithStringValue:(NSString *)stringValue;

+ (id)textWithStringValue:(NSString *)stringValue;

//+ (id)DTDNodeWithXMLString:(NSString *)string;

#pragma mark --- Properties ---

- (CCXmlNodeKind)kind;

- (void)setName:(NSString *)name;
- (NSString *)name;

//- (void)setObjectValue:(id)value;
//- (id)objectValue;

- (void)setStringValue:(NSString *)string;
//- (void)setStringValue:(NSString *)string resolvingEntities:(BOOL)resolve;
- (NSString *)stringValue;

#pragma mark --- Tree Navigation ---

- (NSUInteger)index;

- (NSUInteger)level;

- (CCXmlDocument *)rootDocument;

- (CCXmlNode *)parent;
- (NSUInteger)childCount;
- (NSArray *)children;
- (CCXmlNode *)childAtIndex:(NSUInteger)index;

- (CCXmlNode *)previousSibling;
- (CCXmlNode *)nextSibling;

- (CCXmlNode *)previousNode;
- (CCXmlNode *)nextNode;

- (void)detach;

- (NSString *)XPath;

#pragma mark --- QNames ---

- (NSString *)localName;
- (NSString *)prefix;

- (void)setURI:(NSString *)URI;
- (NSString *)URI;

+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
//+ (CCXmlNode *)predefinedNamespaceForPrefix:(NSString *)name;

#pragma mark --- Output ---

- (NSString *)description;
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

#pragma mark --- XPath/XQuery ---

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery constants:(NSDictionary *)constants error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery error:(NSError **)error;

@end
