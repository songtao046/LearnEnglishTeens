//
//  LENetManager.h
//  LearnEnglish
//
//  Created by Ma SongTao on 6/17/15.
//  Copyright (c) 2015 Sely. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LIST_PAGE_SIZE 6

#define SE_SUCCESS 0
#define INVALID_ID 0

#define SERVER_BASE_URL @"http://learnenglishteens.britishcouncil.org"

#define SERVICE_SKILL @"skills"
#define SERVICE_GRAMMAR @"grammar-vocabulary"
#define SERVICE_EXAMS @"exams"
#define SERVICE_UK @"uk-now"
#define SERVICE_STUDY_BREAK @"study-break"
#define SERVICE_MAGAZINE @"magazine"
#define SERVICE_ALL @"all"

//Skill Service
#define SK_READING @"reading-skills-practice"
#define SK_WRITING @"writing-skills-practice"
#define SK_LISTENING @"listening-skills-practice"

//Grammar & vocabulary Service
#define GV_VIDEOS @"grammar-videos"
#define GV_PV_VIDEOS @"phrasal-verb-videos"
#define GV_EXERCISES @"vocabulary-exercises"

//Exam Service
#define EX_READING @"reading-exams"
#define EX_WRITING @"writing-exams"
#define EX_LISTENING @"listening-exams"
#define EX_SPEAKING @"speaking-exams"
#define EX_GV @"grammar & volcabulary-exams"
#define EX_STUDY_TIPS @"exam-study-tips"

//UK Now Service
#define UK_READ @"read-uk"
#define UK_VIDEO @"video-uk"
#define UK_SP @"stories-and-poems-uk"
#define UK_FILM @"film-uk"
#define UK_MUSIC @"music-uk"
#define UK_SCIENCE @"science-uk"

//Study Break Service
#define SB_VIDEO_ZONE @"video-zone"
#define SB_GAMES @"games"
#define SB_PHOTO_CAPTIONS @"photo-captions"
#define SB_WHAT @"what-it"
#define SB_EASY_READING @"easy-reading"


//Magazine Service
#define MZ_BOOKS @"books"
#define MZ_ENTERTAINMENT @"entertainment"
#define MZ_FASHION @"fashion"
#define MZ_LIFE @"life-around-the-world"
#define MZ_MUSIC @"music"
#define MZ_SCIENCE @"science-and-technology"
#define MZ_SPORT @"sport"

//All Service
#define LE_ALL @"all"

typedef enum {
    HTTPMethodGet,   // GET
    HTTPMethodPost,  // POST
    HTTPMethodPut,   // PUT
    HTTPMethodDelete,// DELETE
} HTTPMethod;


@interface LENetManager : NSObject

+(LENetManager *)manager;

/* Login Token, almost all services need this token as request header. This token is returned by login/createUser interface*/
@property (nonatomic, strong) NSString* token;

-(void) sendRequest:(NSMutableURLRequest*)request
                        service:(NSString*)serviceName
                        path:(NSString*)path
                        parameters:(id)parameters
                        method:(HTTPMethod)method
                        responseHaveToken:(BOOL)haveToken
  completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler;

-(NSMutableURLRequest*) requestWithService:(NSString*)serviceName
                                      path:(NSString*)path
                                parameters:(id)parameters
                                    method:(HTTPMethod)method
                                 needToken:(BOOL)needToken
                             isJsonRequest:(BOOL)isJsonRequest
                                     error:(NSError**)error;


/**
 Create `NSMutableURLRequest` firstly and then use it to send request to server, processing response from server
 
 @param serviceName JAX-RS service name, this will be used to construct request URL
 @param path Addition URL path, will be appended after service name
 @param parameters Request parameters. If method == `HTTPMethodGet` or method == `HTTPMethodDelete`, the parameters should be `NSArray` and those parameters will be appened to request URL. If method == `HTTPMethodPost` or method == `HTTPMethodPut`, the parameters should be `NSDictionary` and those parameters will be treated form key/values format, those key/values will be encoded JSON format
 @param method `HTTPMethod`, different HTTP method will cause different parameters processing
 @param needToken If true, we will add X-SE-TOKEN to request header
 @param responseHaveToken If true, means the response header contains token, we need get it and store to `self.token`
 @param isJsonRequest If true and method = `HTTPMethodPost`, the parameters will encoded as JSON format
 @param completionHandler A block object to be called after request finished, this block will be called at background thread
 */
-(void) sendRequestWithService:(NSString*)serviceName
                          path:(NSString*)path
                    parameters:(id)parameters
                        method:(HTTPMethod)method
                     needToken:(BOOL)needToken
             responseHaveToken:(BOOL)haveToken
                 isJsonRequest:(BOOL)isJsonRequest
             completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError *error))completionHandler;


/**
 Call `completionHandler` at main thread
 
 @param result HTTP response result, already converted to `NSArray` or `NSDictonary` from JSON format
 @param errorCode error code defined by `SEErrorUtility`
 @param error detailed error information
 @param completionHandler A block object to be called at main thread
 */
-(void) completeWithResult:(id)result
                 errorCode:(NSInteger)errorCode
                     error:(NSError*)error
         completionHandler:(void (^)(id responseObject, NSInteger errorCode, NSError * error))completionHandler;
@end
