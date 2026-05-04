# Jira-API-Ticket-Transition-Status-Query
This bash script runs a call to the Jira public API to extract the statuses that a Jira ticket transitioned through from each ticket's expanded changelog.

# OutPut
The output is the ticket ID, author, the status changed FROM, the status changed TO, and the date the change occured in ISO8601 format.

# Use Cases
The output of this script provides every status a Jira ticket went through. This can be used to calculate metrics for a particular project or feature such as coding times, review times, rework percentages, etc.
