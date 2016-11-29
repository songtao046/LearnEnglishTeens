//
//  LENetManager.m
//  LearnEnglish
//
//  Created by Ma SongTao on 6/17/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import "LENetManager.h"
#import "AFNetworking.h"
#import "SETalkingData.h"
#import "Logger.h"
#import "Reachability.h"

static LENetManager* gManager;



// Client Error Definitions
#define JSON_PARSER_FAILED 10000
#define GENERATE_REQUEST_URL_FAILED 10001
#define HTTP_REQUEST_FAILED 10002
#define ERROR_INVALID_RESULT 10003
#define ERROR_INVALID_ID 10004
#define ERROR_RESPONSE_SHOULD_HAVE_TOKEN 10005
#define ERROR_DOWNLOAD_TOKEN_EXPIRED 10006
#define ERROR_QINIU_UPLOAD_FAILED_WITH_WRONG_RESPONSE 10007

// Default server url
#define STONE_ENGINE_HOST @"STONE_ENGINE_HOST"
#define STONE_ENGINE_DB   @"STONE_ENGINE_DB"

// HTTP header for token
#define HTTP_HEADER_TOKEN_NAME @"X-SE-TOKEN"
#define HTTP_HEADER_DB_NAME @"X-SE-DB-NAME"

@interface LENetManager()

@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) NSURL *baseURL;

@end

@implementation LENetManager


#pragma mark - Init
+(LENetManager*) manager
{
    if (gManager == nil)
    {
        gManager = [[LENetManager alloc] init];
    }
    
    return gManager;
}



-(id) init
{
    self = [super init];
    if (self)
    {
        [self initSessionManager];
        _baseURL = [NSURL URLWithString:SERVER_BASE_URL];
    }
    
    return self;
}

-(void) initSessionManager
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    _manager.securityPolicy = [self securityPolicyForCertficateSSL];
//    _manager.responseSerializer = [AFHTTPRequestSerializer serializer];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

}

/**
 Prepare cert file for SSL connection
 */
-(AFSecurityPolicy*) securityPolicyForCertficateSSL
{
    AFSecurityPolicy * securityPolicy = [[AFSecurityPolicy alloc] init];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    
    return securityPolicy;
}


-(void) sendRequest:(NSMutableURLRequest*)request service:(NSString*)serviceName path:(NSString*)path parameters:(id)parameters method:(HTTPMethod)method responseHaveToken:(BOOL)haveToken completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler
{
    NSMutableString* urlPath = [NSMutableString stringWithString:serviceName];
    if (path != nil || path.length > 0)
    {
        [urlPath appendFormat:@"/%@", path];
    }

    // We already modified AFNetworking's dataTaskWithRequest method to make sure completionHandler block will be called at background thread
    __block NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
    NSURLSessionDataTask* task = [self.manager dataTaskWithRequest:request
                                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
                                  {
                                      NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
                                      NSTimeInterval duration = endTime - startTime;
                                      
                                      // Check error, the error could be client network error, server error and JSON decode error
                                      // The response object already be converted to `NSArray` or `NSDictionary` from JSON string by AFNetworking
                                      if (error != nil)
                                      {
                                          if (response != nil)
                                          {
                                              NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
                                              [SETalkingData trackWithEvent:HTTPRequestErrorEvent label:urlPath dicWithKeys:@[SEErrorCode] andValues:@[NSStringFromInteger(httpResponse.statusCode)]];
                                              completionHandler(nil, httpResponse.statusCode, error);
                                          }
                                          else
                                          {
                                              [SETalkingData trackWithEvent:HTTPRequestErrorEvent label:urlPath dicWithKeys:@[SEErrorCode] andValues:@[NSStringFromInteger(HTTP_REQUEST_FAILED)]];
                                              completionHandler(nil, HTTP_REQUEST_FAILED, error);
                                          }
                                          return ;
                                      }
                                      // REVISIT: should we check response status again, it seems AFNetworking already checked response status
                                      // and if status codes means error, the `error` object contains detailed info.
                                      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
                                      if (httpResponse.statusCode != 200)
                                      {
                                          NSError* error = [NSError errorWithDomain:@"HTTP" code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: @"status code != 200" }];
                                          [SETalkingData trackWithEvent:HTTPRequestErrorEvent label:urlPath dicWithKeys:@[SEErrorCode] andValues:@[NSStringFromInteger(httpResponse.statusCode)]];
                                          completionHandler(nil, httpResponse.statusCode, error);
                                          return;
                                      }
                                      
                                      // Response header should contains token
                                      if (haveToken)
                                      {
                                          if ( httpResponse.allHeaderFields[HTTP_HEADER_TOKEN_NAME] == nil)
                                          {
                                              NSError* error = [NSError errorWithDomain:@"HTTP" code:httpResponse.statusCode userInfo:@{NSLocalizedDescriptionKey: @"HTTP response header should have token" }];
                                              [SETalkingData trackWithEvent:HTTPRequestErrorEvent label:urlPath dicWithKeys:@[SEErrorCode] andValues:@[urlPath,NSStringFromInteger(ERROR_RESPONSE_SHOULD_HAVE_TOKEN)]];
                                              completionHandler(nil, ERROR_RESPONSE_SHOULD_HAVE_TOKEN, error);
                                              return;
                                          }
                                          
                                          self.token = httpResponse.allHeaderFields[HTTP_HEADER_TOKEN_NAME];
                                      }
//                                      [[Logger Instance] Info:@"%@ - %@", [[request URL] absoluteString] ,responseObject];
                                      [SETalkingData trackWithEvent:HTTPRequestEvent label:urlPath dicWithKeys:@[SEDuration, SENetwork] andValues:@[[SETalkingData levelOfDuration:duration],  NSStringFromInteger([[Reachability reachabilityForInternetConnection] currentReachabilityStatus])]];
                                      completionHandler(responseObject, SE_SUCCESS, nil);
                                      
                                  }];
    
    [task resume];
    
}

