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
import ballerina.config;
import ballerina.util;
import ballerina.log;
import ballerina.runtime;
import org.wso2.logFile;
import ballerina.io;

@Description { value:"function for sending mails"}
@Param { value:"to: recipient's mail address "}
@Param { value:"subject: mail subject"}
@Param { value:"accessToken: The access token of gmail account"}
@Param { value:"message: message to be sent in mail"}
public function send(string to,string subject, string accessToken, string message)(int){
    endpoint<http:HttpClient> httpConnectorEP {
    //httpClient;
        create http:HttpClient("https://www.googleapis.com/gmail", {});
    }
    string concatMessage = "";
    string from = config:getGlobalValue("GMAIL_FROM");
    //string from = "github-open-pr-analyzer@wso2.com";
    string cc = "engineering-group@wso2.com,rohan@wso2.com,shankar@wso2.com";
    http:OutRequest httpRequest = {};
    http:InResponse httpResponse = {};
    
    concatMessage = concatMessage + "to:" + to + "\n" +
                    "subject:" + subject + "\n" +
                    "from:" + from + "\n" +
                    "cc:" + cc + "\n" +
                    "Content-Type:" + CONTENT_TYPE + "\n" +
                    "\n" + message + "\n";
    
    string encodedRequest = util:base64Encode(concatMessage);
    encodedRequest = encodedRequest.replace("+","-");
    encodedRequest = encodedRequest.replace("/","_");
    json sendMailRequest = {"raw": encodedRequest};
    string sendMailPath = "/v1/users/" + from + "/messages/send";
    httpRequest.addHeader(GMAIL_AUTHORIZATION, GMAIL_BEARER + accessToken);
    httpRequest.setHeader("Content-Type", "application/json");
    httpRequest.setJsonPayload(sendMailRequest);
    http:HttpConnectorError httpConnectorError;
    httpResponse, httpConnectorError = httpConnectorEP.post(sendMailPath, httpRequest);
    int statusCode = httpResponse.statusCode;
    if(httpConnectorError != null){
        log:printError("Error in sending mail : " + httpConnectorError.message);
        logFile:logInfo("Error in sending mail : " + httpConnectorError.message,
                        runtime:getCallStack()[1].packageName);
    }
    return  statusCode;
}

@Description { value:"generate mail body with tables"}
@Param { value:"pullRequests: list of pull requests from non-WSO2 committers"}
@Param { value:"issues: list of issues from non-WSO2 committers"}
public function generateMailBody() {
    var pullRequests = readPRData();
    var issues = readIssueData();
    
    //string message;
    //string to;
    //int iterator;
    //int pullRequestCount;
    //int issuesCount;
    //int index;
    //string pullRequestMessage;
    //string issueMessage;
    //string accessToken = refreshAccessToken();
    //to = "vithursa@wso2.com";
    //
    //string header = "<head>
    //                <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />
    //                    <style>
    //                        table {
    //                            font-family: arial, sans-serif;
    //                            border-collapse: collapse;
    //                            width: 75%;
    //                            text-align: center;
    //                        }
    //                        td, th {
    //                            border: 1.5px solid #17202a;
    //                            text-align: left;
    //                            padding: 8px;
    //                        }
    //                    </style>
    //                </head>";
    //
    //string prTableHeader = "<table
    //                                cellspacing=\"1\"
    //                                cellpadding=\"1\"
    //                                border=\"1\"
    //                                bgcolor=\"#F2F2F2\" >
    //                                <tr bgcolor=\"#b4d0e8\">
    //                                    <th>Repository Name</th>
    //                                    <th>URL</th>
    //                                    <th>Github Id</th>
    //                                    <th>Open Days</th>
    //                                    <th>Open Weeks</th>
    //                                    <th>State</th>
    //                                </tr>";
    //
    //string issueTableHeader = "<table
    //                                cellspacing=\"1\"
    //                                cellpadding=\"1\"
    //                                border=\"1\"
    //                                bgcolor=\"#F2F2F2\" >
    //                                <tr bgcolor=\"#b4d0e8\">
    //                                    <th>Repository Name</th>
    //                                    <th>URL</th>
    //                                    <th>Github Id</th>
    //                                    <th>Open Days</th>
    //                                    <th>Open Weeks</th>
    //                                </tr>";
    //
    //    pullRequestCount = 0;
    //    issuesCount = 0;
    //    pullRequestMessage = "";
    //    issueMessage = "";
    //
    //    // Generate body of table for pull requests
    //
    //    while(iterator < lengthof pullRequests){
    //            pullRequestCount = pullRequestCount + 1;
    //            pullRequestMessage = pullRequestMessage +
    //                                 "<tr>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].RepositoryName + "</td>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].Url+ "</td>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].GithubId + "</td>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].Days+ "</td>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].Weeks + "</td>
    //                <td style=\"font-size:12px;\">" + pullRequests[iterator].State+ "</td>
    //            </tr>";
    //
    //        iterator = iterator + 1;
    //    }
    //    iterator = 0;
    //
    //    // Generate body of table for issues
    //    while(iterator < lengthof issues){
    //            issuesCount = issuesCount + 1;
    //            issueMessage = issueMessage +
    //                           "<tr>
    //                <td style=\"font-size:12px;\">" + issues[iterator].RepositoryName + "</td>
    //                <td style=\"font-size:12px;\">" + issues[iterator].Url + "</td>
    //                <td style=\"font-size:12px;\">" + issues[iterator].GithubId + "</td>
    //                <td style=\"font-size:12px;\">" + issues[iterator].Days + "</td>
    //                <td style=\"font-size:12px;\">" + issues[iterator].Weeks + "</td>
    //                </tr>";
    //        iterator = iterator + 1;
    //    }
    //    iterator = 0;
    //
    //    // Send mail with tables considering whether issues / pull requests
    //    // exists or not
    //
    //    if(pullRequestCount > 0 || issuesCount > 0){
    //        if(checkAccessToken(accessToken)){
    //            accessToken = refreshAccessToken();
    //        }
    //        if(pullRequestCount > 0 && issuesCount > 0){
    //            message = "<html>" +
    //                      header +
    //                      "<h2>
    //                          \n Pull Requests from non WSO2 committers \n
    //                      </h2>
    //                      <body style=\"margin:0; padding:0;\">" +
    //                      prTableHeader +
    //                      pullRequestMessage +
    //                      "</table>
    //                      <h2>
    //                        \n Issues from non WSO2 committers \n
    //                      </h2>" +
    //                      issueTableHeader +
    //                      issueMessage +"
    //                      </table>
    //                      </body>
    //                      </html>";
    //        }
    //        else{
    //            if(pullRequestCount > 0){
    //                message = "<html>" +
    //                          header +
    //                          "<h2>
    //                              \n Pull Requests from non WSO2 committers \n
    //                          </h2>
    //                          <body style=\"margin:0; padding:0;\">" +
    //                          prTableHeader +
    //                          pullRequestMessage +"
    //                          </body>
    //                          </html>";
    //            }
    //            else{
    //                message = "<html>"+
    //                          header +
    //                          "<h2>
    //                              \n Issues from non WSO2 committers \n
    //                          </h2>
    //                          <body style=\"margin:0; padding:0;\">" +
    //                          issueTableHeader +
    //                          issueMessage +"
    //                          </body>
    //                          </html>";
    //            }
    //        }
    //        //to =  mailingList[index] != "" ? mailingList[index] : "engineering-group@wso2.com";
    //        try{
    //            int status = send(to,"Open PRs and issues from non WSO2 committers : Ballerina" ,accessToken,message);
    //            if(status ==200){
    //                log:printInfo("Mail sent to " + to + " and cc to ");
    //            }else{
    //                log:printError("Error in sending mail " + status);
    //            }
    //
    //        }
    //        catch (error err) {
    //            log:printError("Unable to send mail : " + err.message);
    //        }
    //
    //    }
    //    index = index + 1;
}

