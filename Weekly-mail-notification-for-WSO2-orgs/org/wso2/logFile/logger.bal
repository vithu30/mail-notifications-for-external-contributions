//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

package org.wso2.logFile;

string LOG_LEVEL_ERROR = "ERROR";
string LOG_LEVEL_INFO = "INFO";
string LOG_LEVEL_DEBUG = "DEBUG";

@Description {value:"Write error log in log file"}
@Param {value:"message: message of the log"}
public function logError(string message, string packageName){
    var logTime,_ = getTime();

    string strLog = logTime + " " + LOG_LEVEL_ERROR + " [" + packageName + "] - " + message + "\n";
    blob blobLog = strLog.toBlob("UTF-8");
    writeToFile(blobLog);
}

@Description {value:"Write info log in log file"}
@Param {value:"message: message of the log"}
public function logInfo(string message, string packageName){
    var logTime,_ = getTime();

    string strLog = logTime + " " + LOG_LEVEL_INFO + " [" + packageName + "] - " + message + "\n";
    blob blobLog = strLog.toBlob("UTF-8");
    writeToFile(blobLog);
}

@Description {value:"Write debug log in log file"}
@Param {value:"message: message of the log"}
public function logDebug(string message, string packageName){
    var logTime,_ = getTime();

    string strLog = logTime + " " + LOG_LEVEL_DEBUG + " [" + packageName + "] - " + message + "\n";
    blob blobLog = strLog.toBlob("UTF-8");
    writeToFile(blobLog);
}

@Description {value:"Write current date in log file"}
@Param {value:"programName: running program name"}
public function logDate(string programName){
    var _,currentDate = getTime();

    string strLog = "\n%%%%%%%%%%%%%%%%%%%%%%%% "+ programName + " : " + currentDate + " %%%%%%%%%%%%%%%%%%%%%%%%" + "\n\n";
    blob blobLog = strLog.toBlob("UTF-8");
    writeToFile(blobLog);
}

@Description {value:"Clear log records"}
@Param {value:"clearDatesArray: array of cleaning dates"}
public function clearLogRecords(string[] clearDatesArray){
    foreach clearDate in clearDatesArray{
        deleteLogFile(clearDate);
    }
}