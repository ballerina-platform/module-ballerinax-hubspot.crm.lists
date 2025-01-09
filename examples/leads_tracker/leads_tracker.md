## Leads Tracker

This usecase demonstrates how the Ballerina HubSpot CRM Lists connector can be used to create manual lists and add records to them. Example code takes the contact(lead) ID as a CLI input, but in a real-world scenario, you can get these IDs from a database or any other source.

## Prerequisites

### 1. Setup HubSpot Developer Account

Refer to the [Setup guide](../../README.md#setup) to create a HubSpot developer account and obtain the necessary credentials. You need to add `crm.objects.contacts.read` and `crm.objects.contacts.write` scope when generating the access token along with the other scopes mentioned in the Setup giude.

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
