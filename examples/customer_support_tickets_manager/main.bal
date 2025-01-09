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

public function main() returns error? {
    // creating a new folder for customer support tickets
    hubspotcrmLists:ListFolderCreateRequest folderCreateReqPayload = {
        name: "Customer Support Tickets"
    };
    hubspotcrmLists:ListFolderCreateResponse postFolderCreateResponse = check hubspotClient->postFolders_create(folderCreateReqPayload);

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
        hubspotcrmLists:ListCreateResponse highPriorityListResponse = check hubspotClient->post_create(payload = payloadForLists);
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
        hubspotcrmLists:ListCreateResponse mediumPriorityListResponse = check hubspotClient->post_create(payload = payloadForLists);
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
        hubspotcrmLists:ListCreateResponse lowPriorityListResponse = check hubspotClient->post_create(payload = payloadForLists);
        lowPriorityList = lowPriorityListResponse.list;
        io:println("[+] Low priority list created successfully: ", lowPriorityList.name);
    } else {
        lowPriorityList = lowPriorityListCheckResponse.list;
        io:println("[+] Low priority list already exists");
    }

    // Move the created lists to the folder
    _ = check hubspotClient->putFoldersMoveList_movelist(payload = {listId: highPriorityList.listId, newFolderId: folder.id.toString()});
    _ = check hubspotClient->putFoldersMoveList_movelist(payload = {listId: mediumPriorityList.listId, newFolderId: folder.id.toString()});
    _ = check hubspotClient->putFoldersMoveList_movelist(payload = {listId: lowPriorityList.listId, newFolderId: folder.id.toString()});

    // Retrieve each list and print the details
    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId highPriorityListMembersResponse = check hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(highPriorityList.listId);
    hubspotcrmLists:JoinTimeAndRecordId[] highPriorityListMembers = highPriorityListMembersResponse.results;
    io:println("[+] High priority list members: ");
    foreach var member in highPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId mediumPriorityListMembersResponse = check hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(mediumPriorityList.listId);
    hubspotcrmLists:JoinTimeAndRecordId[] mediumPriorityListMembers = mediumPriorityListMembersResponse.results;
    io:println("[+] Medium priority list members: ");
    foreach var member in mediumPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    hubspotcrmLists:ApiCollectionResponseJoinTimeAndRecordId lowPriorityListMembersResponse = check hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(lowPriorityList.listId);
    hubspotcrmLists:JoinTimeAndRecordId[] lowPriorityListMembers = lowPriorityListMembersResponse.results;
    io:println("[+] Low priority list members: ");
    foreach var member in lowPriorityListMembers {
        io:println("    - ", member.recordId);
    }

    io:println("[+] No. of high priority tickets: ", highPriorityListMembersResponse.total);
    io:println("[+] No. of medium priority tickets: ", mediumPriorityListMembersResponse.total);
    io:println("[+] No. of low priority tickets: ", lowPriorityListMembersResponse.total);
}

