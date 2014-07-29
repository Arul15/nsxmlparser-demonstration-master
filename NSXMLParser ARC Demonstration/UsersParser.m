//
//  UserParser.m
//  NSXMLParser ARC Demonstration
//
//  This code was taken from "Parsing XML data with NSXMLParser" at
//  http://wiki.cs.unh.edu/wiki/index.php/Parsing_XML_data_with_NSXMLParser
//
//  I have attempted here to preserve the basic structure of that code
//  but have made numerous modifications as outlined in the README.md document.
//
//  --
//
//  Modified by Robert Ryan on 12/20/12.
//  Copyright (c) 2012 Robert M. Ryan. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UsersParser.h"
#import "User.h"

@interface UsersParser ()

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSMutableString *currentElementValue;

@end

@implementation UsersParser

- (id) init {
    self = [super init];
    
    if (self) {
        // init array of user objects
        _users = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
	
    if ([elementName isEqualToString:@"users"]) {
        return;
    } else if ([elementName isEqualToString:@"user"]) {
        self.user  = [[User alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here:
        // self.user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    } else {
        self.currentElementValue = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.currentElementValue) {
        // append value to the ad hoc string
        [self.currentElementValue appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"users"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:@"user"]) {
        // We are done with user entry – add the parsed user
        // object to our user array
        [self.users addObject:self.user];
        // release user object
        self.user = nil;
    } else {
        // The parser hit one of the element values.
        // This syntax is possible because User object
        // property names match the XML user element names
        [self.user setValue:self.currentElementValue forKey:elementName];
    }
    
    self.currentElementValue = nil;
}

@end
