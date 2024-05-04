//
//  CustomXmlParser.h
//  Rake
//
//  Created by 백상휘 on 5/4/24.
//
#import <Foundation/Foundation.h>

@interface CustomXmlParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSData *xmlData;
@property (strong, nonatomic) NSMutableDictionary *dictionary;
@property (strong, nonatomic) NSMutableDictionary *currentNode;
@property (strong, nonatomic) NSMutableDictionary *currentParentNode;

- (id)initWithXMLData:(NSData *)xmlData;

- (NSMutableDictionary *)dictionary;

@end
