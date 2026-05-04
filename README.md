# Jira-API-Ticket-Transition-Status-Query
This bash script runs a call to the Jira public API to extract the statuses that a Jira ticket transitioned through from each ticket's expanded changelog. The output is the ticket ID, author, the status changed FROM, the status changed TO, and the date the change occured in ISO8601 format.
