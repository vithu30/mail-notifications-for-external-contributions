// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

package org.wso2.contributions_from_outsiders;

import ballerina.net.http;
import ballerina.collections;
import ballerina.config;
import ballerina.log;
import org.wso2.logFile;
import ballerina.runtime;
import ballerina.io;

boolean hasNextPage = true;
string endCursor;


@Description { value:"get all repositories name by traversing all pages"}
public function getRepositories (string organization) (collections:Vector) {
    log:printInfo("Connection established with github API");
    logFile:logInfo("Connection established with github API", runtime:getCallStack()[1].packageName);
    string repositoryQuery;
    collections:Vector responseVector = {vec:[]};
    boolean flag = true;
    hasNextPage = true;
    while(hasNextPage){
        if(flag){
            repositoryQuery  = string `{"{{GIT_VARIABLES}}":{"{{GIT_LOGIN}}":"{{organization}}"},
                                            "{{GIT_QUERY}}":"{{FIRST_PAGE_REPOSITORY_QUERY}}"}`;
            flag = false;
        }
        else{
            repositoryQuery = string `{"{{GIT_VARIABLES}}":
                                        {"{{GIT_LOGIN}}":"{{organization}}","{{GIT_END_CURSOR}}":"{{endCursor}}"},
                                        "{{GIT_QUERY}}":"{{NEXT_PAGE_REPOSITORY_QUERY}}"}`;
        }
        
        var jsonQuery, _ = <json> repositoryQuery;
        json response = generateHttpClient(jsonQuery,createHttpClient());
        responseVector.add(response);
        error typeConversionError;
        try{
            hasNextPage, typeConversionError =
            <boolean> response.data.organization.repositories.pageInfo.hasNextPage.toString();
        } catch (error err) {
            log:printError("Error in fetching data from GraphQL API : " + err.message);
            logFile:logError("Error in fetching data from GraphQL API : " + err.message ,
                             runtime:getCallStack()[1].packageName);
            if(typeConversionError != null){
                log:printError("Error occured in conversion to boolean : " + typeConversionError.message);
                logFile:logError("Error occured in conversion to boolean : " + typeConversionError.message ,
                                 runtime:getCallStack()[1].packageName);
            }
        }
        if(hasNextPage){
            endCursor =  response.data.organization.repositories.pageInfo.endCursor.toString();
        }
    }
    log:printInfo("List of repositories is generated");
    logFile:logInfo("List of repositories is generated", runtime:getCallStack()[1].packageName);
    return responseVector;
}

@Description { value:"get pull requests of given repositories (with pagination)"}
@Param { value:"responseVector: vector contains all repositories name"}
public function getPullRequests (collections:Vector responseVector, string organization) {
    log:printInfo("Connection established with github API");
    logFile:logInfo("Connection established with github API", runtime:getCallStack()[1].packageName);
    int numberOfPages = responseVector.vectorSize;
    int pageIterator;
    int numberOfRepositories;
    string endCursor;
    string repositoryName;
    boolean flag = true;
    while(pageIterator < numberOfPages) {
        var response, typeConversionError = (json)responseVector.get(pageIterator);
        if(typeConversionError != null){
            log:printError("Error in conversion to json : " + typeConversionError.message);
            logFile:logError("Error in conversion to json : " + typeConversionError.message ,
                             runtime:getCallStack()[1].packageName);
        }
        numberOfRepositories = lengthof response.data.organization.repositories.nodes;
        int repositoryIterator;
        while(repositoryIterator < numberOfRepositories) {
            repositoryName = response.data.organization.repositories.nodes[repositoryIterator].name.toString();
            log:printInfo("Get pull requests of repository - " + repositoryName);
            logFile:logInfo("Get pull requests of repository - " + repositoryName,
                            runtime:getCallStack()[1].packageName);
            hasNextPage = true;
            flag = true;
            string pullRequestQuery;
            while(hasNextPage){
                if(flag){
                    pullRequestQuery = string `{"{{GIT_VARIABLES}}":
                    {"{{GIT_LOGIN}}":"{{organization}}","{{GIT_NAME}}":"{{repositoryName}}"},
                    "{{GIT_QUERY}}":"{{FIRST_PAGE_PULL_REQUEST_QUERY}}"}`;
                    flag = false;
                }
                else{
                    pullRequestQuery = string `{"{{GIT_VARIABLES}}":
                    {"{{GIT_LOGIN}}":"{{organization}}","{{GIT_NAME}}":"{{repositoryName}}",
                            "{{GIT_END_CURSOR}}":"{{endCursor}}"},"{{GIT_QUERY}}":"{{NEXT_PAGE_PULL_REQUEST_QUERY}}"}`;
                }
                var jsonPayload, _ = <json> pullRequestQuery;
                json pullRequests = generateHttpClient(jsonPayload,createHttpClient()).data.organization.repository.pullRequests;
                error typeCastError;
                hasNextPage, typeCastError = <boolean> pullRequests.pageInfo.hasNextPage.toString();
                if(hasNextPage){
                    endCursor =  pullRequests.pageInfo.endCursor.toString();
                }
                if(pullRequests.nodes != null){
                    generateData(pullRequests, "pullRequest");
                }
            }
            repositoryIterator = repositoryIterator + 1;
        }
        pageIterator = pageIterator + 1;
    }
}

