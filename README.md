## Notepad

take note of multi workspace patch chectl:
'''kubectl patch checluster/eclipse-che --patch "{\"spec\":{\"server\":{\"customCheProperties\": {\"CHE_LIMITS_USER_WORKSPACES_RUN_COUNT\": \"-1\"}}}}" --type=merge -n che
'''
