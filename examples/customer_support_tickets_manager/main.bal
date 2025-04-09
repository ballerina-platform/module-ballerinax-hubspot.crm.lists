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

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.lists as hslists;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// To run this example, you need to add 'tickets' scope to the HubSpot OAuth key
// with other required scopes for the Ballerina HubSpot CRM Lists connector.

hslists:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hslists:Client hubspotClient = check new ({auth});

public function main() returns error? {
    // creating a new folder for customer support tickets
    hslists:ListFolderCreateRequest folderCreateReqPayload = {
        name: "Customer Support Tickets"
    };
    hslists:ListFolderCreateResponse postFolderCreateResponse = check hubspotClient->postFoldersCreate(folderCreateReqPayload);

    hslists:PublicListFolder folder = postFolderCreateResponse.folder;
    io:println("[+] Folder created successfully: ", folder.name);

    // Generating lists for seperate priority levels
    hslists:PublicEnumerationPropertyOperation filterOperation = {
        includeObjectsWithNoValueSet: false,
        values: ["HIGH"],
        operationType: "ENUMERATION",
        operator: "IS_ANY_OF"
    };
    hslists:PublicPropertyFilter filterName = {
        property: "hs_ticket_priority",
        filterType: "PROPERTY",
        operation: {...filterOperation}
    };
    hslists:PublicAndFilterBranch nestedFilterBranch = {
        filterBranchType: "AND",
        filterBranches: [],
        filterBranchOperator: "AND",
        filters: [filterName]
    };
    hslists:PublicOrFilterBranch filterBranch = {
        filterBranchType: "OR",
        filterBranches: [nestedFilterBranch],
        filterBranchOperator: "OR",
        filters: []
    };
    hslists:ListCreateRequest payloadForLists = {
        objectTypeId: "0-5",
        processingType: "DYNAMIC",
        name: "High priority tickets",
        filterBranch: filterBranch
    };
    hslists:ListFetchResponse|error highPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjectTypeIdNameListNameGetByName("0-5", "High priority tickets");

    hslists:PublicObjectList highPriorityList;
    hslists:PublicObjectList mediumPriorityList;
    hslists:PublicObjectList lowPriorityList;

    if highPriorityListCheckResponse is error {
        hslists:ListCreateResponse highPriorityListResponse = check hubspotClient->postCreate(payloadForLists);
        highPriorityList = highPriorityListResponse.list;
        io:println("[+] High priority list created successfully: ", highPriorityList.name);
    } else {
        highPriorityList = highPriorityListCheckResponse.list;
        io:println("[+] High priority list already exists");
    }

    filterOperation.values = ["MEDIUM"];
    filterName.operation = {...filterOperation};
    payloadForLists.name = "Medium priority tickets";
    hslists:ListFetchResponse|error midPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjectTypeIdNameListNameGetByName("0-5", "High priority tickets");
    if midPriorityListCheckResponse is error {
        hslists:ListCreateResponse mediumPriorityListResponse = check hubspotClient->postCreate(payloadForLists);
        mediumPriorityList = mediumPriorityListResponse.list;
        io:println("[+] Medium priority list created successfully: ", mediumPriorityList.name);
    } else {
        mediumPriorityList = midPriorityListCheckResponse.list;
        io:println("[+] Medium priority list already exists");
    }

    filterOperation.values = ["LOW"];
    filterName.operation = {...filterOperation};
    payloadForLists.name = "Low priority tickets";
    hslists:ListFetchResponse|error lowPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjectTypeIdNameListNameGetByName("0-5", "Low priority tickets");
    if lowPriorityListCheckResponse is error {
        hslists:ListCreateResponse lowPriorityListResponse = check hubspotClient->postCreate(payloadForLists);
        lowPriorityList = lowPriorityListResponse.list;
        io:println("[+] Low priority list created successfully: ", lowPriorityList.name);
    } else {
        lowPriorityList = lowPriorityListCheckResponse.list;
        io:println("[+] Low priority list already exists");
    }

    // Move the created lists to the folder
    _ = check hubspotClient->putFoldersMoveListMoveList({listId: highPriorityList.listId, newFolderId: folder.id.toString()});
    _ = check hubspotClient->putFoldersMoveListMoveList({listId: mediumPriorityList.listId, newFolderId: folder.id.toString()});
    _ = check hubspotClient->putFoldersMoveListMoveList({listId: lowPriorityList.listId, newFolderId: folder.id.toString()});

    // Retrieve each list and print the details
    hslists:ApiCollectionResponseJoinTimeAndRecordId highPriorityListMembersResponse = check hubspotClient->getListIdMembershipsJoinOrderGetPageOrderedByAddedToListDate(highPriorityList.listId);
    hslists:JoinTimeAndRecordId[] highPriorityListMembers = highPriorityListMembersResponse.results;
    io:println("[+] High priority list members: ");
    foreach var member in highPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hslists:ApiCollectionResponseJoinTimeAndRecordId mediumPriorityListMembersResponse = check hubspotClient->getListIdMembershipsJoinOrderGetPageOrderedByAddedToListDate(mediumPriorityList.listId);
    hslists:JoinTimeAndRecordId[] mediumPriorityListMembers = mediumPriorityListMembersResponse.results;
    io:println("[+] Medium priority list members: ");
    foreach var member in mediumPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hslists:ApiCollectionResponseJoinTimeAndRecordId lowPriorityListMembersResponse = check hubspotClient->getListIdMembershipsJoinOrderGetPageOrderedByAddedToListDate(lowPriorityList.listId);
    hslists:JoinTimeAndRecordId[] lowPriorityListMembers = lowPriorityListMembersResponse.results;
    io:println("[+] Low priority list members: ");
    foreach var member in lowPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    io:println("[+] No. of high priority tickets: ", highPriorityListMembersResponse.total);
    io:println("[+] No. of medium priority tickets: ", mediumPriorityListMembersResponse.total);
    io:println("[+] No. of low priority tickets: ", lowPriorityListMembersResponse.total);
}