@Description { value:"get issues of given repositories (with pagination)"}
@Param { value:"responseVector: vector contains all repositories name"}
public function getIssues (collections:Vector responseVector, string organization) {
    int numberOfPages = responseVector.vectorSize;
    int pageIterator;
    int numberOfRepositories;
    string endCursor = "";
    string repositoryName;
    string issueQuery;
    hasNextPage = true;
    boolean flag = true;
    while(pageIterator < numberOfPages) {
        var response, typeConversionError = (json)responseVector.get(pageIterator);
        if(typeConversionError != null){
            log:printError("Error in conversion to json : " + typeConversionError.message);
            logFile:logError("Error in conversion to json : " + typeConversionError.message ,
                             runtime:getCallStack()[1].packageName);
        }
        numberOfRepositories = lengthof response.data.organization.repositories.nodes;
        int repositoryIterator;
        while(repositoryIterator < numberOfRepositories) {
            repositoryName = response.data.organization.repositories.nodes[repositoryIterator].name.toString();
            log:printInfo("Get issues of repository - " + repositoryName);
            logFile:logInfo("Get issues of repository - " + repositoryName,runtime:getCallStack()[1].packageName);
            hasNextPage = true;
            flag = true;
            endCursor = "";
            while(hasNextPage){
                if(flag){
                    issueQuery = string `{"{{GIT_VARIABLES}}":{"{{GIT_LOGIN}}":"{{organization}}",
                    "{{GIT_NAME}}":"{{repositoryName}}"},"{{GIT_QUERY}}":"{{FIRST_PAGE_ISSUE_QUERY}}"}`;
                    flag = false;
                }
                else{
                    issueQuery = string `{"{{GIT_VARIABLES}}":{"{{GIT_LOGIN}}":"{{organization}}",
                    "{{GIT_NAME}}":"{{repositoryName}}","{{GIT_END_CURSOR}}":"{{endCursor}}"},
                    "{{GIT_QUERY}}":"{{NEXT_PAGE_ISSUE_QUERY}}"}`;
                }
                var jsonPayload, _ = <json> issueQuery;
                error typeCastError;
                json issues = generateHttpClient(jsonPayload,createHttpClient()).data.organization.repository.issues;
                hasNextPage, typeCastError = <boolean> issues.pageInfo.hasNextPage.toString();
                if(hasNextPage){
                    endCursor = issues.pageInfo.endCursor.toString();
                }
                if(issues.nodes != null){
                    generateData(issues, "issue");
                }
            }
            repositoryIterator = repositoryIterator + 1;
        }
        pageIterator = pageIterator + 1;
    }
}

public function generateHttpClient (json jsonPayload,http:HttpClient httpClient) (json) {
    endpoint <http:HttpClient> httpGithubEP {
              httpClient;
    }
    http:OutRequest httpOutRequest = {};
    http:InResponse httpInResponse = {};
    string accessToken = config:getGlobalValue("GITHUB_TOKEN");
    httpOutRequest.addHeader("Authorization","Bearer " + accessToken);
    httpOutRequest.setJsonPayload(jsonPayload);
    http:HttpConnectorError  httpConnectError;
    httpInResponse,httpConnectError = httpGithubEP.post("",httpOutRequest);
    io:println("status code of response : " + httpInResponse.statusCode);
    if(httpConnectError != null) {
        log:printError("Error in post request : " + httpConnectError.message);
        logFile:logError("Error in post request : " + httpConnectError.message,runtime:getCallStack()[1].packageName);
    }
    json response = httpInResponse.getJsonPayload();
    if(response.error == null){
        logFile:logInfo("success", runtime:getCallStack()[1].packageName);
    }
    
    return response;
}

public function createHttpClient()(http:HttpClient httpClient){
    httpClient = create http:HttpClient ("https://api.github.com/graphql",{});
    return ;
}