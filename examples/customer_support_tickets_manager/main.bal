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
import ballerina/oauth2;
import ballerinax/hubspot.crm.lists as hubspotcrmLists;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// To run this example, you need to add 'tickets' scope to the HubSpot OAuth key
// with other required scopes for the Ballerina HubSpot CRM Lists connector.

hubspotcrmLists:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hubspotcrmLists:Client hubspotClient = check new hubspotcrmLists:Client(config = {auth});

public function main() {
    // creating a new folder for customer support tickets
    hubspotcrmLists:ListFolderCreateRequest folderCreateReqPayload = {
        name: "Customer Support Tickets"
    };
    hubspotcrmLists:ListFolderCreateResponse|error postFolderCreateResponse = hubspotClient->postFolders_create(folderCreateReqPayload);
    if postFolderCreateResponse is error {
        io:println("[!] Error occurred while creating the folder: ", postFolderCreateResponse);
        return;
    }
    hubspotcrmLists:PublicListFolder folder = postFolderCreateResponse.folder;
    io:println("[+] Folder created successfully: ", folder.name);

    // Generating lists for seperate priority levels
    hubspotcrmLists:PublicEnumerationPropertyOperation filterOperation = {
        includeObjectsWithNoValueSet: false,
        values: ["HIGH"],
        operationType: "ENUMERATION",
        operator: "IS_ANY_OF"
    };
    hubspotcrmLists:PublicPropertyFilter filterName = {
        property: "hs_ticket_priority",
        filterType: "PROPERTY",
        operation: {...filterOperation}
    };
    hubspotcrmLists:PublicAndFilterBranch nestedFilterBranch = {
        filterBranchType: "AND",
        filterBranches: [],
        filterBranchOperator: "AND",
        filters: [filterName]
    };
    hubspotcrmLists:PublicOrFilterBranch filterBranch = {
        filterBranchType: "OR",
        filterBranches: [nestedFilterBranch],
        filterBranchOperator: "OR",
        filters: []
    };
    hubspotcrmLists:ListCreateRequest payloadForLists = {
        objectTypeId: "0-5",
        processingType: "DYNAMIC",
        name: "High priority tickets",
        filterBranch: filterBranch
    };
    hubspotcrmLists:ListFetchResponse|error highPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjecttypeidNameListname_getbyname(objectTypeId = "0-5", listName = "High priority tickets");

    hubspotcrmLists:PublicObjectList highPriorityList;
    hubspotcrmLists:PublicObjectList mediumPriorityList;
    hubspotcrmLists:PublicObjectList lowPriorityList;

    if highPriorityListCheckResponse is error {
        hubspotcrmLists:ListCreateResponse|error highPriorityListResponse = hubspotClient->post_create(payload = payloadForLists);
        if highPriorityListResponse is error {
            io:println("[!] Error occurred while creating the high priority list: ", highPriorityListResponse);
            return;
        }
        highPriorityList = highPriorityListResponse.list;
        io:println("[+] High priority list created successfully: ", highPriorityList.name);
    } else {
        highPriorityList = highPriorityListCheckResponse.list;
        io:println("[+] High priority list already exists");
    }

    filterOperation.values = ["MEDIUM"];
    filterName.operation = {...filterOperation};
    payloadForLists.name = "Medium priority tickets";
    hubspotcrmLists:ListFetchResponse|error midPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjecttypeidNameListname_getbyname(objectTypeId = "0-5", listName = "High priority tickets");
    if midPriorityListCheckResponse is error {
        hubspotcrmLists:ListCreateResponse|error mediumPriorityListResponse = hubspotClient->post_create(payload = payloadForLists);
        if mediumPriorityListResponse is error {
            io:println("[!] Error occurred while creating the medium priority list: ", mediumPriorityListResponse);
            return;
        }
        mediumPriorityList = mediumPriorityListResponse.list;
        io:println("[+] Medium priority list created successfully: ", mediumPriorityList.name);
    } else {
        mediumPriorityList = midPriorityListCheckResponse.list;
        io:println("[+] Medium priority list already exists");
    }

    filterOperation.values = ["LOW"];
    filterName.operation = {...filterOperation};
    payloadForLists.name = "Low priority tickets";
    hubspotcrmLists:ListFetchResponse|error lowPriorityListCheckResponse = hubspotClient->getObjectTypeIdObjecttypeidNameListname_getbyname(objectTypeId = "0-5", listName = "High priority tickets");
    if lowPriorityListCheckResponse is error {
        hubspotcrmLists:ListCreateResponse|error lowPriorityListResponse = hubspotClient->post_create(payload = payloadForLists);
        if lowPriorityListResponse is error {
            io:println("[!] Error occurred while creating the low priority list: ", lowPriorityListResponse);
            return;
        }
        lowPriorityList = lowPriorityListResponse.list;
        io:println("[+] Low priority list created successfully: ", lowPriorityList.name);
    } else {
        lowPriorityList = lowPriorityListCheckResponse.list;
        io:println("[+] Low priority list already exists");
    }

    // Move the created lists to the folder
    http:Response|error highPriorityListMoveResponse = hubspotClient->putFoldersMoveList_movelist(payload = {listId: highPriorityList.listId, newFolderId: folder.id.toString()});
    if highPriorityListMoveResponse is error {
        io:println("[!] Error occurred while moving the high priority list to the folder: ", highPriorityListMoveResponse);
        return;
    }
    http:Response|error midPriorityListMoveResponse = hubspotClient->putFoldersMoveList_movelist(payload = {listId: mediumPriorityList.listId, newFolderId: folder.id.toString()});
    if midPriorityListMoveResponse is error {
        io:println("[!] Error occurred while moving the medium priority list to the folder: ", midPriorityListMoveResponse);
        return;
    }
    http:Response|error lowPriorityListMoveResponse = hubspotClient->putFoldersMoveList_movelist(payload = {listId: lowPriorityList.listId, newFolderId: folder.id.toString()});
    if lowPriorityListMoveResponse is error {
        io:println("[!] Error occurred while moving the low priority list to the folder: ", lowPriorityListMoveResponse);
        return;
    }

    // Retrieve each list and print the details
    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId|error highPriorityListMembersResponse = hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(highPriorityList.listId);
    if highPriorityListMembersResponse is error {
        io:println("[!] Error occurred while retrieving the high priority list members: ", highPriorityListMembersResponse);
        return;
    }
    hubspotcrmLists:JoinTimeAndRecordId[] highPriorityListMembers = highPriorityListMembersResponse.results;
    io:println("[+] High priority list members: ");
    foreach var member in highPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId|error mediumPriorityListMembersResponse = hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(mediumPriorityList.listId);
    if mediumPriorityListMembersResponse is error {
        io:println("[!] Error occurred while retrieving the medium priority list members: ", mediumPriorityListMembersResponse);
        return;
    }
    hubspotcrmLists:JoinTimeAndRecordId[] mediumPriorityListMembers = mediumPriorityListMembersResponse.results;
    io:println("[+] Medium priority list members: ");
    foreach var member in mediumPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId|error lowPriorityListMembersResponse = hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(lowPriorityList.listId);
    if lowPriorityListMembersResponse is error {
        io:println("[!] Error occurred while retrieving the low priority list members: ", lowPriorityListMembersResponse);
        return;
    }
    hubspotcrmLists:JoinTimeAndRecordId[] lowPriorityListMembers = lowPriorityListMembersResponse.results;
    io:println("[+] Low priority list members: ");
    foreach var member in lowPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    io:println();
    io:println("[+] No. of high priority tickets: ", highPriorityListMembersResponse.total);
    io:println("[+] No. of medium priority tickets: ", mediumPriorityListMembersResponse.total);
    io:println("[+] No. of low priority tickets: ", lowPriorityListMembersResponse.total);
}

