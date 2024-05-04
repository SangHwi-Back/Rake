//
//  XmlParser.m
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//


#import <Foundation/Foundation.h>
#import "CustomXmlParser.h"

@implementation CustomXmlParser
@synthesize xmlData = _xmlData, dictionary = _dictionary, currentNode = _currentNode, currentParentNode = _currentParentNode;
- (id)initWithXMLData:(NSData *)xmlData
{
    if(self = [super init]){
        _xmlData = xmlData;
    }
    return self;
}
- (NSMutableDictionary *)dictionary
{
    if(!_dictionary){
        _dictionary = [[NSMutableDictionary alloc] init];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.xmlData];
        parser.delegate = self;
        [parser parse];
    }
    return _dictionary;
}
- (NSMutableDictionary *)currentNode
{
    if(!_currentNode){
        _currentNode = _dictionary;
    }
    return _currentNode;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    NSMutableDictionary *node = [[NSMutableDictionary alloc] init];
    [self.currentNode setObject:node forKey:elementName];
    self.currentParentNode = self.currentNode;
    self.currentNode = node;
    if([attributeDict count] != 0)
    {
        [self.currentNode setObject:attributeDict forKey:@"attributes"];
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    self.currentNode = self.currentParentNode;
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([trimmedString length] != 0){
        [self.currentNode setObject:trimmedString forKey:@"value"];
    }
}
@end
