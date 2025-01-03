import ballerina/test;
import ballerina/oauth2;
import ballerina/http;
import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final string serviceUrl = "https://api.hubapi.com";

final Client hubspotClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

string testListId = "";
string testListName = "my-test-list";

// Create List
@test:Config{}
function testCreateAList() returns error? {
    ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: testListName
    };
    ListCreateResponse response = check hubspotClient->/crm/v3/lists.post(payload);
    testListId = response.list.listId;
    testListName = response.list.name;
    test:assertTrue(response.list.name == testListName);
}

// Fetch Multiple Lists
@test:Config{}
function testGetAllLists() returns error? {
    ListsByIdResponse response = check hubspotClient->/crm/v3/lists();
    test:assertTrue(response.lists.length() >= 0);
}

// Fetch List by Name
@test:Config{
    dependsOn: [testCreateAList]
}
function testGetListByName() returns error? {
    ListFetchResponse response = check hubspotClient->/crm/v3/lists/object\-type\-id/["0-1"]/name/[testListName]();
    test:assertTrue(response.list.name == testListName);
}

// Fetch List by ID
@test:Config{
    dependsOn: [testCreateAList]
}
function testGetListById() returns error? {
    ListFetchResponse response = check hubspotClient->/crm/v3/lists/[testListId]();
    test:assertTrue(response.list.name != "");
}


// Search Lists
@test:Config{}
function testSearchLists() returns error? {
    ListSearchRequest payload = {
        query: "test"
    };
    ListSearchResponse response = check hubspotClient->/crm/v3/lists/search.post(payload);
    io:println(response);
    test:assertTrue(response.lists.length() >= 0);
    if(response.lists.length() > 0) {
        test:assertTrue(response.lists[0].name.includes("test"));
    }
}

// Delete a List
@test:Config{
    dependsOn: [testCreateAList, testGetListById, testGetListByName]
}
function testDeleteListById() returns error? {
    http:Response response = check  hubspotClient->/crm/v3/lists/[testListId].delete();
    test:assertTrue(response.statusCode == 204);
}

// Restore a List
@test:Config{
    dependsOn: [testCreateAList, testDeleteListById]
}
function testRestoreListById() returns error? {
    http:Response response = check hubspotClient->/crm/v3/lists/[testListId]/restore.put();
    test:assertTrue(response.statusCode == 204);
}

// Update List Filter Definition
// Update List Name