-(NSMutableURLRequest*) requestWithService:(NSString*)serviceName path:(NSString*)path parameters:(id)parameters method:(HTTPMethod)method needToken:(BOOL)needToken isJsonRequest:(BOOL)isJsonRequest error:(NSError**)error
{
    // Construct request URL
    NSMutableString* urlPath = [NSMutableString stringWithString:serviceName];
    if (path != nil || path.length > 0)
    {
        [urlPath appendFormat:@"/%@", path];
    }
    
    // If HTTP method is "GET", we will append all parameters to request URL, treat it as Path Parameters
    if (method == HTTPMethodGet && parameters != nil && [parameters isKindOfClass:[NSArray class]])
    {
        for (id para in parameters)
        {
            if ([para isKindOfClass:[NSNumber class]])
            {
                NSNumber* number = (NSNumber*)para;
                
                [urlPath appendFormat:@"/%@", number];
            }
            else if([para isKindOfClass:[NSString class]])
            {
                [urlPath appendFormat:@"/%@", para];
            }
        }
        
        parameters = nil;
    }
    
    NSURL *URL = [NSURL URLWithString:urlPath relativeToURL:self.baseURL];
    
    NSString* httpMethod;
    switch (method)
    {
        case HTTPMethodGet:
            httpMethod = @"GET";
            break;
        case HTTPMethodPost:
            httpMethod = @"POST";
            break;
        case HTTPMethodPut:
            httpMethod = @"PUT";
            break;
        case HTTPMethodDelete:
            httpMethod = @"DELETE";
            break;
        default:
            break;
    }
    
    NSMutableURLRequest* request;
    // Construct request and encode parametres into JSON format if HTTP method is POST or PUT
    if (isJsonRequest)
    {
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:httpMethod
                                                                URLString:[URL absoluteString]
                                                               parameters:httpMethod == HTTPMethodGet ? nil : parameters
                                                                    error:error];
    }
    else
    {
        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:httpMethod
                                                                URLString:[URL absoluteString]
                                                               parameters:httpMethod == HTTPMethodGet ? nil : parameters
                                                                    error:error];
    }
    
    // Add database name to request header, server side will use this db name to find out which database will be used
    // Used for test only purpose, at release or sandbox env, we use default database, so we should not set this header
//    if (![Utility isStringEmpty:self.dbName])
//    {
//        [request addValue:self.dbName forHTTPHeaderField:HTTP_HEADER_DB_NAME];
//    }
    
    // Login token, almost all interfaces need this token to identify user.
    // Some interface like SERVICE_NAME_AUTH, SERVICE_NAME_SMS do not this header
    if (needToken)
    {
        [request addValue:self.token forHTTPHeaderField:HTTP_HEADER_TOKEN_NAME];
    }
    
#if DEBUG
    
    [request addValue:@"134" forHTTPHeaderField:@"abc"];
    [request addValue:@"123" forHTTPHeaderField:@"abcd"];
    [request addValue:@"124" forHTTPHeaderField:@"abce"];
#endif
    
    // Add image processing header
    // REVIST: should we add all image spec header for all method call?
//    if ([serviceName compare:SERVICE_NAME_AUTH] != NSOrderedSame && [serviceName compare:SERVICE_NAME_SMS] != NSOrderedSame)
//    {
//        [self addImageSpec:[SEImageDownloadSpec infoGroupAttendeeSpec] toRequest:request];
//        [self addImageSpec:[SEImageDownloadSpec infoGroupAvatarSpec] toRequest:request];
//        [self addImageSpec:[SEImageDownloadSpec infoImageSpec] toRequest:request];
//        [self addImageSpec:[SEImageDownloadSpec userAvatarSpec] toRequest:request];
//        [self addImageSpec:[SEImageDownloadSpec chatImageSpec] toRequest:request];
//    }
    
    // Add GZip support
    //[request addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    
    return request;
}

-(void) sendRequestWithService:(NSString*)serviceName
                          path:(NSString*)path
                    parameters:(id)parameters
                        method:(HTTPMethod)method
                     needToken:(BOOL)needToken
             responseHaveToken:(BOOL)haveToken
                 isJsonRequest:(BOOL)isJsonRequest
             completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler
{
    NSError* error = nil;
    
    NSMutableURLRequest* request = [self requestWithService:serviceName path:path parameters:parameters method:method needToken:needToken isJsonRequest:isJsonRequest error:&error];
    
    if (error != nil)
    {
        completionHandler(nil, GENERATE_REQUEST_URL_FAILED, error);
        return;
    }
    
    [self sendRequest:request service:(NSString*)serviceName path:(NSString*)path parameters:(id)parameters method:(HTTPMethod)method responseHaveToken:haveToken completionHandler:completionHandler];
}


-(void) completeWithResult:(id)result
                 errorCode:(NSInteger)errorCode
                     error:(NSError*)error
         completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError * error))completionHandler
{
    dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(result, errorCode, error);
    });
}
@end