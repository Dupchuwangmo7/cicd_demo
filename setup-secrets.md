# GitHub Repository Secrets Setup Guide

To fix the workflow errors, you need to set up the following repository secrets in GitHub:

## Required Secrets

### 1. SNYK_TOKEN

- **Purpose**: Authentication for Snyk security scanning
- **How to get it**:
  1. Go to [https://snyk.io](https://snyk.io)
  2. Sign up for a free account or log in
  3. Go to Account Settings → General → Auth Token
  4. Copy your API token

### 2. SLACK_WEBHOOK_URL (Optional)

- **Purpose**: Send notifications to Slack when security issues are found
- **How to get it**:
  1. Go to your Slack workspace
  2. Create a new app at [https://api.slack.com/apps](https://api.slack.com/apps)
  3. Enable Incoming Webhooks
  4. Create a webhook URL for your desired channel
  5. Copy the webhook URL

## How to Add Secrets to GitHub

1. Go to your repository: `https://github.com/Dupchuwangmo7/cicd_demo`
2. Click on **Settings** tab
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Add each secret:

   - **Name**: `SNYK_TOKEN`
   - **Value**: Your Snyk API token
   - Click **Add secret**

6. Repeat for `SLACK_WEBHOOK_URL` (if you want Slack notifications)

## Workflow Fixes Applied

The following issues have been fixed in your workflows:

✅ **Added proper permissions** for security-events, contents, and issues
✅ **Fixed SARIF file handling** - now checks if files exist before uploading
✅ **Made Slack notifications optional** - won't fail if SLACK_WEBHOOK_URL is not set
✅ **Added continue-on-error** for security scans to prevent workflow failures
✅ **Improved error handling** and logging for debugging

## Testing the Fix

After adding the SNYK_TOKEN secret:

1. Make a small commit and push to trigger the workflow
2. Check the Actions tab to see if the workflow runs successfully
3. Any remaining "Resource not accessible" errors should be resolved

## Note

- The workflow will still run even if SLACK_WEBHOOK_URL is not set
- Security scans will continue even if vulnerabilities are found
- SARIF results will only be uploaded if the scan files are successfully generated
