## Customer Support Tickets Manager

This usecase demonstrates how the Ballerina HubSpot CRM Lists connector can be used to create filtered lists of customer support tickets based on the priority level of the ticket. The example involves a sequence of actions that are performed to create a dynamic list with priority level filters, move the lists into a single folder and retrieve ticket details from each list.

## Prerequisites

### 1. Setup HubSpot Developer Account

Refer to the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/tree/main/README.md#setup) to create a HubSpot developer account and obtain the necessary credentials. You need to add `tickets` scope when generating the access token along with the other scopes mentioned in the Setup giude.

### 2. Configuration

Create a `Config.toml` file in the root directory of the example and provide the access token. This file should look like the following:

```
clientId="<CLIENT_ID>"
clientSecret="<CLIENT_SECRET>"
refreshToken="<REFRESH_TOKEN>"
```

## Running the Example

Execute the following commands to run the example:

```bash
bal run
```
