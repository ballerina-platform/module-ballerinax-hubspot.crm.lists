import ballerina/test;
import ballerina/oauth2;
import ballerina/io;
import ballerina/http;

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

@test:Config{}
function testCreateAList() returns error? {
    ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: "my-test-list"
    };
    ListCreateResponse response = check hubspotClient->/crm/v3/lists.post(payload);
    testListId = response.list.listId;
    test:assertTrue(response.list.name == "my-test-list");
}

@test:Config{}
function testGetAllLists() returns error? {
    ListsByIdResponse response = check hubspotClient->/crm/v3/lists();
    io:println("############ TEST RESPONSE ############");
    io:println(response.lists);
    io:println(response.lists.length());
    test:assertTrue(response.lists.length() >= 0);
}

@test:Config{}
function testGetListById() returns error? {
    ListFetchResponse response = check hubspotClient->/crm/v3/lists/["9"]();
    io:println("############ TEST RESPONSE ############");
    io:println(response.list);
    io:println(response.list.name);
    test:assertTrue(response.list.name != "");
}

@test:Config{}
function testDeleteListById() returns error? {
    http:Response response = check  hubspotClient->/crm/v3/lists/[testListId].delete();
    test:assertTrue(response.statusCode == 204);
}