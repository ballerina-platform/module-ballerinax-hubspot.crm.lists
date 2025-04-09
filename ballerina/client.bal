// AUTO-GENERATED FILE. DO NOT MODIFY.
// This file is auto-generated by the Ballerina OpenAPI tool.

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

import ballerina/data.jsondata;
import ballerina/http;

public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.hubapi.com/crm/v3/lists") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, http1Settings: config.http1Settings, http2Settings: config.http2Settings, timeout: config.timeout, forwarded: config.forwarded, followRedirects: config.followRedirects, poolConfig: config.poolConfig, cache: config.cache, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, cookieConfig: config.cookieConfig, responseLimits: config.responseLimits, secureSocket: config.secureSocket, proxy: config.proxy, socketConfig: config.socketConfig, validation: config.validation, laxDataBinding: config.laxDataBinding};
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            httpClientConfig.auth = <http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig>config.auth;
            self.apiKeyConfig = ();
        }
        self.clientEp = check new (serviceUrl, httpClientConfig);
    }

    resource isolated function put [string listId]/update\-list\-name(map<string|string[]> headers = {}, *PutListIdUpdateListNameUpdateNameQueries queries) returns ListUpdateResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}/update-list-name`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    resource isolated function put [string listId]/memberships/add\-and\-remove(MembershipChangeRequest payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships/add-and-remove`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Fetch List by ID
    #
    # + listId - The **ILS ID** of the list to fetch
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string listId](map<string|string[]> headers = {}, *GetListIdGetByIdQueries queries) returns ListFetchResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Delete a List
    #
    # + listId - The **ILS ID** of the list to delete
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [string listId](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(listId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    resource isolated function put [string listId]/update\-list\-filters(ListFilterUpdateRequest payload, map<string|string[]> headers = {}, *PutListIdUpdateListFiltersUpdateListFiltersQueries queries) returns ListUpdateResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}/update-list-filters`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Search Lists
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post search(ListSearchRequest payload, map<string|string[]> headers = {}) returns ListSearchResponse|error {
        string resourcePath = string `/search`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    resource isolated function put folders/move\-list(ListMoveRequest payload, map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/folders/move-list`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Add Records to a List
    #
    # + listId - The **ILS ID** of the `MANUAL` or `SNAPSHOT` list
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put [string listId]/memberships/add(string[] payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships/add`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    resource isolated function get object\-type\-id/[string objectTypeId]/name/[string listName](map<string|string[]> headers = {}, *GetObjectTypeIdObjectTypeIdNameListNameGetByNameQueries queries) returns ListFetchResponse|error {
        string resourcePath = string `/object-type-id/${getEncodedUri(objectTypeId)}/name/${getEncodedUri(listName)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Moves a folder
    #
    # + folderId -
    # + newParentFolderId -
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put folders/[string folderId]/move/[string newParentFolderId](map<string|string[]> headers = {}) returns ListFolderFetchResponse|error {
        string resourcePath = string `/folders/${getEncodedUri(folderId)}/move/${getEncodedUri(newParentFolderId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Translate Legacy List Id to Modern List Id
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get idmapping(map<string|string[]> headers = {}, *GetIdmappingTranslateLegacyListIdToListIdQueries queries) returns PublicMigrationMapping|error {
        string resourcePath = string `/idmapping`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Translate Legacy List Id to Modern List Id in Batch
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post idmapping(string[] payload, map<string|string[]> headers = {}) returns PublicBatchMigrationMapping|error {
        string resourcePath = string `/idmapping`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Restore a List
    #
    # + listId - The **ILS ID** of the list to restore
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function put [string listId]/restore(map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(listId)}/restore`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Rename a folder
    #
    # + folderId -
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function put folders/[string folderId]/rename(map<string|string[]> headers = {}, *PutFoldersFolderIdRenameRenameQueries queries) returns ListFolderFetchResponse|error {
        string resourcePath = string `/folders/${getEncodedUri(folderId)}/rename`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    resource isolated function get [string listId]/memberships/join\-order(map<string|string[]> headers = {}, *GetListIdMembershipsJoinOrderGetPageOrderedByAddedToListDateQueries queries) returns ApiCollectionResponseJoinTimeAndRecordId|error {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships/join-order`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Add All Records from a Source List to a Destination List
    #
    # + listId - The **ILS ID** of the `MANUAL` or `SNAPSHOT` *destination list*, which the *source list* records are added to
    # + sourceListId - The **ILS ID** of the *source list* to grab the records from, which are then added to the *destination list*
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function put [string listId]/memberships/add\-from/[string sourceListId](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships/add-from/${getEncodedUri(sourceListId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }

    # Get lists record is member of
    #
    # + objectTypeId - Object type id of the record
    # + recordId - Id of the record
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get records/[string objectTypeId]/[string recordId]/memberships(map<string|string[]> headers = {}) returns ApiCollectionResponseRecordListMembershipNoPaging|error {
        string resourcePath = string `/records/${getEncodedUri(objectTypeId)}/${getEncodedUri(recordId)}/memberships`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Fetch Multiple Lists
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get .(map<string|string[]> headers = {}, *GetGetAllQueries queries) returns ListsByIdResponse|error {
        string resourcePath = string `/`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<Encoding> queryParamEncoding = {"listIds": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Create List
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post .(ListCreateRequest payload, map<string|string[]> headers = {}) returns ListCreateResponse|error {
        string resourcePath = string `/`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Retrieves a folder.
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get folders(map<string|string[]> headers = {}, *GetFoldersGetAllQueries queries) returns ListFolderFetchResponse|error {
        string resourcePath = string `/folders`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Creates a folder
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post folders(ListFolderCreateRequest payload, map<string|string[]> headers = {}) returns ListFolderCreateResponse|error {
        string resourcePath = string `/folders`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, httpHeaders);
    }

    # Deletes a folder
    #
    # + folderId -
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete folders/[string folderId](map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/folders/${getEncodedUri(folderId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # Fetch List Memberships Ordered by ID
    #
    # + listId - The **ILS ID** of the list
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get [string listId]/memberships(map<string|string[]> headers = {}, *GetListIdMembershipsGetPageQueries queries) returns ApiCollectionResponseJoinTimeAndRecordId|error {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->get(resourcePath, httpHeaders);
    }

    # Delete All Records from a List
    #
    # + listId - The **ILS ID** of the `MANUAL` or `SNAPSHOT` list
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete [string listId]/memberships(map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # Remove Records from a List
    #
    # + listId - The **ILS ID** of the `MANUAL` or `SNAPSHOT` list
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put [string listId]/memberships/remove(string[] payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
        string resourcePath = string `/${getEncodedUri(listId)}/memberships/remove`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        http:Request request = new;
        json jsonBody = jsondata:toJson(payload);
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->put(resourcePath, request, httpHeaders);
    }
}
