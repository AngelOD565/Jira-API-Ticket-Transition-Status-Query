# Jira-API-Ticket-Transition-Status-Query
This bash script runs a call to the Jira public API to extract the statuses that a Jira ticket transitioned through from each ticket's expanded changelog. It will automatically do this for all tickets in a particular Jira query using the URL-encoded JQL as an input.

# Inputs
This script can be ran for your own Jira project/query by inputting specific:
Jira Base URL
Jira Username/Email
Jira Personal Access Token (PAT)
Jira Query (in URL-encoded JQL format)


# Output
The output is a csv file (output file name can be specified in script) containing the ticket ID, author, the status changed FROM, the status changed TO, and the date the change occured in ISO8601 format for each ticket in the query.

# Use Cases
The output of this script provides every status a Jira ticket went through. This can be used to calculate metrics for a particular project or feature such as coding times, review times, rework percentages, etc.
