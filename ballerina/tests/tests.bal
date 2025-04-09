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

import ballerina/oauth2;
import ballerina/test;

configurable boolean isLiveServer = false; // Set this to true to run live tests with hubspot API
configurable string clientId = "testId";
configurable string clientSecret = "testSecret";
configurable string refreshToken = "testToken";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/lists" : "http://localhost:9090";

string testListId = "";
string testDynamicListId = "";
string testListName = "my-test-list";
int:Signed32 testParentFolderId = 0;
int:Signed32 testChildFolderId = 0;

final Client hubspotClient = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
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
    ListCreateResponse response = check hubspotClient->postCreate(payload);
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
    ListCreateResponse response = check hubspotClient->postCreate(payload);
    testDynamicListId = response.list.listId;
    test:assertEquals(response.list.name, "my-test-list-dynamic");
}

// Fetch Multiple Lists
@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllLists() returns error? {
    ListsByIdResponse response = check hubspotClient->getGetAll();
    test:assertTrue(response.lists.length() >= 0);
}

// Fetch List by Name
@test:Config {
    dependsOn: [testCreateAManualList],
    groups: ["live_tests", "mock_tests"]
}
function testGetListByName() returns error? {
    ListFetchResponse response = check hubspotClient->getObjectTypeIdObjectTypeIdNameListNameGetByName(listName = testListName, objectTypeId = "0-1");
    test:assertEquals(response.list.name, testListName);
}

// Fetch List by ID
@test:Config {
    dependsOn: [testCreateAManualList],
    groups: ["live_tests", "mock_tests"]
}
function testGetListById() returns error? {
    ListFetchResponse response = check hubspotClient->getListIdGetById(listId = testListId);
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
    ListSearchResponse response = check hubspotClient->postSearchDoSearch(payload);
    test:assertTrue(response.lists.length() > 0);
    test:assertTrue(response.lists[0].name.includes("test"));
}

// Delete a List
@test:Config {
    dependsOn: [testCreateAManualList, testGetListById, testGetListByName],
    groups: ["live_tests", "mock_tests"]
}
function testDeleteListById() returns error? {
    _ = check hubspotClient->deleteListIdRemove(listId = testListId);
}

// Restore a List
@test:Config {
    dependsOn: [testCreateAManualList, testDeleteListById],
    groups: ["live_tests", "mock_tests"]
}
function testRestoreListById() returns error? {
    _ = check hubspotClient->putListIdRestoreRestore(listId = testListId);
}

// Update List Name
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests", "mock_tests"]
}
function testUpdateListName() returns error? {
    PutListIdUpdateListNameUpdateNameQueries queries = {
        listName: "my-test-list-updated"
    };
    ListUpdateResponse response = check hubspotClient->putListIdUpdateListNameUpdateName(listId = testListId, queries = queries);
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

    ListUpdateResponse response = check hubspotClient->putListIdUpdateListFiltersUpdateListFilters(listId = testDynamicListId, payload = payload);
    test:assertEquals(response.updatedList?.filterBranch, filterBranch);
}

// Fetch List Memberships Ordered by Added to List Date
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testFetchListMembershipsOrderedByAddedToListDate() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->getListIdMembershipsJoinOrderGetPageOrderedByAddedToListDate(listId = testListId);
    test:assertTrue(response.results.length() >= 0);
}

// Fetch List Memberships Ordered by ID
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testFetchListMembershipsOrderedById() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->getListIdMembershipsGetPage(listId = testListId);
    test:assertTrue(response.results.length() >= 0);
};

// Get lists record is member of
@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
function testGetListsRecordIsMemberOf() returns error? {
    ApiCollectionResponseRecordListMembershipNoPaging response = check hubspotClient->getRecordsObjectTypeIdRecordIdMembershipsGetLists(objectTypeId = "0-1", recordId = "123456");
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
    _ = check hubspotClient->putListIdMembershipsAddFromSourceListIdAddAllFromList(listId = testListId, sourceListId = testDynamicListId);
    test:assertTrue(true);
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
    MembershipsUpdateResponse response = check hubspotClient->putListIdMembershipsAddAndRemoveAddAndRemove(listId = testListId, payload = payload);
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
    MembershipsUpdateResponse response = check hubspotClient->putListIdMembershipsAddAdd(listId = testListId, payload = payload);
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
    MembershipsUpdateResponse response = check hubspotClient->putListIdMembershipsRemoveRemove(listId = testListId, payload = payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordIdsRemoved !is ());
}

// Delete All Records from a List
@test:Config {
    dependsOn: [testRestoreListById],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testDeleteAllRecordsFromList() returns error? {
    _ = check hubspotClient->deleteListIdMembershipsRemoveAll(listId = testListId);
    test:assertTrue(true);
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
    ListFolderCreateResponse response = check hubspotClient->postFoldersCreate(payload);
    test:assertEquals(response.folder.name, "test-folder");
    testParentFolderId = response.folder.id;

    ListFolderCreateRequest childPayload = {
        name: "test-child-folder",
        parentFolderId: testParentFolderId.toString()
    };
    ListFolderCreateResponse childResponse = check hubspotClient->postFoldersCreate(childPayload);
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
    ListFolderFetchResponse response = check hubspotClient->putFoldersFolderIdMoveNewParentFolderIdMove(folderId = testChildFolderId.toString(), newParentFolderId = "0");
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
    _ = check hubspotClient->putFoldersMoveListMoveList(payload);
    test:assertTrue(true);
}

// Rename a folder
@test:Config {
    dependsOn: [testCreateFolders],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testRenameAFolder() returns error? {
    PutFoldersFolderIdRenameRenameQueries queries = {
        newFolderName: "test-child-folder-updated"
    };
    ListFolderFetchResponse response = check hubspotClient->putFoldersFolderIdRenameRename(folderId = testChildFolderId.toString(), queries = queries);
    test:assertEquals(response.folder.name, "test-child-folder-updated");
}

// Retrieves a folder
@test:Config {
    dependsOn: [testRenameAFolder],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testRetrieveAFolder() returns error? {
    GetFoldersGetAllQueries queries = {
        folderId: testChildFolderId.toString()
    };
    ListFolderFetchResponse response = check hubspotClient->getFoldersGetAll(queries = queries);
    test:assertEquals(response.folder.name, "test-child-folder-updated");
}

// Deletes a folder
@test:Config {
    dependsOn: [testCreateFolders, testMoveAFolder, testMoveAListToAGivenFolder, testRenameAFolder],
    groups: ["live_tests"],
    enable: isLiveServer
}
function testDeleteFolders() returns error? {
    _ = check hubspotClient->deleteFoldersFolderIdRemove(folderId = testChildFolderId.toString());
    _ = check hubspotClient->deleteFoldersFolderIdRemove(folderId = testParentFolderId.toString());
    test:assertTrue(true);
};

// Delete all lists created for tests
@test:AfterSuite
function deleteTestListAfterRestore() returns error? {
    _ = check hubspotClient->deleteListIdRemove(listId = testListId);
    _ = check hubspotClient->deleteListIdRemove(listId = testDynamicListId);
    test:assertTrue(true);
}

