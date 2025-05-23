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

    # Update List Name
    #
    # + listId - The **ILS ID** of the list to update
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    remote isolated function putListIdUpdateListNameUpdateName(string listId, map<string|string[]> headers = {}, *PutListIdUpdateListNameUpdateNameQueries queries) returns ListUpdateResponse|error {
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

    # Add and/or Remove Records from a List
    #
    # + listId - The **ILS ID** of the `MANUAL` or `SNAPSHOT` list
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    remote isolated function putListIdMembershipsAddAndRemoveAddAndRemove(string listId, MembershipChangeRequest payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
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
    remote isolated function getListIdGetById(string listId, map<string|string[]> headers = {}, *GetListIdGetByIdQueries queries) returns ListFetchResponse|error {
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
    remote isolated function deleteListIdRemove(string listId, map<string|string[]> headers = {}) returns error? {
        string resourcePath = string `/${getEncodedUri(listId)}`;
        map<anydata> headerValues = {...headers};
        if self.apiKeyConfig is ApiKeysConfig {
            headerValues["private-app"] = self.apiKeyConfig?.privateApp;
        }
        map<string|string[]> httpHeaders = http:getHeaderMap(headerValues);
        return self.clientEp->delete(resourcePath, headers = httpHeaders);
    }

    # Update List Filter Definition
    #
    # + listId - The **ILS ID** of the list to update
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    remote isolated function putListIdUpdateListFiltersUpdateListFilters(string listId, ListFilterUpdateRequest payload, map<string|string[]> headers = {}, *PutListIdUpdateListFiltersUpdateListFiltersQueries queries) returns ListUpdateResponse|error {
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
    remote isolated function postSearchDoSearch(ListSearchRequest payload, map<string|string[]> headers = {}) returns ListSearchResponse|error {
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

    # Moves a list to a given folder
    #
    # + headers - Headers to be sent with the request 
    # + return - No content 
    remote isolated function putFoldersMoveListMoveList(ListMoveRequest payload, map<string|string[]> headers = {}) returns error? {
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
    remote isolated function putListIdMembershipsAddAdd(string listId, string[] payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
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

    # Fetch List by Name
    #
    # + listName - The name of the list to fetch. This is **not** case sensitive
    # + objectTypeId - The object type ID of the object types stored by the list to fetch. For example, `0-1` for a `CONTACT` list
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    remote isolated function getObjectTypeIdObjectTypeIdNameListNameGetByName(string listName, string objectTypeId, map<string|string[]> headers = {}, *GetObjectTypeIdObjectTypeIdNameListNameGetByNameQueries queries) returns ListFetchResponse|error {
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
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    remote isolated function putFoldersFolderIdMoveNewParentFolderIdMove(string folderId, string newParentFolderId, map<string|string[]> headers = {}) returns ListFolderFetchResponse|error {
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
    remote isolated function getIdmappingTranslateLegacyListIdToListId(map<string|string[]> headers = {}, *GetIdmappingTranslateLegacyListIdToListIdQueries queries) returns PublicMigrationMapping|error {
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
    remote isolated function postIdmappingTranslateLegacyListIdToListIdBatch(string[] payload, map<string|string[]> headers = {}) returns PublicBatchMigrationMapping|error {
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
    remote isolated function putListIdRestoreRestore(string listId, map<string|string[]> headers = {}) returns error? {
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
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    remote isolated function putFoldersFolderIdRenameRename(string folderId, map<string|string[]> headers = {}, *PutFoldersFolderIdRenameRenameQueries queries) returns ListFolderFetchResponse|error {
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

    # Fetch List Memberships Ordered by Added to List Date
    #
    # + listId - The **ILS ID** of the list
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    remote isolated function getListIdMembershipsJoinOrderGetPageOrderedByAddedToListDate(string listId, map<string|string[]> headers = {}, *GetListIdMembershipsJoinOrderGetPageOrderedByAddedToListDateQueries queries) returns ApiCollectionResponseJoinTimeAndRecordId|error {
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
    remote isolated function putListIdMembershipsAddFromSourceListIdAddAllFromList(string listId, string sourceListId, map<string|string[]> headers = {}) returns error? {
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
    remote isolated function getRecordsObjectTypeIdRecordIdMembershipsGetLists(string objectTypeId, string recordId, map<string|string[]> headers = {}) returns ApiCollectionResponseRecordListMembershipNoPaging|error {
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
    remote isolated function getGetAll(map<string|string[]> headers = {}, *GetGetAllQueries queries) returns ListsByIdResponse|error {
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
    remote isolated function postCreate(ListCreateRequest payload, map<string|string[]> headers = {}) returns ListCreateResponse|error {
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
    remote isolated function getFoldersGetAll(map<string|string[]> headers = {}, *GetFoldersGetAllQueries queries) returns ListFolderFetchResponse|error {
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
    remote isolated function postFoldersCreate(ListFolderCreateRequest payload, map<string|string[]> headers = {}) returns ListFolderCreateResponse|error {
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
    # + headers - Headers to be sent with the request 
    # + return - No content 
    remote isolated function deleteFoldersFolderIdRemove(string folderId, map<string|string[]> headers = {}) returns error? {
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
    remote isolated function getListIdMembershipsGetPage(string listId, map<string|string[]> headers = {}, *GetListIdMembershipsGetPageQueries queries) returns ApiCollectionResponseJoinTimeAndRecordId|error {
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
    remote isolated function deleteListIdMembershipsRemoveAll(string listId, map<string|string[]> headers = {}) returns error? {
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
    remote isolated function putListIdMembershipsRemoveRemove(string listId, string[] payload, map<string|string[]> headers = {}) returns MembershipsUpdateResponse|error {
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
