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

// To run this example, you need to add following scope to the HubSpot OAuth key
// with other required scopes for the Ballerina HubSpot CRM Lists connector.
//   - crm.objects.contacts.read
//   - crm.objects.contacts.write

hslists:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final hslists:Client hubspotClient = check new ({auth});

function getLeadsIDs() returns string[] {
    // This function returns a dummy ID set for demonstration purposes.
    // In a real-world scenario, you can get the lead IDs from a database or any other source.
    return ["85187972687", "85187972688", "85187972689", "85187972690"];
}

function addRecordsToList(string listId, string typeOfLeads) returns error? {
    string[] payload = getLeadsIDs();
    hslists:MembershipsUpdateResponse response = check hubspotClient->putListIdMembershipsAddAdd(listId, payload);
    if response.recordsIdsAdded !is () {
        io:println("[+] Leads added to the " + typeOfLeads + " Leads List: ", response.recordsIdsAdded);
    }
    if response.recordIdsMissing !is () {
        io:println("[!] Leads not added to the " + typeOfLeads + " Leads List: ", response.recordIdsMissing);
    }
}

public function main() returns error? {
    // This example uses manual processing type for the lists for demonstration purposes.
    // In a real-world scenario, you can use the processing type that suits your requirement.

    hslists:ListCreateRequest payloadForList = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: "New Leads"
    };

    // Create lists for leads with status 'New'
    hslists:ListCreateResponse newLeadsListCreateResponse = check hubspotClient->postCreate(payload = payloadForList);
    io:println("[+] New Leads List created successfully: ", newLeadsListCreateResponse.list.name);

    // Create a list for leads with status 'Open'
    payloadForList.name = "Open Leads";
    hslists:ListCreateResponse openLeadsListCreateResponse = check hubspotClient->postCreate(payload = payloadForList);
    io:println("[+] Open Leads List created successfully: ", openLeadsListCreateResponse.list.name);

    // Create a list for leads with status 'In progress'
    payloadForList.name = "In Progress Leads";
    hslists:ListCreateResponse inProgressLeadsListCreateResponse = check hubspotClient->postCreate(payload = payloadForList);
    io:println("[+] In Progress Leads List created successfully: ", inProgressLeadsListCreateResponse.list.name);

    // Create a list for leads with status 'Contacted'
    payloadForList.name = "Contacted Leads";
    hslists:ListCreateResponse contactedLeadsListCreateResponse = check hubspotClient->postCreate(payload = payloadForList);
    io:println("[+] Contacted Leads List created successfully: ", contactedLeadsListCreateResponse.list.name);

    // adding leads to the list
    check addRecordsToList(newLeadsListCreateResponse.list.listId, "New");
    check addRecordsToList(openLeadsListCreateResponse.list.listId, "Open");
    check addRecordsToList(inProgressLeadsListCreateResponse.list.listId, "In Progress");
    check addRecordsToList(contactedLeadsListCreateResponse.list.listId, "Contacted");

}

