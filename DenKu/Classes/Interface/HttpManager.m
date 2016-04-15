

#import "HttpManager.h"
#import "SHXMLParser.h"
#import "SBJsonParser.h"

@implementation HttpManager

static HttpManager *manager;

+ (void)initialize
{
    if (self == [HttpManager class]) {
        manager = [[HttpManager alloc] init];
    }
}

+ (HttpManager *)shareHttpManager
{
    return manager;
}

- (void)startAsynchronousWith:(ASIHTTPRequest *)request
{
    if (request) {
        [request setShouldContinueWhenAppEntersBackground:YES];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (ASIFormDataRequest *)getRequestWith:(NSString *)url
                               Modular:(NSString *)modular
                             Operation:(NSString *)classify
                           PostContent:(NSString *)content
                                  Post:(NSDictionary *)wsParas
{
    
    if ([classify isEqualToString:@"brand_list_index"]||[classify isEqualToString:@"brand_list_index_all"]) {
        wsParas = [NSMutableDictionary dictionaryWithDictionary:wsParas];
        [wsParas setValue:@"1" forKey:@"version_chk_flg"];
    }
    NSArray *sortKey = [wsParas.allKeys sortedArrayUsingComparator:^(NSString *obj1, NSString *obj2){
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    NSMutableString *tmpContent = [NSMutableString string];
    for (NSString *key in sortKey) {
        [tmpContent  appendFormat:@"%@=%@&", key, wsParas[key]];
    }
    if (tmpContent.length > 0) {
        [tmpContent replaceCharactersInRange:NSMakeRange(tmpContent.length - 1, 1)
                                  withString:SecretKey];
    } else {
        [tmpContent appendString:SecretKey];
    }
    NSString *sign = [[Common md5:tmpContent] lowercaseString];
    NSString *urlString;
    if ([classify isEqualToString:@"brand_list_index"]||[classify isEqualToString:@"brand_list_index_all"]) {
        urlString = [NSString stringWithFormat:@"%@c=%@&a=%@%@&sign=%@&version_chk_flg=1",
           url, modular, classify, (content ? content : @""), sign];
    }
    else {
        urlString = [NSString stringWithFormat:@"%@c=%@&a=%@%@&sign=%@",
                     url, modular, classify, (content ? content : @""), sign];
    }
    
    NSLog(@"urlString == %@",urlString);

    NSURL *nsurl = [NSURL URLWithString:urlString];
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:nsurl];
    [theRequest setRequestMethod:@"GET"];
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [theRequest setTimeOutSeconds:kHTTPRequestTimeOut];
    return theRequest;
}

- (ASIFormDataRequest *)getASISOAP11Request:(NSString *) WebURL
                                  InterFace:(NSString *)funcName
                                 Parameters:(NSArray *) wsParas
{
    NSString * soapMsgBodyHeader = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n"
                                                            "<SOAP-ENV:Envelope \r\n"
                                                            "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\"\r\n "//
                                                            "xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" \r\n"
                                                            "xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">\r\n "
                                                            "<SOAP-ENV:Body>\r\n"
                                                            "<%@>\n", funcName];
    NSString * soapMsgBodyFooter =[NSString stringWithFormat:@"</%@>\n"
                                                               "</soap:Body>\n"
                                                               "</soap:Envelope>", funcName];
    
    NSString * soapParas = @"";
    if (![wsParas isEqual:nil]) {
        int i = 0;
        for (i = 0; i < [wsParas count]; i = i + 2) {
            soapParas = [soapParas stringByAppendingFormat:
                         @"<%@ xsi:type=\"xsd:string\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\">%@</%@>\r\n",
                         [wsParas objectAtIndex:i],
                         [wsParas objectAtIndex:i+1],
                         [wsParas objectAtIndex:i]];
        }
    }
    NSString * soapMsg = [soapMsgBodyHeader stringByAppendingFormat:@"%@%@", soapParas, soapMsgBodyFooter];
    
    NSURL * url = [NSURL URLWithString:WebURL];
    
    ASIFormDataRequest * theRequest = [ASIFormDataRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    
    [theRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    [theRequest addRequestHeader:@"Content-Length" value:msgLength];
    [theRequest setRequestMethod:@"POST"];
    [theRequest appendPostData:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [theRequest setTimeOutSeconds:kHTTPRequestTimeOut];

    return theRequest;
}

- (NSDictionary *)parserXML:(NSString *)content
{
    if (content.length > 0) {
        SHXMLParser *parser = [[SHXMLParser alloc] init];
        return [parser parseData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}

- (id)parserJSON:(NSString *)content
{
    if (content.length > 0) {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        return [parser objectWithString:content];
    }
    return nil;
}

- (NSString *)parserReturn:(NSDictionary *)diction
{
    for (NSString *key in diction.allKeys) {
        if ([key isEqualToString:@"return"]) {
            return diction[key];
        } else if ([diction[key] isKindOfClass:[NSDictionary class]]) {
            return [self parserReturn:diction[key]];
        } else if ([diction[key] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dic in diction[key]) {
                id result = nil;
                if ((result = [self parserReturn:dic])) {
                    return result;
                }
            }
        }
    }
    return nil;
}

@end
