#import <Foundation/Foundation.h>
#import "CCXml.h"

// These methods are not part of the standard NSXML API.
// But any developer working extensively with XML will likely appreciate them.

@interface CCXmlElement (DDAdditions)

+ (CCXmlElement *)elementWithName:(NSString *)name xmlns:(NSString *)ns;

- (CCXmlElement *)elementForName:(NSString *)name;
- (CCXmlElement *)elementForName:(NSString *)name xmlns:(NSString *)xmlns;

- (NSString *)xmlns;
- (void)setXmlns:(NSString *)ns;

- (NSString *)prettyXMLString;
- (NSString *)compactXMLString;

- (void)addAttributeWithName:(NSString *)name stringValue:(NSString *)string;

- (NSDictionary *)attributesAsDictionary;

@end
