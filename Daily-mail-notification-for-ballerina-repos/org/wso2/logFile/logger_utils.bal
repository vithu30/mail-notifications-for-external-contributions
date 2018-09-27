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

import ballerina.io;
import ballerina.file;
import ballerina.time;
import ballerina.config;

const string FILE_PATH = config:getGlobalValue("LOG_FILE_PATH");
const string FILE_NAME = config:getGlobalValue("LOG_FILE_NAME");

@Description {value:"Write to a file"}
@Param {value:"readContent: content for write"}
function writeToFile (blob readContent) {
    string dstFilePath = FILE_PATH + FILE_NAME;
    io:ByteChannel destinationChannel = getByteChannel(dstFilePath, "a");
    _ = destinationChannel.writeBytes(readContent, 0);
}

@Description {value:"Create byte channel for write to file"}
@Param {value:"fileName: name of the file"}
@Param {value:"permission: access mode"}
@Return {value:"io:ByteChannel: created byte channel"}
function getByteChannel (string fileName, string permission)(io:ByteChannel) {
    file:File src = {path:fileName};
    io:ByteChannel channel = src.openChannel(permission);
    return channel;
}

@Description {value:"Generate curent time and time formating"}
@Return {value:"string: current time in full format"}
@Return {value:"string: current time in only date format"}
function getTime()(string, string){
    time:Time currentTime = time:currentTime();
    string fullTime = currentTime.format("yyyy-MM-dd'T'HH:mm:ss.SSS");
    fullTime = fullTime.split("T")[0] + " " +fullTime.split("T")[1];
    string fullDate = currentTime.format("yyyy-MM-dd");
    return fullTime,fullDate;
}

@Description {value:"Delete log file"}
@Param {value:"clearDate: date for clear log file"}
function deleteLogFile(string logClearDate) {
    time:Time time = time:currentTime();
    string currentDate = time.format("MM-dd");
    if(logClearDate == currentDate) {
        file:File logFile = {path:(FILE_PATH + FILE_NAME)};
        logFile.delete();
    }
}