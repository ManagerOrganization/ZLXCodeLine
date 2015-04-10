#import <Foundation/Foundation.h>
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

@interface CCXmlElement : CCXmlNode
{
}

- (id)initWithName:(NSString *)name;
- (id)initWithName:(NSString *)name URI:(NSString *)URI;
- (id)initWithName:(NSString *)name stringValue:(NSString *)string;
- (id)initWithXMLString:(NSString *)string error:(NSError **)error;

#pragma mark --- Elements by name ---

- (NSArray *)elementsForName:(NSString *)name;
- (NSArray *)elementsForLocalName:(NSString *)localName URI:(NSString *)URI;

#pragma mark --- Attributes ---

- (void)addAttribute:(CCXmlNode *)attribute;
- (void)removeAttributeForName:(NSString *)name;
- (void)setAttributes:(NSArray *)attributes;
//- (void)setAttributesAsDictionary:(NSDictionary *)attributes;
- (NSArray *)attributes;
- (CCXmlNode *)attributeForName:(NSString *)name;
//- (CCXmlNode *)attributeForLocalName:(NSString *)localName URI:(NSString *)URI;

#pragma mark --- Namespaces ---

- (void)addNamespace:(CCXmlNode *)aNamespace;
- (void)removeNamespaceForPrefix:(NSString *)name;
- (void)setNamespaces:(NSArray *)namespaces;
- (NSArray *)namespaces;
- (CCXmlNode *)namespaceForPrefix:(NSString *)prefix;
- (CCXmlNode *)resolveNamespaceForName:(NSString *)name;
- (NSString *)resolvePrefixForNamespaceURI:(NSString *)namespaceURI;

#pragma mark --- Children ---

- (void)insertChild:(CCXmlNode *)child atIndex:(NSUInteger)index;
//- (void)insertChildren:(NSArray *)children atIndex:(NSUInteger)index;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)setChildren:(NSArray *)children;
- (void)addChild:(CCXmlNode *)child;
//- (void)replaceChildAtIndex:(NSUInteger)index withNode:(CCXmlNode *)node;
//- (void)normalizeAdjacentTextNodesPreservingCDATA:(BOOL)preserve;

@end
