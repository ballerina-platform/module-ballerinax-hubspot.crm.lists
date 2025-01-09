# Examples

The `ballerinax/hubspot.crm.lists` connector provides practical examples illustrating usage in various scenarios.

1. [Customer Support Ticket Manager](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/tree/main/examples/customer_support_tickets_manager) - Integrates with HubSpot CRM Lists to create filtered lists of customer support tickets based on the priority level of the ticket.
2. [Leads Tracker](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.lists/tree/main/examples/leads_tracker) - Integrates with HubSpot CRM Lists to create Manual Lists and add leads(contacts) to the lists from CLI.

## Prerequisites

1. Generate HubSpot CRM Lists access token as described in the [Setup guide](../README.md#setup). Make sure to provide the necessary scopes for each example when generating the access token.
2. For each example, create a `Config.toml` file in the root directory of the example and provide the access token. This file should look like the following:

    ```
    clientId="<CLIENT_ID>"
    clientSecret="<CLIENT_SECRET>"
    refreshToken="<REFRESH_TOKEN>"
    ```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```