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
import ballerina/oauth2;
import ballerina/test;

configurable boolean isLiveServer = false; // Set this to true to run live tests with hubspot API
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

Client hubspotClient = test:mock(Client);

string testListId = "";
string testDynamicListId = "";
string testListName = "my-test-list";
int:Signed32 testParentFolderId = 0;
int:Signed32 testChildFolderId = 0;

@test:BeforeSuite
function setup() returns error? {
    OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };
    if isLiveServer {
        hubspotClient = check new Client(config = {auth});
    } else {
        hubspotClient = check new Client(config = {auth}, serviceUrl = "http://localhost:9090");
    }
}

// Create List
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateAManualList() returns error? {
    ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: testListName
    };
    ListCreateResponse response = check hubspotClient->post_create(payload);
    testListId = response.list.listId;
    testListName = response.list.name;
    test:assertEquals(response.list.name, testListName);
}

// Create a Dynamic List
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateADynamicList() returns error? {
    PublicMultiStringPropertyOperation operation = {
        includeObjectsWithNoValueSet: false,
        values: ["John"],
        operationType: "MULTISTRING",
        operator: "IS_EQUAL_TO"
    };
    PublicPropertyFilter filterName = {
        property: "firstname",
        filterType: "PROPERTY",
        operation: {...operation}
    };
    PublicAndFilterBranch nestedFilterBranch = {
        filterBranchType: "AND",
        filterBranches: [],
        filterBranchOperator: "AND",
        filters: [filterName]
    };
    PublicOrFilterBranch filterBranch = {
        filterBranchType: "OR",
        filterBranches: [nestedFilterBranch],
        filterBranchOperator: "OR",
        filters: []
    };
    ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "DYNAMIC",
        name: "my-test-list-dynamic",
        filterBranch: filterBranch
    };
    ListCreateResponse response = check hubspotClient->post_create(payload);
    testDynamicListId = response.list.listId;
    test:assertEquals(response.list.name, "my-test-list-dynamic");
}

// Fetch Multiple Lists
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllLists() returns error? {
    ListsByIdResponse response = check hubspotClient->get_getall();
    test:assertTrue(response.lists.length() >= 0);
}

// Fetch List by Name
@test:Config {
    dependsOn: [testCreateAManualList],
    groups: ["live_tests", "mock_tests"]
}
function testGetListByName() returns error? {
    ListFetchResponse response = check hubspotClient->getObjectTypeIdObjecttypeidNameListname_getbyname(listName = testListName, objectTypeId = "0-1");
    test:assertEquals(response.list.name, testListName);
}

// Fetch List by ID
@test:Config {
    dependsOn: [testCreateAManualList],
    groups: ["live_tests", "mock_tests"]
}
function testGetListById() returns error? {
    ListFetchResponse response = check hubspotClient->getListid_getbyid(listId = testListId);
    test:assertTrue(response.list.name != "");
}

// Search Lists
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSearchLists() returns error? {
    ListSearchRequest payload = {
        query: "test"
    };
    ListSearchResponse response = check hubspotClient->postSearch_dosearch(payload);
    test:assertTrue(response.lists.length() > 0);
    test:assertTrue(response.lists[0].name.includes("test"));
}

// Delete a List
@test:Config {
    dependsOn: [testCreateAManualList, testGetListById, testGetListByName],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteListById() returns error? {
    http:Response response = check hubspotClient->deleteListid_remove(listId = testListId);
    test:assertEquals(response.statusCode, 204);
}

// Restore a List
@test:Config {
    dependsOn: [testCreateAManualList, testDeleteListById],
    groups: ["live_tests", "mock_tests"]
}
function testRestoreListById() returns error? {
    http:Response response = check hubspotClient->putListidRestore_restore(listId = testListId);
    test:assertEquals(response.statusCode, 204);
}

// Update List Name
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests", "mock_tests"]
}
function testUpdateListName() returns error? {
    PutListidUpdateListName_updatenameQueries queries = {
        listName: "my-test-list-updated"
    };
    ListUpdateResponse response = check hubspotClient->putListidUpdateListName_updatename(listId = testListId, queries = queries);
    test:assertEquals(response.updatedList?.name, "my-test-list-updated");
}

// Update List Filter Definition
@test:Config {
    dependsOn: [testCreateADynamicList],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testUpdateListFilter() returns error? {
    PublicMultiStringPropertyOperation operationFirstname = {
        includeObjectsWithNoValueSet: false,
        values: ["John"],
        operationType: "MULTISTRING",
        operator: "IS_EQUAL_TO"
    };
    PublicMultiStringPropertyOperation operationLastname = {
        includeObjectsWithNoValueSet: false,
        values: ["Doe"],
        operationType: "MULTISTRING",
        operator: "IS_EQUAL_TO"
    };
    PublicPropertyFilter filterFirstName = {
        property: "firstname",
        filterType: "PROPERTY",
        operation: {...operationFirstname}
    };
    PublicPropertyFilter filterLastName = {
        property: "firstname",
        filterType: "PROPERTY",
        operation: {...operationLastname}
    };
    PublicAndFilterBranch nestedFilterBranch = {
        filterBranchType: "AND",
        filterBranches: [],
        filterBranchOperator: "AND",
        filters: [filterFirstName, filterLastName]
    };
    PublicOrFilterBranch filterBranch = {
        filterBranchType: "OR",
        filterBranches: [nestedFilterBranch],
        filterBranchOperator: "OR",
        filters: []
    };
    ListFilterUpdateRequest payload = {
        filterBranch
    };

    ListUpdateResponse response = check hubspotClient->putListidUpdateListFilters_updatelistfilters(listId = testDynamicListId, payload = payload);
    test:assertEquals(response.updatedList?.filterBranch, filterBranch);
}

// Fetch List Memberships Ordered by Added to List Date
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testFetchListMembershipsOrderedByAddedToListDate() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->getListidMembershipsJoinOrder_getpageorderedbyaddedtolistdate(listId = testListId);
    test:assertTrue(response.results.length() >= 0);
}

