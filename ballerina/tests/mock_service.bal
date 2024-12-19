import ballerina/http;
service / on new http:Listener(9090) {
    // Delete a list mock 
    resource function delete crm/v3/lists/[string listId]() returns http:Response {
        http:Response response = new http:Response();
        response.statusCode = 204;
        return response;
    }
}