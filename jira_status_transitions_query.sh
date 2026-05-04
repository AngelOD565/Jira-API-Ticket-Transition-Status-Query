#!/usr/bin/env bash
set -euo pipefail

# ========= CONFIG =========
JIRA_BASE_URL=""

# Jira PAT auth
JIRA_USER="" 
JIRA_PAT=""

AUTH="-u ${JIRA_USER}:${JIRA_PAT}"

OUTPUT_FILE=""
PAGE_SIZE=100

# URL-encoded JQL
JQL=""

# ========= SETUP =========
echo "issue,from_status,to_status,changed_at,changed_by" > "$OUTPUT_FILE"

START_AT=0
TOTAL=1

echo "🔍 Fetching issues from Jira..."

# ========= SEARCH LOOP =========
while (( START_AT < TOTAL )); do
  RESPONSE=$(curl -s -H "Authorization: Bearer $JIRA_PAT" \
    -H "Accept: application/json" \
    "$JIRA_BASE_URL/rest/api/2/search?jql=$JQL&fields=key&maxResults=$PAGE_SIZE&startAt=$START_AT")

  # Validate auth & JSON
  if ! echo "$RESPONSE" | jq -e '.total' >/dev/null 2>&1; then
    echo "❌ Authentication failed or invalid response."
    echo "👉 Verify your PAT and Jira permissions."
    exit 1
  fi

  TOTAL=$(echo "$RESPONSE" | jq '.total')
  ISSUE_KEYS=$(echo "$RESPONSE" | jq -r '.issues[].key')
  CLEAN_BASE=$(echo "$JIRA_BASE_URL" | tr -d '\r')

  for ISSUE in $ISSUE_KEYS; do
    echo "➡️  Processing $ISSUE..."
        
    CLEAN_ISSUE=$(echo "$ISSUE" | tr -d '\r')
    ISSUE_URL="$CLEAN_BASE/rest/api/2/issue/$CLEAN_ISSUE?expand=changelog"

    ISSUE_RESPONSE=$(curl -s -H "Authorization: Bearer $JIRA_PAT" \
      -H "Accept: application/json" \
      "$ISSUE_URL")

    echo "$ISSUE_RESPONSE" | jq -r '
      .changelog.histories[]
      | .created as $created
      | .author.displayName as $author
      | .items[]
      | select(.field=="status")
      | "\("'"$CLEAN_ISSUE"'"),\(.fromString),\(.toString),\($created),\($author)"
    ' >> "$OUTPUT_FILE"
  done

  START_AT=$(( START_AT + PAGE_SIZE ))
done

echo "✅ Done! Status transitions written to $OUTPUT_FILE"