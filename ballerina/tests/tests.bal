import ballerina/test;
import ballerina/oauth2;
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

final Client hubspotClient = check new Client(config = {auth},serviceUrl = "http://localhost:9090");

@test:Config{}
function testDeleteAList() returns error?{
    http:Response response = check hubspotClient->/crm/v3/lists/["1"].delete();
    test:assertEquals(response.statusCode, 204);
}