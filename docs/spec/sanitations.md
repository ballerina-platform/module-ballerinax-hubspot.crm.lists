_Author_:  @sajitha-tj \
_Created_: 2025/01/03 \
_Updated_: 2025/01/09 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot CRM Lists. 
The OpenAPI specification is obtained from [HubSpot CRM Lists API specification](https://github.com/HubSpot/HubSpot-public-api-spec-collection/blob/main/PublicApiSpecs/CRM/Lists/Rollouts/144891/v3/lists.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. **Change the `url`property of the `servers` object**:
    - **Original**: `https://api.hubapi.com`
    - **Updated**: `https://api.hubapi.com/crm/v3/lists`
    - **Reason**: Centralizes the versioning to the base URL, which is a common best practice.

2. **Update API Paths**:
    - **Original**: Paths shared a common segment across all resource endpoints.
    - **Updated**: Common paths segment is removed from the resource endpoints, as it is now included in the base URL. For example:
        - **Original**: `/crm/v3/lists/search`
        - **Updated**: `/search`
    - **Reason**: Simplifies the API paths, making them shorter and more readable.

3. **Change the data format of DateTime Variables in schemas**
    - **Original**: `"format" : "date-time"`
    - **Updated**: `"format" : "datetime"`
    - **Reason**: `date-time` data format is not supported in Ballerina, hence it is converted into a string by default. Changing this to `datetime` which is supported by Ballerina, resolves this issue.

4. **Changing required fields of `MembershipsUpdateResponse` schema**
    - **Original**:
    ```
    "MembershipsUpdateResponse" : {
        "required" : [ "recordIdsMissing", "recordIdsRemoved", "recordsIdsAdded" ],
        "type" : "object",
        ...
    ```
    - **Updated**:
    ```
    "MembershipsUpdateResponse" : {
        "type" : "object",
        ...
    ```
    - **Reason**: Although the API specifications says these feilds are required, the endpoint does not return all three fields `recordIdsMissing`, `recordIdsRemoved`, `recordsIdsAdded` for every request. This leads to a Payload Binding Error (`PayloadBindingClientError`). Removing these from required list ensures correct generation of connector client.


## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --client-methods remote --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.