@Description { value:"check whether the access token is expired or not"}
@Param { value:"accessToken: access token of the gmail account"}
public function checkAccessToken(string accessToken)(boolean){
    endpoint<http:HttpClient> httpConnector {
        create http:HttpClient(GMAIL_API_CHECK_ACCESS_TOKEN_URL, {});
    }
    boolean isExpired = false;
    http:OutRequest httpRequest = {};
    http:InResponse httpResponse = {};
    
    httpRequest.addHeader("Content-Type", "application/x-www-form-urlencoded");
    httpRequest.setJsonPayload("access_token=" + accessToken);
    http:HttpConnectorError httpConnectorError;
    httpResponse, httpConnectorError = httpConnector.post("/tokeninfo", httpRequest);
    if(httpConnectorError != null){
        log:printError("Error in checking access token : " + httpConnectorError.message);
        logFile:logError("Error in checking access token : " + httpConnectorError.message,
                         runtime:getCallStack()[1].packageName);
    }
    json jsonResponse = httpResponse.getJsonPayload();
    try{
        if(jsonResponse.error_description != null) {
            isExpired = true;
        }
    }
    catch (error err) {
        log:printError("Error in getting response" + err.message);
        logFile:logError("Error in getting response" + err.message, runtime:getCallStack()[1].packageName);
    }
    
    return isExpired;
}

@Description { value:"generate new access token from refresh token"}
public function refreshAccessToken () (string) {
    endpoint<http:HttpClient> refreshTokenHTTPEP {
        create http:HttpClient(GMAIL_API_REFRESH_TOKEN_URL, {});
    }
    string accessToken;
    string refreshToken = config:getGlobalValue("GMAIL_REFRESH_TOKEN");
    string clientId = config:getGlobalValue("GMAIL_CLIENT_ID");
    string clientSecret = config:getGlobalValue("GMAIL_CLIENT_SECRET");
    //string refreshToken = "1/AjQW_fYCrAvsoWr2v5bHYC0BPUumuWYMUYmqmS7boJ0";
    //string clientSecret = "6A1f6P3IXcilu9TVgsZX22A4";
    //string clientId = "453012534900-mdp60q45n0q976ocbe2suqnlsvk2g0rb.apps.googleusercontent.com";
    string request = "grant_type=refresh_token" + "&client_id=" + clientId +
                     "&client_secret=" + clientSecret +"&refresh_token=" + refreshToken;
    http:OutRequest httpRequest = {};
    http:InResponse httpResponse = {};
    
    httpRequest.setHeader("Content-Type", "application/x-www-form-urlencoded");
    httpRequest.setStringPayload(request);
    http:HttpConnectorError httpConnectorError;
    httpResponse,httpConnectorError = refreshTokenHTTPEP.post("/token", httpRequest);
    if(httpConnectorError != null){
        log:printError("Error in generating access token : " + httpConnectorError.message);
        logFile:logError("Error in generating access token : " + httpConnectorError.message,
                         runtime:getCallStack()[1].packageName);
    }
    json response = httpResponse.getJsonPayload();
    try{
        accessToken = response.access_token.toString();
    }catch (error err) {
        log:printError(response.error.toString());
        logFile:logError(response.error.toString(),runtime:getCallStack()[1].packageName);
    }
    return accessToken;
}
