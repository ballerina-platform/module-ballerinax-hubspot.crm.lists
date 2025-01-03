_Author_:  Sajitha Jayawickrama \
_Created_: 2025/01/03 \
_Updated_: 2025/01/03 \
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
    - **Original**: path includes `/crm/v3/lists` prefix in each end points (e.g., `/crm/v3/lists/search`).
    - **Updated**: Paths are modified to remove the prefix from the endpoints, as it is now included in the base URL. For example:
        - **Original**: `/crm/v3/lists/search`
        - **Updated**: `/search`
    - **Reason**: Simplifies the API paths, making them shorter and more readable.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.json --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
