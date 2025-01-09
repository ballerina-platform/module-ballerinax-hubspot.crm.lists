## Overview

[HubSpot](https://www.hubspot.com/) is an AI-powered customer relationship management (CRM) platform. 

The `ballerinax/hubspot.crm.lists` offers APIs to connect and interact with the [HubSpot CRM Lists API](https://developers.hubspot.com/docs/reference/api/crm/lists) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api/overview)

## Setup guide

To use the HubSpot CRM Lists connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot Developer Account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2 (Optional): Create a Developer Test Account

Within app developer accounts, you can create a [developer test account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account to test apps and integrations without affecting any real HubSpot data.

> **Note:** These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to Test Account section from the left sidebar.

   ![Hubspot developer portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/test_acc_1.png)

2. Click Create developer test account.

   ![Creating a hubspot test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/test_acc_2.png)

3. In the dialogue box, give a name to your test account and click create.

   ![Adding a name and description for the test account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/test_acc_3.png)

### Step 3: Create a HubSpot App under your account.

1. In your developer account, navigate to the "Apps" section. Click on "Create App"

   ![Creating a new App](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

### Step 4: Configure the Authentication Flow.

1. Move to the Auth Tab.

   ![Selecting the Auth tab](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/create_app_2.png)

2. In the Scopes section, add the following scopes for your app using the "Add new scope" button.

   * `crm.lists.read`
   * `crm.lists.write`
   * `cms.membership.access_groups.write`

   ![List of scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/scope_set.png)

   Scopes listed above are the mandotory scopes needed to use the HubSpot CRM Lists API. However you may need to add additional scopes based on your usecase. For example, if you are working with contacts, you may need to add `crm.objects.contacts.read` and `crm.objects.contacts.write` scopes as well.

3. Add your Redirect URI in the relevant section. You can also use `localhost` addresses for local development purposes. Click "Create App".

   ![Adding the redirect URI and save](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/create_app_final.png)

### Step 5: Get your Client ID and Client Secret

- Navigate to the Auth section of your app. Make sure to save the provided Client ID and Client Secret.

   ![Client ID and secret of the App](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/get_credentials.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

2. Paste it in the browser and select your developer test account to install the app when prompted. Provide consent for all scopes needed.

   ![Selecting the App for OAuth process](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/main/docs/setup/resources/install_app.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Lists` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.lists` module and `oauth2` module.

```ballerina
import ballerinax/hubspot.crm.lists as hslists;
import ballerina/oauth2;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina 
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final hslists:Client crmListClient = check new ({auth});

    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Create a CRM List
    
```ballerina
public function main() returns error? {
    hslists:ListCreateRequest payload = {
        objectTypeId: "0-1",
        processingType: "MANUAL",
        name: "my-test-list"
    };
    hslists:ListCreateResponse response = check crmListClient->/crm/v3/lists.post(payload);
}
```

## Examples

The `HubSpot CRM Lists` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.lists/tree/main/examples/), covering the following use cases:

1. [Customer Support Ticket Manager](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/tree/main/examples/customer_support_tickets_manager) - Integrates with HubSpot CRM Lists to create filtered lists of customer support tickets based on the priority level of the ticket.
2. [Leads Tracker](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/tree/main/examples/leads_tracker) - Integrates with HubSpot CRM Lists to create Manual Lists and add leads(contacts) to the lists from CLI.
