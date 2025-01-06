import ballerina/http;
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final Client hubspotClient = check new Client(config = {auth});

string testListId = "";
string testDynamicListId = "";
string testListName = "my-test-list";
int:Signed32 testParentFolderId = 0;
int:Signed32 testChildFolderId = 0;

// Create List
@test:Config {}
function testCreateAManualList() returns error? {
    ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: testListName
    };
    ListCreateResponse response = check hubspotClient->/.post(payload);
    testListId = response.list.listId;
    testListName = response.list.name;
    test:assertTrue(response.list.name == testListName);
}

// Create a Dynamic List
@test:Config {}
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
    ListCreateResponse response = check hubspotClient->/.post(payload);
    testDynamicListId = response.list.listId;
    test:assertTrue(response.list.name == "my-test-list-dynamic");
}

// Fetch Multiple Lists
@test:Config {}
function testGetAllLists() returns error? {
    ListsByIdResponse response = check hubspotClient->/();
    test:assertTrue(response.lists.length() >= 0);
}

// Fetch List by Name
@test:Config {
    dependsOn: [testCreateAManualList]
}
function testGetListByName() returns error? {
    ListFetchResponse response = check hubspotClient->/object\-type\-id/["0-1"]/name/[testListName]();
    test:assertTrue(response.list.name == testListName);
}

// Fetch List by ID
@test:Config {
    dependsOn: [testCreateAManualList]
}
function testGetListById() returns error? {
    ListFetchResponse response = check hubspotClient->/[testListId]();
    test:assertTrue(response.list.name != "");
}

// Search Lists
@test:Config {}
function testSearchLists() returns error? {
    ListSearchRequest payload = {
        query: "test"
    };
    ListSearchResponse response = check hubspotClient->/search.post(payload);
    test:assertTrue(response.lists.length() >= 0);
    if (response.lists.length() > 0) {
        test:assertTrue(response.lists[0].name.includes("test"));
    }
}

// Delete a List
@test:Config {
    dependsOn: [testCreateAManualList, testGetListById, testGetListByName]
}
function testDeleteListById() returns error? {
    http:Response response = check hubspotClient->/[testListId].delete();
    test:assertTrue(response.statusCode == 204);
}

// Restore a List
@test:Config {
    dependsOn: [testCreateAManualList, testDeleteListById]
}
function testRestoreListById() returns error? {
    http:Response response = check hubspotClient->/[testListId]/restore.put();
    test:assertTrue(response.statusCode == 204);
}

// Update List Name
@test:Config {
    dependsOn: [testRestoreListById]
}
function testUpdateListName() returns error? {
    PutListidUpdateListName_updatenameQueries queries = {
        listName: "my-test-list-updated"
    };
    ListUpdateResponse response = check hubspotClient->/[testListId]/update\-list\-name.put(queries = queries);
    test:assertTrue(response.updatedList?.name == "my-test-list-updated");
}

// Update List Filter Definition
@test:Config {
    dependsOn: [testCreateADynamicList]
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

    ListUpdateResponse response = check hubspotClient->/[testDynamicListId]/update\-list\-filters.put(payload);
    test:assertEquals(response.updatedList?.filterBranch, filterBranch);
}

// Fetch List Memberships Ordered by Added to List Date
@test:Config {
    dependsOn: [testRestoreListById]
}
function testFetchListMembershipsOrderedByAddedToListDate() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->/[testListId]/memberships/join\-order();
    test:assertTrue(response.results.length() >= 0);
}

// Fetch List Memberships Ordered by ID
@test:Config {
    dependsOn: [testRestoreListById]
}
function testFetchListMembershipsOrderedById() returns error? {
    ApiCollectionResponseJoinTimeAndRecordId response = check hubspotClient->/[testListId]/memberships();
    test:assertTrue(response.results.length() >= 0);
};

// Get lists record is member of
@test:Config {}
function testGetListsRecordIsMemberOf() returns error? {
    ApiCollectionResponseRecordListMembershipNoPaging response = check hubspotClient->/records/["0-1"]/["123123"]/memberships();
    int total = response.total ?: 0;
    test:assertEquals(response.results.length(), total);
}

// Add All Records from a Source List to a Destination List
@test:Config {
    dependsOn: [testRestoreListById, testCreateADynamicList]
}
function testAddAllRecordsFromSourceListToDestinationList() returns error? {
    http:Response response = check hubspotClient->/[testListId]/memberships/add\-from/[testDynamicListId].put();
    test:assertTrue(response.statusCode == 204);
}