// Fetch List Memberships Ordered by ID
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testFetchListMembershipsOrderedById() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->getListidMemberships_getpage(listId = testListId);
    test:assertTrue(response.results.length() >= 0);
};

// Get lists record is member of
@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
function testGetListsRecordIsMemberOf() returns error? {
    ApiCollectionResponseRecordListMembershipNoPaging response = check hubspotClient->getRecordsObjecttypeidRecordidMemberships_getlists(objectTypeId = "0-1", recordId = "123456");
    int total = response.total ?: 0;
    test:assertEquals(response.results.length(), total);
}

// Add All Records from a Source List to a Destination List
@test:Config {
    dependsOn: [testRestoreListById, testCreateADynamicList],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testAddAllRecordsFromSourceListToDestinationList() returns error? {
    http:Response response = check hubspotClient->putListidMembershipsAddFromSourcelistid_addallfromlist(listId = testListId, sourceListId = testDynamicListId);
    test:assertEquals(response.statusCode, 204);
}

// Add and/or Remove Records from a List
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testAddRemoveRecordsFromAList() returns error? {
    MembershipChangeRequest payload = {
        recordIdsToAdd: ["123123", "123456"],
        recordIdsToRemove: ["456456"]
    };
    MembershipsUpdateResponse response = check hubspotClient->putListidMembershipsAddAndRemove_addandremove(listId = testListId, payload = payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordsIdsAdded !is ());
}

// Add Records to a List
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testAddRecordsToAList() returns error? {
    string[] payload = ["123123", "123456"];
    MembershipsUpdateResponse response = check hubspotClient->putListidMembershipsAdd_add(listId = testListId, payload = payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordsIdsAdded !is ());
}

// Remove Records from a List
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testRemoveRecordsFromList() returns error? {
    string[] payload = ["123123"];
    MembershipsUpdateResponse response = check hubspotClient->putListidMembershipsRemove_remove(listId = testListId, payload = payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordIdsRemoved !is ());
}

// Delete All Records from a List
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testDeleteAllRecordsFromList() returns error? {
    http:Response response = check hubspotClient->deleteListidMemberships_removeall(listId = testListId);
    test:assertEquals(response.statusCode, 204);
}

// Creates a folder
@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
function testCreateFolders() returns error? {
    ListFolderCreateRequest payload = {
        name: "test-folder"
    };
    ListFolderCreateResponse response = check hubspotClient->postFolders_create(payload);
    test:assertEquals(response.folder.name, "test-folder");
    testParentFolderId = response.folder.id;

    ListFolderCreateRequest childPayload = {
        name: "test-child-folder",
        parentFolderId: testParentFolderId.toString()
    };
    ListFolderCreateResponse childResponse = check hubspotClient->postFolders_create(childPayload);
    test:assertEquals(childResponse.folder.name, "test-child-folder");
    testChildFolderId = childResponse.folder.id;
}

// Moves a folder
@test:Config {
    dependsOn: [testCreateFolders],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testMoveAFolder() returns error? {
    ListFolderFetchResponse response = check hubspotClient->putFoldersFolderidMoveNewparentfolderid_move(folderId = testChildFolderId.toString(), newParentFolderId = "0");
    test:assertEquals(response.folder.parentFolderId, 0);
}

// Moves a list to a given folder
@test:Config {
    dependsOn: [testCreateAManualList, testMoveAFolder],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testMoveAListToAGivenFolder() returns error? {
    ListMoveRequest payload = {
        listId: testListId,
        newFolderId: testChildFolderId.toString()
    };
    http:Response response = check hubspotClient->putFoldersMoveList_movelist(payload);
    test:assertEquals(response.statusCode, 204);
}

// Rename a folder
@test:Config {
    dependsOn: [testCreateFolders],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testRenameAFolder() returns error? {
    PutFoldersFolderidRename_renameQueries queries = {
        newFolderName: "test-child-folder-updated"
    };
    ListFolderFetchResponse response = check hubspotClient->putFoldersFolderidRename_rename(folderId = testChildFolderId.toString(), queries = queries);
    test:assertEquals(response.folder.name, "test-child-folder-updated");
}

// Retrieves a folder
@test:Config {
    dependsOn: [testRenameAFolder],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testRetrieveAFolder() returns error? {
    GetFolders_getallQueries queries = {
        folderId: testChildFolderId.toString()
    };
    ListFolderFetchResponse response = check hubspotClient->getFolders_getall(queries = queries);
    test:assertEquals(response.folder.name, "test-child-folder-updated");
}

// Deletes a folder
@test:Config {
    dependsOn: [testCreateFolders, testMoveAFolder, testMoveAListToAGivenFolder, testRenameAFolder],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testDeleteFolders() returns error? {
    http:Response response = check hubspotClient->deleteFoldersFolderid_remove(folderId = testChildFolderId.toString());
    test:assertEquals(response.statusCode, 204);
    http:Response responseParent = check hubspotClient->deleteFoldersFolderid_remove(folderId = testParentFolderId.toString());
    test:assertEquals(responseParent.statusCode, 204);
};

// Delete all lists created for tests
@test:AfterSuite
function deleteTestListAfterRestore() returns error? {
    http:Response response = check hubspotClient->deleteListid_remove(listId = testListId);
    http:Response responseDynamic = check hubspotClient->deleteListid_remove(listId = testDynamicListId);
    test:assertTrue(response.statusCode == 204 && responseDynamic.statusCode == 204);
}

