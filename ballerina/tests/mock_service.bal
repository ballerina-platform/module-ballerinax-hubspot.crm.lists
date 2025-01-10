// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/http;
import ballerina/io;

listener http:Listener httpListner = new (9090);

http:Service mockService = service object {
    // Create a List.
    resource function post .(http:Caller caller, http:Request request) returns error? {
        json payload = check request.getJsonPayload();
        string processingType = check payload.processingType;
        string objectTypeId = check payload.objectTypeId;
        string name = check payload.name;
        json response = {
            "list": {
                "listId": "1",
                "processingStatus": "",
                "processingType": processingType,
                "objectTypeId": objectTypeId,
                "listVersion": 0,
                "name": name
            }
        };
        return caller->respond(response);
    }

    // Fetch Multiple Lists.
    resource function get .(http:Caller caller, http:Request request) returns error? {
        json response = {
            "lists": [
                {
                    "listId": "1",
                    "processingStatus": "",
                    "processingType": "1",
                    "objectTypeId": "1",
                    "listVersion": 0,
                    "name": "Test"
                }
            ]
        };
        return caller->respond(response);
    }

    // Fetch List by Name
    resource function get object\-type\-id/[string objectTypeId]/name/[string listName](http:Caller caller, http:Request request) returns error? {
        json response = {
            "list": {
                "listId": "1",
                "processingStatus": "",
                "processingType": "1",
                "objectTypeId": objectTypeId,
                "listVersion": 0,
                "name": listName
            }
        };
        return caller->respond(response);
    }

    // Fetch List by ID
    resource function get [string listId](http:Caller caller, http:Request request) returns error? {
        json response = {
            "list": {
                "listId": listId,
                "processingStatus": "",
                "processingType": "1",
                "objectTypeId": "1",
                "listVersion": 0,
                "name": "Test"
            }
        };
        return caller->respond(response);
    }

    // Search Lists
    resource function post search(http:Caller caller, http:Request request) returns error? {
        json payload = check request.getJsonPayload();
        string query = check payload.query;
        json response = {
            "total": 0,
            "offset": 0,
            "lists": [
                {
                    "listId": "1",
                    "processingStatus": "",
                    "processingType": "",
                    "objectTypeId": "",
                    "listVersion": 0,
                    "name": query,
                    "additionalProperties": {}
                }
            ],
            hasMore: false
        };
        return caller->respond(response);
    }

    // Delete a List
    resource function delete [string listId](http:Caller caller, http:Request request) returns error? {
        http:Response response = new http:Response();
        response.statusCode = 204;
        return caller->respond(response);
    }

    // Restore a List
    resource function put [string listId]/restore(http:Caller caller, http:Request request) returns error? {
        http:Response response = new http:Response();
        response.statusCode = 204;
        return caller->respond(response);
    }

    // Update List Name
    resource function put [string listId]/update\-list\-name(http:Caller caller, http:Request request) returns error? {
        string listName = request.getQueryParamValue("listName") ?: "";
        json response = {
            "updatedList": {
                "listId": listId,
                "processingStatus": "",
                "processingType": "1",
                "objectTypeId": "0-1",
                "listVersion": 0,
                "name": listName
            }
        };
        return caller->respond(response);
    }
};

function init() returns error? {
    if isLiveServer {
        return;
    }
    io:println("Initiating mock server");
    check httpListner.attach(mockService, "/");
    check httpListner.start();
};