// Add and/or Remove Records from a List
@test:Config {
    dependsOn: [testRestoreListById]
}
function testAddRemoveRecordsFromAList() returns error? {
    MembershipChangeRequest payload = {
        recordIdsToAdd: ["123123", "123456"],
        recordIdsToRemove: ["456456"]
    };
    MembershipsUpdateResponse response = check hubspotClient->/[testListId]/memberships/add\-and\-remove.put(payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordsIdsAdded !is ());
}

// Add Records to a List
@test:Config {
    dependsOn: [testRestoreListById]
}
function testAddRecordsToAList() returns error? {
    string[] payload = ["123123", "123456"];
    MembershipsUpdateResponse response = check hubspotClient->/[testListId]/memberships/add.put(payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordsIdsAdded !is ());
}

// Remove Records from a List
@test:Config {
    dependsOn: [testRestoreListById]
}
function testRemoveRecordsFromList() returns error? {
    string[] payload = ["123123"];
    MembershipsUpdateResponse response = check hubspotClient->/[testListId]/memberships/remove.put(payload);
    test:assertTrue(response.recordIdsMissing !is () || response.recordIdsRemoved !is ());
}

// Delete All Records from a List
@test:Config {
    dependsOn: [testRestoreListById]
}
function testDeleteAllRecordsFromList() returns error? {
    http:Response response = check hubspotClient->/[testListId]/memberships.delete();
    test:assertTrue(response.statusCode == 204);
}

// Creates a folder
@test:Config {}
function testCreateFolders() returns error? {
    ListFolderCreateRequest payload = {
        name: "test-folder"
    };
    ListFolderCreateResponse response = check hubspotClient->/folders.post(payload);
    test:assertTrue(response.folder.name == "test-folder");
    testParentFolderId = response.folder.id;

    ListFolderCreateRequest childPayload = {
        name: "test-child-folder",
        parentFolderId: testParentFolderId.toString()
    };
    ListFolderCreateResponse childResponse = check hubspotClient->/folders.post(childPayload);
    test:assertTrue(childResponse.folder.name == "test-child-folder");
    testChildFolderId = childResponse.folder.id;
}

// Moves a folder
@test:Config {
    dependsOn: [testCreateFolders]
}
function testMoveAFolder() returns error? {
    ListFolderFetchResponse response = check hubspotClient->/folders/[testChildFolderId.toString()]/move/["0"].put();
    test:assertTrue(response.folder.parentFolderId == 0);
}

// Moves a list to a given folder
@test:Config {
    dependsOn: [testCreateAManualList, testMoveAFolder]
}
function testMoveAListToAGivenFolder() returns error? {
    ListMoveRequest payload = {
        listId: testListId,
        newFolderId: testChildFolderId.toString()
    };
    http:Response response = check hubspotClient->/folders/move\-list.put(payload);
    test:assertTrue(response.statusCode == 204);
}

// Retrieves a folder
// 
//  TODO: method call gives an error:
//        client resource access action is not yet supported when the corresponding resource method is ambiguous
// 
// @test:Config{
//     dependsOn: [testMoveAListToAGivenFolder]
// }
// function testRetrieveAFolder() returns error? {
//     GetFolders_getallQueries queries = {
//         folderId: testChildFolderId.toString()
//     };
//     ListFolderFetchResponse response = check hubspotClient->/folders(queries);
// }

// Rename a folder
@test:Config {
    dependsOn: [testCreateFolders]
}
function testRenameAFolder() returns error? {
    PutFoldersFolderidRename_renameQueries queries = {
        newFolderName: "test-child-folder-updated"
    };
    ListFolderFetchResponse response = check hubspotClient->/folders/[testChildFolderId.toString()]/rename.put(queries = queries);
    test:assertEquals(response.folder.name, "test-child-folder-updated");
}

// Deletes a folderDEL
@test:Config {
    dependsOn: [testCreateFolders, testMoveAFolder, testMoveAListToAGivenFolder, testRenameAFolder]
}
function testDeleteFolders() returns error? {
    http:Response response = check hubspotClient->/folders/[testChildFolderId.toString()].delete();
    test:assertEquals(response.statusCode, 204);
    http:Response responseParent = check hubspotClient->/folders/[testParentFolderId.toString()].delete();
    test:assertEquals(responseParent.statusCode, 204);
};

// Delete all lists created for tests
@test:AfterSuite
function deleteTestListAfterRestore() returns error? {
    http:Response response = check hubspotClient->/[testListId].delete();
    http:Response responseDynamic = check hubspotClient->/[testDynamicListId].delete();
    test:assertTrue(response.statusCode == 204 && responseDynamic.statusCode == 204);
}

